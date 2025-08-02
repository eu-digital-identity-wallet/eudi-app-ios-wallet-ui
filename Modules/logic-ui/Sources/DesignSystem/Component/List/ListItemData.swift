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
import logic_resources
import logic_business
import Copyable

@Copyable
public struct ListItemData: Identifiable, Sendable, Equatable {

  public enum MainStyle: Sendable, Equatable {
    case plain
    case bold
  }

  @EquatableNoop
  public var id: String

  @EquatableNoop
  public var groupId: String

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
    groupId: String? = nil,
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
    self.groupId = groupId ?? id
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
  case textWithIcon(Image, Color = Color.accentColor, LocalizableStringKey = .custom(""))
  case icon(Image, Color = Color.accentColor)
  case checkbox(Bool, Bool, @Sendable (Bool) -> Void)
  case empty

  public static func == (lhs: TrailingContent, rhs: TrailingContent) -> Bool {
    switch (lhs, rhs) {
    case let (.textWithIcon(lImage, lColor, lKey), .textWithIcon(rImage, rColor, rKey)):
      return lImage == rImage && lColor == rColor && lKey == rKey
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

public typealias GenericListItemSection = ListItemSection<Sendable>

@Copyable
public struct ListItemSection<T: Sendable>: Identifiable, Equatable, Routable {

  public let id: String
  public let title: String
  public let listItems: [ExpandableListItem<T>]

  public var log: String {
    "id: \(id), title: \(title)"
  }

  public init(id: String, title: String, listItems: [ExpandableListItem<T>]) {
    self.id = id
    self.title = title
    self.listItems = listItems
  }
}

public typealias GenericExpandableItem = ExpandableListItem<Sendable>

public enum ExpandableListItem<T: Sendable>: Identifiable, Equatable, Sendable {

  case single(SingleListItemData)
  case nested(NestedListItemData)

  public var id: String {
    return switch self {
    case .single(let data):
      data.collapsed.id
    case .nested(let data):
      data.collapsed.id
    }
  }

  public var title: String {
    return switch self {
    case .single(let data):
      if let overlineText = data.collapsed.overlineText {
        overlineText.toString
      } else {
        data.collapsed.mainText.toString
      }
    case .nested(let data):
      data.collapsed.mainText.toString
    }
  }

  public var leadingIcon: LeadingIcon? {
    return switch self {
    case .single(let data):
      data.collapsed.leadingIcon
    case .nested(let data):
      data.collapsed.leadingIcon
    }
  }

  public var mainText: LocalizableStringKey {
    return switch self {
    case .single(let data):
      data.collapsed.mainText
    case .nested(let data):
      data.collapsed.mainText
    }
  }

  public var overlineText: LocalizableStringKey? {
    return switch self {
    case .single(let data):
      data.collapsed.overlineText
    case .nested(let data):
      data.collapsed.overlineText
    }
  }

  public var domainModel: T? {
    return switch self {
    case .single(let data):
      data.domainModel
    case .nested:
      nil
    }
  }

  @Copyable
  public struct SingleListItemData: Equatable, Sendable {

    public static func == (lhs: ExpandableListItem<T>.SingleListItemData, rhs: ExpandableListItem<T>.SingleListItemData) -> Bool {
      return lhs.collapsed == rhs.collapsed
    }

    public let collapsed: ListItemData
    public let domainModel: T?

    public init(
      collapsed: ListItemData,
      domainModel: T?
    ) {
      self.collapsed = collapsed
      self.domainModel = domainModel
    }
  }

  @Copyable
  public struct NestedListItemData: Equatable, Sendable {

    public let collapsed: ListItemData
    public let expanded: [ExpandableListItem]
    public var isExpanded: Bool

    public init(
      collapsed: ListItemData,
      expanded: [ExpandableListItem],
      isExpanded: Bool
    ) {
      self.collapsed = collapsed
      self.expanded = expanded
      self.isExpanded = isExpanded
    }
  }
}
