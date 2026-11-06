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
import logic_ui
@testable import logic_core
@testable import feature_proximity
@testable import logic_test
@testable import feature_test

final class TestProximityConnectionViewModel: EudiTest {

  @MainActor
  func testSetPhase_WhenTheAppGoesToTheBackgroundWithTheQrShown_ThenTheSessionStopsAndTheScreenCloses() async {
    let stopped = expectation(description: "session stopped")
    let closed = expectation(description: "screen closed")
    let session = makeSession(
      router: makeRouter(currentScreen: Self.qrRoute, onPop: { closed.fulfill() }),
      onStop: { stopped.fulfill() }
    )

    await session.showQr(in: self)
    session.viewModel.setPhase(with: .background)

    await fulfillment(of: [stopped, closed], timeout: 5)
    session.finish()
  }

  @MainActor
  func testSetPhase_WhenTheAppIsOnlyInactive_ThenTheSessionKeepsRunning() async {
    let stopped = invertedExpectation(description: "session stopped")
    let closed = invertedExpectation(description: "screen closed")
    let session = makeSession(
      router: makeRouter(currentScreen: Self.qrRoute, onPop: { closed.fulfill() }),
      onStop: { stopped.fulfill() }
    )

    await session.showQr(in: self)
    session.viewModel.setPhase(with: .inactive)
    session.viewModel.setPhase(with: .active)

    await fulfillment(of: [stopped, closed], timeout: 0.5)
    session.finish()
  }

  @MainActor
  func testSetPhase_WhenAReaderHasConnected_ThenTheSessionIsLeftToTheRequestScreen() async {
    let handedOver = expectation(description: "request screen opened")
    let stopped = invertedExpectation(description: "session stopped")
    let session = makeSession(
      router: makeRouter(currentScreen: Self.qrRoute, onPush: { handedOver.fulfill() }),
      onStop: { stopped.fulfill() }
    )

    await session.showQr(in: self)
    session.states.yield(.requestReceived(Constants.mockPresentationRequest))
    await fulfillment(of: [handedOver], timeout: 5)
    session.viewModel.setPhase(with: .background)

    await fulfillment(of: [stopped], timeout: 0.5)
    session.finish()
  }

  @MainActor
  func testSetPhase_WhenAnotherScreenIsInFront_ThenTheSessionStopsAndNothingCloses() async {
    let stopped = expectation(description: "session stopped")
    let closed = invertedExpectation(description: "screen closed")
    let session = makeSession(
      router: makeRouter(currentScreen: .featureDashboardModule(.dashboard), onPop: { closed.fulfill() }),
      onStop: { stopped.fulfill() }
    )

    await session.showQr(in: self)
    session.viewModel.setPhase(with: .background)

    await fulfillment(of: [stopped], timeout: 5)
    await fulfillment(of: [closed], timeout: 0.5)
    session.finish()
  }

  @MainActor
  func testSetPhase_WhenNoScreenIsInFront_ThenTheSessionStopsAndNothingCloses() async {
    let stopped = expectation(description: "session stopped")
    let closed = invertedExpectation(description: "screen closed")
    let session = makeSession(
      router: makeRouter(currentScreen: nil, onPop: { closed.fulfill() }),
      onStop: { stopped.fulfill() }
    )

    await session.showQr(in: self)
    session.viewModel.setPhase(with: .background)

    await fulfillment(of: [stopped], timeout: 5)
    await fulfillment(of: [closed], timeout: 0.5)
    session.finish()
  }

  @MainActor
  func testSetPhase_WhenTheAppGoesToTheBackgroundAgain_ThenTheSessionStopsOnce() async {
    let stopped = expectation(description: "session stopped")
    stopped.assertForOverFulfill = false
    let stoppedAgain = invertedExpectation(description: "session stopped again")
    stoppedAgain.expectedFulfillmentCount = 2
    let session = makeSession(
      router: makeRouter(currentScreen: Self.qrRoute),
      onStop: {
        stopped.fulfill()
        stoppedAgain.fulfill()
      }
    )

    await session.showQr(in: self)
    session.viewModel.setPhase(with: .background)
    session.viewModel.setPhase(with: .active)
    session.viewModel.setPhase(with: .background)

    await fulfillment(of: [stopped], timeout: 5)
    await fulfillment(of: [stoppedAgain], timeout: 0.5)
    session.finish()
  }

  @MainActor
  func testSetPhase_WhenEngagementReturnedButNoQrIsReady_ThenThereIsNothingToStop() async {
    let stopped = invertedExpectation(description: "session stopped")
    let closed = invertedExpectation(description: "screen closed")
    let session = makeSession(
      router: makeRouter(currentScreen: Self.qrRoute, onPop: { closed.fulfill() }),
      onStop: { stopped.fulfill() }
    )

    await session.viewModel.initialize()
    session.viewModel.setPhase(with: .background)

    await fulfillment(of: [stopped, closed], timeout: 0.5)
    session.finish()
  }

  @MainActor
  func testOnEngagementReady_WhenTheUserHadAlreadyLeft_ThenTheSessionStopsAndNoQrIsMade() async {
    let stopped = expectation(description: "session stopped")
    let closed = expectation(description: "screen closed")
    let qrMade = invertedExpectation(description: "QR code made")
    let session = makeSession(
      router: makeRouter(currentScreen: Self.qrRoute, onPop: { closed.fulfill() }),
      onQr: { qrMade.fulfill() },
      onStop: { stopped.fulfill() }
    )

    session.viewModel.setPhase(with: .background)
    session.start()
    session.states.yield(.prepareQr)

    await fulfillment(of: [stopped, closed], timeout: 5)
    await fulfillment(of: [qrMade], timeout: 0.5)
    session.finish()
  }

  @MainActor
  func testOnConnectionSuccess_WhenTheSessionWasStopped_ThenNoRequestScreenOpens() async {
    let stopped = expectation(description: "session stopped")
    let handedOver = invertedExpectation(description: "request screen opened")
    let session = makeSession(
      router: makeRouter(currentScreen: Self.qrRoute, onPush: { handedOver.fulfill() }),
      onStop: { stopped.fulfill() }
    )

    await session.showQr(in: self)
    session.states.yield(.requestReceived(Constants.mockPresentationRequest))
    session.viewModel.setPhase(with: .background)

    await fulfillment(of: [stopped], timeout: 5)
    await fulfillment(of: [handedOver], timeout: 0.5)
    session.finish()
  }
}

/// A QR screen's view model with the session states it observes. `.prepareQr` makes the QR code. Engagement returns
/// at once, which in the app happens only when a reader's request arrives or the session fails.
@MainActor
private struct ProximityConnectionSession {
  let viewModel: ProximityConnectionViewModel<MockRouterHost>
  let states: AsyncStream<PresentationState>.Continuation
  let qrMade: AsyncStream<Void>

  func start() {
    Task { await viewModel.initialize() }
  }

  /// Starts the screen and waits, at most five seconds, until its QR code is made.
  func showQr(in test: XCTestCase) async {
    let made = test.expectation(description: "QR made")
    let waiting = Task {
      for await _ in qrMade {
        made.fulfill()
        return
      }
    }
    start()
    states.yield(.prepareQr)
    await test.fulfillment(of: [made], timeout: 5)
    waiting.cancel()
  }

  func finish() {
    states.finish()
  }
}

private extension TestProximityConnectionViewModel {

  static var qrRoute: AppRoute {
    .featureProximityModule(
      .proximityConnection(
        presentationCoordinator: MockProximitySessionCoordinator(session: Constants.mockPresentationSession),
        originator: .featureDashboardModule(.dashboard)
      )
    )
  }

  func invertedExpectation(description: String) -> XCTestExpectation {
    let inverted = expectation(description: description)
    inverted.isInverted = true
    return inverted
  }

  @MainActor
  func makeRouter(
    currentScreen: AppRoute?,
    onPop: @escaping @Sendable () -> Void = {},
    onPush: @escaping @Sendable () -> Void = {}
  ) -> MockRouterHost {
    let router = MockRouterHost()
    stub(router) { mock in
      when(mock.getCurrentScreen()).thenReturn(currentScreen)
      when(mock.pop()).then { onPop() }
      when(mock.push(with: any())).then { _ in onPush() }
    }
    return router
  }

  @MainActor
  func makeSession(
    router: MockRouterHost,
    onQr: @escaping @Sendable () -> Void = {},
    onStop: @escaping @Sendable () -> Void = {}
  ) -> ProximityConnectionSession {
    let (states, stateContinuation) = AsyncStream.makeStream(of: PresentationState.self)
    let (qrMade, qrContinuation) = AsyncStream.makeStream(of: Void.self)
    let interactor = MockProximityInteractor()
    stub(interactor) { mock in
      when(mock.getSessionStatePublisher()).thenReturn(.success(states))
      when(mock.onDeviceEngagement()).thenReturn(.success)
      when(mock.onQRGeneration()).then {
        onQr()
        qrContinuation.yield()
        return .success(UIImage())
      }
      when(mock.stopPresentation()).then { onStop() }
      when(mock.getCoordinator()).thenReturn(
        .success(MockProximitySessionCoordinator(session: Constants.mockPresentationSession))
      )
    }
    return ProximityConnectionSession(
      viewModel: ProximityConnectionViewModel(
        router: router,
        interactor: interactor,
        originator: .featureDashboardModule(.dashboard)
      ),
      states: stateContinuation,
      qrMade: qrMade
    )
  }
}
