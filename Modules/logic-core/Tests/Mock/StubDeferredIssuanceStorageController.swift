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
import logic_storage
import logic_test

/// In-memory entries keyed by document id. Can be made to fail reads or writes, or to hold one read until a gate opens.
actor StubDeferredIssuanceStorageController: DeferredIssuanceStorageController {

  struct ReadFailure: Error {}
  struct WriteFailure: Error {}

  private(set) var entries: [String: DeferredIssuance] = [:]
  private var failsReads = false
  private var failsWrites = false
  private var readCount = 0
  private var heldRead: (number: Int, gate: AsyncGate, reached: @Sendable () -> Void)?

  init(_ entries: [DeferredIssuance] = []) {
    self.entries = Dictionary(uniqueKeysWithValues: entries.map { ($0.identifier, $0) })
  }

  func setEntries(_ entries: [DeferredIssuance]) {
    self.entries = Dictionary(uniqueKeysWithValues: entries.map { ($0.identifier, $0) })
  }

  func setFailsReads(_ failsReads: Bool) {
    self.failsReads = failsReads
  }

  func setFailsWrites(_ failsWrites: Bool) {
    self.failsWrites = failsWrites
  }

  /// Holds the `number`th call to `retrieveAll()`, counting from 1, until `gate` opens. Calls `reached` when it gets there.
  func hold(read number: Int, until gate: AsyncGate, reached: @escaping @Sendable () -> Void) {
    heldRead = (number, gate, reached)
  }

  func store(_ value: DeferredIssuance) async throws {
    guard !failsWrites else { throw WriteFailure() }
    entries[value.identifier] = value
  }

  func store(_ values: [DeferredIssuance]) async throws {
    guard !failsWrites else { throw WriteFailure() }
    values.forEach { entries[$0.identifier] = $0 }
  }

  func update(_ value: DeferredIssuance) async throws {
    guard !failsWrites else { throw WriteFailure() }
    entries[value.identifier] = value
  }

  func retrieve(_ identifier: String) async throws -> DeferredIssuance {
    guard !failsReads else { throw ReadFailure() }
    guard let entry = entries[identifier] else { throw StorageError.itemNotFound }
    return entry
  }

  func retrieveAll() async throws -> [DeferredIssuance] {
    readCount += 1
    if let heldRead, heldRead.number == readCount {
      heldRead.reached()
      await heldRead.gate.wait()
    }
    guard !failsReads else { throw ReadFailure() }
    guard !entries.isEmpty else { throw StorageError.itemsNotFound }
    return Array(entries.values)
  }

  func delete(_ identifier: String) async throws {
    entries[identifier] = nil
  }

  func deleteAll() async throws {
    entries = [:]
  }
}
