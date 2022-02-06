//
//  CaseStatusRepository.swift
//  CaseTracker
//
//  Created by Shaun Fowler on 1/31/22.
//

import Foundation
import Combine

typealias CaseStatusLocalCache = CaseStatusReadable & CaseStatusWritable & CaseStatusCachable

protocol Repository {
    func query(force: Bool) async -> Result<[CaseStatus], Error>
    func addCase(receiptNumber: String) async -> Result<CaseStatus, Error>
    func removeCase(receiptNumber: String) async -> Result<(), Error>
}

class CaseStatusRepository: Repository {

    // MARK: - Internal Types

    enum Constants {
        static let cacheExpirySeconds: TimeInterval = 5 * 60 // 5-min
    }

    // MARK: - Properties

    private let local: CaseStatusLocalCache
    private let remote: CaseStatusReadable

    // MARK: - Initialization

    init(
        local: CaseStatusLocalCache = LocalCaseStatusAPI(),
        remote: CaseStatusReadable = RemoteCaseStatusAPI()
    ) {
        self.local = local
        self.remote = remote
    }

    // MARK: - Public Functions

    func query(force: Bool = false) async -> Result<[CaseStatus], Error> {
        print("BEGIN - Query")
        // TODO - How to do concurrently and sync access to `data`?
        var result = [CaseStatus]()
        for receiptNumber in self.local.keys() {
            if case .success(let caseStatus) = await self.get(forCaseId: receiptNumber, force: force) {
                print(caseStatus)
                result.append(caseStatus)
            }
        }
        print("END - Query")
        return .success(result.sorted(by: { lhs, rhs in lhs.id < rhs.id }))
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
            print("repository get for \(id); diff = \(diff); expired: \(isExpired);")
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
}
