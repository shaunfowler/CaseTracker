//
//  CaseStatusRepository.swift
//  CaseTracker
//
//  Created by Shaun Fowler on 1/31/22.
//

import Foundation
import Combine
import UIKit
import OSLog
import Network
import CocoaLumberjack

public typealias CaseStatusLocalCache = CaseStatusQueryable & CaseStatusWritable

public protocol Repository {

    var data: CurrentValueSubject<[CaseStatus], Never> { get }
    var error: CurrentValueSubject<Error?, Never> { get }
    var networkReachable: CurrentValueSubject<Bool, Never> { get }

    func query(force: Bool) async
    func addCase(receiptNumber: String) async -> Result<CaseStatus, Error>
    func removeCase(receiptNumber: String) async -> Result<(), Error>
    func getHistory(receiptNumber: String) async -> Result<[CaseStatusHistorical], Error>
}

public class CaseStatusRepository: Repository {

    // MARK: - Internal Types

    enum Constants {
        static let cacheExpirySeconds: TimeInterval = 30 * 60 // 30-min
        static let refreshInterval: TimeInterval = 5 * 60     // 5-min
    }

    // MARK: - Public Properties

    public private(set) var data = CurrentValueSubject<[CaseStatus], Never>([])
    public private(set) var error = CurrentValueSubject<Error?, Never>(nil)
    public private(set) var networkReachable = CurrentValueSubject<Bool, Never>(true)

    // MARK: - Private Properties

    private let local: CaseStatusLocalCache
    private let remote: CaseStatusReadable
    private let notificationService: NotificationService

    private var cancellables = Set<AnyCancellable>()
    private let networkMonitorQueue = DispatchQueue(label: "network-monitor")
    private let networkPathMonitor: NWPathMonitor = NWPathMonitor()

    // MARK: - Initialization

    public convenience init(notificationService: NotificationService = NotificationService()) {
        self.init(local: LocalCaseStatusPersistence(),
                  remote: RemoteCaseStatusAPI(),
                  notificationService: notificationService)
    }

    public init(
        local: CaseStatusLocalCache,
        remote: CaseStatusReadable,
        notificationService: NotificationService
    ) {
        self.local = local
        self.remote = remote
        self.notificationService = notificationService

        startNetworkMonitor()
        setupTimer()
    }

    // MARK: - Public Functions

    public func query(force: Bool = false) async {
        defer { os_signpost(.end, log: OSLog.caseTrackerPoi, name: "CaseStatusRepository_query") }
        os_signpost(.begin, log: OSLog.caseTrackerPoi, name: "CaseStatusRepository_query")

        DDLogInfo("Querying all cases...")

        var result = [CaseStatus]()
        error.value = nil

        do {
            // Send local data to publisher first.
            let localResults = try await local.query().get().sorted(by: { lhs, rhs in lhs.id < rhs.id })
            data.value = localResults

            // If no case has expired cache, skip the `.get()` call
            let now = Date.now
            if !force {
                guard localResults.compactMap({ $0.lastFetched }).contains(where: { element in
                    hasExpired(lastFetched: element, now: now)
                }) else {
                    DDLogInfo("Using cache for all cases.")
                    return
                }
            }

            // USCIS doesn't properly return responses for simultaneous requests so request serially.
            for localResult in localResults {
                let fetched = await self.get(forCaseId: localResult.receiptNumber, force: force)
                switch fetched {
                case .success(let caseStatus):
                    result.append(caseStatus)
                case .failure(let error):
                    // Fallback to expired result.
                    DDLogError("Error reloading remote case: \(localResult.receiptNumber).")
                    result.append(localResult)
                    self.error.value = error
                }
            }

            // Send remote data to publisher.
            data.value = result.sorted(by: { lhs, rhs in lhs.id < rhs.id })
            DDLogInfo("Finished querying \(result.count) cases.")
        } catch {
            self.error.value = error
            DDLogError("Error querying cases: \(error.localizedDescription).")
        }
    }

    public func addCase(receiptNumber: String) async -> Result<CaseStatus, Error> {
        DDLogInfo("Adding new case: \(receiptNumber)...")
        let result = await get(forCaseId: receiptNumber)
        if case .success(let caseStatus) = result {
            DDLogDebug("Adding case to local repository publisher.")
            data.value = ([caseStatus] + data.value).sorted(by: { lhs, rhs in lhs.id < rhs.id })
        }
        return result
    }

    public func removeCase(receiptNumber: String) async -> Result<(), Error> {
        DDLogInfo("Removing case: \(receiptNumber)...")
        data.value = data.value.filter { $0.id != receiptNumber }
        return await local.remove(receiptNumber: receiptNumber)
    }

    public func getHistory(receiptNumber: String) async -> Result<[CaseStatusHistorical], Error> {
        await local.history(receiptNumber: receiptNumber)
    }

    // MARK: - Private Functions

    private func get(forCaseId id: String, force: Bool = false) async -> Result<CaseStatus, Error> {
        defer { os_signpost(.end, log: OSLog.caseTrackerPoi, name: "CaseStatusRepository_get") }
        os_signpost(.begin, log: OSLog.caseTrackerPoi, name: "CaseStatusRepository_get")
        let cachedValue = data.value.first { $0.receiptNumber == id}

        if !force,
           let cachedValue = cachedValue,
           let lastFetched = cachedValue.lastFetched,
           !hasExpired(lastFetched: lastFetched) {
            return .success(cachedValue)
        }

        let result = await remote.get(forCaseId: id)

        switch result {
        case .success(var updatedCase):
            if let cachedValue = cachedValue {
                detectChanges(existingCase: cachedValue, updatedCase: updatedCase)
            }
            updatedCase.lastFetched = Date.now
            await local.set(caseStatus: updatedCase)
            return .success(updatedCase)

        case .failure(let error):
            DDLogError("Error fetching case from remote API: \(error.localizedDescription).")
            return .failure(error)
        }
    }

    private func startNetworkMonitor() {
        DDLogInfo("Starting network monitor...")
        networkPathMonitor.pathUpdateHandler = { [weak self] path in
            let satisfied = path.status == .satisfied
            DDLogInfo("Network path satisfied: \(satisfied).")
            self?.networkReachable.send(satisfied)
        }
        networkPathMonitor.start(queue: networkMonitorQueue)
    }

    private func setupTimer() {
        Timer.scheduledTimer(withTimeInterval: Constants.refreshInterval, repeats: true) { _ in
            Task { [weak self] in
                DDLogInfo("Reloading data on periodic timer...")
                await self?.query()
            }
        }
    }

    private func detectChanges(existingCase: CaseStatus, updatedCase: CaseStatus) {
        if existingCase.lastUpdated != updatedCase.lastUpdated || existingCase.status != updatedCase.status {
            DDLogInfo("Detected case change from status [\(existingCase.status)] to [\(updatedCase.status)].")
            notificationService.request(notification: .statusUpdated(updatedCase))
        }
    }

    private func hasExpired(lastFetched: Date, now: Date = .now) -> Bool {
        let diff = abs(lastFetched.timeIntervalSinceNow)
        return diff > Constants.cacheExpirySeconds
    }
}