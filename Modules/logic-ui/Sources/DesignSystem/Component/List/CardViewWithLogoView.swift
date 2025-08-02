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
import SwiftUI
import logic_resources

public struct CardViewWithLogoView: View {
  private let cornerRadius: CGFloat
  private let backgroundColor: Color
  private let icon: RemoteImageView.ImageContentOption
  private let title: LocalizableStringKey
  private let isVerified: Bool
  private let isLoading: Bool
  private let action: (() -> Void)?

  public init(
    cornerRadius: CGFloat = 13,
    backgroundColor: Color = Theme.shared.color.surfaceContainer,
    icon: RemoteImageView.ImageContentOption = .none,
    title: LocalizableStringKey,
    isVerified: Bool = false,
    isLoading: Bool = false,
    action: (() -> Void)? = nil
  ) {
    self.cornerRadius = cornerRadius
    self.backgroundColor = backgroundColor
    self.icon = icon
    self.title = title
    self.isVerified = isVerified
    self.isLoading = isLoading
    self.action = action
  }

  public var body: some View {
    WrapCardView(backgroundColor: backgroundColor) {
      VStack(alignment: .leading, spacing: SPACING_MEDIUM) {

        switch icon {
        case .none: EmptyView()
        case .remoteImage(let url, let image):
          HStack {
            RemoteImageView(
              url: url,
              icon: image,
              width: getScreenRect().width / 2.5,
              height: nil
            )
            Spacer()
          }
        case .image(let image):
          HStack {
            image
              .resizable()
              .aspectRatio(contentMode: .fit)
              .frame(height: Theme.shared.dimension.remoteImageIconSize)
            Spacer()
          }
          .frame(maxWidth: .infinity, alignment: .leading)
        }

        Text(title)
          .typography(Theme.shared.font.bodyLarge)
          .foregroundStyle(Theme.shared.color.onSurface)
          .if(isVerified) {
            $0.leftImage(
              image: Theme.shared.image.relyingPartyVerified,
              spacing: Theme.shared.dimension.verifiedBadgeSpacing
            )
          }
          .if(icon.isNone) {
            $0.frame(maxWidth: .infinity, alignment: .leading)
          }
      }
      .padding(.all, SPACING_MEDIUM)
    }
    .contentShape(Rectangle())
    .onTapGesture {
      action?()
    }
    .shimmer(isLoading: isLoading)
  }
}

#Preview {
  VStack(spacing: 16) {
    CardViewWithLogoView(
      icon: .image(
        Image(
          systemName: "building.2.crop.circle.fill"
        )
        .renderingMode(.original)
      ),
      title: .custom("Hellenic Government")
    )

    CardViewWithLogoView(
      icon: .image(
        Image(
          systemName: "building.2.crop.circle.fill"
        )
        .renderingMode(.original)
      ),
      title: .custom("Another Organization")
    )

    CardViewWithLogoView(
      backgroundColor: Theme.shared.color.tertiary,
      icon: .image(
        Image(
          systemName: "building.2.crop.circle.fill"
        )
        .renderingMode(.original)
      ),
      title: .custom("Another Organization"),
      isVerified: true
    )
  }
  .padding()
}
