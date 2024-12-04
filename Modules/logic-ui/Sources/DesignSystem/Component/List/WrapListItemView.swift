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
  private let listItem: ListItemData
  private let action: (() -> Void)?

  public init(
    listItem: ListItemData,
    action: (() -> Void)? = nil
  ) {
    self.listItem = listItem
    self.action = action
  }

  public var body: some View {
    HStack(alignment: .center, spacing: SPACING_SMALL) {
      if let leadingIcon = listItem.leadingIcon {
        leadingIcon
          .resizable()
          .frame(width: 40, height: 40)
      }

      VStack(alignment: .leading, spacing: SPACING_EXTRA_SMALL) {
        if let overlineText = listItem.overlineText {
          Text(overlineText)
            .font(.caption)
            .foregroundStyle(listItem.overlineTextColor)
            .lineLimit(1)
            .truncationMode(.tail)
        }

        Text(listItem.mainText)
          .font(.body)
          .foregroundStyle(Theme.shared.color.onSurface)
          .fontWeight(.medium)
          .lineLimit(1)
          .truncationMode(.tail)

        if let supportingText = listItem.supportingText {
          Text(supportingText)
            .font(.subheadline)
            .foregroundStyle(Theme.shared.color.onSurfaceVariant)
            .lineLimit(1)
            .truncationMode(.tail)
            .if(listItem.isBlur) {
              $0.blur(radius: 4, opaque: false)
            }
        }
      }
      .frame(maxWidth: .infinity, alignment: .leading)

      if let trailingContent = listItem.trailingContent {
        switch trailingContent {
        case .icon(let image):
          image
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 14, height: 14)
            .foregroundColor(Color.accentColor)

        case .checkbox(let isChecked, let onToggle):
          WrapCheckbox(
            checkboxData: CheckboxData(
              isChecked: isChecked,
              enabled: true,
              onCheckedChange: { _ in
                onToggle(!isChecked)
              }))
        }
      }
    }
    .contentShape(Rectangle())
    .onTapGesture {
      action?()
    }
    .padding(.all, SPACING_MEDIUM)
  }
}

#Preview {
  VStack(spacing: 16) {
    WrapCardView {
      WrapListItemView(
        listItem: ListItemData(
          mainText: "Main Text",
          overlineText: "Overline Text",
          supportingText: "Supporting Text",
          leadingIcon: Image(systemName: "star"),
          trailingContent: .icon(Image(systemName: "chevron.right"))
        ),
        action: {}
      )
    }

    WrapCardView {
      WrapListItemView(
        listItem: ListItemData(
          mainText: "Another Item",
          overlineText: nil,
          supportingText: "Additional Info",
          leadingIcon: nil
        )
      )
    }

    WrapCardView {
      WrapListItemView(
        listItem: ListItemData(
          mainText: "Another Item",
          overlineText: nil,
          supportingText: "Additional Info",
          leadingIcon: Image(systemName: "heart")
        )
      )
    }

    WrapCardView {
      WrapListItemView(
        listItem: ListItemData(
          mainText: "Another Item",
          overlineText: "Overline Texr",
          supportingText: "Additional Info",
          overlineTextColor: Theme.shared.color.error,
          leadingIcon: Image(systemName: "heart")
        )
      )
    }

    WrapCardView {
      WrapListItemView(
        listItem: ListItemData(
          mainText: "Main Text",
          overlineText: "Overline Text",
          supportingText: "Supporting Text",
          leadingIcon: Image(systemName: "star"),
          trailingContent: .checkbox(true) { _ in }
        ),
        action: {}
      )
    }
  }
  .padding()
}
