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
import UIKit
@testable import logic_ui
@testable import logic_test

final class TestUserInteractionController: EudiTest {

  @MainActor
  func testInteractionGestureRecognizer_WhenATouchBegins_ThenReportsItWithoutHoldingTouchesBack() {
    var touches = 0
    let recognizer = InteractionGestureRecognizer { touches += 1 }

    recognizer.touchesBegan([], with: UIEvent())

    XCTAssertEqual(touches, 1)
    XCTAssertFalse(recognizer.cancelsTouchesInView)
    XCTAssertFalse(recognizer.delaysTouchesBegan)
    XCTAssertFalse(recognizer.delaysTouchesEnded)
    XCTAssertTrue(
      recognizer.gestureRecognizer(recognizer, shouldRecognizeSimultaneouslyWith: UITapGestureRecognizer())
    )
  }

  @MainActor
  func testStart_WhenTextChanges_ThenReportsInteraction() async {
    let reported = expectation(description: "interaction")
    let controller = UserInteractionControllerImpl()
    controller.start { reported.fulfill() }

    NotificationCenter.default.post(name: UITextField.textDidChangeNotification, object: nil)

    await fulfillment(of: [reported], timeout: 2)
  }

  @MainActor
  func testStart_WhenVoiceOverFocusMoves_ThenReportsInteraction() async {
    let reported = expectation(description: "interaction")
    let controller = UserInteractionControllerImpl()
    controller.start { reported.fulfill() }

    NotificationCenter.default.post(name: UIAccessibility.elementFocusedNotification, object: nil)

    await fulfillment(of: [reported], timeout: 2)
  }

  @MainActor
  func testStart_WhenCalledTwice_ThenKeepsTheFirstObserver() async {
    let first = expectation(description: "first observer")
    let second = expectation(description: "second observer")
    second.isInverted = true
    let controller = UserInteractionControllerImpl()
    controller.start { first.fulfill() }
    controller.start { second.fulfill() }

    NotificationCenter.default.post(name: UITextView.textDidChangeNotification, object: nil)

    await fulfillment(of: [first, second], timeout: 1)
  }
}
