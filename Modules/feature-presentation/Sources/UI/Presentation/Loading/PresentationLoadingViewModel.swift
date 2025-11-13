/*
 * Copyright (c) 2025 European Commission
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

final class PresentationLoadingViewModel<Router: RouterHost, RequestItem: Sendable>: BaseLoadingViewModel<Router, RequestItem> {

  private let interactor: PresentationInteractor
  private var publisherTask: Task<Void, Error>?
  private var coordinator: RemoteSessionCoordinator?

  init(
    router: Router,
    interactor: PresentationInteractor,
    relyingParty: String,
    relyingPartyIsTrusted: Bool,
    originator: AppRoute,
    requestItems: [ListItemSection<RequestItem>]
  ) {

    self.interactor = interactor

    super.init(
      router: router,
      originator: originator,
      requestItems: requestItems,
      relyingParty: relyingParty,
      relyingPartyIsTrusted: relyingPartyIsTrusted,
      cancellationTimeout: 5
    )
  }

  func subscribeToCoordinatorPublisher() async {
    switch await self.interactor.getSessionStatePublisher() {
    case .success(let publisher):
      for try await state in publisher {
        switch state {
        case .error(let error):
          self.onError(with: error)
        case .responseSent(let url):
          await self.interactor.stopPresentation()
          self.onNavigate(type: .push(await getOnSuccessRoute(with: url)))
        default:
          ()
        }
      }
    case .failure(let error):
      self.onError(with: error)
    }
  }

  override func getTitle() -> LocalizableStringKey {
    .requestDataTitle([getRelyingParty()])
  }

  override func getCaption() -> LocalizableStringKey {
    .requestsTheFollowing
  }

  private func getOnSuccessRoute(with url: URL?) async -> AppRoute {

    self.publisherTask?.cancel()

    var navigationType: UIConfig.DeepLinkNavigationType {
      guard let url else {
        return .pop(screen: getOriginator())
      }
      guard !isDynamicIssuance() else {
        Task { await interactor.storeDynamicIssuancePendingUrl(with: url) }
        return .pop(screen: getOriginator())
      }
      return .deepLink(
        link: url,
        popToScreen: .featureDashboardModule(.dashboard)
      )
    }

    return .featurePresentationModule(
      .presentationSuccess(
        config: DocumentSuccessUIConfig(
          successNavigation: navigationType,
          relyingParty: getRelyingParty(),
          relyingPartyIsTrusted: isRelyingPartyIstrusted()
        ),
        getRequestItems()
      )
    )
  }

  private func isDynamicIssuance() -> Bool {
    guard
      getOriginator() == AppRoute.featureIssuanceModule(.credentialOfferRequest(config: NoConfig()))
        || getOriginator() == AppRoute.featureIssuanceModule(.issuanceAddDocument(config: NoConfig()))
        || getOriginator() == AppRoute.featureIssuanceModule(.issuanceCode(config: NoConfig()))
    else {
      return false
    }
    return true
  }

  override func getOnPopRoute() -> AppRoute? {
    self.publisherTask?.cancel()
    guard let coordinator = self.coordinator else { return nil }
    return .featurePresentationModule(
      .presentationRequest(
        presentationCoordinator: coordinator,
        originator: getOriginator()
      )
    )
  }

  override func doWork() async {

    startPublisherTask()

    await getCoordinator()

    let result = await interactor.onSendResponse()

    switch result {
    case .sent: break
    case .failure(let error):
      self.onError(with: error)
    }
  }

  private func startPublisherTask() {
    if publisherTask == nil || publisherTask?.isCancelled == true {
      publisherTask = Task {
        await self.subscribeToCoordinatorPublisher()
      }
      Task { try? await self.publisherTask?.value }
    }
  }

  private func getCoordinator() async {
    switch await interactor.getCoordinator() {
    case .success(let remoteSessionCoordinator):
      self.coordinator = remoteSessionCoordinator
    case .failure:
      self.coordinator = nil
    }
  }
}
