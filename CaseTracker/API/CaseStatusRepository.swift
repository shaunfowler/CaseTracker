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

typealias CaseStatusLocalCache = CaseStatusReadable & CaseStatusWritable & CaseStatusCachable

protocol Repository {

    var data: CurrentValueSubject<[CaseStatus], Never> { get }
    var error: CurrentValueSubject<Error?, Never> { get }

    func query(force: Bool) async
    func addCase(receiptNumber: String) async -> Result<CaseStatus, Error>
    func removeCase(receiptNumber: String) async -> Result<(), Error>
}

class CaseStatusRepository: Repository {

    // MARK: - Internal Types

    enum Constants {
        static let cacheExpirySeconds: TimeInterval = 30 * 60 // 30-min
        static let refreshInterval: TimeInterval = 10 * 60 // * 60 // 10-min
    }

    // MARK: - Properties

    private var cancellables = Set<AnyCancellable>()

    private let local: CaseStatusLocalCache
    private let remote: CaseStatusReadable

    var internalData: [CaseStatus] = [] {
        didSet {
            data.send(internalData)
        }
    }

    var internalError: Error? = nil {
        didSet {
            error.send(internalError)
        }
    }

    private(set) var data = CurrentValueSubject<[CaseStatus], Never>([])
    private(set) var error = CurrentValueSubject<Error?, Never>(nil)

    // MARK: - Initialization

    init(
        local: CaseStatusLocalCache = LocalCaseStatusAPI(),
        remote: CaseStatusReadable = RemoteCaseStatusAPI()
    ) {
        self.local = local
        self.remote = remote

        setupTimer()
    }

    // MARK: - Public Functions

    func query(force: Bool = false) async {
        Logger.main.info("Querying all cases...")
        // USCIS doesn't properly return responses for simultaneous requests
        // Request serially
        var result = [CaseStatus]()
        for receiptNumber in self.local.keys() {
            if case .success(let caseStatus) = await self.get(forCaseId: receiptNumber, force: force) {
                // Logger.main.debug("\(caseStatus)")
                result.append(caseStatus)
            }
        }
        internalError = nil
        internalData = result.sorted(by: { lhs, rhs in lhs.id < rhs.id })
        Logger.main.info("Finished querying \(result.count) cases.")
    }

    func addCase(receiptNumber: String) async -> Result<CaseStatus, Error> {
        await get(forCaseId: receiptNumber)
    }

    func removeCase(receiptNumber: String) async -> Result<(), Error> {
        await local.remove(receiptNumber: receiptNumber)
    }

    // MARK: - Private Functions

    private func get(forCaseId id: String, force: Bool = false) async -> Result<CaseStatus, Error> {
        let cachedValue = await local.get(forCaseId: id)

        if !force, case .success(let caseStatus) = cachedValue {
            let diff = abs(caseStatus.dateFetched.timeIntervalSinceNow)
            let isExpired =  diff > Constants.cacheExpirySeconds
            if !isExpired {
                return .success(caseStatus)
            }
        }

        let caseStatusResult = await remote.get(forCaseId: id)
        if case .success(var caseStatus) = caseStatusResult {
            caseStatus.dateFetched = Date.now
            await local.set(caseStatus: caseStatus)
            return .success(caseStatus)
        }

        return .failure(CSError.http)
    }

    private func setupTimer() {
        Timer.scheduledTimer(withTimeInterval: Constants.refreshInterval, repeats: true) { _ in
            Task { [weak self] in
                Logger.main.info("Reloading data on periodic timer...")
                await self?.query()
            }
        }
    }
}
