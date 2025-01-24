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

public struct ListItemData: Identifiable, Sendable {

  public enum MainStyle: Sendable {
    case plain
    case bold
  }

  public let id: String
  public let mainText: LocalizableString.Key
  public let mainStyle: MainStyle
  public let overlineText: LocalizableString.Key?
  public let supportingText: LocalizableString.Key?
  public let supportingTextColor: Color
  public let overlineTextColor: Color
  public let leadingIcon: (imageUrl: URL?, image: Image?)?
  public let isBlur: Bool
  public let trailingContent: TrailingContent?

  public init(
    id: String = UUID().uuidString,
    mainText: LocalizableString.Key,
    mainStyle: MainStyle = .plain,
    overlineText: LocalizableString.Key? = nil,
    supportingText: LocalizableString.Key? = nil,
    supportingTextColor: Color = Theme.shared.color.onSurfaceVariant,
    overlineTextColor: Color = Theme.shared.color.onSurfaceVariant,
    leadingIcon: (imageUrl: URL?, image: Image?)? = nil,
    isBlur: Bool = false,
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
  }
}

public enum TrailingContent: Sendable {
  case icon(Image, Color = Color.accentColor)
  case checkbox(Bool, Bool, @Sendable (Bool) -> Void)
  case empty
}
