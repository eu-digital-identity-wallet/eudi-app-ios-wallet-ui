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
import logic_resources
import logic_business

public struct ListItemData: Identifiable, Sendable, Equatable {

  public enum MainStyle: Sendable, Equatable {
    case plain
    case bold
  }

  @EquatableNoop
  public var id: String
  public let mainText: LocalizableStringKey
  public let mainStyle: MainStyle
  public let overlineText: LocalizableStringKey?
  public let supportingText: LocalizableStringKey?
  public let supportingTextColor: Color
  public let overlineTextColor: Color
  public let leadingIcon: LeadingIcon?
  public let isBlur: Bool
  public let isEnable: Bool
  public let trailingContent: TrailingContent?

  public init(
    id: String = UUID().uuidString,
    mainText: LocalizableStringKey,
    mainStyle: MainStyle = .plain,
    overlineText: LocalizableStringKey? = nil,
    supportingText: LocalizableStringKey? = nil,
    supportingTextColor: Color = Theme.shared.color.onSurfaceVariant,
    overlineTextColor: Color = Theme.shared.color.onSurfaceVariant,
    leadingIcon: LeadingIcon? = nil,
    isBlur: Bool = false,
    isEnable: Bool = true,
    trailingContent: TrailingContent? = nil
  ) {
    self.id = id
    self.mainText = mainText
    self.mainStyle = mainStyle
    self.overlineText = overlineText
    self.supportingText = supportingText
    self.supportingTextColor = supportingTextColor
    self.overlineTextColor = overlineTextColor
    self.leadingIcon = leadingIcon
    self.trailingContent = trailingContent
    self.isBlur = isBlur
    self.isEnable = isEnable
  }
}

public struct LeadingIcon: Sendable, Equatable {
  public let imageUrl: URL?
  public let image: Image?

  public init(
    imageUrl: URL? = nil,
    image: Image? = nil
  ) {
    self.imageUrl = imageUrl
    self.image = image
  }
}

public enum TrailingContent: Sendable, Equatable {
  case icon(Image, Color = Color.accentColor)
  case checkbox(Bool, Bool, @Sendable (Bool) -> Void)
  case empty

  public static func == (lhs: TrailingContent, rhs: TrailingContent) -> Bool {
    switch (lhs, rhs) {
    case let (.icon(lImage, lColor), .icon(rImage, rColor)):
      return lImage == rImage && lColor == rColor
    case let (.checkbox(lValue, lIsEnabled, _), .checkbox(rValue, rIsEnabled, _)):
      return lValue == rValue && lIsEnabled == rIsEnabled
    case (.empty, .empty):
      return true
    default:
      return false
    }
  }
}
