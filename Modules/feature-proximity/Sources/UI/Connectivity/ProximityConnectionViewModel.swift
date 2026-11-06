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
import logic_ui
import logic_business
import logic_resources
import logic_core

@Copyable
struct ProxmityConnectivityState: ViewState {
  let error: ContentErrorView.Config?
  let qrImage: UIImage?
  let originator: AppRoute
}

final class ProximityConnectionViewModel<Router: RouterHost>: ViewModel<Router, ProxmityConnectivityState> {

  private let interactor: ProximityInteractor
  private var publisherTask: Task<Void, Error>?
  private var isSessionStarted = false
  private var isSessionHandedOver = false
  private var isSessionStopped = false
  private var scenePhase: ScenePhase = .active

  init(router: Router, interactor: ProximityInteractor, originator: AppRoute) {
    self.interactor = interactor
    super.init(
      router: router,
      initialState: .init(
        error: nil,
        qrImage: nil,
        originator: originator
      )
    )
  }

  func initialize() async {
    self.startPublisherTask()
    switch await self.interactor.onDeviceEngagement() {
    case .success: break
    case .failure(let error):
      self.onError(with: error)
    }
  }

  /// Stops the session when the app goes to the background while this screen waits for a reader, as the Android wallet
  /// does when its activity stops on the QR screen, so that the wallet does not go on advertising over Bluetooth until
  /// iOS suspends it, nor resume the session on return. `.inactive`, such as Control Center or a system sheet over the
  /// app, changes nothing.
  func setPhase(with phase: ScenePhase) {
    scenePhase = phase
    stopSessionIfInBackground()
  }

  func toolbarContent() -> ToolBarContent {
    .init(
      trailingActions: [],
      leadingActions: [
        .init(
          image: Theme.shared.image.chevronLeft,
          accessibilityLocator: ToolbarLocators.chevronLeft
        ) {
          self.pop()
        }
      ]
    )
  }

  private func startPublisherTask() {
    if publisherTask == nil || publisherTask?.isCancelled == true {
      publisherTask = Task {
        await self.subscribeToCoordinatorPublisher()
      }
      Task { try? await self.publisherTask?.value }
    }
  }

  private func subscribeToCoordinatorPublisher() async {
    switch await self.interactor.getSessionStatePublisher() {
    case .success(let publisher):
      for try await state in publisher {
        switch state {
        case .prepareQr:
          await self.onEngagementReady()
        case .requestReceived:
          await self.onConnectionSuccess()
        case .error(let error):
          self.onError(with: error)
        default:
          ()
        }
      }
    case .failure(let error):
      self.onError(with: error)
    }
  }

  private func pop() {
    stopSession()
    router.pop()
  }

  /// Starts the stop while iOS lets the app go on in the background, so that the user leaving the app does not cut it
  /// short.
  private func stopSession() {
    isSessionStopped = true
    publisherTask?.cancel()
    Task {
      await UIApplication.shared.keepRunningInBackground(named: "ProximityConnectionStop") {
        await self.interactor.stopPresentation()
      }
    }
  }

  /// Stops a session this screen started and still owns, once the app is in the background, also when the QR code
  /// became ready after the user had left. A session handed over to the request screen is that screen's to stop, and
  /// one already stopped or not yet advertising has nothing to stop. The screen then closes only while it is still in
  /// front, so that a screen that has taken its place is not closed instead.
  private func stopSessionIfInBackground() {
    guard
      scenePhase == .background,
      isSessionStarted,
      !isSessionHandedOver,
      !isSessionStopped
    else {
      return
    }
    stopSession()
    if case .featureProximityModule(.proximityConnection) = router.getCurrentScreen() {
      router.pop()
    }
  }

  /// The QR code is ready once WalletKit advertises over Bluetooth, so the session counts as started from here; the
  /// engagement itself returns only when a reader's request arrives or the session fails.
  private func onEngagementReady() async {
    isSessionStarted = true
    stopSessionIfInBackground()
    guard !isSessionStopped else { return }
    await onQRGeneration()
  }

  private func onQRGeneration() async {
    switch await interactor.onQRGeneration() {
    case .success(let qrImage):
      setState { $0.copy(error: nil).copy(qrImage: qrImage) }
    case .failure(let error):
      self.onError(with: error)
    }
  }

  /// Hands the session to the request screen, unless it has stopped, before or while the coordinator is fetched, for
  /// example by Back.
  private func onConnectionSuccess() async {
    isSessionHandedOver = true
    publisherTask?.cancel()
    switch await interactor.getCoordinator() {
    case .success(let proximitySessionCoordinator):
      guard !isSessionStopped else { return }
      router.push(
        with: .featureProximityModule(
          .proximityRequest(
            presentationCoordinator: proximitySessionCoordinator,
            originator: viewState.originator
          )
        )
      )
    case .failure(let error):
      self.onError(with: error)
    }
  }

  private func onError(with error: Error) {
    setState {
      $0.copy(
        error: .init(
          description: .custom(error.localizedDescription),
          cancelAction: self.pop()
        )
      )
    }
  }
}
