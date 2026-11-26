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

public extension PresentationCredentialQueriesDomain {

  /// The ids of the queries that `documentId` answers in this option; empty when it answers none.
  func queryIds(of documentId: String) -> [String] {
    queryIdsByDocumentId[documentId] ?? []
  }

  /// The documents of `documentIds` that the user chooses to share or not: each answers only queries that accept
  /// more than one document, and every one of those queries has two or more of `documentIds`. Documents in
  /// `transactionDocumentIds` are left out: WalletKit authorizes their transaction data with them.
  func choosableDocumentIds(among documentIds: [String], excluding transactionDocumentIds: Set<String> = []) -> Set<String> {
    let documentCounts = documentCountsByQueryId(among: documentIds)
    return Set(
      documentIds.filter { documentId in
        !transactionDocumentIds.contains(documentId)
          && answersOnlyMultipleQueries(documentId)
          && queryIds(of: documentId).allSatisfy { documentCounts[$0, default: 0] > 1 }
      }
    )
  }

  /// True when two or more of `documentIds` answer the same query that accepts only one document. WalletKit builds
  /// such an option when two credential sets name the same query, but refuses to send it.
  func hasSingleQueryWithManyDocuments(among documentIds: [String]) -> Bool {
    documentCountsByQueryId(among: documentIds).contains { queryId, count in
      !multipleQueryIds.contains(queryId) && count > 1
    }
  }

  /// True when every query that `documentIds` answer keeps at least one document of `sharedDocumentIds`.
  func keepsEveryQuery(of documentIds: [String], sharing sharedDocumentIds: Set<String>) -> Bool {
    let sharedQueryIds = Set(documentIds.filter(sharedDocumentIds.contains).flatMap(queryIds(of:)))
    return documentIds.flatMap(queryIds(of:)).allSatisfy(sharedQueryIds.contains)
  }

  /// True when the option can be offered without `blockedDocumentIds`: each of them answers only queries that accept
  /// more than one document, carries no transaction data (`transactionDocumentIds`), and every query keeps another
  /// document of `documentIds`. The user then chooses among the rest.
  func canLeaveOut(
    _ blockedDocumentIds: Set<String>,
    among documentIds: [String],
    transactionDocumentIds: Set<String>
  ) -> Bool {
    blockedDocumentIds.allSatisfy { answersOnlyMultipleQueries($0) && !transactionDocumentIds.contains($0) }
      && keepsEveryQuery(of: documentIds, sharing: Set(documentIds).subtracting(blockedDocumentIds))
  }
}

private extension PresentationCredentialQueriesDomain {

  /// True when `documentId` answers at least one query, and only queries that accept more than one document.
  func answersOnlyMultipleQueries(_ documentId: String) -> Bool {
    let queryIds = queryIds(of: documentId)
    return !queryIds.isEmpty && queryIds.allSatisfy(multipleQueryIds.contains)
  }

  /// How many distinct documents of `documentIds` answer each query.
  func documentCountsByQueryId(among documentIds: [String]) -> [String: Int] {
    Set(documentIds).reduce(into: [:]) { counts, documentId in
      for queryId in Set(queryIds(of: documentId)) {
        counts[queryId, default: 0] += 1
      }
    }
  }
}
