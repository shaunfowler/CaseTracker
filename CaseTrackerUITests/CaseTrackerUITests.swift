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
        app.launchArguments = ["-uiTests"]
        app.launch()
    }

    // MARK: - Adding cases

    func testAddCases() {
        // Add case modal
        app.buttons["Add Your First Case"].tap()

        // Add case modal filled in
        app.textFields["XYZ0123456789"].tap()
        enterReceiptNumber(serviceCenter: "IOE", number: "9119251367")
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
    }

    // MARK: - Adding case with error

    func testAddCaseError() {
        // Add a case with garbage receipt number
        app.buttons["Add Your First Case"].tap()
        app.textFields["XYZ0123456789"].tap()
        enterReceiptNumber(serviceCenter: "AAA", number: "123")
        app.buttons["Add Case"].tap()

        // Dismiss error alert and close modal
        app.buttons["OK"].tap()
        app.buttons["Close"].tap()
    }

    // MARK: - Removing case

    func testAddRemoveCase() {
        // Add case modal
        app.buttons["Add Your First Case"].tap()

        // Add case modal filled in
        app.textFields["XYZ0123456789"].tap()
        enterReceiptNumber(serviceCenter: "IOE", number: "9119251367")
        app.buttons["Add Case"].tap()

        // Swipe to delete case
        app.otherElements.buttons["IOE9119251367"].swipeLeft()
        app.buttons["Delete"].tap()
    }

    func testAddRemoveCaseFromDetailsView() {
        // Add case modal
        app.buttons["Add Your First Case"].tap()

        // Add case modal filled in
        app.textFields["XYZ0123456789"].tap()
        enterReceiptNumber(serviceCenter: "IOE", number: "9119251367")
        app.buttons["Add Case"].tap()

        // Select case and delete
        app.otherElements.buttons["IOE9119251367"].tap()
        app.buttons["More"].tap()
        app.buttons["Remove Case"].tap()
        app.alerts["Remove Case"].buttons["Remove"].tap()
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
