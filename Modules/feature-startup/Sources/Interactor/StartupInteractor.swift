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
import logic_business

public protocol StartupInteractorType {
  func initialize(with splashAnimationDuration: TimeInterval) async -> AppRoute
}

public final actor StartupInteractor: StartupInteractorType {

  private lazy var walletController: WalletKitControllerType = WalletKitController.shared

  private var hasDocuments: Bool {
    return !walletController.fetchDocuments().isEmpty
  }

  private lazy var quickPinInteractor: QuickPinInteractorType = QuickPinInteractor()

  public init() {}

  public func initialize(with splashAnimationDuration: TimeInterval) async -> AppRoute {
    try? await Task.sleep(nanoseconds: splashAnimationDuration.nanoseconds)
    if quickPinInteractor.hasPin() {
      return .biometry(
        config: UIConfig.Biometry(
          title: .loginTitle,
          caption: .loginCaption,
          quickPinOnlyCaption: .loginCaptionQuickPinOnly,
          navigationSuccessConfig: .init(
            screen: hasDocuments
            ? .dashboard
            : .issuanceAddDocument(config: IssuanceFlowUiConfig(flow: .noDocument)),
            navigationType: .push
          ),
          navigationBackConfig: nil,
          isPreAuthorization: true,
          shouldInitializeBiometricOnCreate: true
        )
      )
    } else {
      return .quickPin(config: QuickPinUiConfig(flow: .set))
    }
  }
}
