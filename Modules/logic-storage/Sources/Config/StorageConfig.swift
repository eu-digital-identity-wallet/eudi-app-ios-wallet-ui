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
import RealmSwift
import logic_business
import Foundation

protocol StorageConfig: Sendable {
  var schemaVersion: UInt64 { get }
  var databaseName: String { get }
  var databaseExtension: String { get }
  var databaseKey: Data { get }
  var realmConfiguration: Realm.Configuration { get }
}

final class StorageConfigImpl: StorageConfig {

  private let keyChainController: KeyChainController

  init(keyChainController: KeyChainController) {
    self.keyChainController = keyChainController
  }

  var schemaVersion: UInt64 {
    1
  }

  var databaseName: String {
    "eudi_wallet"
  }

  var databaseExtension: String {
    "realm"
  }

  var databaseKey: Data {
    getRealmKey()
  }

  var realmConfiguration: Realm.Configuration {
    var realmConfig = Realm.Configuration.defaultConfiguration
    realmConfig.schemaVersion = self.schemaVersion
    realmConfig.fileURL?.deleteLastPathComponent()
    realmConfig.fileURL?.appendPathComponent(self.databaseName)
    realmConfig.fileURL?.appendPathExtension(self.databaseExtension)
    realmConfig.encryptionKey = self.databaseKey
    return realmConfig
  }
}

private extension StorageConfigImpl {
  func getRealmKey() -> Data {

    if let storedKey = keyChainController.getData(key: KeyChainIdentifier.realmKey) {
      return storedKey
    }

    var key = Data(count: 64)
    _ = key.withUnsafeMutableBytes {
        SecRandomCopyBytes(kSecRandomDefault, 64, $0.baseAddress!)
    }

    keyChainController.storeValue(key: KeyChainIdentifier.realmKey, value: key)

    return key
  }
}
