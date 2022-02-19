//
//  PreviewDataRepository.swift
//  CaseTracker
//
//  Created by Shaun Fowler on 2/6/22.
//

// swiftlint:disable force_try line_length

import Foundation
import Combine
import CaseTrackerCore

class PreviewDataRepository: Repository {

    var data: CurrentValueSubject<[CaseStatus], Never> = .init([case1, case2])
    var error: CurrentValueSubject<Error?, Never> = .init(nil)
    var networkReachable: CurrentValueSubject<Bool, Never> = .init(true)

    static let case1 = CaseStatus(
        receiptNumber: "IOE9119251367",
        status: Status.caseIsActivelyBeingReviewedByUSCIS.rawValue,
        body: "As of February 15, 2022, we are actively reviewing your Form I-129, Petition for a Nonimmigrant Worker, Receipt Number IOE9119251367. Our records show nothing is outstanding at this time. We will let you know if we need anything from you. If you move, go to www.uscis.gov/addresschange to give us your new mailing address.",
        formType: "I-129",
        lastUpdated: Date.now,
        lastFetched: Date()
    )

    static let case2 = CaseStatus(
        receiptNumber: "MSC2119251333",
        status: Status.caseWasApproved.rawValue,
        body: "On January 23, 2022, we approved your Form I-765, Application for Employment Authorization, Receipt Number MSC2119251333. We sent you an approval notice. Please follow the instructions in the notice. If you do not receive your approval notice by March 3, 2022, please go to www.uscis.gov/e-request. If you move, go to www.uscis.gov/addresschange to give us your new mailing address.",
        formType: "I-765",
        lastUpdated: try! Date("2022-01-23T12:00:00+0000", strategy: .iso8601),
        lastFetched: Date()
    )

    static let case3 = CaseStatus(
        receiptNumber: "MSC2119258454",
        status: Status.caseWasApproved.rawValue,
        body: "On January 23, 2022, we approved your Form I-131, Application for Travel Document, Receipt Number MSC2119258454. We sent you an approval notice. Please follow the instructions in the notice. If you do not receive your approval notice by March 3, 2022, please go to www.uscis.gov/e-request. If you move, go to www.uscis.gov/addresschange to give us your new mailing address.",
        formType: "I-131",
        lastUpdated: try! Date("2022-01-23T12:00:00+0000", strategy: .iso8601),
        lastFetched: Date()
    )

    static let case4 = CaseStatus(
        receiptNumber: "LIN2118251021",
        status: Status.responseToUSCISRequestForEvidenceWasReceived.rawValue,
        body: "On December 29, 2021, we received your response to our Request for Evidence for your Form I-485, Application to Register Permanent Residence or Adjust Status, Receipt Number LIN2118251021. USCIS has begun working on your case again. We will send you a decision or notify you if we need something from you. If you move, go to www.uscis.gov/addresschange to give us your new mailing address.",
        formType: "I-485",
        lastUpdated: try! Date("2021-12-29T12:00:00+0000", strategy: .iso8601),
        lastFetched: Date()
    )

    var cases = [PreviewDataRepository.case1, PreviewDataRepository.case2, PreviewDataRepository.case3, PreviewDataRepository.case4]

    init(cases: [CaseStatus]) {
        self.cases = cases
    }

    init() { }

    func query(force: Bool) async {
        data.value = cases
    }

    func addCase(receiptNumber: String) async -> Result<CaseStatus, Error> {
        .success(cases.first ?? Self.case1)
    }

    func removeCase(receiptNumber: String) async -> Result<(), Error> {
        .success(())
    }
}
