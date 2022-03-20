//
//  CaseStatusTests.swift
//  CaseTrackerTests
//
//  Created by Fowler, Shaun on 2/20/22.
//

import XCTest
import Case_Tracker

enum Receipt: String {
    case ABC1234
    case LIN2119051098
    case LIN2119051099
}

private func loadCaseHtml(filename: String) -> String? {
    if let file = Bundle(for: CaseStatusTests.self).url(forResource: filename, withExtension: "html"),
       let data = try? Data(contentsOf: file) {
        return String(data: data, encoding: .utf8)
    }
    return nil
}

// swiftlint:disable force_try line_length
class CaseStatusTests: XCTestCase {

    func testParseCompleteCase() {
        let receiptNumber = "LIN2119051099"
        let html = loadCaseHtml(filename: receiptNumber)!
        let result = try! CaseStatus(receiptNumber: receiptNumber, htmlString: html)

        XCTAssertEqual(result.receiptNumber, receiptNumber)
        XCTAssertEqual(result.status, Status.responseToUSCISRequestForEvidenceWasReceived.rawValue)
        XCTAssertEqual(result.body, "On March 17, 2022, we received your response to our Request for Evidence for your Form I-485, Application to Register Permanent Residence or Adjust Status, Receipt Number LIN2119051099. USCIS has begun working on your case again. We will send you a decision or notify you if we need something from you. If you move, go to www.uscis.gov/addresschange to give us your new mailing address.")
        XCTAssertEqual(result.formType, "I-485")

        XCTAssertNotNil(result.lastUpdated)
        let components = Calendar.current.dateComponents([.year, .month, .day], from: result.lastUpdated!)
        XCTAssertEqual(components.year, 2022)
        XCTAssertEqual(components.month, 3)
        XCTAssertEqual(components.day, 17)
    }

    func testParseIncompleteCase() {
        let receiptNumber = "LIN2119051098"
        let html = loadCaseHtml(filename: receiptNumber)!
        let result = try! CaseStatus(receiptNumber: receiptNumber, htmlString: html)

        XCTAssertEqual(result.receiptNumber, receiptNumber)
        XCTAssertEqual(result.status, Status.caseWasApprovedAndMyDecisionWasEmailed.rawValue)
        XCTAssertEqual(result.body, "We approved your Form I-140, Immigrant Petition for Alien Worker, Receipt Number LIN2119051098, and emailed you an approval notice. Please follow any instructions on the approval notice. If you move, go to www.uscis.gov/addresschange to give us your new mailing address.")
        XCTAssertEqual(result.formType, "I-140")

        XCTAssertNil(result.lastUpdated)
    }

    func testParseError() {
        let receiptNumber = "ABC1234"
        let html = loadCaseHtml(filename: receiptNumber)!
        XCTAssertThrowsError(try CaseStatus(receiptNumber: "ABC1234", htmlString: html), "") { error in
            XCTAssertEqual(error as? CSError, CSError.invalidCase)
        }
    }

    func testParseGarbageData() {
        let html = "df9u823fnsadanguisdgh!)@#&FD*=/*"
        XCTAssertThrowsError(try CaseStatus(receiptNumber: "LIN2119051099", htmlString: html), "") { error in
            XCTAssertEqual(error as? CSError, CSError.htmlParse)
        }
    }
}
