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
import feature_common
import logic_core
import logic_business

public protocol StartupInteractor {
  func initialize(with splashAnimationDuration: TimeInterval) async -> AppRoute
}

final class StartupInteractorImpl: StartupInteractor {

  private let walletKitController: WalletKitController
  private let quickPinInteractor: QuickPinInteractor

  private var hasDocuments: Bool {
    return !walletKitController.fetchAllDocuments().isEmpty
  }

  init(
    walletKitController: WalletKitController,
    quickPinInteractor: QuickPinInteractor
  ) {
    self.walletKitController = walletKitController
    self.quickPinInteractor = quickPinInteractor
  }

  public func initialize(with splashAnimationDuration: TimeInterval) async -> AppRoute {
    try? await walletKitController.loadDocuments()
    try? await Task.sleep(nanoseconds: splashAnimationDuration.nanoseconds)
    if quickPinInteractor.hasPin() {
      return .biometry(
        config: UIConfig.Biometry(
          title: .loginTitle,
          caption: .loginCaption,
          quickPinOnlyCaption: .loginCaptionQuickPinOnly,
          navigationSuccessType: .push(
            hasDocuments
            ? .dashboard
            : .issuanceAddDocument(config: IssuanceFlowUiConfig(flow: .noDocument))
          ),
          navigationBackType: nil,
          isPreAuthorization: true,
          shouldInitializeBiometricOnCreate: true
        )
      )
    } else {
      return .quickPin(config: QuickPinUiConfig(flow: .set))
    }
  }
}
