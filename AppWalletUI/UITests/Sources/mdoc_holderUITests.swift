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

import XCTest
@testable import EudiWalletKit
import MdocDataModel18013

final class appWalletUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
	
	
	func testIssueWithVCInoOffer() async throws {
		let wallet = EudiWallet.standard
		wallet.userAuthenticationRequired = true
		//wallet.trustedReaderCertificates = [Data(name: "scytales_root_ca", ext: "der")!]
		wallet.verifierApiUri = ProcessInfo.processInfo.environment["VERIFIER_API"] ?? "https://eudi.netcompany-intrasoft.com"
		wallet.vciIssuerUrl = ProcessInfo.processInfo.environment["VCI_ISSUER_URL"] ?? "https://eudi.netcompany-intrasoft.com/pid-issuer" // "https://preprod.issuer.eudiw.dev/oidc"
		wallet.vciClientId = ProcessInfo.processInfo.environment["VCI_CLIENT_ID"] ?? "wallet-dev"
		wallet.vciRedirectUri = ProcessInfo.processInfo.environment["VCI_CALLBACK_SCHEME"] ?? "urn:ietf:wg:oauth:2.0:oob" // "eu
		let doc = try await wallet.issueDocument(docType: EuPidModel.euPidDocType, format: .cbor)
		XCTAssert(doc.data.count > 0)
	}

    func app_wallet_ui_user_interface() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
		app.launch()
		takeScreenshot(of: app, named: "Main view")
		XCUIApplication().buttons["Add sample documents"].tap()
		takeScreenshot(of: app, named: "Main view 2")
		app.buttons["EuPidButton"].tap()
		takeScreenshot(of: app, named: "EU-PID data view")
		let backButton = app.navigationBars["_TtGC7SwiftUI32NavigationStackHosting"].buttons["Back"]
		backButton.tap()
		app.buttons["IsoMdlButton"].tap()
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
