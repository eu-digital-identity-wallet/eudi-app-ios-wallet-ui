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
import EudiWalletKit

extension DisclosedDocumentSet {
  /// The option's DCQL queries as the request screen uses them.
  func credentialQueriesDomain() -> PresentationCredentialQueriesDomain {
    PresentationCredentialQueriesDomain(
      queryIdsByDocumentId: credentialSelections.queryIdsByDocumentId(),
      multipleQueryIds: Set(credentialQueries.filter(\.multiple).map(\.queryId.value))
    )
  }
}

extension CredentialSelectionSet {
  /// Every query id each document answers, keyed by document id: a document that answers alternatives merged into
  /// one option carries all of their ids.
  func queryIdsByDocumentId() -> [String: [String]] {
    reduce(into: [:]) { result, selection in
      result[selection.credentialId, default: []].append(contentsOf: selection.queryIds.map(\.value))
    }
  }
}
