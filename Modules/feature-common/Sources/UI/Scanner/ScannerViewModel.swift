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

struct ScannerState: ViewState {
  let config: ScannerUiConfig

  var title: LocalizableString.Key {
    return config.flow.title
  }

  var caption: LocalizableString.Key {
    return config.flow.caption
  }
}

final class ScannerViewModel<Router: RouterHost>: BaseViewModel<Router, ScannerState> {

  private let walletKitController: WalletKitController

  @Published var onShowError: Bool = false

  init(
    config: any UIConfigType,
    router: Router,
    walletKitController: WalletKitController
  ) {
    guard let config = config as? ScannerUiConfig else {
      fatalError("ScannerViewModel:: Invalid configuraton")
    }
    self.walletKitController = walletKitController
    super.init(router: router, initialState: .init(config: config))
  }

  func onResult(scanResult: String) {
    switch viewState.config.flow {
    case .presentation:
      router.push(
        with: .presentationRequest(
          presentationCoordinator: walletKitController.startCrossDevicePresentation(
            urlString: scanResult
          )
        )
      )
    case .issuing:
      // MARK: - TODO ADD LOGIC FOR CREDENTIAL OFFER
      break
    }
  }

  func onDismiss() {
    router.pop()
  }

  func onError() {
    self.onShowError = true
  }
}
