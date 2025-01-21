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

public struct HomeCardView: View {
  private let text: LocalizableString.Key
  private let buttonText: LocalizableString.Key
  private let illustration: Image?
  private let buttonViewStyle: ButtonViewStyle
  private let learnMoreText: LocalizableString.Key?
  private let learnMoreAction: (() -> Void)?
  private let action: () -> Void

  public init(
    text: LocalizableString.Key,
    buttonText: LocalizableString.Key,
    illustration: Image? = nil,
    buttonViewStyle: ButtonViewStyle = .primary,
    learnMoreText: LocalizableString.Key? = nil,
    learnMoreAction: (() -> Void)? = nil,
    action: @escaping () -> Void
  ) {
    self.text = text
    self.buttonText = buttonText
    self.learnMoreAction = learnMoreAction
    self.action = action
    self.illustration = illustration
    self.buttonViewStyle = buttonViewStyle
    self.learnMoreText = learnMoreText
  }

  public var body: some View {
    VStack(alignment: .center, spacing: .zero) {
      HStack(alignment: .top) {
        VStack(alignment: .leading, spacing: SPACING_MEDIUM_LARGE) {
          Text(text)
            .typography(Theme.shared.font.headlineSmall)
            .foregroundStyle(Theme.shared.color.onSurfaceVariant)
            .lineLimit(nil)
        }

        Spacer()
        if let illustration {
          illustration
            .resizable()
            .scaledToFit()
            .frame(width: 100, height: 100)
        }
      }

      WrapButtonView(
        style: buttonViewStyle,
        title: buttonText,
        gravity: .center,
        onAction: action()
      )
      .padding(.top, SPACING_LARGE)

      if let learnMoreAction, let learnMoreText {
        Button(action: learnMoreAction) {
          HStack(spacing: SPACING_EXTRA_SMALL) {
            Theme.shared.image.infoCircle

            Text(learnMoreText)
              .typography(Theme.shared.font.bodyLarge)
              .fontWeight(.semibold)
          }
          .foregroundStyle(Theme.shared.color.primary)
        }
        .buttonStyle(PlainButtonStyle())
        .padding(.top, SPACING_LARGE_MEDIUM)
      }
    }
    .padding(SPACING_MEDIUM)
    .background(Theme.shared.color.surfaceContainer)
    .cornerRadius(13)
  }
}

#Preview {
  ScrollView {
    VStack {
      HomeCardView(
        text: LocalizableString.Key.authenticateAuthoriseTransactions,
        buttonText: LocalizableString.Key.addDocumentTitle,
        illustration: Image(systemName: "person.fill"),
        learnMoreText: LocalizableString.Key.learnMore,
        learnMoreAction: {},
        action: {}
      )

      HomeCardView(
        text: LocalizableString.Key.authenticateAuthoriseTransactions,
        buttonText: LocalizableString.Key.addDocumentTitle,
        illustration: Image(systemName: "person.fill"),
        buttonViewStyle: .secondary,
        learnMoreAction: {},
        action: {}
      )

      HomeCardView(
        text: LocalizableString.Key.authenticateAuthoriseTransactions,
        buttonText: LocalizableString.Key.addDocumentTitle,
        illustration: Image(systemName: "person.fill"),
        action: {}
      )

      HomeCardView(
        text: LocalizableString.Key.authenticateAuthoriseTransactions,
        buttonText: LocalizableString.Key.addDocumentTitle,
        action: {}
      )
    }
    .padding()
  }
}
