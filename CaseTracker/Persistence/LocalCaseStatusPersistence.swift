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

    let context = PersistenceController.shared.container.viewContext

    func get(forCaseId id: String) async -> Result<CaseStatus, Error> {
        do {
            var caseStatus: CaseStatus?
            try context.performAndWait {
                let fetchRequest = CaseStatusManagedObject.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "id = %@", id)
                let entities = try self.context.fetch(fetchRequest)
                caseStatus = entities.first.map { entity in
                    return CaseStatus(
                        id: entity.id!,
                        status: entity.status!,
                        body: entity.body!,
                        formType: entity.formType,
                        lastUpdated: entity.lastUpdated,
                        dateFetched: entity.lastFetched!
                    )
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

                let fetchRequest = CaseStatusManagedObject.fetchRequest()
                fetchRequest.fetchLimit = 1
                fetchRequest.predicate = NSPredicate(format: "id = %@", caseStatus.id)
                let result = try self.context.fetch(fetchRequest)
                if let existing = result.first {
                    // Update existing
                    existing.lastFetched = caseStatus.dateFetched
                    existing.lastUpdated = caseStatus.lastUpdated
                    existing.status = caseStatus.status
                    existing.body = caseStatus.body
                } else {
                    // Create new
                    let managedObject = CaseStatusManagedObject(context: self.context)
                    managedObject.id = caseStatus.id
                    managedObject.formType = caseStatus.formType
                    managedObject.status = caseStatus.status
                    managedObject.body = caseStatus.body
                    managedObject.lastUpdated = caseStatus.lastUpdated
                    managedObject.lastFetched = caseStatus.dateFetched
                }
                try self.context.save()
            }
            return .success(())
        } catch {
            return .failure(error)
        }
    }

    func remove(receiptNumber: String) async -> Result<(), Error> {
        do {
            try await context.perform {
                let fetchRequest = CaseStatusManagedObject.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "id = %@", receiptNumber)
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
        var ids: [String] = []
        context.performAndWait {
            let request = CaseStatusManagedObject.fetchRequest()
            request.propertiesToFetch = ["id"]
            if let result = try? self.context.fetch(request) {
                ids = result.compactMap(\.id)
            }
        }
        return ids // mock here
    }
}

