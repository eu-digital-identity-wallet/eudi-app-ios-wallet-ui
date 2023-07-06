//
//  mdoc_holderUITests.swift
//  mdoc-holderUITests
//
//  Created by ffeli on 21/05/2023.
//

import XCTest

final class mdoc_holderUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testUserInterface() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
		app.launch()
		takeScreenshot(of: app, named: "Main view")
		app.buttons["EU PID, eu.europa.ec.eudiw.pid.1"].tap()
		takeScreenshot(of: app, named: "EU-PID data view")
		let backButton = app.navigationBars["_TtGC7SwiftUI32NavigationStackHosting"].buttons["Back"]
		backButton.tap()
		app.buttons["mDL, org.iso.18013.5.1"].tap()
		takeScreenshot(of: app, named: "ISO mDL data view")
		backButton.tap()
		XCUIApplication().buttons["Share"].tap()
		takeScreenshot(of: app, named: "Present Device Engagement")
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
