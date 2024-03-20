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

struct ProxmityConnectivityState: ViewState {
  let error: ContentErrorView.Config?
  let qrImage: UIImage?
}

final class ProximityConnectionViewModel<Router: RouterHost>: BaseViewModel<Router, ProxmityConnectivityState> {

  private let interactor: ProximityInteractor

  init(router: Router, interactor: ProximityInteractor) {
    self.interactor = interactor
    super.init(
      router: router,
      initialState: .init(
        error: nil,
        qrImage: nil
      )
    )
  }

  func initialize() async {
    await self.subscribeToCoordinatorPublisher()
    switch await self.interactor.onDeviceEngagement() {
    case .success:
      await self.onConnectionSuccess()
    case .failure(let error):
      setNewState(
        error: .init(
          description: .custom(error.localizedDescription),
          cancelAction: self.router.pop()
        )
      )
    }
  }

  func subscribeToCoordinatorPublisher() async {
    await interactor.getSessionStatePublisher()
      .sink { state in
        switch state {
        case .prepareQr:
          await self.onQRGeneration()
        case .error:
          self.onError()
        default:
          print(state)
        }
      }
      .store(in: &cancellables)
  }

  private func onQRGeneration() async {
    switch await interactor.onQRGeneration() {
    case .success(let qrImage):
      setNewState(qrImage: qrImage)
    case .failure(let error):
      setNewState(
        error: .init(
          description: .custom(error.localizedDescription),
          cancelAction: self.router.pop()
        )
      )
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
    router.push(with: .proximityRequest(presentationCoordinator: interactor.presentationSessionCoordinator))
  }

  private func onError() {
    self.setNewState(
      error: .init(
        description: .genericErrorDesc,
        cancelAction: self.router.pop()
      )
    )
  }

  private func setNewState(
    error: ContentErrorView.Config? = nil,
    qrImage: UIImage? = nil
  ) {
    setState { previousState in
        .init(
          error: error,
          qrImage: qrImage ?? previousState.qrImage
        )
    }
  }
}
