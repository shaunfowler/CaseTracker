//
//  CaseStatusHistoricalManagedObjectExtensions.swift
//  CaseTracker
//
//  Created by Shaun Fowler on 3/22/22.
//

import Foundation
import CoreData

extension CaseStatusHistoricalManagedObject {

    // MARK: - Conversions

    func toModel() -> CaseStatusHistorical? {
        if let receiptNumber = receiptNumber, let status = status, let dateAdded = dateAdded {
            return CaseStatusHistorical(
                receiptNumber: receiptNumber,
                dateAdded: dateAdded,
                lastUpdated: lastUpdated,
                status: status
            )
        }
        return nil
    }

    @discardableResult
    static func from(model: CaseStatusHistorical, context: NSManagedObjectContext) -> CaseStatusHistoricalManagedObject {
        let object = CaseStatusHistoricalManagedObject(context: context)
        object.receiptNumber = model.receiptNumber
        object.dateAdded = model.dateAdded
        object.lastUpdated = model.lastUpdated
        object.status = model.status
        return object
    }

    // MARK: - Requests

    static func fetchBy(receiptNumber: String, status: String) -> NSFetchRequest<CaseStatusHistoricalManagedObject> {
        let request = NSFetchRequest<CaseStatusHistoricalManagedObject>(entityName: "CaseStatusHistoricalManagedObject")
        request.fetchLimit = 1
        let compound = NSCompoundPredicate(
            type: .and,
            subpredicates: [
                NSPredicate(format: "receiptNumber = %@", receiptNumber),
                NSPredicate(format: "status = %@", status)
            ]
        )
        request.predicate = compound
        return request
    }

    static func fetchBy(receiptNumber: String) -> NSFetchRequest<CaseStatusHistoricalManagedObject> {
        let request = NSFetchRequest<CaseStatusHistoricalManagedObject>(entityName: "CaseStatusHistoricalManagedObject")
        request.predicate = NSPredicate(format: "receiptNumber = %@", receiptNumber)
        return request
    }
}
