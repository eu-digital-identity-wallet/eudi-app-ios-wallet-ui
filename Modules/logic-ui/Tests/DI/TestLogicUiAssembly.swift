/*
 * Copyright (c) 2026 European Commission
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
import Swinject
import logic_business
@testable import logic_ui
@testable import logic_core
@testable import logic_test

final class TestLogicUiAssembly: EudiTest {

  func testAssemble_WhenTheLinkInteractionAndCaptureControllersAreResolvedTwice_ThenEachIsTheSameInstance() {
    let container = Container()
    LogicBusinessAssembly().assemble(container: container)
    LogicUiAssembly().assemble(container: container)
    let prefsController = MockPrefsController()
    stub(prefsController) { mock in
      when(mock.remove(forKey: any())).thenDoNothing()
    }
    container.register(PrefsController.self) { _ in prefsController }
    container.register(WalletKitController.self) { _ in MockWalletKitController() }

    let link = container.resolve(DeepLinkController.self) as AnyObject?
    let interaction = container.resolve(UserInteractionController.self) as AnyObject?
    let capture = container.resolve(ScreenCaptureController.self) as AnyObject?

    XCTAssertNotNil(link)
    XCTAssertTrue(link === container.resolve(DeepLinkController.self) as AnyObject?)
    XCTAssertNotNil(interaction)
    XCTAssertTrue(interaction === container.resolve(UserInteractionController.self) as AnyObject?)
    XCTAssertNotNil(capture)
    XCTAssertTrue(capture === container.resolve(ScreenCaptureController.self) as AnyObject?)
  }
}
