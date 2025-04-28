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

public extension UIConfig {

  struct Success: UIConfigType, Equatable {

    public let title: Title
    public let subtitle: LocalizableStringKey
    public let buttons: [Success.Button]
    public let visualKind: VisualKind

    public var log: String {
      return "title: \(title.value.toString)" +
      "title color: \(title.color)" +
      " caption: \(subtitle.toString)" +
      " buttons: \(buttons.map({ $0.title.toString }).joined(separator: ","))" +
      " actions: \(buttons.map(\.navigationType.type).joined(separator: ","))"
    }

    public init(
      title: Title,
      subtitle: LocalizableStringKey,
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
  struct Title: Equatable, Sendable {
    public let value: LocalizableStringKey
    public let color: Color

    public init(
      value: LocalizableStringKey,
      color: Color = Theme.shared.color.success
    ) {
      self.value = value
      self.color = color
    }
  }
}

public extension UIConfig.Success {

  enum VisualKind: Equatable, Sendable {
    case defaultIcon
    case customIcon(Image, Color)
  }

  struct Button: Identifiable, Equatable, Sendable {

    @EquatableNoop
    public var id: UUID

    public let title: LocalizableStringKey
    public let style: Style
    public let navigationType: UIConfig.DeepLinkNavigationType

    public enum Style: Equatable, Sendable {
      case primary
      case secondary
    }

    public init(
      title: LocalizableStringKey,
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
