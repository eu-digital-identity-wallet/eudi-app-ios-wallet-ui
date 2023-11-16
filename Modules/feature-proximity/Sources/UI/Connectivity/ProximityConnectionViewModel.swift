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
import EudiWalletKit
import logic_resources

struct ProxmityConnectivityState: ViewState {
  let error: ContentError.Config?
  let qrImage: UIImage?
  let transferStatus: TransferStatus
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
        qrImage: nil,
        transferStatus: interactor.presentationSession.status
      )
    )

    self.interactor.presentationSession.$status.sink { transferStatus in
      self.setNewState(transferStatus: transferStatus)
      switch transferStatus {
      case .qrEngagementReady:
        await self.generateQRCode()
      case .requestReceived:
        await self.onConnectionSuccess()
      case .error:
        self.onError()
      default:
        ()
      }
    }
    .store(in: &cancellables)
  }

  func initialize() async {
    switch await self.interactor.startDeviceEngagement() {
    case .success:
      print("Started Device Engagement")
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
    router.pop()
  }

  private func generateQRCode() async {
    switch await interactor.generateQRCode() {
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
    switch await interactor.doWork() {
    case .success:
      router.push(with: .proximityRequest)
    case .failure(let error):
      setNewState(
        error: .init(
          description: .custom(error.localizedDescription),
          cancelAction: self.router.pop()
        )
      )
    }
  }

  private func onError() {
    let errorDesc: LocalizableString.Key =
    if let errorDesc = interactor.presentationSession.uiError?.errorDescription {
      LocalizableString.Key.custom(errorDesc)
    } else {
      .genericErrorDesc
    }

    self.setNewState(
      error: .init(
        description: errorDesc,
        cancelAction: self.router.pop()
      )
    )
  }

  private func setNewState(
    error: ContentError.Config? = nil,
    qrImage: UIImage? = nil,
    transferStatus: TransferStatus? = nil
  ) {
    setState { previousState in
        .init(
          error: error,
          qrImage: qrImage ?? previousState.qrImage,
          transferStatus: transferStatus ?? previousState.transferStatus
        )
    }
  }
}
