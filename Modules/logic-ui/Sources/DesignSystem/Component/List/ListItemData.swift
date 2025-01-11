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

public struct ListItemData: Identifiable {

  public enum MainStyle {
    case plain
    case bold
  }

  public var id: String
  public let mainText: String
  public let mainStyle: MainStyle
  public let overlineText: String?
  public let supportingText: String?
  public let overlineTextColor: Color
  public let leadingIcon: Image?
  public let isBlur: Bool
  public let trailingContent: TrailingContent?

  public init(
    id: String = UUID().uuidString,
    mainText: String,
    mainStyle: MainStyle = .plain,
    overlineText: String? = nil,
    supportingText: String? = nil,
    overlineTextColor: Color = Theme.shared.color.onSurfaceVariant,
    leadingIcon: Image? = nil,
    isBlur: Bool = false,
    trailingContent: TrailingContent? = nil
  ) {
    self.id = id
    self.mainText = mainText
    self.mainStyle = mainStyle
    self.overlineText = overlineText
    self.supportingText = supportingText
    self.overlineTextColor = overlineTextColor
    self.leadingIcon = leadingIcon
    self.trailingContent = trailingContent
    self.isBlur = isBlur
  }
}

public enum TrailingContent {
  case icon(Image)
  case checkbox(Bool, (Bool) -> Void)
}
