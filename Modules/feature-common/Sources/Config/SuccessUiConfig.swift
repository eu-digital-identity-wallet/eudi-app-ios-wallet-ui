/*
 * Copyright (c) 2023 European Commission
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import logic_ui
import Foundation
import SwiftUI

public extension UIConfig {

  struct Success: UIConfigType, Equatable {

    public let title: LocalizedStringKey
    public let subtitle: LocalizedStringKey
    public let buttons: [Success.Button]
    public let visualKind: VisualKind

    public init(
      title: LocalizedStringKey,
      subtitle: LocalizedStringKey,
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

    public let title: LocalizedStringKey
    public let screen: AppRoute
    public let deepLink: URL?
    public let style: Style
    public let navigationType: NavigationType

    public enum Style: Equatable {
      case primary
      case secondary
    }

    public enum NavigationType: Equatable {
      case pop
      case deepLink
    }

    public init(
      title: LocalizedStringKey,
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
