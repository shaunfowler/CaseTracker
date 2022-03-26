//
//  LocalCaseStatusPersistence.swift
//  CaseTracker
//
//  Created by Shaun Fowler on 2/9/22.
//

import Foundation
import CoreData
import OSLog

public class LocalCaseStatusPersistence {

    private let viewContext: NSManagedObjectContext

    public init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
    }

    convenience init() {
        self.init(viewContext: PersistenceController.shared.container.viewContext)
    }
}

extension LocalCaseStatusPersistence: CaseStatusWritable {

    public func set(caseStatus: CaseStatus) async -> Result<(), Error> {
        defer { os_signpost(.end, log: OSLog.caseTrackerPoi, name: "LocalCaseStatusPersistence_get") }
        os_signpost(.begin, log: OSLog.caseTrackerPoi, name: "LocalCaseStatusPersistence_get")
        do {
            try viewContext.performAndWait {

                let fetchRequest = CaseStatusManagedObject.fetchBy(receiptNumber: caseStatus.receiptNumber)
                let fetchRequestHistorical = CaseStatusHistoricalManagedObject.fetchBy(receiptNumber: caseStatus.receiptNumber, status: caseStatus.status)

                let result = try self.viewContext.fetch(fetchRequest)
                if let existing = result.first {
                    existing.update(from: caseStatus, context: self.viewContext) // update
                    if try self.viewContext.fetch(fetchRequestHistorical).isEmpty {
                        existing.addToHistory(createHistoricalItem(from: caseStatus))
                    }
                } else {
                    let new = CaseStatusManagedObject.from(model: caseStatus, context: self.viewContext) // insert
                    new.addToHistory(createHistoricalItem(from: caseStatus))
                }

                try self.viewContext.save()
            }
        } catch {
            return .failure(error)
        }
        return .success(())
    }

    public func remove(receiptNumber: String) async -> Result<(), Error> {
        defer { os_signpost(.end, log: OSLog.caseTrackerPoi, name: "LocalCaseStatusPersistence_remove") }
        os_signpost(.begin, log: OSLog.caseTrackerPoi, name: "LocalCaseStatusPersistence_remove")
        do {
            try await viewContext.perform {
                let fetchRequest = CaseStatusManagedObject.fetchBy(receiptNumber: receiptNumber)
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

    private func createHistoricalItem(from caseStatus: CaseStatus) -> CaseStatusHistoricalManagedObject {
        let historicalItem = CaseStatusHistoricalManagedObject(context: viewContext)
        historicalItem.receiptNumber = caseStatus.receiptNumber
        historicalItem.lastUpdated = caseStatus.lastUpdated
        historicalItem.dateAdded = Date.now
        historicalItem.status = caseStatus.status
        return historicalItem
    }
}

extension LocalCaseStatusPersistence: CaseStatusQueryable {

    public func query() async -> Result<[CaseStatus], Error> {
        defer { os_signpost(.end, log: OSLog.caseTrackerPoi, name: "LocalCaseStatusPersistence_query") }
        os_signpost(.begin, log: OSLog.caseTrackerPoi, name: "LocalCaseStatusPersistence_query")
        do {
            var resultSet: [CaseStatus] = []
            try viewContext.performAndWait {
                let request = CaseStatusManagedObject.fetchRequest()
                request.sortDescriptors = [NSSortDescriptor(key: "receiptNumber", ascending: true)]
                let result = try self.viewContext.fetch(request)
                resultSet = result.compactMap { $0.toModel() }
            }
            return .success(resultSet)
        } catch {
            return .failure(error)
        }
    }

    public func history(receiptNumber: String) async -> Result<[CaseStatusHistorical], Error> {
        defer { os_signpost(.end, log: OSLog.caseTrackerPoi, name: "LocalCaseStatusPersistence_history") }
        os_signpost(.begin, log: OSLog.caseTrackerPoi, name: "LocalCaseStatusPersistence_history")
        do {
            var resultSet: [CaseStatusHistorical] = []
            try viewContext.performAndWait {
                let request = CaseStatusHistoricalManagedObject.fetchBy(receiptNumber: receiptNumber)
                request.sortDescriptors = [NSSortDescriptor(key: "dateAdded", ascending: false)]
                let result = try self.viewContext.fetch(request)
                resultSet = result.compactMap { $0.toModel() }
            }
            return .success(resultSet)
        } catch {
            return .failure(error)
        }
    }
}
