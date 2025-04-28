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
import logic_core
import logic_ui
import Copyable

@Copyable
public struct DocumentUIModel: Equatable, Identifiable, Routable {

  public let id: String
  public let type: DocumentTypeIdentifier
  public let documentName: String
  public let issuer: IssuerField?
  public let createdAt: Date
  public let hasExpired: Bool
  public let documentFields: [GenericExpandableItem]

  public var log: String {
    "id: \(id), type: \(type.rawValue), name: \(documentName)"
  }

  public init(
    id: String,
    type: DocumentTypeIdentifier,
    documentName: String,
    issuer: IssuerField?,
    createdAt: Date,
    hasExpired: Bool,
    documentFields: [GenericExpandableItem]
  ) {
    self.id = id
    self.type = type
    self.documentName = documentName
    self.issuer = issuer
    self.createdAt = createdAt
    self.hasExpired = hasExpired
    self.documentFields = documentFields
  }
}

public extension DocumentUIModel {

  struct IssuerField: Identifiable, Sendable, Equatable {
    public let id: String
    public let name: String
    public let logoUrl: URL?
    public let isVerified: Bool

    public init(
      id: String = UUID().uuidString,
      issuersName: String,
      logoUrl: URL?,
      isVerified: Bool
    ) {
      self.id = id
      self.name = issuersName
      self.logoUrl = logoUrl
      self.isVerified = isVerified
    }
  }
}
