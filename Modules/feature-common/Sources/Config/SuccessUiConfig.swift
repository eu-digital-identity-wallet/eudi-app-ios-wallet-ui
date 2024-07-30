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

    public let title: Title
    public let subtitle: LocalizableString.Key
    public let buttons: [Success.Button]
    public let visualKind: VisualKind

    public var log: String {
      return "title: \(LocalizableString.shared.get(with: title.value))" +
      "title color: \(title.color)" +
      " caption: \(LocalizableString.shared.get(with: subtitle))" +
      " buttons: \(buttons.map({ LocalizableString.shared.get(with: $0.title) as String }).joined(separator: ","))" +
      " actions: \(buttons.map(\.navigationType.type).joined(separator: ","))"
    }

    public init(
      title: Title,
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
  struct Title: Equatable {
    public let value: LocalizableString.Key
    public let color: Color

    public init(
      value: LocalizableString.Key,
      color: Color = Theme.shared.color.success
    ) {
      self.value = value
      self.color = color
    }
  }
}

public extension UIConfig.Success {

  enum VisualKind: Equatable {
    case defaultIcon
    case customIcon(Image, Color)
  }

  struct Button: Identifiable, Equatable {

    public var id: UUID

    public let title: LocalizableString.Key
    public let style: Style
    public let navigationType: UIConfig.DeepLinkNavigationType

    public enum Style: Equatable {
      case primary
      case secondary
    }

    public init(
      title: LocalizableString.Key,
      style: Style,
      navigationType: UIConfig.DeepLinkNavigationType
    ) {
      self.id = UUID()
      self.title = title
      self.style = style
      self.navigationType = navigationType
    }
  }
}
