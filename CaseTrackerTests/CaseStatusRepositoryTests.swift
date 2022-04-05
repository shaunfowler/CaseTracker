//
//  CaseStatusRepositoryTests.swift
//  CaseTrackerTests
//
//  Created by Shaun Fowler on 4/5/22.
//

import XCTest
@testable import Case_Tracker

class CaseStatusRepositoryTests: XCTestCase {

    var otherCase = CaseStatus(
        receiptNumber: "MSC2119251333",
        status: Status.caseWasApproved.rawValue,
        body: "...",
        formType: "I-765",
        lastUpdated: Date.now,
        lastFetched: Date()
    )

    let caseInitial = CaseStatus(
        receiptNumber: "IOE9119251367",
        status: Status.caseIsActivelyBeingReviewedByUSCIS.rawValue,
        body: "...",
        formType: "I-129",
        lastUpdated: Date.now - 100_000,
        lastFetched: Date() - 100_000
    )

    let caseFinal_WithFormType = CaseStatus(
        receiptNumber: "IOE9119251367",
        status: Status.caseApproved.rawValue,
        body: "...",
        formType: "I-129", // form type
        lastUpdated: Date.now,
        lastFetched: Date()
    )

    let caseFinal_WithoutFormType = CaseStatus(
        receiptNumber: "IOE9119251367",
        status: Status.caseApproved.rawValue,
        body: "...",
        formType: nil, // nil
        lastUpdated: Date.now,
        lastFetched: Date()
    )

    var repository: CaseStatusRepository!
    var mockLocalApi: MockLocalCaseStatusAPI!
    var mockRemoteApi: MockRemoteCaseStatusAPI!
    var mockNotificationService: MockNotificationService!

    override func setUp() {
        mockLocalApi = MockLocalCaseStatusAPI()
        mockRemoteApi = MockRemoteCaseStatusAPI()
        mockNotificationService = MockNotificationService()
        self.repository = CaseStatusRepository(
            local: mockLocalApi,
            remote: mockRemoteApi,
            notificationService: mockNotificationService
        )
    }

    func testAddCase() async {

        mockNotificationService.onRequestCalled = { _ in
            XCTFail("Notification should not have been invoked")
        }

        mockRemoteApi.onGetCalled = { receiptNumber in
            if receiptNumber == self.caseInitial.receiptNumber {
                return .success(self.caseInitial)
            } else {
                return .failure(CSError.invalidCase(receiptNumber))
            }
        }

        let result = await repository.addCase(receiptNumber: caseInitial.receiptNumber)
        switch result {
        case .success(let caseStatus):
            XCTAssertEqual(caseStatus.receiptNumber, caseInitial.receiptNumber)
        case .failure:
            XCTFail("Expected success case")
        }
    }

    func testUpdateCaseWithSameStatus() async {

        let expectation = XCTestExpectation()
        expectation.isInverted = true

        mockNotificationService.onRequestCalled = { notification in
            switch notification {
            case .statusUpdated(let caseStatus):
                XCTAssertEqual(caseStatus.receiptNumber, self.caseInitial.receiptNumber)
                expectation.fulfill()
            }
        }

        mockLocalApi.onQueryCalled = {
            .success([self.otherCase, self.caseInitial])
        }

        mockRemoteApi.onGetCalled = { receiptNumber in
            if receiptNumber == self.caseInitial.receiptNumber {
                return .success(self.caseInitial)
            } else if receiptNumber == self.otherCase.receiptNumber {
                return .success(self.otherCase)
            } else {
                return .failure(CSError.invalidCase(receiptNumber))
            }
        }

        await repository.query(force: true)
        await repository.query(force: true)

        wait(for: [expectation], timeout: 1)
    }

    func testUpdateCaseWithNewStatus() async {

        let expectation = XCTestExpectation()
        expectation.expectedFulfillmentCount = 1

        mockNotificationService.onRequestCalled = { notification in
            switch notification {
            case .statusUpdated(let caseStatus):
                XCTAssertEqual(caseStatus.receiptNumber, self.caseInitial.receiptNumber)
                expectation.fulfill()
            }
        }

        var callCount = 1
        mockLocalApi.onQueryCalled = {
            // Return two cases to ensure notification is only sent once for updated case and not `otherCase`.
            if callCount == 2 {
                return .success([self.otherCase, self.caseFinal_WithFormType])
            } else {
                callCount += 1
                return .success([self.otherCase, self.caseInitial])
            }
        }

        mockRemoteApi.onGetCalled = { receiptNumber in
            if receiptNumber == self.caseInitial.receiptNumber {
                return .success(self.caseInitial)
            } else if receiptNumber == self.otherCase.receiptNumber {
                return .success(self.otherCase)
            } else {
                return .failure(CSError.invalidCase(receiptNumber))
            }
        }

        await repository.query(force: true)
        await repository.query(force: true)

        wait(for: [expectation], timeout: 1)
    }
}
