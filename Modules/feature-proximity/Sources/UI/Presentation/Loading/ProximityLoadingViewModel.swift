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

final class ProximityLoadingViewModel<Router: RouterHost>: BaseLoadingViewModel<Router> {

  private let interactor: ProximityInteractor
  private let relyingParty: String
  private let relyingPartyIsTrusted: Bool
  private var publisherTask: Task<Void, Error>?
  private let requestItems: [RequestDataUI]

  init(
    router: Router,
    interactor: ProximityInteractor,
    relyingParty: String,
    relyingPartyIsTrusted: Bool,
    originator: AppRoute,
    requestItems: [any Routable]
  ) {
    guard
      let requestItems = requestItems as? [RequestDataUI]
    else {
      fatalError("ProximityLoadingViewModel:: Invalid configuraton")
    }

    self.interactor = interactor
    self.relyingParty = relyingParty
    self.relyingPartyIsTrusted = relyingPartyIsTrusted
    self.requestItems = requestItems
    super.init(router: router, originator: originator, cancellationTimeout: 5)
  }

  func subscribeToCoordinatorPublisher() async {
    switch self.interactor.getSessionStatePublisher() {
    case .success(let publisher):
      for try await state in publisher {
        switch state {
        case .error(let error):
          self.onError(with: error)
        case .responseSent:
          self.interactor.stopPresentation()
          self.onNavigate(
            type: .push(
              getOnSuccessRoute()
            )
          )
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
    .requestsTheFollowing
  }

  private func getOnSuccessRoute() -> AppRoute {
    publisherTask?.cancel()
    return .featureProximityModule(
      .proximitySuccess(
        config: DocumentSuccessUIConfig(
          successNavigation: .pop(screen: getOriginator()),
          relyingParty: relyingParty,
          relyingPartyIsTrusted: relyingPartyIsTrusted
        ),
        requestItems.map { $0.matToListItemSection() }
      )
    )
  }

  override func getOnPopRoute() -> AppRoute? {
    publisherTask?.cancel()
    return switch interactor.getCoordinator() {
    case .success(let proximitySessionCoordinator):
        .featureProximityModule(
          .proximityRequest(
            presentationCoordinator: proximitySessionCoordinator,
            originator: getOriginator()
          )
        )
    case .failure: nil
    }
  }

  override func doWork() async {

    startPublisherTask()

    let state = await Task.detached { () -> ProximityResponsePartialState in
      return await self.interactor.onSendResponse()
    }.value

    switch state {
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
