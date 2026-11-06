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
import feature_common
import logic_core

final class ProximityRequestViewModel<Router: RouterHost>: BaseRequestViewModel<Router> {

  private let interactor: ProximityInteractor
  private var publisherTask: Task<Void, Error>?
  private var disconnectTask: Task<Void, Never>?
  private var isWatchingReader = false
  private var hasReaderLeft = false
  private var coordinator: ProximitySessionCoordinator?

  init(
    router: Router,
    interactor: ProximityInteractor,
    originator: AppRoute
  ) {
    self.interactor = interactor
    super.init(router: router, originator: originator)
  }

  deinit {
    disconnectTask?.cancel()
    publisherTask?.cancel()
  }

  override func doWork() async {

    self.onStartLoading()
    self.startPublisherTask()

    await self.getCoordinator()

    let state = await interactor.onRequestReceived()

    switch state {
    case .success(let combinations, let relyingParty, _, let isTrusted, let registration):
      self.onReceivedCombinations(
        with: combinations,
        title: .requestDataTitle([relyingParty]),
        relyingParty: .custom(relyingParty),
        isTrusted: isTrusted
      )
      self.onReceivedRegistration(registration, isRelyingPartyTrusted: isTrusted)
      self.isWatchingReader = true
      self.watchReaderDisconnect()
    case .notSecuredRequest:
      self.onTrustBlocked()
    case .failure(let error):
      self.onEmptyDocuments(error: error.errorMessage)
      if let registration = await interactor.registrationForFailedRequest() {
        self.onReceivedRegistration(registration, isRelyingPartyTrusted: registration.isVerified)
      }
    }
  }

  override func onShare() {
    guard !hasReaderLeft else { return }
    disconnectTask?.cancel()
    Task {

      let items = self.viewState.items

      let response = await interactor.onResponsePrepare(requestItems: items)

      switch response {
      case .success:
        if let route = self.getSuccessRoute() {
          self.router.push(with: route)
        } else {
          self.router.pop()
        }
      case .failure(let error):
        self.showError(error)
      }
    }
  }

  /// Resumes the reader watch when the request shows again, for example after the user backed out of biometry.
  override func onReappear() async {
    guard isWatchingReader, !hasReaderLeft, viewState.error == nil else { return }
    watchReaderDisconnect()
  }

  override func getSuccessRoute() -> AppRoute? {
    publisherTask?.cancel()
    guard let coordinator = self.coordinator else { return nil }
    return .featureCommonModule(
      .biometry(
        config: UIConfig.Biometry(
          navigationTitle: .biometryConfirmRequest,
          caption: .requestDataShareBiometryCaption,
          quickPinOnlyCaption: .requestDataShareQuickPinCaption,
          pinTextFieldTitle: .enterYourPin,
          navigationSuccessType: .push(
            .featureProximityModule(
              .proximityLoader(
                relyingParty: getRelyingParty().toString,
                relyingPartyisTrusted: getRelyingPartyIsTrusted(),
                presentationCoordinator: coordinator,
                originator: getOriginator(),
                items: viewState.items.filterSelectedRows()
              )
            )
          ),
          navigationBackType: .pop,
          isPreAuthorization: false,
          shouldInitializeBiometricOnCreate: true
        )
      )
    )
  }

  override func getPopRoute() -> AppRoute? {
    publisherTask?.cancel()
    disconnectTask?.cancel()
    return getOriginator()
  }

  override func stopPresentation() async {
    await interactor.stopPresentation()
  }

  override func declineRequest() async {
    await stopPresentation()
  }

  override func getRelyingParty() -> LocalizableStringKey {
    viewState.relyingParty
  }

  /// Ends the presentation and goes back, as the back arrow does, once the reader ends the Bluetooth session
  /// before the user answers, as the Android wallet's request screen does. A share or leaving the screen
  /// cancels the watch first, so the reader's disconnect after a response does not send the user back.
  private func watchReaderDisconnect() {
    disconnectTask?.cancel()
    disconnectTask = Task { [weak self, interactor] in
      guard await interactor.waitForReaderDisconnect(), !Task.isCancelled, let self else { return }
      self.hasReaderLeft = true
      await self.stopPresentation()
      self.onPop()
    }
  }

  /// Shows an error and stops the reader watch: the request is over, so a later disconnect must not act.
  private func showError(_ error: Error) {
    disconnectTask?.cancel()
    onError(with: error)
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
        case .error(let error):
          self.showError(error)
        default:
          ()
        }
      }
    case .failure(let error):
      self.showError(error)
    }
  }

  private func getCoordinator() async {
    return switch await interactor.getCoordinator() {
    case .success(let proximitySessionCoordinator):
      self.coordinator = proximitySessionCoordinator
    case .failure:
      self.coordinator = nil
    }
  }
}
