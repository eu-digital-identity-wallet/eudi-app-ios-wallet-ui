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
import logic_ui
import logic_resources
import Foundation
import SwiftUI

public extension UIConfig {

  struct Success: UIConfigType, Equatable {

    public let title: LocalizableString.Key
    public let subtitle: LocalizableString.Key
    public let buttons: [Success.Button]
    public let visualKind: VisualKind

    public var log: String {
      return "title: \(LocalizableString.shared.get(with: title))" +
      " caption: \(LocalizableString.shared.get(with: subtitle))" +
      " buttons: \(buttons.map({ LocalizableString.shared.get(with: $0.title) as String }).joined(separator: ","))" +
      " actions: \(buttons.map(\.navigationType.type).joined(separator: ","))"
    }

    public init(
      title: LocalizableString.Key,
      subtitle: LocalizableString.Key,
      buttons: [Success.Button],
      visualKind: VisualKind
    ) {
      self.title = title
      self.subtitle = subtitle
      self.buttons = buttons
      self.visualKind = visualKind
    }
  }
}

public extension UIConfig.Success {

  enum VisualKind: Equatable {
    case defaultIcon
    case customIcon(Image)
  }

  struct Button: Identifiable, Equatable {

    public var id: UUID

    public let title: LocalizableString.Key
    public let style: Style
    public let navigationType: NavigationType

    public enum Style: Equatable {
      case primary
      case secondary
    }

    public enum NavigationType: Equatable {

      case pop(screen: AppRoute, inclusive: Bool = false)
      case push(screen: AppRoute)
      case deepLink(link: URL, popToScreen: AppRoute)

      public var type: String {
        return switch self {
        case .pop(let screen, _):
          "pop to \(screen)"
        case .push(let screen):
          "push to \(screen)"
        case .deepLink(let link, _):
          "open \(link)"
        }
      }
    }

    public init(
      title: LocalizableString.Key,
      style: Style,
      navigationType: NavigationType
    ) {
      self.id = UUID()
      self.title = title
      self.style = style
      self.navigationType = navigationType
    }
  }
}
