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

final class TestProximityRequestViewModel: EudiTest {

  @MainActor
  func testDoWork_WhenTheReaderDidNotAuthenticate_ThenWarnsAboutItsAccessCertificate() async {
    let viewModel = makeViewModel(isTrusted: false)

    await viewModel.doWork()

    XCTAssertEqual(viewModel.viewState.registrationWarning, .accessCertificateNotTrusted)
  }

  @MainActor
  func testDoWork_WhenTheReaderAuthenticated_ThenShowsNoWarning() async {
    let viewModel = makeViewModel(isTrusted: true)

    await viewModel.doWork()

    XCTAssertNil(viewModel.viewState.registrationWarning)
  }

  @MainActor
  func testDoWork_WhenTheReaderLeavesBeforeTheUserAnswers_ThenThePresentationEndsAndTheScreenGoesBack() async {
    let router = MockRouterHost()
    let wentBack = expectation(description: "went back")
    let stopped = expectation(description: "presentation stopped")
    stub(router) { mock in
      when(mock.popTo(with: any())).then { _ in wentBack.fulfill() }
    }
    let viewModel = makeViewModel(
      isTrusted: true,
      router: router,
      readerLeaves: true,
      onStop: { stopped.fulfill() }
    )

    await viewModel.doWork()

    await fulfillment(of: [stopped, wentBack], timeout: 5, enforceOrder: true)
  }

  @MainActor
  func testDeclineRequest_WhenTheUserGoesBack_ThenThePresentationEnds() async {
    let stopped = expectation(description: "presentation stopped")
    let viewModel = makeViewModel(isTrusted: true, onStop: { stopped.fulfill() })

    await viewModel.declineRequest()

    await fulfillment(of: [stopped], timeout: 5)
  }

  @MainActor
  func testOnShare_WhenTheReaderLeavesAfterTheShare_ThenTheScreenDoesNotGoBack() async {
    let router = MockRouterHost()
    let wentBack = expectation(description: "went back")
    wentBack.isInverted = true
    stub(router) { mock in
      when(mock.popTo(with: any())).then { _ in wentBack.fulfill() }
      when(mock.pop()).thenDoNothing()
    }
    let viewModel = makeViewModel(isTrusted: true, router: router, readerLeaves: true)

    await viewModel.doWork()
    viewModel.onShare()

    await fulfillment(of: [wentBack], timeout: 0.5)
  }

  @MainActor
  func testGetPopRoute_WhenTheScreenIsLeft_ThenALaterDisconnectDoesNotGoBack() async {
    let router = MockRouterHost()
    let wentBack = expectation(description: "went back")
    wentBack.isInverted = true
    stub(router) { mock in
      when(mock.popTo(with: any())).then { _ in wentBack.fulfill() }
    }
    let viewModel = makeViewModel(isTrusted: true, router: router, readerLeaves: true)

    await viewModel.doWork()
    _ = viewModel.getPopRoute()

    await fulfillment(of: [wentBack], timeout: 0.5)
  }

  @MainActor
  func testOnShare_WhenTheReaderHasLeft_ThenNothingIsShared() async throws {
    let router = MockRouterHost()
    let wentBack = expectation(description: "went back")
    stub(router) { mock in
      when(mock.popTo(with: any())).then { _ in wentBack.fulfill() }
    }
    let shared = expectation(description: "response prepared")
    shared.isInverted = true
    let viewModel = makeViewModel(
      isTrusted: true,
      router: router,
      readerLeaves: true,
      onPrepare: { shared.fulfill() }
    )

    await viewModel.doWork()
    await fulfillment(of: [wentBack], timeout: 5)
    viewModel.onShare()

    await fulfillment(of: [shared], timeout: 0.5)
  }

  @MainActor
  func testOnReappear_WhenTheRequestShowsAgain_ThenTheReaderIsWatchedAgain() async {
    let watched = expectation(description: "reader watched")
    watched.expectedFulfillmentCount = 2
    let viewModel = makeViewModel(isTrusted: true, onWatch: { watched.fulfill() })

    await viewModel.doWork()
    await viewModel.onReappear()

    await fulfillment(of: [watched], timeout: 5)
  }

  @MainActor
  func testOnReappear_WhenTheReaderHasLeft_ThenTheReaderIsNotWatchedAgain() async {
    let router = MockRouterHost()
    let wentBack = expectation(description: "went back")
    stub(router) { mock in
      when(mock.popTo(with: any())).then { _ in wentBack.fulfill() }
    }
    let watchedAgain = Self.secondWatch(of: self)
    let viewModel = makeViewModel(
      isTrusted: true,
      router: router,
      readerLeaves: true,
      onWatch: { watchedAgain.fulfill() }
    )

    await viewModel.doWork()
    await fulfillment(of: [wentBack], timeout: 5)
    await viewModel.onReappear()

    await fulfillment(of: [watchedAgain], timeout: 0.5)
  }

  @MainActor
  func testOnReappear_WhenTheRequestShowsAnError_ThenTheReaderIsNotWatchedAgain() async {
    let (sessionStates, continuation) = AsyncStream.makeStream(of: PresentationState.self)
    let watchedAgain = Self.secondWatch(of: self)
    let viewModel = makeViewModel(
      isTrusted: true,
      sessionStates: sessionStates,
      onWatch: { watchedAgain.fulfill() }
    )

    await viewModel.doWork()
    let errorShown = expectation(description: "error shown")
    withObservationTracking { _ = viewModel.viewState } onChange: { errorShown.fulfill() }
    continuation.yield(.error(RuntimeError.genericError))
    await fulfillment(of: [errorShown], timeout: 5)
    await viewModel.onReappear()
    continuation.finish()

    XCTAssertNotNil(viewModel.viewState.error)
    await fulfillment(of: [watchedAgain], timeout: 0.5)
  }
}

private extension TestProximityRequestViewModel {

  /// Fails the test when the reader is watched a second time; the first watch, when the request shows, counts
  /// towards it without fulfilling it.
  static func secondWatch(of test: XCTestCase) -> XCTestExpectation {
    let watchedAgain = test.expectation(description: "reader watched again")
    watchedAgain.expectedFulfillmentCount = 2
    watchedAgain.isInverted = true
    return watchedAgain
  }

  @MainActor
  func makeViewModel(
    isTrusted: Bool,
    router: MockRouterHost = MockRouterHost(),
    readerLeaves: Bool = false,
    sessionStates: AsyncStream<PresentationState> = AsyncStream { $0.finish() },
    onWatch: @escaping @Sendable () -> Void = {},
    onStop: @escaping @Sendable () -> Void = {},
    onPrepare: @escaping @Sendable () -> Void = {}
  ) -> ProximityRequestViewModel<MockRouterHost> {
    let interactor = MockProximityInteractor()
    stub(interactor) { mock in
      when(mock.waitForReaderDisconnect()).then {
        onWatch()
        return readerLeaves
      }
      when(mock.stopPresentation()).then { onStop() }
      when(mock.onResponsePrepare(requestItems: any())).then { _ in
        onPrepare()
        return .success(RequestItems())
      }
      when(mock.getSessionStatePublisher()).thenReturn(.success(sessionStates))
      when(mock.getCoordinator()).thenReturn(.failure(RuntimeError.genericError))
      when(mock.onRequestReceived()).thenReturn(
        .success(
          [],
          relyingParty: "Reader",
          dataRequestInfo: "",
          isTrusted: isTrusted,
          relyingPartyRegistration: RelyingPartyRegistration(
            name: nil,
            uniqueId: nil,
            isVerified: false,
            logoUrl: nil,
            registration: .notSupported
          )
        )
      )
    }
    return ProximityRequestViewModel(
      router: router,
      interactor: interactor,
      originator: .featureDashboardModule(.dashboard)
    )
  }
}
