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
import logic_business
@testable import logic_core
@testable import feature_common
@testable import feature_proximity
@testable import logic_test
@testable import feature_test

final class TestProximityLoadingViewModel: EudiTest {

  @MainActor
  func testDoWork_WhenTheResponseIsSent_ThenShowsSuccessAndStopsOnlyOnceTheReaderLeaves() async {
    // Given
    let router = MockRouterHost()
    let successShown = expectation(description: "success shown")
    let stopLeftToTheReader = expectation(description: "stop left to the reader")
    let stoppedAtOnce = expectation(description: "stopped at once")
    stoppedAtOnce.isInverted = true
    stub(router) { mock in
      when(mock.push(with: any())).then { _ in successShown.fulfill() }
    }
    let interactor = MockProximityInteractor()
    stub(interactor) { mock in
      when(mock.getSessionStatePublisher()).thenReturn(.success(AsyncStream { $0.yield(.responseSent(nil)) }))
      when(mock.getCoordinator()).thenReturn(.failure(RuntimeError.genericError))
      when(mock.onSendResponse()).thenReturn(.sent)
      when(mock.stopPresentationOnceTheReaderLeaves()).then { stopLeftToTheReader.fulfill() }
      when(mock.stopPresentation()).then { stoppedAtOnce.fulfill() }
    }
    let viewModel = ProximityLoadingViewModel<MockRouterHost, DocumentElementClaim>(
      router: router,
      interactor: interactor,
      relyingParty: "Reader",
      relyingPartyIsTrusted: true,
      originator: .featureDashboardModule(.dashboard),
      requestItems: []
    )

    // When
    await viewModel.doWork()

    // Then
    await fulfillment(of: [stopLeftToTheReader, successShown, stoppedAtOnce], timeout: 1)
  }
}
