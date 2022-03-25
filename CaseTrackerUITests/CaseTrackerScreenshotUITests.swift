//
//  CaseTrackerScreenshotUITests.swift
//  CaseTrackerUITests
//
//  Created by Shaun Fowler on 3/25/22.
//

import XCTest

class CaseTrackerScreenshotUITests: XCTestCase {

    // swiftlint:disable comma
    let argsLight = ["-uiTests", "-uiTestsLightMode", "-uiTestsScreenshots"]
    let argsDark  = ["-uiTests", "-uiTestsDarkMode",  "-uiTestsScreenshots"]

    let app = XCUIApplication()

    override func setUp() {
        setupSnapshot(app)
        app.launchArguments = self.name.contains("_Dark") ? argsDark : argsLight
        app.launch()
        print(self.name)
    }

    func testScreenshotsTestData_Light() {
        snapshot("TestData-Light")
    }

    func testScreenshotsTestData_Dark() {
        snapshot("TestData-Dark")
    }
}
