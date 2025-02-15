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

public struct ContentHeaderConfig {
  public let appIconAndTextData: AppIconAndTextData
  public let description: LocalizableStringKey?
  public let descriptionTextConfig: TextConfig?
  public let mainText: LocalizableStringKey?
  public let icon: RemoteImageView.ImageContentOption
  public let mainTextConfig: TextConfig?
  public let relyingPartyData: RelyingPartyData?

  public init(
    appIconAndTextData: AppIconAndTextData,
    description: LocalizableStringKey? = nil,
    descriptionTextConfig: TextConfig? = nil,
    mainText: LocalizableStringKey? = nil,
    icon: RemoteImageView.ImageContentOption = .none,
    mainTextConfig: TextConfig? = nil,
    relyingPartyData: RelyingPartyData? = nil
  ) {
    self.appIconAndTextData = appIconAndTextData
    self.description = description
    self.descriptionTextConfig = descriptionTextConfig
    self.mainText = mainText
    self.mainTextConfig = mainTextConfig
    self.relyingPartyData = relyingPartyData
    self.icon = icon
  }
}

public struct TextConfig {
  public let font: Font
  public let color: Color
  public let textAlign: TextAlignment
  public let maxLines: Int
  public let fontWeight: Font.Weight?

  public init(
    font: Font,
    color: Color = Theme.shared.color.onSurface,
    textAlign: TextAlignment = .center,
    maxLines: Int = 2,
    fontWeight: Font.Weight? = nil
  ) {
    self.font = font
    self.color = color
    self.fontWeight = fontWeight
    self.textAlign = textAlign
    self.maxLines = maxLines
  }
}

public struct ContentHeader: View {
  private let config: ContentHeaderConfig

  public init(config: ContentHeaderConfig) {
    self.config = config
  }

  public var body: some View {
    VStack(alignment: .center, spacing: SPACING_MEDIUM) {
      AppIconAndText(
        appIconAndTextData: config.appIconAndTextData
      )

      if let description = config.description {
        WrapText(
          text: description,
          textConfig: config.descriptionTextConfig ?? TextConfig(
            font: Theme.shared.font.bodyLarge.font,
            color: Theme.shared.color.onSurface,
            textAlign: .center,
            maxLines: 2,
            fontWeight: nil
          )
        )
        .padding(.vertical, SPACING_SMALL)
      }

      if let mainText = config.mainText {
        WrapText(
          text: mainText,
          textConfig: config.mainTextConfig ?? TextConfig(
            font: Theme.shared.font.headlineMedium.font,
            color: Theme.shared.color.onSurface,
            textAlign: .center,
            maxLines: 2,
            fontWeight: .semibold
          )
        )
        .padding(.vertical, SPACING_MEDIUM_SMALL)
      }

      switch config.icon {
        case .none: EmptyView()
        case .remoteImage(let url, let image):
          RemoteImageView(
            url: url,
            icon: image,
            width: getScreenRect().width / 2.5,
            height: nil
          )
        case .image(let image):
          image
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(height: Theme.shared.dimension.remoteImageIconSize)
      }

      if let relyingPartyData = config.relyingPartyData {
        RelyingParty(relyingPartyData: relyingPartyData)
          .padding(.vertical, SPACING_SMALL)
      }
    }
    .frame(maxWidth: .infinity)
  }
}

#Preview {
  ContentHeader(
    config: ContentHeaderConfig(
      appIconAndTextData: AppIconAndTextData(
        appIcon: Image(systemName: "app"),
        appText: Image(systemName: "app")
      ),
      description: .custom("This is a description"),
      descriptionTextConfig: nil,
      mainText: .custom("Main Text"),
      mainTextConfig: nil,
      relyingPartyData: RelyingPartyData(
        logo: .image(Image(systemName: "person.crop.circle")),
        isVerified: true,
        name: .custom("Relying Party Name"),
        nameTextConfig: nil,
        description: .custom("Relying party description"),
        descriptionTextConfig: nil
      )
    )
  )
  .padding()
}
