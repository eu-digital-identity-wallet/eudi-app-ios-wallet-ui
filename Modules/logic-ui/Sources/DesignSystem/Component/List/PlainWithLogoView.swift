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

public struct PlainWithLogoView: View {
  private let icon: Image
  private let title: String
  private let isVerified: Bool
  private let isLoading: Bool
  private let action: (() -> Void)?

  public init(
    icon: Image,
    title: String,
    isVerified: Bool = false,
    isLoading: Bool = false,
    action: (() -> Void)? = nil
  ) {
    self.icon = icon
    self.title = title
    self.isVerified = isVerified
    self.isLoading = isLoading
    self.action = action
  }

  public var body: some View {
    VStack(alignment: .leading, spacing: SPACING_SMALL) {

      icon
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(height: Theme.shared.dimension.smallImageHeight)
        .frame(maxWidth: .infinity, alignment: .center)

      VStack(alignment: .center, spacing: SPACING_SMALL) {
        Text(title)
          .typography(Theme.shared.font.bodyMedium)
          .if(isVerified) {
            $0.leftImage(image: Theme.shared.image.relyingPartyVerified)
          }
          .foregroundStyle(Theme.shared.color.onSurfaceVariant)
          .frame(maxWidth: .infinity, alignment: .center)
      }
    }
    .padding(.all, SPACING_MEDIUM)
    .onTapGesture {
      action?()
    }
    .shimmer(isLoading: isLoading)
  }
}

#Preview {
  VStack(spacing: 16) {
    PlainWithLogoView(
      icon: Image(systemName: "building.2.crop.circle.fill")
        .renderingMode(.original),
      title: "Hellenic Government"
    )

    PlainWithLogoView(
      icon: Image(systemName: "building.2.crop.circle.fill"),
      title: "Another Organization"
    )

    PlainWithLogoView(
      icon: Image(systemName: "building.2.crop.circle.fill"),
      title: "Another Organization",
      isVerified: true
    )
  }
  .padding()
}
