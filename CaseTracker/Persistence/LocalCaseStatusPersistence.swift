//
//  LocalCaseStatusPersistence.swift
//  CaseTracker
//
//  Created by Shaun Fowler on 2/9/22.
//

import Foundation
import CoreData
import OSLog

class LocalCaseStatusPersistence: CaseStatusReadable, CaseStatusWritable, CaseStatusCachable {

    private let context = PersistenceController.shared.container.viewContext

    func get(forCaseId id: String) async -> Result<CaseStatus, Error> {
        do {
            var caseStatus: CaseStatus?
            try context.performAndWait {
                let fetchRequest = CaseStatusManagedObject.fetchByReceiptNumberRequest(receiptNumber: id)
                let entities = try self.context.fetch(fetchRequest)
                if let entity = entities.first {
                    caseStatus = entity.toModel()
                }
            }
            if let caseStatus = caseStatus {
                return .success(caseStatus)
            }
            return .failure(CSError.notCached)
        } catch {
            print(error)
        }

        return .failure(CSError.notCached)
    }

    func set(caseStatus: CaseStatus) async -> Result<(), Error> {
        do {
            try await context.perform {
                let fetchRequest = CaseStatusManagedObject.fetchByReceiptNumberRequest(receiptNumber: caseStatus.id)
                let result = try self.context.fetch(fetchRequest)
                if let existing = result.first {
                    existing.update(from: caseStatus, context: self.context) // update
                } else {
                    CaseStatusManagedObject.from(model: caseStatus, context: self.context) // insert
                }
                try self.context.save()
            }
        } catch {
            return .failure(error)
        }
        return .success(())
    }

    func remove(receiptNumber: String) async -> Result<(), Error> {
        do {
            try await context.perform {
                let fetchRequest = CaseStatusManagedObject.fetchByReceiptNumberRequest(receiptNumber: receiptNumber)
                if let entity = try self.context.fetch(fetchRequest).first {
                    self.context.delete(entity)
                    try self.context.save()
                }
            }
        } catch {
            return .failure(error)
        }
        return .success(())
    }

    func keys() async -> [String] {
        var receiptNumbers: [String] = []
        context.performAndWait {
            let request = CaseStatusManagedObject.fetchRequest()
            request.propertiesToFetch = ["id"]
            if let result = try? self.context.fetch(request) {
                receiptNumbers = result.compactMap(\.id)
            }
        }
        return receiptNumbers // mock here
    }
}

