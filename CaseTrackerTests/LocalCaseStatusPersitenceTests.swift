//
//  LocalCaseStatusPersitenceTests.swift
//  CaseTrackerTests
//
//  Created by Shaun Fowler on 3/24/22.
//

import XCTest
@testable import Case_Tracker

class LocalCaseStatusPersitenceTests: XCTestCase {

    var coreData: TestCoreDataStack!
    var persistence: LocalCaseStatusPersistence!

    override func setUp() {
        coreData = TestCoreDataStack()
        persistence = LocalCaseStatusPersistence(viewContext: coreData.persistentContainer.viewContext)
    }

    func testSetCaseStatusResultsInHistoricalEntry() async {
        _ = await persistence.set(caseStatus: PreviewDataRepository.case2)

        let count = try? await persistence.query().get().count
        XCTAssertEqual(count, 1)

        let historicalItems = try? await persistence.history(receiptNumber: PreviewDataRepository.case2.receiptNumber).get()
        XCTAssertEqual(historicalItems?.count, 1)
        XCTAssertEqual(historicalItems?.first?.receiptNumber, PreviewDataRepository.case2.receiptNumber)
        XCTAssertEqual(historicalItems?.first?.lastUpdated, PreviewDataRepository.case2.lastUpdated)
        XCTAssertEqual(historicalItems?.first?.status, PreviewDataRepository.case2.status)
    }

    func testSetDuplicateCaseStatusResultsInSingleEntry() async {
        _ = await persistence.set(caseStatus: PreviewDataRepository.case2)
        _ = await persistence.set(caseStatus: PreviewDataRepository.case2)

        let count = try? await persistence.query().get().count
        XCTAssertEqual(count, 1)

        let historicalItems = try? await persistence.history(receiptNumber: PreviewDataRepository.case2.receiptNumber).get()
        XCTAssertEqual(historicalItems?.count, 1)
    }

    func testSetUpdatedStatesResultsInTwoHistoricalEntries() async {

        // Case was received
        var initialCase = PreviewDataRepository.case2
        initialCase.status = Status.caseWasReceived.rawValue
        initialCase.lastUpdated = PreviewDataRepository.case2.lastUpdated! - 1000000
        _ = await persistence.set(caseStatus: initialCase)

        // Case was approved
        let finalCase = PreviewDataRepository.case2
        _ = await persistence.set(caseStatus: finalCase)

        let count = try? await persistence.query().get().count
        XCTAssertEqual(count, 1)

        let historicalItems = try? await persistence.history(receiptNumber: PreviewDataRepository.case2.receiptNumber).get()
        XCTAssertEqual(historicalItems?.count, 2)

        XCTAssertEqual(historicalItems?.first?.receiptNumber, PreviewDataRepository.case2.receiptNumber)
        XCTAssertEqual(historicalItems?.first?.lastUpdated, finalCase.lastUpdated)
        XCTAssertEqual(historicalItems?.first?.status, finalCase.status)

        XCTAssertEqual(historicalItems?[1].receiptNumber, PreviewDataRepository.case2.receiptNumber)
        XCTAssertEqual(historicalItems?[1].lastUpdated, initialCase.lastUpdated)
        XCTAssertEqual(historicalItems?[1].status, initialCase.status)
    }

    func testReuseFormTypeFromPreviousStatus() async {

        let caseInitial = CaseStatus(
            receiptNumber: "IOE9119251367",
            status: Status.caseIsActivelyBeingReviewedByUSCIS.rawValue,
            body: "...",
            formType: "I-129",
            lastUpdated: Date.now - 100_000,
            lastFetched: Date() - 100_000
        )

        let caseFinal_WithoutFormType = CaseStatus(
            receiptNumber: "IOE9119251367",
            status: Status.caseApproved.rawValue,
            body: "...",
            formType: nil, // nil
            lastUpdated: Date.now,
            lastFetched: Date()
        )

        _ = await persistence.set(caseStatus: caseInitial)
        let results1 = try? await persistence.query().get()
        XCTAssertEqual(results1?[0].formType, caseInitial.formType)

        _ = await persistence.set(caseStatus: caseFinal_WithoutFormType)
        let results2 = try? await persistence.query().get()
        XCTAssertEqual(results2?[0].formType, caseInitial.formType)
    }
}
