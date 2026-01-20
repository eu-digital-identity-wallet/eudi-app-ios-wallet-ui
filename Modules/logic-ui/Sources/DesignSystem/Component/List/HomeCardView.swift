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

public struct HomeCardView: View {
  private let text: LocalizableStringKey
  private let locator: LocatorType?
  private let buttonText: LocalizableStringKey
  private let illustration: Image?
  private let buttonViewStyle: ButtonViewStyle
  private let learnMoreText: LocalizableStringKey?
  private let learnMoreAction: (() -> Void)?
  private let action: () -> Void

  public init(
    text: LocalizableStringKey,
    locator: LocatorType? = nil,
    buttonText: LocalizableStringKey,
    illustration: Image? = nil,
    buttonViewStyle: ButtonViewStyle = .primary,
    learnMoreText: LocalizableStringKey? = nil,
    learnMoreAction: (() -> Void)? = nil,
    action: @autoclosure @escaping () -> Void
  ) {
    self.text = text
    self.locator = locator
    self.buttonText = buttonText
    self.learnMoreAction = learnMoreAction
    self.action = action
    self.illustration = illustration
    self.buttonViewStyle = buttonViewStyle
    self.learnMoreText = learnMoreText
  }

  public var body: some View {
    VStack(alignment: .center, spacing: SPACING_NONE) {
      HStack(alignment: .top) {
        VStack(alignment: .leading, spacing: SPACING_MEDIUM_LARGE) {
          Text(text)
            .typography(Theme.shared.font.headlineSmall)
            .foregroundStyle(Theme.shared.color.onSurfaceVariant)
            .lineLimit(nil)
        }

        if let illustration {
          illustration
            .resizable()
            .scaledToFit()
            .frame(width: 100, height: 100)
            .frame(maxWidth: .infinity, alignment: .topTrailing)
        }
      }

      WrapButtonView(
        style: buttonViewStyle,
        title: buttonText,
        gravity: .center,
        onAction: action()
      )
      .padding(.top, SPACING_MEDIUM)
      .ifLet(locator) { view, locator in
        view.combineChilrenAccessibility(locator: locator)
      }

      if let learnMoreAction, let learnMoreText {
        Button(action: learnMoreAction) {
          Label {
            Text(learnMoreText)
              .typography(Theme.shared.font.bodyLarge)
              .fontWeight(.semibold)
          } icon: {
            Theme.shared.image.infoCircle
          }
          .foregroundStyle(Theme.shared.color.primary)
          .padding(SPACING_SMALL)
        }
        .buttonStyle(PlainButtonStyle())
        .padding(.top, SPACING_MEDIUM)
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
        text: LocalizableStringKey.authenticateAuthoriseTransactions,
        buttonText: LocalizableStringKey.addDocumentTitle,
        illustration: Image(systemName: "person.fill"),
        learnMoreText: LocalizableStringKey.learnMore,
        learnMoreAction: {},
        action: {}()
      )

      HomeCardView(
        text: LocalizableStringKey.authenticateAuthoriseTransactions,
        buttonText: LocalizableStringKey.addDocumentTitle,
        illustration: Image(systemName: "person.fill"),
        buttonViewStyle: .secondary,
        learnMoreAction: {},
        action: {}()
      )

      HomeCardView(
        text: LocalizableStringKey.authenticateAuthoriseTransactions,
        buttonText: LocalizableStringKey.addDocumentTitle,
        illustration: Image(systemName: "person.fill"),
        action: {}()
      )

      HomeCardView(
        text: LocalizableStringKey.authenticateAuthoriseTransactions,
        buttonText: LocalizableStringKey.addDocumentTitle,
        action: {}()
      )
    }
    .padding()
  }
}
