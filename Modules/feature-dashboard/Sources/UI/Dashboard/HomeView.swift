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
import logic_ui
import logic_resources
import feature_common
import logic_business

public struct HomeView: View {
  private let bearer: BearerUIModel

  public init(bearer: BearerUIModel) {
    self.bearer = bearer
  }

  public var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: SPACING_LARGE_MEDIUM) {
        ContentHeader(
          config: ContentHeaderConfig(
            appIconAndTextData: AppIconAndTextData(
              appIcon: ThemeManager.shared.image.logoEuDigitalIndentityWallet,
              appText: ThemeManager.shared.image.euditext
            )
          )
        )

        Text("\(LocalizableString.shared.get(with: .welcomeBack)), \(bearer.value.name)")
          .font(Theme.shared.font.headlineMedium.font)
          .foregroundStyle(Theme.shared.color.onSurface)

        HomeCardView(
          text: LocalizableString.Key.authenticateAuthoriseTransactions,
          buttonText: LocalizableString.Key.addDocumentTitle,
          illustration: Theme.shared.image.homeIdentity,
          learnMoreText: LocalizableString.Key.learnMore,
          learnMoreAction: {},
          action: {}
        )

        HomeCardView(
          text: LocalizableString.Key.electronicallySignDigitalDocuments,
          buttonText: LocalizableString.Key.signDocument,
          illustration: Theme.shared.image.homeContract,
          learnMoreText: LocalizableString.Key.learnMore,
          learnMoreAction: {},
          action: {}
        )
      }
      .padding(.horizontal, SPACING_MEDIUM)
    }
    .clipped()
  }
}

#Preview {
  HomeView(bearer: BearerUIModel.mock())
}
