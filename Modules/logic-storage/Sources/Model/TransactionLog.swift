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

class RealmTransactionLog: Object {

  @Persisted(primaryKey: true) var identifier: String
  @Persisted var value: String = ""

  convenience init(identifier: String, value: String) {
    self.init()
    self.identifier = identifier
    self.value = value
  }
}

public struct TransactionLog: StoredObject {
  public let identifier: String
  public let value: String

  public init(identifier: String, value: String) {
    self.identifier = identifier
    self.value = value
  }
}

extension RealmTransactionLog {
  func toTransactionLog() -> TransactionLog {
    TransactionLog(identifier: self.identifier, value: self.value)
  }
}

extension TransactionLog {
  func toRealmTransactionLog() -> RealmTransactionLog {
    RealmTransactionLog(identifier: self.identifier, value: self.value)
  }
}

extension Array where Element == RealmTransactionLog {
  func toTransactionLogs() -> [TransactionLog] {
    self.map { $0.toTransactionLog() }
  }
}

extension Array where Element == TransactionLog {
  func toRealmTransactionLogs() -> [RealmTransactionLog] {
    self.map { $0.toRealmTransactionLog() }
  }
}
