//
//  LocalStatusAPI.swift
//  CaseTracker
//
//  Created by Shaun Fowler on 1/31/22.
//

import Foundation
import OSLog

extension UserDefaults {
    static let caseStatus: UserDefaults = {
        UserDefaults(suiteName: "com.shaunfowler.CaseTracker.case-status")! // ?? UserDefaults.standard
    }()
}

class LocalCaseStatusAPI: CaseStatusReadable & CaseStatusWritable {

    private let storage = UserDefaults.caseStatus

    init() {
        // storage.set(nil, forKey: "case-XXX) // delete
        [].forEach { storage.set("", forKey: "case-\($0)") } // seed
        // storage.synchronize()
    }

    // MARK: - CaseStatusReadable

    func get(forCaseId id: String) async -> Result<CaseStatus, Error> {
        Logger.api.log("Getting case from storage.")
        let decoder = JSONDecoder()
        do {
            if let restored = storage.object(forKey: key(for: id)) as? Data {
                let caseStatus = try decoder.decode(CaseStatus.self, from: restored)
                return .success(caseStatus)
            }
            return .failure(CSError.notCached)
        } catch {
            Logger.api.error("Failed to get case in local storage with error: \(error.localizedDescription).")
            return .failure(error)
        }
    }

    // MARK: - CaseStatusWritable

    func set(caseStatus: CaseStatus) async -> Result<Void, Error> {
        Logger.api.log("Saving case to storage.")
        let encoder = JSONEncoder()
        let key = key(for: caseStatus.id)
        do {
            let encoded = try encoder.encode(caseStatus)
            storage.set(encoded, forKey: key)
#if targetEnvironment(simulator)
            storage.synchronize() // force on simulator
#endif
            return .success(())
        } catch {
            Logger.api.error("Failed to set case in local storage with error: \(error.localizedDescription).")
            return .failure(error)
        }
    }

    func remove(receiptNumber: String) async -> Result<(), Error> {
        Logger.api.log("Removing case from storage.")
        storage.set(nil, forKey: key(for: receiptNumber))
        return .success(())
    }
}

extension LocalCaseStatusAPI: CaseStatusCachable {
    func keys() -> [String] {
        let keys: [String] = storage.dictionaryRepresentation().keys
            .filter { $0.starts(with: "case-") }
            .map {
                var stripped = $0
                stripped.removeFirst("case-".count)
                return stripped
            }
        Logger.api.log("Found \(keys.count) receipt numbers in local storage.")
        return keys
    }

    private func key(for receiptNumber: String) -> String {
        "case-\(receiptNumber)"
    }
}
