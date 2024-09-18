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

final class ProximityConnectionViewModel<Router: RouterHost>: BaseViewModel<Router, ProxmityConnectivityState> {

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
    switch await self.interactor.onDeviceEngagement() {
    case .success:
      await self.onConnectionSuccess()
    case .failure(let error):
      self.onError(with: .custom(error.localizedDescription))
    }
  }

  func subscribeToCoordinatorPublisher() async {
    await interactor.getSessionStatePublisher()
      .sink { state in
        switch state {
        case .prepareQr:
          await self.onQRGeneration()
        case .error:
          self.onError(with: .genericErrorDesc)
        default:
          print(state)
        }
      }
      .store(in: &cancellables)
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
    cancellables.forEach({$0.cancel()})
    router.push(
      with: .featureProximityModule(
        .proximityRequest(
          presentationCoordinator: interactor.presentationSessionCoordinator,
          originator: viewState.originator
        )
      )
    )
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
