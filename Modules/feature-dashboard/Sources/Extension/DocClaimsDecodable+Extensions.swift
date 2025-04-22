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
import SwiftUI
import feature_common
import logic_core

public extension DocClaimsDecodable {
  func transformToTransactionListItemSection() -> ListItemSection<Sendable> {
    return .init(
      id: self.id,
      title: self.displayName.ifNilOrEmpty { self.docType.orEmpty },
      listItems: self.parseClaim(
        documentId: self.id,
        isSensitive: false,
        input: self.docClaims
      )
    )
  }
}

public extension Array where Element == DocClaimsDecodable {
  func transformToTransactionListItemSections() -> [ListItemSection<Sendable>] {
    return self.map { $0.transformToTransactionListItemSection() }
  }
}
