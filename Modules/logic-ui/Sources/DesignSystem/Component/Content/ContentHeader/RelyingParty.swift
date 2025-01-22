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

public struct RelyingPartyData {
  public let logo: Image?
  public let isVerified: Bool
  public let name: String
  public let nameTextConfig: TextConfig?
  public let description: String?
  public let descriptionTextConfig: TextConfig?

  public init(
    logo: Image? = nil,
    isVerified: Bool,
    name: String,
    nameTextConfig: TextConfig? = nil,
    description: String? = nil,
    descriptionTextConfig: TextConfig? = nil
  ) {
    self.logo = logo
    self.isVerified = isVerified
    self.name = name
    self.nameTextConfig = nameTextConfig
    self.description = description
    self.descriptionTextConfig = descriptionTextConfig
  }
}

public struct RelyingParty: View {
  private let relyingPartyData: RelyingPartyData

  public init(relyingPartyData: RelyingPartyData) {
    self.relyingPartyData = relyingPartyData
  }

  public var body: some View {
    VStack(alignment: .center, spacing: SPACING_SMALL) {
      if let logo = relyingPartyData.logo {
        logo
          .resizable()
          .scaledToFit()
          .frame(width: 40, height: 40)
      }

      WrapText(
        text: relyingPartyData.name,
        textConfig: relyingPartyData.nameTextConfig ?? TextConfig(
          font: Theme.shared.font.bodyLarge.font,
          color: Theme.shared.color.onSurface,
          textAlign: .center,
          maxLines: 1,
          fontWeight: .semibold
        )
      )
      .if(relyingPartyData.isVerified) {
        $0.leftImage(
          image: Theme.shared.image.relyingPartyVerified,
          spacing: Theme.shared.dimension.verifiedBadgeSpacing,
          size: 20
        )
      }

      if let description = relyingPartyData.description {
        WrapText(
          text: description,
          textConfig: relyingPartyData.descriptionTextConfig ?? TextConfig(
            font: Theme.shared.font.bodyMedium.font,
            color: Theme.shared.color.onSurface,
            textAlign: .center,
            maxLines: 2,
            fontWeight: nil
          )
        )
      }
    }
    .frame(maxWidth: .infinity, alignment: .center)
  }
}
