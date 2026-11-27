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

/// Keeps a deletion and a deferred request for the same document from overlapping. WalletKit keeps a deferred
/// document's keys when it deletes it, so a credential arriving after the deletion would be stored as an issued
/// document the user had just removed.
/// A deletion waits for the request under way for its document; no request starts while it runs, and one
/// that ends meanwhile sees it with `isDeleting(_:)`. Clearing all documents does the same for every document.
/// An issuance waits for every request under way, and no request starts while it runs (`isIssuing`): WalletKit keeps
/// one issuance request per issuer, which two calls running at once would share.
actor DeferredRequestGate {

  /// Documents with a request under way, and the deletions waiting for it.
  private var requests: [String: [CheckedContinuation<Void, Never>]] = [:]
  /// Deletions under way per document; two can overlap.
  private var deletions: [String: Int] = [:]
  private var clearings = 0
  private var issuances = 0

  /// True while an issuance holds the requests back.
  var isIssuing: Bool {
    issuances > 0
  }

  /// False when the document is being deleted, an issuance is under way, or the document already has a request
  /// under way; then none may start.
  func beginRequest(for id: String) -> Bool {
    guard !isDeleting(id), !isIssuing, requests[id] == nil else { return false }
    requests[id] = []
    return true
  }

  func endRequest(for id: String) {
    requests.removeValue(forKey: id)?.forEach { $0.resume() }
  }

  func isDeleting(_ id: String) -> Bool {
    deletions[id] != nil || clearings > 0
  }

  /// Returns once the request under way for the document, if any, has ended.
  func beginDeletion(of id: String) async {
    deletions[id, default: 0] += 1
    await waitForRequest(for: id)
  }

  func endDeletion(of id: String) {
    guard let count = deletions[id] else { return }
    deletions[id] = count > 1 ? count - 1 : nil
  }

  /// Returns once every request under way has ended.
  func beginClearing() async {
    clearings += 1
    for id in Array(requests.keys) {
      await waitForRequest(for: id)
    }
  }

  func endClearing() {
    clearings = max(clearings - 1, 0)
  }

  /// Returns once every request under way has ended. Issuances can overlap one another.
  func beginIssuance() async {
    issuances += 1
    for id in Array(requests.keys) {
      await waitForRequest(for: id)
    }
  }

  func endIssuance() {
    issuances = max(issuances - 1, 0)
  }

  /// True while a request is under way for the document. Used by tests.
  func isRequesting(_ id: String) -> Bool {
    requests[id] != nil
  }
}

private extension DeferredRequestGate {

  func waitForRequest(for id: String) async {
    guard requests[id] != nil else { return }
    await withCheckedContinuation { continuation in
      requests[id, default: []].append(continuation)
    }
  }
}
