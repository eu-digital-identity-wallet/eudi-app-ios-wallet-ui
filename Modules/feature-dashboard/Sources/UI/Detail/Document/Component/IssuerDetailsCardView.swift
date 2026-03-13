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
import logic_ui

struct IssuerDetailsCardView: View {

  private let issuerDetails: IssuerDocumentDetailsCardUIModel
  private let onAction: (() -> Void)?

  init(
    issuerDetails: IssuerDocumentDetailsCardUIModel,
    onAction: (() -> Void)? = nil
  ) {
    self.issuerDetails = issuerDetails
    self.onAction = onAction
  }

  var body: some View {
    ExpandableCardView(
      header: .init(
        mainContent: .text(issuerDetails.issuerName),
        supportingText: issuerDetails.dateText ?? .viewDetails,
        supportingTextColor: issuerDetails.dateTextColor,
        leadingIcon: .init(
          imageUrl: issuerDetails.issuerLogo,
          image: Theme.shared.image.id
        )
      )
    ) {
      VStack(alignment: .leading, spacing: SPACING_MEDIUM) {
        if let dateTextKey = issuerDetails.expandedDateText {
          Text(dateTextKey)
            .typography(Theme.shared.font.bodyMedium)
            .foregroundStyle(Theme.shared.color.onSurfaceVariant)
        }

        HStack(alignment: .center, spacing: SPACING_SMALL) {
          Text(issuerDetails.expandedMessageText)
            .typography(Theme.shared.font.bodyMedium)
            .foregroundStyle(Theme.shared.color.onSurfaceVariant)

          Spacer()

          if let onAction, let textButton = issuerDetails.expandedActionButtonText {
            Button(action: onAction) {
              Text(textButton)
                .typography(Theme.shared.font.bodyLarge)
                .fontWeight(.medium)
                .foregroundStyle(Theme.shared.color.primary)
            }
          }
        }
      }
      .frame(maxWidth: .infinity, alignment: .leading)
      .padding(.horizontal, SPACING_MEDIUM)
      .padding(.bottom, SPACING_MEDIUM)
    }
    .accessibilityElement()
    .combineChilrenAccessibility(
      locator: DocumentDetailsLocators.documetIssuerDetails
    )
  }
}
