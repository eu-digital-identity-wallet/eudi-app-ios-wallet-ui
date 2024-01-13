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
    public let screen: AppRoute
    public let deepLink: URL?
    public let style: Style
    public let navigationType: NavigationType

    public enum Style: Equatable {
      case primary
      case secondary
    }

    public enum NavigationType: Equatable {
      case pop(inclusive: Bool = false)
      case push
      case deepLink
    }

    public init(
      title: LocalizableString.Key,
      screen: AppRoute,
      deepLink: URL? = nil,
      style: Style,
      navigationType: NavigationType
    ) {
      self.id = UUID()
      self.title = title
      self.screen = screen
      self.deepLink = deepLink
      self.style = style
      self.navigationType = navigationType
    }
  }
}