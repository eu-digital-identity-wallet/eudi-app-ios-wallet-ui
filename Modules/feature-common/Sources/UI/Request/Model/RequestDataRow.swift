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
import SwiftUI
import logic_business
import logic_core

public struct RequestDataRow: Identifiable, Equatable, Sendable {

  @EquatableNoop
  public var id: String
  public let claim: Claim

  public init(
    id: String = UUID().uuidString,
    claim: DocumentElementClaim
  ) {
    self.id = id
    switch claim {
    case .group(let id, let title, let items):
      self.claim = .group(id: id, title: title, items: items.toClaims())
    case .primitive(let id, let title, let path, let value, let status):
      self.claim = .primitive(
        id: id,
        title: title,
        path: path,
        value: value.toValue(),
        status: status.toStatus()
      )
    }
  }
}

public extension Array where Element == RequestDataRow {
  func toListItems() -> [ExpandableListItem] {
    self.map { $0.toListItem() }
  }
}

public extension RequestDataRow {
  func toListItem() -> ExpandableListItem {
    return self.claim.toExpandableListItem()
  }
}

public extension RequestDataRow {
  enum Claim: Equatable, Sendable {
    case group(id: String, title: String, items: [Claim])
    case primitive(id: String, title: String, path: [String], value: Value, status: Status)

    var title: String {
      return switch self {
      case .group(_, let title, _):
        title
      case .primitive(_, let title, _, _, _):
        title
      }
    }
  }
}

public extension RequestDataRow.Claim {
  enum `Status`: Sendable, Equatable {

    case available(isRequired: Bool)
    case notAvailable

    var isRequired: Bool {
      return switch self {
      case .available(let isRequired):
        isRequired
      case .notAvailable:
        false
      }
    }

    var isAvailable: Bool {
      return switch self {
      case .available:
        true
      case .notAvailable:
        false
      }
    }
  }
}

private extension DocumentElementClaim.Status {
  func toStatus() -> RequestDataRow.Claim.Status {
    return switch self {
    case .available(let isRequired):
        .available(isRequired: isRequired)
    case .notAvailable:
        .notAvailable
    }
  }
}

private extension RequestDataRow.Claim {
  func toExpandableListItem() -> ExpandableListItem {
    switch self {
    case .group(let id, let title, let items):
      return .nested(
        .init(
          id: id,
          collapsed: .init(mainText: .custom(title)),
          expanded: items.map { $0.toExpandableListItem() },
          isExpanded: false
        )
      )
    case .primitive(let id, let title, _, let value, let status):
      switch value {
      case .string(let value):
        return .single(
          .init(
            id: id,
            collapsed: .init(
              mainText: .custom(value),
              overlineText: .custom(title),
              isEnable: !status.isRequired,
              trailingContent: .checkbox(
                !status.isRequired,
                status.isAvailable,
                { _ in }
              )
            )
          )
        )
      case .image(let image):
        return .single(
          .init(
            id: id,
            collapsed: .init(
              mainText: .custom(title),
              leadingIcon: .init(image: image),
              isEnable: !status.isRequired,
              trailingContent: .checkbox(
                !status.isRequired,
                status.isAvailable,
                { _ in }
              )
            )
          )
        )
      }
    }
  }
}

private extension Array where Element == DocumentElementClaim {
  func toClaims() -> [RequestDataRow.Claim] {
    self.map {
      switch $0 {
      case .group(let id, let title, let items):
          .group(id: id, title: title, items: items.toClaims())
      case .primitive(let id, let title, let path, let value, let status):
          .primitive(id: id, title: title, path: path, value: value.toValue(), status: status.toStatus())
      }
    }
  }
}

public extension RequestDataRow {
  enum Value: Equatable, Sendable {
    case string(String)
    case image(Image)

    public var string: String? {
      switch self {
      case .string(let string):
        string
      default:
        nil
      }
    }

    public var image: Image? {
      switch self {
      case .image(let image):
        image
      default:
        nil
      }
    }
  }
}

private extension DocumentElementValue {
  func toValue() -> RequestDataRow.Value {
    return switch self {
    case .string(let string):
        .string(string)
    case .unavailable(let string):
        .string(string)
    case .image(let image):
        .image(image)
    }
  }
}
