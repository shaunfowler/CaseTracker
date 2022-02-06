//
//  PreviewDataRepository.swift
//  CaseTracker
//
//  Created by Shaun Fowler on 2/6/22.
//

import Foundation

class PreviewDataRepository: Repository {

    static let case1 = CaseStatus(
        id: "ABC123456789",
        status: "Fees Were Waived",
        body: "Body",
        formType: "I-131",
        lastUpdated: Date() - 50 * 86_400,
        dateFetched: Date()
    )

    static let case2 = CaseStatus(
        id: "XYZ987654321",
        status: "Request For Initial Evidence Was Sent",
        body: "Body",
        formType: "I-765",
        lastUpdated: Date() - 900 * 86_400,
        dateFetched: Date()
    )

    var cases = [PreviewDataRepository.case1, PreviewDataRepository.case2]

    init(cases: [CaseStatus]? = nil) {
        if let cases = cases {
            self.cases = cases
        }
    }

    func query(force: Bool) async -> Result<[CaseStatus], Error> {
        .success(cases)
    }

    func addCase(receiptNumber: String) async -> Result<CaseStatus, Error> {
        .success(cases.first ?? Self.case1)
    }

    func removeCase(receiptNumber: String) async -> Result<(), Error> {
        .success(())
    }
}
