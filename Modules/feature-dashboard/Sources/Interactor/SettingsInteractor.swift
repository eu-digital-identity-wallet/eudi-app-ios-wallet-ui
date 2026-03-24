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
import feature_common

public protocol SettingsInteractor: Sendable {
  func getAppVersion() async -> String
  func retrieveLogFileUrl() async -> URL?
  func retrieveChangeLogUrl() async -> URL?
  func isBiometryAvailable() async -> Bool
  func isBiometryEnabled() async -> Bool
  func authenticateBiometry() async -> BiometricsState
  func setBiometrySelection(isEnabled: Bool) async
  func openBiometrySettings(action: @escaping @Sendable () -> Void) async
  func setBatchCounter(isEnabled: Bool) async
  func isBatchCounterEnabled() async -> Bool
}

final actor SettingsInteractorImpl: SettingsInteractor {

  private let walletController: WalletKitController
  private let prefsController: PrefsController
  private let configLogic: ConfigLogic
  private let biometryInteractor: BiometryInteractor

  init(
    walletController: WalletKitController,
    configLogic: ConfigLogic,
    biometryInteractor: BiometryInteractor,
    prefsController: PrefsController
  ) {
    self.walletController = walletController
    self.prefsController = prefsController
    self.configLogic = configLogic
    self.biometryInteractor = biometryInteractor
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

  func authenticateBiometry() async -> BiometricsState {
    await biometryInteractor.authenticate()
  }

  func setBiometrySelection(isEnabled: Bool) async {
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
}
