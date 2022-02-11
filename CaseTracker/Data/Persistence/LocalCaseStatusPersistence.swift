//
//  LocalCaseStatusPersistence.swift
//  CaseTracker
//
//  Created by Shaun Fowler on 2/9/22.
//

import Foundation
import CoreData
import OSLog

protocol CaseStatusReadable {
    func get(forCaseId id: String) async -> Result<CaseStatus, Error>
}

protocol CaseStatusQueryable {
    func query() async -> Result<[CaseStatus], Error>
}

class LocalCaseStatusPersistence {
    private let backgroundContext = PersistenceController.shared.container.newBackgroundContext()
}

extension LocalCaseStatusPersistence: CaseStatusWritable {

    func set(caseStatus: CaseStatus) async -> Result<(), Error> {
        do {
            try await backgroundContext.perform {
                let fetchRequest = CaseStatusManagedObject.fetchByReceiptNumberRequest(receiptNumber: caseStatus.id)
                let result = try self.backgroundContext.fetch(fetchRequest)
                if let existing = result.first {
                    existing.update(from: caseStatus, context: self.backgroundContext) // update
                } else {
                    CaseStatusManagedObject.from(model: caseStatus, context: self.backgroundContext) // insert
                }
                try self.backgroundContext.save()
            }
        } catch {
            return .failure(error)
        }
        return .success(())
    }

    func remove(receiptNumber: String) async -> Result<(), Error> {
        do {
            try await backgroundContext.perform {
                let fetchRequest = CaseStatusManagedObject.fetchByReceiptNumberRequest(receiptNumber: receiptNumber)
                if let entity = try self.backgroundContext.fetch(fetchRequest).first {
                    self.backgroundContext.delete(entity)
                    try self.backgroundContext.save()
                }
            }
        } catch {
            return .failure(error)
        }
        return .success(())
    }
}

extension LocalCaseStatusPersistence: CaseStatusQueryable {

    func query() async -> Result<[CaseStatus], Error> {
        do {
            var resultSet: [CaseStatus] = []
            try await backgroundContext.perform {
                let request = CaseStatusManagedObject.fetchRequest()
                let result = try self.backgroundContext.fetch(request)
                resultSet = result.compactMap { $0.toModel() }
            }
            return .success(resultSet)
        } catch {
            return .failure(error)
        }
    }
}
