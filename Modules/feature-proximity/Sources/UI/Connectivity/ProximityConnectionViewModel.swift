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
import Foundation
import logic_ui
import logic_business
import UIKit
import logic_resources

@Copyable
struct ProxmityConnectivityState: ViewState {
  let error: ContentErrorView.Config?
  let qrImage: UIImage?
  let originator: AppRoute
}

final class ProximityConnectionViewModel<Router: RouterHost>: ViewModel<Router, ProxmityConnectivityState> {

  private let interactor: ProximityInteractor

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
    await self.subscribeToCoordinatorPublisher()

    let state = await Task.detached { () -> ProximityInitialisationPartialState in
      return await self.interactor.onDeviceEngagement()
    }.value

    switch state {
    case .success:
      await self.onConnectionSuccess()
    case .failure(let error):
      self.onError(with: .custom(error.localizedDescription))
    }
  }

  func subscribeToCoordinatorPublisher() async {
    switch self.interactor.getSessionStatePublisher() {
    case .success(let publisher):
      for try await state in publisher {
        switch state {
        case .prepareQr:
          await self.onQRGeneration()
        case .error:
          self.onError(with: .genericErrorDesc)
        default:
          ()
        }
      }
    case .failure(let error):
      self.onError(with: .custom(error.localizedDescription))
    }
  }

  private func onQRGeneration() async {
    switch await interactor.onQRGeneration() {
    case .success(let qrImage):
      setState { $0.copy(error: nil).copy(qrImage: qrImage) }
    case .failure(let error):
      self.onError(with: .custom(error.localizedDescription))
    }
  }

  func goBack() {
    Task {
      await interactor.stopPresentation()
    }
    router.pop()
  }

  private func onConnectionSuccess() async {
    switch interactor.getCoordinator() {
    case .success(let proximitySessionCoordinator):
      cancellables.forEach({$0.cancel()})
      router.push(
        with: .featureProximityModule(
          .proximityRequest(
            presentationCoordinator: proximitySessionCoordinator,
            originator: viewState.originator
          )
        )
      )
    case .failure(let error):
      self.onError(with: .custom(error.localizedDescription))
    }
  }

  private func onError(with desc: LocalizableString.Key) {
    setState {
      $0.copy(
        error: .init(
          description: desc,
          cancelAction: self.router.pop()
        )
      )
    }
  }
}
