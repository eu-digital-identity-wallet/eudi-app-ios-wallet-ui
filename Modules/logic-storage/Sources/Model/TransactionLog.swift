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
import SwiftData

@Model
final class SDTransactionLog: IdentifiableObject {

  @Attribute(.unique) var identifier: String
  var value: String

  init(identifier: String, value: String) {
    self.identifier = identifier
    self.value = value
  }
}

public struct TransactionLog: Sendable {

  public let identifier: String
  public let value: String

  public init(identifier: String, value: String) {
    self.identifier = identifier
    self.value = value
  }
}

extension SDTransactionLog {
  func toTransactionLog() -> TransactionLog {
    TransactionLog(identifier: identifier, value: value)
  }
}

extension TransactionLog {
  func toSdModel() -> SDTransactionLog {
    SDTransactionLog(identifier: identifier, value: value)
  }
}

extension Array where Element == SDTransactionLog {
  func toTransactionLogs() -> [TransactionLog] {
    map { $0.toTransactionLog() }
  }
}

extension Array where Element == TransactionLog {
  func toSdModels() -> [SDTransactionLog] {
    map { $0.toSdModel() }
  }
}
