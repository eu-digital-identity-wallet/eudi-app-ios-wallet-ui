/*
 * Copyright (c) 2023 European Commission
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

final class PresentationLoadingViewModel<Router: RouterHost>: BaseLoadingViewModel<Router> {

  private let interactor: PresentationInteractor
  private let relyingParty: String
  private var publisherTask: Task<Void, Error>?

  init(
    router: Router,
    interactor: PresentationInteractor,
    relyingParty: String,
    originator: AppRoute
  ) {
    self.interactor = interactor
    self.relyingParty = relyingParty
    super.init(router: router, originator: originator, cancellationTimeout: 5)
  }

  func subscribeToCoordinatorPublisher() async {
    switch self.interactor.getSessionStatePublisher() {
    case .success(let publisher):
      for try await state in publisher {
        switch state {
        case .error(let error):
          self.onError(with: error)
        case .responseSent(let url):
          self.interactor.stopPresentation()
          self.onNavigate(type: .push(getOnSuccessRoute(with: url)))
        default:
          ()
        }
      }
    case .failure(let error):
      self.onError(with: error)
    }
  }

  override func getTitle() -> LocalizableString.Key {
    .requestDataTitle([relyingParty])
  }

  override func getCaption() -> LocalizableString.Key {
    .pleaseWait
  }

  private func getOnSuccessRoute(with url: URL?) -> AppRoute {

    self.publisherTask?.cancel()

    var navigationType: UIConfig.DeepLinkNavigationType {
      guard let url else {
        return .pop(screen: getOriginator())
      }
      guard !isDynamicIssuance() else {
        interactor.storeDynamicIssuancePendingUrl(with: url)
        return .pop(screen: getOriginator())
      }
      return .deepLink(link: url, popToScreen: .featureDashboardModule(.dashboard))
    }

    return .featureCommonModule(
      .success(
        config: UIConfig.Success(
          title: .init(value: .success),
          subtitle: .requestDataShareSuccess([relyingParty]),
          buttons: [
            .init(
              title: .requestDataShareButton,
              style: .primary,
              navigationType: navigationType
            )
          ],
          visualKind: .defaultIcon
        )
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
    return switch interactor.getCoordinator() {
    case .success(let remoteSessionCoordinator):
        .featurePresentationModule(
          .presentationRequest(
            presentationCoordinator: remoteSessionCoordinator,
            originator: getOriginator()
          )
        )
    case .failure: nil
    }
  }

  override func doWork() async {

    startPublisherTask()

    let result = await Task.detached { () -> RemoteSentResponsePartialState in
      return await self.interactor.onSendResponse()
    }.value

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
      Task {
        try? await self.publisherTask?.value
      }
    }
  }
}
