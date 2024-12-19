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

public struct CardViewWithLogo: View {
  private let cornerRadius: CGFloat
  private let backgroundColor: Color
  private let icon: Image
  private let title: String
  private let subtitle: String
  private let footer: String
  private let isVerified: Bool
  private let action: (() -> Void)?

  public init(
    cornerRadius: CGFloat = 13,
    backgroundColor: Color = Theme.shared.color.surfaceContainer,
    icon: Image,
    title: String,
    subtitle: String,
    footer: String,
    isVerified: Bool = false,
    action: (() -> Void)? = nil
  ) {
    self.cornerRadius = cornerRadius
    self.backgroundColor = backgroundColor
    self.icon = icon
    self.title = title
    self.subtitle = subtitle
    self.footer = footer
    self.isVerified = isVerified
    self.action = action
  }

  public var body: some View {
    WrapCardView(backgroundColor: backgroundColor) {
      VStack(alignment: .leading, spacing: SPACING_MEDIUM) {

        HStack {
          icon
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(height: 50)
          Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .leading)

        Text(title)
          .typography(Theme.shared.font.bodyLarge)
          .foregroundStyle(Theme.shared.color.onSurface)
          .if(isVerified) {
            $0.leftImage(image: Theme.shared.image.relyingPartyVerified)
          }

        VStack(alignment: .leading, spacing: SPACING_EXTRA_SMALL) {
          Text(title)
            .typography(Theme.shared.font.bodyMedium)
            .foregroundStyle(Theme.shared.color.onSurfaceVariant)
          Text(footer)
            .typography(Theme.shared.font.bodyMedium)
            .foregroundStyle(Theme.shared.color.onSurfaceVariant)
        }
      }
      .padding(.all, SPACING_MEDIUM)
    }
    .contentShape(Rectangle())
    .onTapGesture {
      action?()
    }
  }
}

#Preview {
  VStack(spacing: 16) {
    CardViewWithLogo(
      icon: Image(systemName: "building.2.crop.circle.fill")
        .renderingMode(.original),
      title: "Hellenic Government",
      subtitle: "Government agency",
      footer: "Athens - Greece"
    )

    CardViewWithLogo(
      icon: Image(systemName: "building.2.crop.circle.fill"),
      title: "Another Organization",
      subtitle: "Non-Government agency",
      footer: "Athens - Greece"
    )

    CardViewWithLogo(
      backgroundColor: Theme.shared.color.tertiary,
      icon: Image(systemName: "building.2.crop.circle.fill"),
      title: "Another Organization",
      subtitle: "Non-Government agency",
      footer: "Athens - Greece",
      isVerified: true
    )
  }
  .padding()
}
