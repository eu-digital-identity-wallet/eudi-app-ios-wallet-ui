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
import feature_common
import logic_core

extension DocumentUIModel {

  static func mock() -> DocumentUIModel {
    DocumentUIModel(
      id: UUID().uuidString,
      type: DocumentTypeIdentifier.mDocPid,
      documentName: "Digital ID",
      issuer: .init(
        id: UUID().uuidString,
        issuersName: "Digital Credential Service",
        logoUrl: URL(string: "https://www.example.com")!,
        isVerified: true
      ),
      createdAt: Date(),
      hasExpired: false,
      documentFields:
        [
          .single(
            .init(
              collapsed: .init(
                mainText: .custom("AB12356"),
                overlineText: .custom("ID no")
              ),
              domainModel: nil
            )
          ),
          .single(
            .init(
              collapsed: .init(
                mainText: .custom("Hellenic"),
                overlineText: .custom("Nationality")
              ),
              domainModel: nil
            )
          ),
          .single(
            .init(
              collapsed: .init(
                mainText: .custom("21 Oct 1994"),
                overlineText: .custom("Place of birth")
              ),
              domainModel: nil
            )
          ),
          .single(
            .init(
              collapsed: .init(
                mainText: .custom("1,82"),
                overlineText: .custom("Height")
              ),
              domainModel: nil
            )
          )
        ]
      +
      Array(
        count: 6,
        createElement: .single(
          .init(
            collapsed: .init(
              mainText: .custom("Placeholder Field Value".padded(padLength: 10)),
              overlineText: .custom("Placeholder Field Title".padded(padLength: 5))
            ),
            domainModel: nil
          )
        )
      )
    )
  }

  func toggleVisibility(isVisible: Bool) -> [GenericExpandableItem] {

    func toggleSelection(isVisible: Bool, fields: inout [GenericExpandableItem]) {
      for index in fields.indices {
        switch fields[index] {
        case .single(let item):
          fields[index] = .single(item.copy(collapsed: item.collapsed.copy(isBlur: isVisible)))
        case .nested(let item):
          var children = item.expanded
          toggleSelection(isVisible: isVisible, fields: &children)
          fields[index] = .nested(item.copy(expanded: children))
        }
      }
    }

    var documentFields = self.documentFields
    toggleSelection(isVisible: isVisible, fields: &documentFields)
    return documentFields

  }
}
