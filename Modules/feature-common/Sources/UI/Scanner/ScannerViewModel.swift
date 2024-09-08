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
import logic_ui
import logic_core
import logic_resources
import logic_business

@Copyable
struct ScannerState: ViewState {

  let config: ScannerUiConfig
  let error: LocalizableString.Key?
  let showInformativeText: Bool
  let informativeTest: LocalizableString.Key
  let allowScanning: Bool
  let failedScanAttempts: Int

  var title: LocalizableString.Key {
    return config.flow.title
  }

  var caption: LocalizableString.Key {
    return config.flow.caption
  }
}

private extension ScannerState {
  static let MAX_ALLOWED_FAILED_SCANS = 5
}

final class ScannerViewModel<Router: RouterHost>: BaseViewModel<Router, ScannerState> {

  private let interactor: ScannerInteractor

  init(
    config: any UIConfigType,
    router: Router,
    interactor: ScannerInteractor
  ) {
    guard let config = config as? ScannerUiConfig else {
      fatalError("ScannerViewModel:: Invalid configuraton")
    }
    self.interactor = interactor
    super.init(
      router: router,
      initialState: .init(
        config: config,
        error: nil,
        showInformativeText: false,
        informativeTest: config.flow.informativeText,
        allowScanning: true,
        failedScanAttempts: 0
      )
    )
  }

  func onResult(scanResult: String) {
    guard viewState.allowScanning else { return }
    setState { $0.copy(allowScanning: false) }
    Task {

      let isValid = await interactor.validateForm(
        form: .init(
          inputs: [[Rule.ValidateUrl(errorMessage: "")]: scanResult]
        )
      ).isValid

      if isValid {
        self.onScanResultValidated(scanResult: scanResult)
      } else {

        let updatedFailedAttempts = viewState.failedScanAttempts + 1
        let maxFailedAttemptsExceeded = updatedFailedAttempts > ScannerState.MAX_ALLOWED_FAILED_SCANS

        setState {
          $0.copy(
            showInformativeText: maxFailedAttemptsExceeded,
            allowScanning: true,
            failedScanAttempts: updatedFailedAttempts
          )
        }
      }
    }
  }

  func onDismiss() {
    router.pop()
  }

  func onError() {
    setState {
      $0.copy(error: .cameraError)
    }
  }

  func onErrorClick() {
    UIApplication.shared.openAppSettings()
  }

  private func onScanResultValidated(scanResult: String) {
    switch viewState.config.flow {
    case .presentation:
      router.push(
        with: .presentationRequest(
          presentationCoordinator: interactor.startCrossDevicePresentation(scanResult: scanResult),
          originator: .dashboard
        )
      )
    case .issuing(let config):
      var successNavType: UIConfig.TwoWayNavigationType {
        return switch config.flow {
        case .noDocument: .push(.dashboard)
        case .extraDocument: .popTo(.dashboard)
        }
      }
      router.push(
        with: .credentialOfferRequest(
          config: UIConfig.Generic(
            arguments: ["uri": scanResult],
            navigationSuccessType: successNavType,
            navigationCancelType: .popTo(.issuanceAddDocument(config: config))
          )
        )
      )
    }
  }
}
