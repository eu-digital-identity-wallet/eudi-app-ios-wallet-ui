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
import Foundation

extension Array where Element == WalletStorage.Document {
  func transformToDeferredDecodables() -> [DocClaimsDecodable] {
    return self.compactMap { document in
      return document.transformToDeferredDecodable()
    }
  }
}

extension WalletStorage.Document {
  func transformToDeferredDecodable() -> DeferrredDocument {
    let metadata = DocMetadata(from: self.metadata)
    return DeferrredDocument(
      id: self.id,
      statusIdentifier: nil,
      createdAt: self.createdAt,
      displayName: metadata?.getDisplayName(Locale.current.systemLanguageCode),
      docClaims: [],
      docDataFormat: self.docDataFormat,
      ageOverXX: [:],
      display: metadata?.display,
      issuerDisplay: metadata?.issuerDisplay,
      credentialIssuerIdentifier: metadata?.credentialIssuerIdentifier,
      configurationIdentifier: metadata?.configurationIdentifier,
      validFrom: nil,
      validUntil: nil
    )
  }
}
