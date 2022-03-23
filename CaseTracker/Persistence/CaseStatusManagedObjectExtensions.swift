//
//  CaseStatusManagedObject+toModel.swift
//  CaseTracker
//
//  Created by Shaun Fowler on 2/9/22.
//

import Foundation
import CoreData

extension CaseStatusManagedObject {

    // MARK: - Conversions

    func toModel() -> CaseStatus? {
        if let receiptNumber = receiptNumber, let status = status, let body = body {
            return CaseStatus(
                receiptNumber: receiptNumber,
                status: status,
                body: body,
                formType: formType,
                lastUpdated: lastUpdated,
                lastFetched: lastFetched! // bad
            )
        }
        return nil
    }

    @discardableResult
    static func from(model: CaseStatus, context: NSManagedObjectContext) -> CaseStatusManagedObject {
        let object = CaseStatusManagedObject(context: context)
        object.receiptNumber = model.receiptNumber
        object.formType = model.formType
        object.status = model.status
        object.body = model.body
        object.lastUpdated = model.lastUpdated
        object.lastFetched = model.lastFetched
        return object
    }

    // MARK: - Update

    func update(from caseStatus: CaseStatus, context: NSManagedObjectContext) {
        lastFetched = caseStatus.lastFetched
        lastUpdated = caseStatus.lastUpdated
        status = caseStatus.status
        body = caseStatus.body
    }

    // MARK: - Requests

    static func fetchBy(receiptNumber: String) -> NSFetchRequest<CaseStatusManagedObject> {
        let request = NSFetchRequest<CaseStatusManagedObject>(entityName: "CaseStatusManagedObject")
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "receiptNumber = %@", receiptNumber)
        return request
    }
}
