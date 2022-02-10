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
        if let id = id, let status = status, let body = body {
            return CaseStatus(
                id: id,
                status: status,
                body: body,
                formType: formType,
                lastUpdated: lastUpdated,
                dateFetched: lastFetched! // bad
            )
        }
        return nil
    }

    @discardableResult
    static func from(model: CaseStatus, context: NSManagedObjectContext) -> CaseStatusManagedObject {
        let object = CaseStatusManagedObject(context: context)
        object.id = model.id
        object.formType = model.formType
        object.status = model.status
        object.body = model.body
        object.lastUpdated = model.lastUpdated
        object.lastFetched = model.dateFetched
        return object
    }

    // MARK: - Update

    func update(from caseStatus: CaseStatus, context: NSManagedObjectContext) {
        lastFetched = caseStatus.dateFetched
        lastUpdated = caseStatus.lastUpdated
        status = caseStatus.status
        body = caseStatus.body
    }

    // MARK: - Requests

    static func fetchByReceiptNumberRequest(receiptNumber: String) -> NSFetchRequest<CaseStatusManagedObject> {
        let request = NSFetchRequest<CaseStatusManagedObject>(entityName: "CaseStatusManagedObject")
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "id = %@", receiptNumber)
        return request
    }
}
