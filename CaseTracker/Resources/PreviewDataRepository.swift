//
//  PreviewDataRepository.swift
//  CaseTracker
//
//  Created by Shaun Fowler on 2/6/22.
//

import Foundation
import Combine

class PreviewDataRepository: Repository {

    var data: CurrentValueSubject<[CaseStatus], Never> = .init([case1, case2])
    var error: CurrentValueSubject<Error?, Never> = .init(nil)
    var networkReachable: CurrentValueSubject<Bool, Never> = .init(true)

    static let case1 = CaseStatus(
        receiptNumber: "ABC123456789",
        status: "Fees Were Waived",
        body: "Body",
        formType: "I-131",
        lastUpdated: Date() - 50 * 86_400,
        lastFetched: Date()
    )

    static let case2 = CaseStatus(
        receiptNumber: "XYZ987654321",
        status: "Request For Initial Evidence Was Sent",
        body: "Body",
        formType: "I-765",
        lastUpdated: Date() - 900 * 86_400,
        lastFetched: Date()
    )

    var cases = [PreviewDataRepository.case1, PreviewDataRepository.case2]

    init(cases: [CaseStatus]? = nil) {
        if let cases = cases {
            self.cases = cases
        }
    }

    func query(force: Bool) async {
        // no-op
    }

    func addCase(receiptNumber: String) async -> Result<CaseStatus, Error> {
        .success(cases.first ?? Self.case1)
    }

    func removeCase(receiptNumber: String) async -> Result<(), Error> {
        .success(())
    }
}
