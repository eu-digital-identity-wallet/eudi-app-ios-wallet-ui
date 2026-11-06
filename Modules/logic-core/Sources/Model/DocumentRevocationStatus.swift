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

/// What a status list reported for a document the wallet keeps a revocation record for. Every record
/// blocks the document. A revoked document stays revoked; a suspended or unrecognised one is restored when
/// the status list reports it valid again. The statuses are the Android wallet's.
public enum DocumentRevocationStatus: String, Sendable, Equatable {
  case revoked
  case suspended
  /// A status value the wallet cannot interpret (application-specific or reserved), or a record stored
  /// before the status was kept. It blocks the document and is shown as revoked.
  case unrecognised
}
