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
import logic_business

final class ProximityRequestViewModel<Router: RouterHost>: BaseRequestViewModel<Router> {

  private let interactor: ProximityInteractor
  private var publisherTask: Task<Void, Error>?

  init(
    router: Router,
    interactor: ProximityInteractor,
    originator: AppRoute
  ) {
    self.interactor = interactor
    super.init(router: router, originator: originator)
  }

  func subscribeToCoordinatorPublisher() async {
    switch self.interactor.getSessionStatePublisher() {
    case .success(let publisher):
      for try await state in publisher {
        switch state {
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

  override func doWork() async {

    self.onStartLoading()
    self.startPublisherTask()

    let state = await Task.detached { () -> ProximityRequestPartialState in
      return await self.interactor.onRequestReceived()
    }.value

    switch state {
    case .success(let items, let relyingParty, _, let isTrusted):
      self.onReceivedItems(
        with: items,
        title: .requestDataTitle([relyingParty]),
        relyingParty: relyingParty,
        isTrusted: isTrusted
      )
    case .failure:
      self.onEmptyDocuments()
    }
  }

  override func onShare() {
    Task {

      let items = self.viewState.items

      let response = await Task.detached { () -> ProximityResponsePreparationPartialState in
        return await self.interactor.onResponsePrepare(requestItems: items)
      }.value

      switch response {
      case .success:
        if let route = self.getSuccessRoute() {
          self.router.push(with: route)
        } else {
          self.router.pop()
        }
      case .failure(let error):
        self.onError(with: error)
      }
    }
  }

  override func getSuccessRoute() -> AppRoute? {
    publisherTask?.cancel()
    return switch interactor.getCoordinator() {
    case .success(let proximitySessionCoordinator):
        .featureCommonModule(
          .biometry(
            config: UIConfig.Biometry(
              title: getTitle(),
              caption: .requestDataShareBiometryCaption,
              quickPinOnlyCaption: .requestDataShareQuickPinCaption,
              navigationSuccessType: .push(
                .featureProximityModule(
                  .proximityLoader(
                    getRelyingParty(),
                    presentationCoordinator: proximitySessionCoordinator,
                    originator: getOriginator()
                  )
                )
              ),
              navigationBackType: .pop,
              isPreAuthorization: false,
              shouldInitializeBiometricOnCreate: true
            )
          )
        )
    case .failure: nil
    }
  }

  override func getPopRoute() -> AppRoute? {
    publisherTask?.cancel()
    return getOriginator()
  }

  override func getTitle() -> LocalizableString.Key {
    viewState.title
  }

  override func getCaption() -> LocalizableString.Key {
    .requestDataCaption
  }

  override func getDataRequestInfo() -> LocalizableString.Key {
    .requestDataInfoNotice
  }

  override func getRelyingParty() -> String {
    viewState.relyingParty
  }

  override func getTitleCaption() -> String {
    LocalizableString.shared.get(with: .requestDataTitle([""]))
  }

  override func getTrustedRelyingParty() -> LocalizableString.Key {
    .requestDataVerifiedEntity
  }

  override func getTrustedRelyingPartyInfo() -> LocalizableString.Key {
    .requestDataVerifiedEntityMessage
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
