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

public struct TransactionCardView: View {
  private let cornerRadius: CGFloat
  private let backgroundColor: Color
  private let title: String
  private let subtitle: String
  private let caption: String

  private let footerTitle: String
  private let footerSubtitle: String

  private let verifiedIcon: Image?
  private let isVerified: Bool
  private let onAction: (() -> Void)?

  public init(
    cornerRadius: CGFloat = 13,
    backgroundColor: Color = Theme.shared.color.surfaceContainer,
    title: String,
    subtitle: String,
    caption: String,
    footerTitle: String,
    footerSubtitle: String,
    verifiedIcon: Image? = nil,
    isVerified: Bool = false,
    onAction: (() -> Void)? = nil
  ) {
    self.cornerRadius = cornerRadius
    self.backgroundColor = backgroundColor
    self.title = title
    self.subtitle = subtitle
    self.caption = caption
    self.footerTitle = footerTitle
    self.footerSubtitle = footerSubtitle
    self.verifiedIcon = verifiedIcon
    self.isVerified = isVerified
    self.onAction = onAction
  }

  public var body: some View {
    WrapCardView(backgroundColor: backgroundColor) {
      VStack(alignment: .leading, spacing: SPACING_MEDIUM) {

        VStack(alignment: .leading, spacing: .zero) {
          Text(title)
            .typography(Theme.shared.font.bodyLarge)
            .foregroundStyle(Theme.shared.color.onSurface)
            .if(isVerified) {
              $0.rightImage(image: Theme.shared.image.walletVerified)
            }
          Text(subtitle)
            .typography(Theme.shared.font.bodyMedium)
            .foregroundStyle(Theme.shared.color.onSurfaceVariant)
          Text(caption)
            .typography(Theme.shared.font.bodyMedium)
            .foregroundStyle(Theme.shared.color.onSurfaceVariant)
        }

        HStack {
          VStack(alignment: .leading, spacing: 4) {
            Text(footerTitle)
              .typography(Theme.shared.font.bodyMedium)
              .foregroundStyle(Theme.shared.color.onSurfaceVariant)
            Text(footerSubtitle)
              .typography(Theme.shared.font.bodyMedium)
              .foregroundStyle(Theme.shared.color.onSurfaceVariant)
          }
          Spacer()
        }
      }
      .padding(.all, SPACING_MEDIUM)
    }
  }
}

#Preview {
  VStack(spacing: 16) {
    TransactionCardView(
      title: "Hellenic Government",
      subtitle: "Government agency",
      caption: "Brussels - Belgium",
      footerTitle: "Date",
      footerSubtitle: "16 February 2024"
    )

    TransactionCardView(
      title: "Hellenic Government",
      subtitle: "Government agency",
      caption: "Brussels - Belgium",
      footerTitle: "Date",
      footerSubtitle: "16 February 2024",
      verifiedIcon: Image(systemName: "checkmark"),
      isVerified: true,
      onAction: {}
    )
  }
  .padding()
}
