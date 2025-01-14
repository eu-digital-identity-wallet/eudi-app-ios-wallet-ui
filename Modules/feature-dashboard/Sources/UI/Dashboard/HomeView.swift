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

public struct HomeView: View {
  private let bearer: BearerUIModel

  private let addDocument: () -> Void
  private let signDocument: () -> Void

  @State private var addDocumentAlert: Bool = false
  @State private var signDocumentAlert: Bool = false

  public init(
    bearer: BearerUIModel,
    addDocument: @escaping () -> Void,
    signDocument: @escaping () -> Void
  ) {
    self.bearer = bearer
    self.addDocument = addDocument
    self.signDocument = signDocument
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
          buttonText: LocalizableString.Key.authenticate,
          illustration: Theme.shared.image.homeIdentity,
          learnMoreText: LocalizableString.Key.learnMore,
          learnMoreAction: {
            addDocumentAlert = true
          },
          action: {
            addDocument()
          }
        )
        .alertView(
          isPresented: $addDocumentAlert,
          title: LocalizableString.shared.get(with: .alertAccessOnlineServices),
          message: LocalizableString.shared.get(with: .alertAccessOnlineServicesMessage),
          buttonText: LocalizableString.shared.get(with: .okButton),
          onDismiss: {
            addDocumentAlert = false
          }
        )

        HomeCardView(
          text: LocalizableString.Key.electronicallySignDigitalDocuments,
          buttonText: LocalizableString.Key.signDocument,
          illustration: Theme.shared.image.homeContract,
          learnMoreText: LocalizableString.Key.learnMore,
          learnMoreAction: {
            signDocumentAlert = true
          },
          action: {
            signDocument()
          }
        )
        .alertView(
          isPresented: $signDocumentAlert,
          title: LocalizableString.shared.get(with: .alertSignDocumentsSafely),
          message: LocalizableString.shared.get(with: .alertSignDocumentsSafelyMessage),
          buttonText: LocalizableString.shared.get(with: .okButton),
          onDismiss: {
            signDocumentAlert = false
          }
        )
      }
      .padding(.horizontal, SPACING_MEDIUM)
    }
    .clipped()
  }
}

#Preview {
  HomeView(bearer: BearerUIModel.mock()) {} signDocument: {}

}
