//
//  LocalCaseStatusPersistence.swift
//  CaseTracker
//
//  Created by Shaun Fowler on 2/9/22.
//

import Foundation
import CoreData
import OSLog

public protocol CaseStatusReadable {
    func get(forCaseId id: String) async -> Result<CaseStatus, Error>
}

public protocol CaseStatusQueryable {
    func query() async -> Result<[CaseStatus], Error>
}

public class LocalCaseStatusPersistence {

    private let viewContext = PersistenceController.shared.container.viewContext

    public init() { }
}

extension LocalCaseStatusPersistence: CaseStatusWritable {

    public func set(caseStatus: CaseStatus) async -> Result<(), Error> {
        do {
            try viewContext.performAndWait {
                let fetchRequest = CaseStatusManagedObject.fetchByReceiptNumberRequest(receiptNumber: caseStatus.id)
                let result = try self.viewContext.fetch(fetchRequest)
                if let existing = result.first {
                    existing.update(from: caseStatus, context: self.viewContext) // update
                } else {
                    CaseStatusManagedObject.from(model: caseStatus, context: self.viewContext) // insert
                }
                try self.viewContext.save()
            }
        } catch {
            return .failure(error)
        }
        return .success(())
    }

    public func remove(receiptNumber: String) async -> Result<(), Error> {
        do {
            try await viewContext.perform {
                let fetchRequest = CaseStatusManagedObject.fetchByReceiptNumberRequest(receiptNumber: receiptNumber)
                if let entity = try self.viewContext.fetch(fetchRequest).first {
                    self.viewContext.delete(entity)
                    try self.viewContext.save()
                }
            }
        } catch {
            return .failure(error)
        }
        return .success(())
    }
}

extension LocalCaseStatusPersistence: CaseStatusQueryable {

    public func query() async -> Result<[CaseStatus], Error> {
        do {
            var resultSet: [CaseStatus] = []
            try viewContext.performAndWait {
                let request = CaseStatusManagedObject.fetchRequest()
                let result = try self.viewContext.fetch(request)
                resultSet = result.compactMap { $0.toModel() }
            }
            return .success(resultSet)
        } catch {
            return .failure(error)
        }
    }
}
