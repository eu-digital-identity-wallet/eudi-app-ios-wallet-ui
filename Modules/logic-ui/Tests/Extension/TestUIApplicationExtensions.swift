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

final class TestUIApplicationExtensions: EudiTest {

  @MainActor
  func testIsCovered_WhenAControllerOfACoveringModuleIsPresented_ThenIsTrue() {
    let root = StubPresentingController(presenting: StubPresentingController(presenting: nil))

    XCTAssertTrue(UIApplication.isCovered(presentedFrom: root, byModules: ["logic_ui_tests"]))
  }

  @MainActor
  func testIsCovered_WhenTheCoveringControllerIsPresentedOverAnother_ThenIsTrue() {
    let covering = CoveringScreens.StubController(presenting: nil)
    let root = StubPresentingController(presenting: StubPresentingController(presenting: covering))

    XCTAssertTrue(UIApplication.isCovered(presentedFrom: root, byModules: ["logic_ui_tests.CoveringScreens"]))
    XCTAssertFalse(UIApplication.isCovered(presentedFrom: root, byModules: ["logic_ui_tests.OtherScreens"]))
  }

  @MainActor
  func testIsCovered_WhenNothingIsPresentedOrOnlyOtherModules_ThenIsFalse() {
    let root = StubPresentingController(presenting: UIViewController())

    XCTAssertFalse(UIApplication.isCovered(presentedFrom: root, byModules: ["EudiRQESUi"]))
    XCTAssertFalse(UIApplication.isCovered(presentedFrom: StubPresentingController(presenting: nil), byModules: ["EudiRQESUi"]))
    XCTAssertFalse(UIApplication.isCovered(presentedFrom: nil, byModules: ["EudiRQESUi"]))
  }
}

/// Stands for a covering SDK: its type names start with `logic_ui_tests.CoveringScreens.`.
enum CoveringScreens {
  final class StubController: StubPresentingController {}
}

class StubPresentingController: UIViewController {
  private let presented: UIViewController?

  init(presenting presented: UIViewController?) {
    self.presented = presented
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    nil
  }

  override var presentedViewController: UIViewController? {
    presented
  }

  @MainActor
  func testKeepRunningInBackground_WhenTheOperationEnds_ThenReturnsItsValue() async {
    var ran = false

    let value = await UIApplication.shared.keepRunningInBackground(named: "test") { () async -> Int in
      ran = true
      return 42
    }

    XCTAssertTrue(ran)
    XCTAssertEqual(value, 42)
  }
}
