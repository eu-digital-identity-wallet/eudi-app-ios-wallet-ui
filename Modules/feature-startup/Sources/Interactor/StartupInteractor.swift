/*
 * Copyright (c) 2025 European Commission
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
import feature_common
import logic_core
import logic_business

public protocol StartupInteractor: Sendable {
  func initialize(with splashAnimationDuration: TimeInterval) async -> AppRoute
}

final actor StartupInteractorImpl: StartupInteractor {

  private let walletKitController: WalletKitController
  private let quickPinInteractor: QuickPinInteractor
  private let keyChainController: KeyChainController
  private let prefsController: PrefsController
  private let configLogic: ConfigLogic

  init(
    walletKitController: WalletKitController,
    quickPinInteractor: QuickPinInteractor,
    keyChainController: KeyChainController,
    prefsController: PrefsController,
    configLogic: ConfigLogic
  ) {
    self.walletKitController = walletKitController
    self.quickPinInteractor = quickPinInteractor
    self.keyChainController = keyChainController
    self.prefsController = prefsController
    self.configLogic = configLogic
  }

  public func initialize(with splashAnimationDuration: TimeInterval) async -> AppRoute {
    await manageStorageForFirstRun()
    try? await walletKitController.loadDocuments()
    let hasDocuments = await !walletKitController.fetchAllDocuments().isEmpty
    try? await Task.sleep(nanoseconds: splashAnimationDuration.nanoseconds)
    if await quickPinInteractor.hasPin() {
      return .featureCommonModule(
        .biometry(
          config: UIConfig.Biometry(
            navigationTitle: .custom(""),
            title: .loginTitle,
            caption: .loginCaption,
            quickPinOnlyCaption: .loginCaptionQuickPinOnly,
            navigationSuccessType: .push(
              !hasDocuments && configLogic.forcePidActivation
              ? .featureIssuanceModule(.issuanceAddDocument(config: IssuanceFlowUiConfig(flow: .noDocument)))
              : .featureDashboardModule(.dashboard)
            ),
            navigationBackType: nil,
            isPreAuthorization: true,
            shouldInitializeBiometricOnCreate: true
          )
        )
      )
    } else {
      return .featureCommonModule(
        .quickPin(
          config: QuickPinUiConfig(
            flow: configLogic.forcePidActivation
            ? .setWithActivation
            : .setWithoutActivation
          )
        )
      )
    }
  }

  private func manageStorageForFirstRun() async {
    if !prefsController.getBool(forKey: .runAtLeastOnce) {
      await walletKitController.clearAllDocuments()
      keyChainController.clear()
      prefsController.setValue(true, forKey: .runAtLeastOnce)
    }
  }
}
