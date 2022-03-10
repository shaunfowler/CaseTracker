//
//  CaseTrackerUITests.swift
//  CaseTrackerUITests
//
//  Created by Fowler, Shaun on 2/20/22.
//

import XCTest

class CaseTrackerUITests: XCTestCase {

    let app = XCUIApplication()

    override func setUp() {
        setupSnapshot(app)
        app.launchArguments = ["-uiTests"]
        app.launch()
    }

    func testAddCase() {
        app.buttons["Add Your First Case"].tap()

        snapshot("AddCase")

        app.textFields["XYZ0123456789"].tap()

        enterText("IOE")
        if UIDevice.current.userInterfaceIdiom == .phone {
            app.keys["more"].tap()
        }
        enterText("8780539778")

        snapshot("AddingCase")

        app.buttons["Add Case"].tap()

        snapshot("AddedCase")

        app.navigationBars["My Cases"].buttons["Add Case"].tap()

        enterText("LIN")
        if UIDevice.current.userInterfaceIdiom == .phone {
            app.keys["more"].tap()
        }
        enterText("2119151272")

        app.buttons["Add Case"].firstMatch.tap()

        snapshot("AddingCase2")
    }

    private func enterText(_ text: String) {
        for t in text {
            app.keys[t.uppercased()].tap()
        }
    }
}
