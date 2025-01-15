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

public struct DeferrredDocument: DocClaimsDecodable {
  public var id: String
  public var createdAt: Date
  public var modifiedAt: Date?
  public var displayName: String?
  public var docType: String?
  public var docClaims: [MdocDataModel18013.DocClaim]
  public var docDataFormat: MdocDataModel18013.DocDataFormat
  public var ageOverXX: [Int: Bool]
  public var display: [MdocDataModel18013.DisplayMetadata]?
  public var issuerDisplay: [MdocDataModel18013.DisplayMetadata]?
  public var credentialIssuerIdentifier: String?
  public var configurationIdentifier: String?
}
