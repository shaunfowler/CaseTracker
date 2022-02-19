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

public typealias CaseStatusLocalCache = CaseStatusQueryable & CaseStatusWritable

public protocol Repository {

    var data: CurrentValueSubject<[CaseStatus], Never> { get }
    var error: CurrentValueSubject<Error?, Never> { get }
    var networkReachable: CurrentValueSubject<Bool, Never> { get }

    func query(force: Bool) async
    func addCase(receiptNumber: String) async -> Result<CaseStatus, Error>
    func removeCase(receiptNumber: String) async -> Result<(), Error>
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
        Logger.main.log("Querying all cases...")
        var result = [CaseStatus]()
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
                    Logger.main.log("Using cache for all cases.")
                    return
                }
            }

            // USCIS doesn't properly return responses for simultaneous requests so request serially.
            for receiptNumber in localResults.map(\.receiptNumber) {
                if case .success(let caseStatus) = await self.get(forCaseId: receiptNumber, force: force) {
                    result.append(caseStatus)
                }
            }

            // Send remote data to publisher.
            error.value = nil
            data.value = result.sorted(by: { lhs, rhs in lhs.id < rhs.id })
            Logger.main.log("Finished querying \(result.count, privacy: .public) cases.")
        } catch {
            Logger.main.error("Error querying cases: \(error.localizedDescription, privacy: .public).")
        }
    }

    public func addCase(receiptNumber: String) async -> Result<CaseStatus, Error> {
        Logger.api.log("Adding new case: \(receiptNumber)...")
        let result = await get(forCaseId: receiptNumber)
        if case .success(let caseStatus) = result {
            Logger.api.debug("Adding case to local repository publisher.")
            data.value = [caseStatus] + data.value
        }
        return result
    }

    public func removeCase(receiptNumber: String) async -> Result<(), Error> {
        Logger.api.log("Removing case: \(receiptNumber)...")
        data.value = data.value.filter { $0.id != receiptNumber }
        return await local.remove(receiptNumber: receiptNumber)
    }

    // MARK: - Private Functions

    private func get(forCaseId id: String, force: Bool = false) async -> Result<CaseStatus, Error> {
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
            Logger.api.error("Error fetching case from remote API: \(error.localizedDescription, privacy: .public).")
            return .failure(CSError.http)
        }
    }

    private func startNetworkMonitor() {
        Logger.api.log("Starting network monitor...")
        networkPathMonitor.pathUpdateHandler = { [weak self] path in
            let satisfied = path.status == .satisfied
            Logger.api.log("Network path satisfied: \(satisfied, privacy: .public).")
            self?.networkReachable.send(satisfied)
        }
        networkPathMonitor.start(queue: networkMonitorQueue)
    }

    private func setupTimer() {
        Timer.scheduledTimer(withTimeInterval: Constants.refreshInterval, repeats: true) { _ in
            Task { [weak self] in
                Logger.main.log("Reloading data on periodic timer...")
                await self?.query()
            }
        }
    }

    private func detectChanges(existingCase: CaseStatus, updatedCase: CaseStatus) {
        if existingCase.lastUpdated != updatedCase.lastUpdated || existingCase.status != updatedCase.status {
            Logger.api.log("Detected case change from status [\(existingCase.status, privacy: .public)] to [\(updatedCase.status, privacy: .public)].")
            notificationService.request(notification: .statusUpdated(updatedCase))
        }
    }

    private func hasExpired(lastFetched: Date, now: Date = .now) -> Bool {
        let diff = abs(lastFetched.timeIntervalSinceNow)
        return diff > Constants.cacheExpirySeconds
    }
}
