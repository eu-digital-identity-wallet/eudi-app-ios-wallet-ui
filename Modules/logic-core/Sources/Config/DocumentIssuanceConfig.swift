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
import EudiWalletKit

struct DocumentIssuanceConfig {
  let defaultRule: DocumentIssuanceRule
  let documentSpecificRules: [DocumentTypeIdentifier: DocumentIssuanceRule]

  func rule(for documentIdentifier: DocumentTypeIdentifier?) -> DocumentIssuanceRule {
    guard let documentIdentifier, let rule = documentSpecificRules[documentIdentifier] else {
      return defaultRule
    }
    return rule
  }
}

struct DocumentIssuanceRule {
  let policy: CredentialPolicy
  let numberOfCredentials: Int
}
