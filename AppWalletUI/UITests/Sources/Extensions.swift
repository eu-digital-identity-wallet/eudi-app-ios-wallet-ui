/*
 * Copyright (c) 2023 European Commission
 *
 * Licensed under the EUPL, Version 1.2 or - as soon they will be approved by the European
 * Commission - subsequent versions of the EUPL (the "Licence"); You may not use this work
 * except in compliance with the Licence.
 *
 * You may obtain a copy of the Licence at:
 * https://joinup.ec.europa.eu/software/page/eupl
 *
 * Unless required by applicable law or agreed to in writing, software distributed under
 * the Licence is distributed on an "AS IS" basis, WITHOUT WARRANTIES OR CONDITIONS OF
 * ANY KIND, either express or implied. See the Licence for the specific language
 * governing permissions and limitations under the Licence.
 */

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
