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
import logic_core
import logic_business

public protocol SettingsInteractor: Sendable {
  func getAppVersion() async -> String
  func retrieveLogFileUrl() async -> URL?
  func retrieveChangeLogUrl() async -> URL?
}

final actor SettingsInteractorImpl: SettingsInteractor {

  private let walletController: WalletKitController
  private let configLogic: ConfigLogic

  init(
    walletController: WalletKitController,
    configLogic: ConfigLogic
  ) {
    self.walletController = walletController
    self.configLogic = configLogic
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
}
