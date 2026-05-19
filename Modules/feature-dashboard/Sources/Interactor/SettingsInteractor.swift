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
import LocalAuthentication
import logic_core
import logic_business
import logic_authentication
import feature_common

public struct SetBiometryResult: Sendable {
  public let isEnabled: Bool
  public let error: SystemBiometryError?

  public init(isEnabled: Bool, error: SystemBiometryError? = nil) {
    self.isEnabled = isEnabled
    self.error = error
  }
}

public protocol SettingsInteractor: Sendable {
  func getAppVersion() async -> String
  func retrieveLogFileUrl() async -> URL?
  func retrieveChangeLogUrl() async -> URL?
  func isBiometryAvailable() async -> Bool
  func isBiometryEnabled() async -> Bool
  func setBiometryEnabled(isEnabled: Bool) async -> SetBiometryResult
  func openBiometrySettings(action: @escaping @Sendable () -> Void) async
}

final actor SettingsInteractorImpl: SettingsInteractor {

  private let walletController: WalletKitController
  private let configLogic: ConfigLogic
  private let biometryInteractor: BiometryInteractor

  init(
    walletController: WalletKitController,
    configLogic: ConfigLogic,
    biometryInteractor: BiometryInteractor
  ) {
    self.walletController = walletController
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

  func setBiometryEnabled(isEnabled: Bool) async -> SetBiometryResult {
    guard isEnabled else {
      await biometryInteractor.setBiometrySelection(isEnabled: false)
      return SetBiometryResult(isEnabled: false)
    }

    switch await biometryInteractor.authenticate() {
    case .authenticated:
      await biometryInteractor.setBiometrySelection(isEnabled: true)
      return SetBiometryResult(isEnabled: true)
    case .failure(let error):
      return SetBiometryResult(isEnabled: false, error: error)
    }
  }

  func openBiometrySettings(action: @escaping @Sendable () -> Void) async {
    await biometryInteractor.openSettings(action: action)
  }
}
