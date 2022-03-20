//
//  CaseTrackerUITests.swift
//  CaseTrackerUITests
//
//  Created by Fowler, Shaun on 2/20/22.
//

import XCTest
import SwiftUI

class CaseTrackerUITests: XCTestCase {

    let app = XCUIApplication()

    override func setUp() {
        setupSnapshot(app)
    }

    // MARK: - Adding cases

    func testScreenshotsAddCases_Light() {
        app.launchArguments = ["-uiTests", "-uiTestsLightMode"]
        app.launch()
        performAddCases("Light")
    }

    func testScreenshotsAddCases_Dark() {
        app.launchArguments = ["-uiTests", "-uiTestsDarkMode"]
        app.launch()
        performAddCases("Dark")
    }

    private func performAddCases(_ colorScheme: String) {
        // First-time view
        snapshot("FirstTime-\(colorScheme)")

        // Add case modal
        app.buttons["Add Your First Case"].tap()
        snapshot("AddCaseEmpty-\(colorScheme)")

        // Add case modal filled in
        app.textFields["XYZ0123456789"].tap()
        enterReceiptNumber(serviceCenter: "IOE", number: "9119251367")
        snapshot("AddCaseFilled-\(colorScheme)")
        app.buttons["Add Case"].tap()

        // Add remaining cases
        app.navigationBars["My Cases"].buttons["Add Case"].tap()
        enterReceiptNumber(serviceCenter: "MSC", number: "2119251333")
        app.buttons["Add Case"].firstMatch.tap()

        app.navigationBars["My Cases"].buttons["Add Case"].tap()
        enterReceiptNumber(serviceCenter: "MSC", number: "2119258454")
        app.buttons["Add Case"].firstMatch.tap()

        app.navigationBars["My Cases"].buttons["Add Case"].tap()
        enterReceiptNumber(serviceCenter: "LIN", number: "2118251021")
        app.buttons["Add Case"].firstMatch.tap()

        // Snapshot case list
        snapshot("CaseList-\(colorScheme)")
    }

    // MARK: - Adding case with error

    func testScreenshotAddCaseError_Light() {
        app.launchArguments = ["-uiTests", "-uiTestsLightMode"]
        app.launch()
        performAddCaseError("Light")
    }

    func testScreenshotAddCaseError_Dark() {
        app.launchArguments = ["-uiTests", "-uiTestsDarkMode"]
        app.launch()
        performAddCaseError("Dark")
    }

    private func performAddCaseError(_ colorScheme: String) {
        // Add a case with garbage receipt number
        app.buttons["Add Your First Case"].tap()
        app.textFields["XYZ0123456789"].tap()
        enterReceiptNumber(serviceCenter: "AAA", number: "123")
        app.buttons["Add Case"].tap()
        snapshot("AddCaseError-\(colorScheme)")

        // Dismiss error alert and close modal
        app.buttons["OK"].tap()
        app.buttons["Close"].tap()
    }

    // MARK: - Utilities

    private func enterText(_ text: String) {
        for t in text {
            app.keys[t.uppercased()].tap()
        }
    }

    private func enterReceiptNumber(serviceCenter: String, number: String) {
        enterText(serviceCenter)
        if UIDevice.current.userInterfaceIdiom == .phone {
            app.keys["more"].tap()
        }
        enterText(number)
    }
}
