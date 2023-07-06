//
//  Extensions.swift
//  mdoc-holderUITests
//
//  Created by ffeli on 06/07/2023.
//

import Foundation
import XCTest

extension XCTestCase {
	/// Take a screenshot of a given app and add it to the test attachements.
	/// - Parameters:
	///   - app: The app to take a screenshot of.
	///   - name: The name of the screenshot.
	func takeScreenshot(of app: XCUIApplication, named name: String) {
		let screenshot = app.windows.firstMatch.screenshot()
		let attachment = XCTAttachment(screenshot: screenshot)
		#if os(iOS)
		attachment.name = "Screenshot-\(name)-\(UIDevice.current.name).png"
		#else
		attachment.name = "Screenshot-\(name)-macOS.png"
		#endif
		attachment.lifetime = .keepAlways
		add(attachment)
	}
}
