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
 * the Licence is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF
 * ANY KIND, either express or implied. See the Licence for the specific language
 * governing permissions and limitations under the Licence.
 */
import XCTest
@testable import logic_core
@testable import logic_test

final class TestProximitySessionCoordinatorError: EudiTest {

  func testUiError_WhenTheReaderAuthenticationIsRefused_ThenTheStateSaysThePresentationIsBlocked() {
    let session = PresentationSession.stoppableFixture(onStop: nil)
    let coordinator = ProximitySessionCoordinatorImpl(session: session)

    session.uiError = WalletError(description: "Reader auth signature validation failed", code: .notSecuredRequest)

    guard case .error(let error) = coordinator.sendableCurrentValueSubject.getValue() else {
      return XCTFail("Expected an error state")
    }
    XCTAssertEqual(error.localizedDescription, WalletCoreError.presentationBlocked.localizedDescription)
  }

  func testUiError_WhenAnotherErrorIsReported_ThenTheStateIsLeftAlone() {
    let session = PresentationSession.stoppableFixture(onStop: nil)
    let coordinator = ProximitySessionCoordinatorImpl(session: session)

    session.uiError = WalletError(description: "Other", code: .internalError)

    XCTAssertEqual(coordinator.sendableCurrentValueSubject.getValue(), .loading)
  }
}
