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
  private let mainText: String
  private let overlineText: String?
  private let overlineTextColor: Color
  private let supportingText: String?
  private let isBlur: Bool
  private let leadingIcon: Image?
  private let trailingIcon: Image?
  private let action: (() -> Void)?

  public init(
    mainText: String,
    overlineText: String? = nil,
    overlineTextColor: Color = Theme.shared.color.onSurfaceVariant,
    supportingText: String? = nil,
    isBlur: Bool = false,
    leadingIcon: Image? = nil,
    trailingIcon: Image? = nil,
    action: (() -> Void)? = nil
  ) {
    self.mainText = mainText
    self.overlineText = overlineText
    self.overlineTextColor = overlineTextColor
    self.supportingText = supportingText
    self.isBlur = isBlur
    self.leadingIcon = leadingIcon
    self.trailingIcon = trailingIcon
    self.action = action
  }

  public var body: some View {
    HStack(alignment: .center, spacing: SPACING_SMALL) {
      if let leadingIcon {
        leadingIcon
          .resizable()
          .frame(width: 40, height: 40)
      }

      VStack(alignment: .leading, spacing: SPACING_EXTRA_SMALL) {
        if let overlineText = overlineText {
          Text(overlineText)
            .font(.caption)
            .foregroundStyle(overlineTextColor)
            .lineLimit(1)
            .truncationMode(.tail)
        }

        Text(mainText)
          .font(.body)
          .foregroundStyle(Theme.shared.color.onSurface)
          .fontWeight(.medium)
          .lineLimit(1)
          .truncationMode(.tail)

        if let supportingText = supportingText {
          Text(supportingText)
            .font(.subheadline)
            .foregroundStyle(Theme.shared.color.onSurfaceVariant)
            .lineLimit(1)
            .truncationMode(.tail)
            .if(isBlur) {
              $0.blur(radius: 4, opaque: false)
            }
        }
      }
      .frame(maxWidth: .infinity, alignment: .leading)

      if let trailingIcon {
        trailingIcon
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: 14, height: 14)
          .foregroundColor(Color.accentColor)
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
        mainText: "Main Text",
        overlineText: "Overline Text",
        supportingText: "Supporting Text",
        leadingIcon: Image(systemName: "star"),
        trailingIcon: Image(systemName: "chevron.right")
      )
    }

    WrapCardView {
      WrapListItemView(
        mainText: "Another Item",
        overlineText: nil,
        supportingText: "Additional Info",
        trailingIcon: nil
      )
    }

    WrapCardView {
      WrapListItemView(
        mainText: "Another Item",
        overlineText: nil,
        supportingText: "Additional Info",
        leadingIcon: Image(systemName: "heart"),
        trailingIcon: nil
      )
    }

    WrapCardView {
      WrapListItemView(
        mainText: "Another Item",
        overlineText: "Overline Texr",
        overlineTextColor: Theme.shared.color.error,
        supportingText: "Additional Info",
        leadingIcon: Image(systemName: "heart"),
        trailingIcon: nil
      )
    }

    WrapCardView {
      WrapListItemView(
        mainText: "Another Item",
        overlineText: "Overline Texr",
        overlineTextColor: Theme.shared.color.error,
        supportingText: "Additional Info",
        isBlur: true,
        leadingIcon: Image(systemName: "heart"),
        trailingIcon: nil
      )
    }
  }
  .padding()
}
