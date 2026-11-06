/*
 * Copyright (c) 2026 European Commission
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
import logic_authentication

/// The route start-up continues to, or the error that stops it.
public enum StartupPartialState: Sendable {
  case success(AppRoute)
  case failure(Error)
}

public protocol StartupInteractor: Sendable {
  func initialize(with splashAnimationDuration: TimeInterval) async -> StartupPartialState
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

  /// Routes to login when a PIN exists and to PIN creation only when the wallet is known to hold no
  /// documents. A PIN record that cannot be read, or documents without one, end in `failure`. No
  /// document is loaded before login: whether any exist is read from the Keychain without them.
  public func initialize(with splashAnimationDuration: TimeInterval) async -> StartupPartialState {
    await manageStorageForFirstRun()
    let storedDocuments: Result<Bool, Error>
    do {
      storedDocuments = .success(try await walletKitController.hasStoredDocuments())
    } catch {
      storedDocuments = .failure(error)
    }
    try? await Task.sleep(seconds: splashAnimationDuration)
    let continuationRoute: AppRoute
    do {
      continuationRoute = try await getContinuationRoute(storedDocuments: storedDocuments)
    } catch {
      return .failure(error)
    }
    guard !prefsController.getBool(forKey: .trustMarkIntroductionCompleted) else {
      return .success(continuationRoute)
    }
    return .success(
      .featureCommonModule(
        .trustMark(
          config: TrustMarkUiConfig(
            mode: .welcome(continuationRoute: continuationRoute)
          )
        )
      )
    )
  }

  /// `storedDocuments` is whether the wallet holds documents, or why that could not be read.
  private func getContinuationRoute(storedDocuments: Result<Bool, Error>) async throws -> AppRoute {
    let hasDocuments = (try? storedDocuments.get()) ?? false
    if try await quickPinInteractor.hasPin() {
      return .featureCommonModule(
        .biometry(
          config: UIConfig.Biometry(
            navigationTitle: .enterYourPin,
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
            shouldInitializeBiometricOnCreate: true,
            displayNavigationBar: true
          )
        )
      )
    } else {
      if case .failure(let error) = storedDocuments {
        throw error
      }
      guard !hasDocuments else {
        throw AuthenticationError.pinNotFound
      }
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
    guard !prefsController.getBool(forKey: .runAtLeastOnce) else { return }
    try? await walletKitController.clearAllDocuments()

    let didWipeStorage = keyChainController.clear()
    if didWipeStorage {
      prefsController.setValue(true, forKey: .runAtLeastOnce)
    }
  }
}
