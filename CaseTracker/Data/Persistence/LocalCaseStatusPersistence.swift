//
//  LocalCaseStatusPersistence.swift
//  CaseTracker
//
//  Created by Shaun Fowler on 2/9/22.
//

import Foundation
import CoreData
import OSLog
import SwiftUI

struct WidgetEntry: Codable {
    var name: String
    var colorR: CGFloat
    var colorG: CGFloat
    var colorB: CGFloat
}

class WidgetPersistence {
    
    let jsonEncoder = JSONEncoder()
    let jsonDecoder = JSONDecoder()
    let userDefaults = UserDefaults(suiteName: "group.com.shaunfowler.CaseTracker.appGroup")
    
    func set(receiptNumber: String, name: String, color: Color) {
        let cgColor = UIColor(color).cgColor
        let widgetEntry = WidgetEntry(
            name: name,
            colorR: cgColor.components?[0] ?? 0,
            colorG: cgColor.components?[1] ?? 0,
            colorB: cgColor.components?[2] ?? 0
        )

        let encoded = try? jsonEncoder.encode(widgetEntry)
        userDefaults?.set(encoded, forKey: receiptNumber)
    }

    func get() -> [WidgetEntry] {
        var result: [WidgetEntry] = []
        if let data = userDefaults?.dictionaryRepresentation().values {
            data.forEach { entry in
                if let entry = entry as? Data,
                   let decoded = try? jsonDecoder.decode(WidgetEntry.self, from: entry) {
                    result.append(decoded)
                    print(decoded)
                }
                print(entry)
            }
        }
        return result
    }
}

class LocalCaseStatusPersistence {

    private let viewContext: NSManagedObjectContext
    private let widgetPersistence: WidgetPersistence

    init(viewContext: NSManagedObjectContext, widgetPersistence: WidgetPersistence = .init()) {
        self.viewContext = viewContext
        self.widgetPersistence = widgetPersistence
    }

    convenience init() {
        self.init(viewContext: PersistenceController.shared.container.viewContext)
    }
}

extension LocalCaseStatusPersistence: CaseStatusWritable {

    func set(caseStatus: CaseStatus) async -> Result<CaseStatus, Error> {
        defer { os_signpost(.end, log: OSLog.caseTrackerPoi, name: "LocalCaseStatusPersistence_get") }
        os_signpost(.begin, log: OSLog.caseTrackerPoi, name: "LocalCaseStatusPersistence_get")
        var caseStatus = caseStatus
        do {
            try viewContext.performAndWait {

                let fetchRequest = CaseStatusManagedObject.fetchBy(receiptNumber: caseStatus.receiptNumber)
                let fetchRequestHistorical = CaseStatusHistoricalManagedObject.fetchBy(receiptNumber: caseStatus.receiptNumber, status: caseStatus.status)

                let result = try self.viewContext.fetch(fetchRequest)
                if let existing = result.first {
                    // Preserve form type in case the updated status text no longer contains it
                    caseStatus.formType = existing.formType

                    // Update local persistence
                    existing.update(from: caseStatus, context: self.viewContext)
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

        widgetPersistence.set(receiptNumber: caseStatus.receiptNumber, name: caseStatus.formType ?? caseStatus.formName ?? caseStatus.receiptNumber, color: caseStatus.color)

        return .success(caseStatus)
    }

    func remove(receiptNumber: String) async -> Result<(), Error> {
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

    func query() async -> Result<[CaseStatus], Error> {
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

    func history(receiptNumber: String) async -> Result<[CaseStatusHistorical], Error> {
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
