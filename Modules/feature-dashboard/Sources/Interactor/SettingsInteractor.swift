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
import logic_core
import logic_business
import logic_authentication
import feature_common

/// The outcome of the factory reset, for the reset screen.
public enum WalletResetPartialState: Sendable {
  case success
  case failure(Error)
}

public protocol SettingsInteractor: Sendable {
  func getAppVersion() async -> String
  func retrieveLogFileUrl() async -> URL?
  func retrieveChangeLogUrl() async -> URL?
  func isBiometryAvailable() async -> Bool
  func isBiometryEnabled() async -> Bool
  func setBiometrySelection(isEnabled: Bool) async -> BiometricsState
  func openBiometrySettings(action: @escaping @Sendable () -> Void) async
  func setBatchCounter(isEnabled: Bool) async
  func isBatchCounterEnabled() async -> Bool
  func setIssuerRegistrationValidation(isEnabled: Bool) async
  func isIssuerRegistrationValidationEnabled() async -> Bool
  /// Whether this iOS version has the Digital Credential API; without it the setting would do nothing.
  func isDocumentOfferingAvailable() async -> Bool
  /// The "Allow requests from websites (DC API)" setting, on by default.
  func isOfferingDocumentsToApps() async -> Bool
  /// Stores the choice and registers or withdraws the documents at once.
  func setOfferingDocumentsToApps(isEnabled: Bool) async
  /// Runs the factory reset; see `WalletResetController.resetWallet()`.
  func resetWallet() async -> WalletResetPartialState
}

final actor SettingsInteractorImpl: SettingsInteractor {

  private let walletController: WalletKitController
  private let prefsController: PrefsController
  private let configLogic: ConfigLogic
  private let biometryInteractor: BiometryInteractor
  private let walletResetController: WalletResetController

  init(
    walletController: WalletKitController,
    configLogic: ConfigLogic,
    biometryInteractor: BiometryInteractor,
    prefsController: PrefsController,
    walletResetController: WalletResetController
  ) {
    self.walletController = walletController
    self.prefsController = prefsController
    self.configLogic = configLogic
    self.biometryInteractor = biometryInteractor
    self.walletResetController = walletResetController
  }

  func resetWallet() async -> WalletResetPartialState {
    do {
      try await walletResetController.resetWallet()
      return .success
    } catch {
      return .failure(error)
    }
  }

  func getAppVersion() -> String {
    return configLogic.appVersion
  }

  func retrieveLogFileUrl() async -> URL? {
    return await walletController.retrieveLogFileUrl()
  }

  func retrieveChangeLogUrl() -> URL? {
    return configLogic.changelogUrl
  }

  func isBiometryAvailable() async -> Bool {
    await biometryInteractor.getBiometryType() != .none
  }

  func isBiometryEnabled() async -> Bool {
    await biometryInteractor.isBiometryEnabled()
  }

  func setBiometrySelection(isEnabled: Bool) async -> BiometricsState {
    await biometryInteractor.setBiometrySelection(isEnabled: isEnabled)
  }

  func openBiometrySettings(action: @escaping @Sendable () -> Void) async {
    await biometryInteractor.openSettings(action: action)
  }

  func isBatchCounterEnabled() async -> Bool {
    prefsController.getBool(forKey: .batchCounter)
  }

  func setBatchCounter(isEnabled: Bool) async {
    prefsController.setValue(isEnabled, forKey: .batchCounter)
  }

  func isIssuerRegistrationValidationEnabled() async -> Bool {
    prefsController.getBool(forKey: .validateIssuerRegistrationCertificate)
  }

  func isDocumentOfferingAvailable() -> Bool {
    if #available(iOS 26.0, *) {
      return true
    }
    return false
  }

  func isOfferingDocumentsToApps() async -> Bool {
    prefsController.getBool(forKey: .offerDocumentsToApps)
  }

  func setOfferingDocumentsToApps(isEnabled: Bool) async {
    prefsController.setValue(isEnabled, forKey: .offerDocumentsToApps)
    await walletController.reconcileRegistrations()
  }

  func setIssuerRegistrationValidation(isEnabled: Bool) async {
    prefsController.setValue(isEnabled, forKey: .validateIssuerRegistrationCertificate)
  }
}
