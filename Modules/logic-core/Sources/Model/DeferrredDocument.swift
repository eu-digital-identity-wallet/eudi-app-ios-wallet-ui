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

public struct DeferrredDocument: MdocDecodable {
  public var id: String
  public var createdAt: Date
  public var issuerSigned: IssuerSigned?
  public var devicePrivateKey: CoseKeyPrivate?
  public var docType: String
  public var nameSpaces: [NameSpace]?
  public var displayName: String?
  public var ageOverXX = [Int: Bool]()
  public var displayStrings = [NameValue]()
  public var displayImages = [NameImage]()
  public var mandatoryElementKeys: [DataElementIdentifier] = []
}
