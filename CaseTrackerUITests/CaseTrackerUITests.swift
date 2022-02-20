//
//  CaseTrackerUITests.swift
//  CaseTrackerUITests
//
//  Created by Fowler, Shaun on 2/20/22.
//

import XCTest

class CaseTrackerUITests: XCTestCase {

    func testLaunchPerformance() throws {
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }
}
