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

    // MARK: - Case List

    func testScreenshotsCaseList_Light() {
        snapshot("CaseList-Light")
    }

    func testScreenshotsCaseList_Dark() {
        snapshot("CaseList-Dark")
    }

    // MARK: - Add Case

    func testScreenshotsAddCase_Light() {
        app.buttons["Add Case"].tap()
        snapshot("AddCase-Light")
    }

    func testScreenshotsAddCase_Dark() {
        app.buttons["Add Case"].tap()
        snapshot("AddCase-Dark")
    }

    // MARK: - Case Details

    func testScreenshotCaseDetails_Light() {
        app.otherElements.buttons["MSC2119251333"].tap()
        snapshot("CaseDetails-Light")
    }

    func testScreenshotCaseDetails_Dark() {
        app.otherElements.buttons["MSC2119251333"].tap()
        snapshot("CaseDetails-Dark")
    }

    // MARK: - Case Details > More Menu

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

    // MARK: - Case Details > Share

    func testScreenshotCaseDetailsShare_Light() {
        app.otherElements.buttons["MSC2119251333"].tap()
        app.buttons["More"].tap()
        app.buttons["Share"].tap()
        snapshot("CaseDetailsShare-Light")
    }

    func testScreenshotCaseDetailsShare_Dark() {
        app.otherElements.buttons["MSC2119251333"].tap()
        app.buttons["More"].tap()
        app.buttons["Share"].tap()
        snapshot("CaseDetailsShare-Dark")
    }

    // MARK: - Case Details > Website

    func testScreenshotCaseDetailsWebsite_Light() {
        app.otherElements.buttons["MSC2119251333"].tap()
        app.buttons["More"].tap()
        app.buttons["View on USCIS Website"].tap()
        snapshot("CaseDetailsWebsite-Light")
    }

    func testScreenshotCaseDetailsWebsite_Dark () {
        app.otherElements.buttons["MSC2119251333"].tap()
        app.buttons["More"].tap()
        app.buttons["View on USCIS Website"].tap()
        snapshot("CaseDetailsWebsite-Dark")
    }
}
