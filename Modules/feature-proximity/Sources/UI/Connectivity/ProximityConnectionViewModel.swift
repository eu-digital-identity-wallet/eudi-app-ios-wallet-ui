/*
 * Copyright (c) 2023 European Commission
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import Foundation
import logic_ui
import logic_business
import UIKit
import logic_resources

struct ProxmityConnectivityState: ViewState {
  let error: ContentError.Config?
  let qrImage: UIImage?
}

@MainActor
final class ProximityConnectionViewModel<Router: RouterHostType, Interactor: ProximityInteractorType>: BaseViewModel<Router, ProxmityConnectivityState> {

  private let interactor: Interactor

  init(router: Router, interactor: Interactor) {
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

  func goBack() {
    Task {
      await interactor.stopPresentation()
    }
    router.pop()
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
    error: ContentError.Config? = nil,
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
