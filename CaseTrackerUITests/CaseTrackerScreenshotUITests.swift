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

    func testScreenshotsCaseList_Light() {
        snapshot("CaseList-Light")
    }

    func testScreenshotsCaseList_Dark() {
        snapshot("CaseList-Dark")
    }

    func testScreenshotsAddCase_Light() {
        app.buttons["Add Case"].tap()
        snapshot("AddCase-Light")
    }

    func testScreenshotsAddCase_Dark() {
        app.buttons["Add Case"].tap()
        snapshot("AddCase-Dark")
    }

    func testScreenshotCaseDetails_Light() {
        app.otherElements.buttons["MSC2119251333"].tap()
        snapshot("CaseDetails-Light")
    }

    func testScreenshotCaseDetails_Dark() {
        app.otherElements.buttons["MSC2119251333"].tap()
        snapshot("CaseDetails-Dark")
    }

    func testScreenshotCaseDetailsMoreMenu_Light() {
        app.otherElements.buttons["MSC2119251333"].tap()
        app.buttons["More"].tap()
        snapshot("CaseDetailsMoreMenu-Light")
    }

    func testScreenshotCaseDetailsMoreMenu_Dark() {
        app.otherElements.buttons["MSC2119251333"].tap()
        app.buttons["More"].tap()
        snapshot("CaseDetailsMoreMenu-Dark")
    }
}
