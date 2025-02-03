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
import SwiftUI
import logic_resources

public struct WrapListItemView: View {
  public enum ClickableArea {
    case entireRow
    case trailingContent
  }

  private let listItem: ListItemData
  private let action: (() -> Void)?
  private let mainTextVerticalPadding: CGFloat?
  private let minHeight: Bool
  private let clickableArea: ClickableArea

  public init(
    listItem: ListItemData,
    mainTextVerticalPadding: CGFloat? = nil,
    minHeight: Bool = true,
    clickableArea: ClickableArea = .entireRow,
    action: (() -> Void)? = nil
  ) {
    self.listItem = listItem
    self.mainTextVerticalPadding = mainTextVerticalPadding
    self.minHeight = minHeight
    self.clickableArea = clickableArea
    self.action = action
  }

  public var body: some View {
    HStack(alignment: .center, spacing: SPACING_MEDIUM) {

      if let url = listItem.leadingIcon?.imageUrl {
        RemoteImageView(
          url: url,
          icon: listItem.leadingIcon?.image,
          width: Theme.shared.dimension.remoteImageIconSize,
          height: Theme.shared.dimension.remoteImageIconSize
        )
        .if(listItem.isBlur) {
          $0.blur(radius: 4, opaque: false)
        }
      } else if let icon = listItem.leadingIcon?.image {
        icon
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(height: Theme.shared.dimension.remoteImageIconSize)
          .if(listItem.isBlur) {
            $0.blur(radius: 4, opaque: false)
          }
      }

      VStack(alignment: .leading, spacing: SPACING_EXTRA_SMALL) {
        if let overlineText = listItem.overlineText {
          Text(overlineText)
            .typography(Theme.shared.font.bodySmall)
            .foregroundStyle(listItem.overlineTextColor)
            .lineLimit(1)
            .truncationMode(.tail)
        }

        Text(listItem.mainText)
          .typography(Theme.shared.font.headlineMedium)
          .foregroundStyle(Theme.shared.color.onSurface)
          .fontWeight(listItem.mainStyle == .plain ? .medium : .bold)
          .lineLimit(nil)
          .multilineTextAlignment(.leading)
          .truncationMode(.tail)
          .if(listItem.isBlur) {
            $0.blur(radius: 4, opaque: false)
          }

        if let supportingText = listItem.supportingText {
          Text(supportingText)
            .typography(Theme.shared.font.headlineSmall)
            .font(Theme.shared.font.bodyMedium.font)
            .foregroundStyle(listItem.supportingTextColor)
            .lineLimit(1)
            .truncationMode(.tail)
        }
      }
      .frame(maxWidth: .infinity, alignment: .leading)

      if let trailingContent = listItem.trailingContent {
        switch trailingContent {
        case .icon(let image, let color):
          image
            .renderingMode(.template)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 20, height: 20)
            .foregroundColor(color)

        case .checkbox(let enabled, let isChecked, let onToggle):
          WrapCheckbox(
            checkboxData: CheckboxData(
              isChecked: isChecked,
              enabled: enabled,
              onCheckedChange: { _ in
                if clickableArea == .trailingContent {
                  onToggle(!isChecked)
                } else {
                  action?()
                }
              }))
        case .empty:
          EmptyView()
        }
      }
    }
    .contentShape(Rectangle())
    .onTapGesture {
      if clickableArea == .entireRow {
        action?()
      }
    }
    .padding(.all, mainTextVerticalPadding != nil ? mainTextVerticalPadding : SPACING_MEDIUM)
    .if(minHeight) {
      $0.frame(minHeight: 80, alignment: .leading)
    }
  }
}

#Preview {
  VStack(spacing: 16) {
    WrapCardView {
      WrapListItemView(
        listItem: .init(
          mainText: .custom("Main Text"),
          overlineText: .custom("Overline Text"),
          supportingText: .custom("Valid until: 22 March 2030"),
          leadingIcon: LeadingIcon(image: Image(systemName: "star")),
          trailingContent: .icon(Image(systemName: "chevron.right"))
        ),
        action: {}
      )
    }

    WrapCardView {
      WrapListItemView(
        listItem: .init(
          mainText: .custom("Another Item"),
          overlineText: nil,
          supportingText: .custom("Additional Info"),
          leadingIcon: nil
        )
      )
    }

    WrapCardView {
      WrapListItemView(
        listItem: .init(
          mainText: .custom("Another Item"),
          overlineText: nil,
          supportingText: .custom("Additional Info"),
          leadingIcon: LeadingIcon(image: Image(systemName: "heart"))
        )
      )
    }

    WrapCardView {
      WrapListItemView(
        listItem: .init(
          mainText: .custom("Another Item"),
          overlineText: .custom("Overline Texr"),
          supportingText: .custom("Additional Info"),
          overlineTextColor: Theme.shared.color.error,
          leadingIcon: LeadingIcon(image: Image(systemName: "heart"))
        )
      )
    }

    WrapCardView {
      WrapListItemView(
        listItem: .init(
          mainText: .custom("Main Text"),
          overlineText: .custom("Overline Text"),
          supportingText: .custom("Valid until: 22 March 2030"),
          leadingIcon: LeadingIcon(image: Image(systemName: "star")),
          trailingContent: .checkbox(true, true) { _ in }
        ),
        action: { }
      )
    }

    WrapCardView {
      WrapListItemView(
        listItem: .init(
          mainText: .custom("Another Item"),
          trailingContent: .icon(Image(systemName: "plus"))
        )
      )
    }
  }
  .padding()
}
