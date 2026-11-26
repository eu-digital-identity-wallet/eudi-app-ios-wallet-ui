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

/// The DCQL credential queries of one option of a remote request, as wallet-kit built the option: the queries each
/// document answers, and the queries that accept more than one document (`multiple: true`, OpenID4VP 1.0, section
/// 6.1). Empty for proximity, whose requests have no DCQL queries.
public struct PresentationCredentialQueriesDomain: Sendable, Equatable {

  /// The ids of the queries each document answers in this option, keyed by document id.
  public let queryIdsByDocumentId: [String: [String]]
  /// The ids of the queries that accept more than one document.
  public let multipleQueryIds: Set<String>

  public init(queryIdsByDocumentId: [String: [String]] = [:], multipleQueryIds: Set<String> = []) {
    self.queryIdsByDocumentId = queryIdsByDocumentId
    self.multipleQueryIds = multipleQueryIds
  }
}

public extension PresentationCredentialQueriesDomain {

  /// The ids of the queries that `documentId` answers in this option; empty when it answers none.
  func queryIds(of documentId: String) -> [String] {
    queryIdsByDocumentId[documentId] ?? []
  }

  /// The documents of `documentIds` that the user chooses to share or not: each answers only queries that accept
  /// more than one document, and every one of those queries has two or more of `documentIds`. Documents in
  /// `fixedDocumentIds` are left out: they carry transaction data, which wallet-kit can only authorize with them.
  func choosableDocumentIds(among documentIds: [String], excluding fixedDocumentIds: Set<String> = []) -> Set<String> {
    let documentCounts = documentCountsByQueryId(among: documentIds)
    return Set(
      documentIds.filter { documentId in
        let queryIds = queryIds(of: documentId)
        return !fixedDocumentIds.contains(documentId)
          && !queryIds.isEmpty
          && queryIds.allSatisfy { multipleQueryIds.contains($0) && documentCounts[$0, default: 0] > 1 }
      }
    )
  }

  /// True when `documentIds` give a query that accepts one document two or more documents. wallet-kit offers such
  /// an option when two credential sets name the same query, but refuses to send it (OpenID4VP 1.0, section 8.1).
  func givesASingleQueryManyDocuments(_ documentIds: [String]) -> Bool {
    documentCountsByQueryId(among: documentIds).contains { queryId, count in
      !multipleQueryIds.contains(queryId) && count > 1
    }
  }

  /// True when every query that `documentIds` answer keeps at least one document of `sharedDocumentIds`.
  func keepsEveryQuery(of documentIds: [String], sharing sharedDocumentIds: Set<String>) -> Bool {
    let sharedQueryIds = Set(documentIds.filter(sharedDocumentIds.contains).flatMap(queryIds(of:)))
    return documentIds.flatMap(queryIds(of:)).allSatisfy(sharedQueryIds.contains)
  }
}

private extension PresentationCredentialQueriesDomain {

  /// How many distinct documents of `documentIds` answer each query.
  func documentCountsByQueryId(among documentIds: [String]) -> [String: Int] {
    Set(documentIds).reduce(into: [:]) { counts, documentId in
      for queryId in Set(queryIds(of: documentId)) {
        counts[queryId, default: 0] += 1
      }
    }
  }
}
