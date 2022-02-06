//
//  PreviewDataRepository.swift
//  CaseTracker
//
//  Created by Shaun Fowler on 2/6/22.
//

import Foundation

class PreviewDataRepository: Repository {

    static let case1 = CaseStatus(
        id: "ABC123456",
        status: "Fees Were Waived",
        body: "Body",
        formType: "I-131",
        lastUpdated: Date.distantPast,
        dateFetched: Date()
    )

    func query(force: Bool) async -> Result<[CaseStatus], Error> {
        .success([Self.case1])
    }

    func addCase(receiptNumber: String) async -> Result<CaseStatus, Error> {
        .success(Self.case1)
    }

    func removeCase(receiptNumber: String) async -> Result<(), Error> {
        .success(())
    }
}
