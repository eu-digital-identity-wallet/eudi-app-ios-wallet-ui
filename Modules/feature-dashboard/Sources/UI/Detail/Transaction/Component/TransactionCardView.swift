/*
 * Copyright (c) 2026 European Commission
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

public struct TransactionCardView: View {

  @Environment(\.openURL) private var openURL
  @State private var isExpanded = false

  private let backgroundColor: Color
  private let transactionDetailsCardData: TransactionDetailsCardData
  private let isLoading: Bool

  public init(
    backgroundColor: Color = Theme.shared.color.groupedBackground,
    transactionDetailsCardData: TransactionDetailsCardData,
    isLoading: Bool = false
  ) {
    self.backgroundColor = backgroundColor
    self.transactionDetailsCardData = transactionDetailsCardData
    self.isLoading = isLoading
  }

  public var body: some View {
    WrapCardView(backgroundColor: backgroundColor) {
      VStack(alignment: .leading, spacing: SPACING_MEDIUM) {

        VStack(alignment: .leading, spacing: SPACING_EXTRA_SMALL) {
          Text(transactionDetailsCardData.transactionTypeLabel)
            .typography(Theme.shared.font.labelSmall)
            .fontWeight(.semibold)
            .foregroundStyle(Theme.shared.color.secondaryLabel)

          Text(transactionDetailsCardData.partyName ?? .unknown)
            .typography(Theme.shared.font.bodyLarge)
            .fontWeight(.medium)
            .foregroundStyle(Theme.shared.color.primaryLabel)

          if let partyType = transactionDetailsCardData.partyType {
            Text(partyType)
              .typography(Theme.shared.font.bodyMedium)
              .foregroundStyle(Theme.shared.color.secondaryLabel)
          }
        }

        HStack(alignment: .bottom) {
          VStack(alignment: .leading, spacing: SPACING_EXTRA_SMALL) {
            Text(.transactionDetailsScreenCardDateLabel)
              .typography(Theme.shared.font.labelSmall)
              .fontWeight(.semibold)
              .foregroundStyle(Theme.shared.color.secondaryLabel)

            Text(transactionDetailsCardData.transactionDate)
              .typography(Theme.shared.font.bodyMedium)
              .foregroundStyle(Theme.shared.color.primaryLabel)
          }

          Spacer()

          Text(transactionDetailsCardData.transactionStatusLabel)
            .typography(Theme.shared.font.labelMedium)
            .foregroundStyle(Theme.shared.color.white)
            .padding(.horizontal, SPACING_MEDIUM)
            .padding(.vertical, SPACING_SMALL)
            .background(transactionDetailsCardData.transactionIsCompleted ? Theme.shared.color.green : Theme.shared.color.red)
            .cornerRadius(8)
        }

        if let nonCompletionReason = transactionDetailsCardData.nonCompletionReason {
          Text(nonCompletionReason)
            .typography(Theme.shared.font.bodyMedium)
            .foregroundStyle(Theme.shared.color.secondaryLabel)
        }

        if !transactionDetailsCardData.details.isEmpty {
          Button {
            withAnimation { isExpanded.toggle() }
          } label: {
            Text(isExpanded ? .hideDetails : .viewDetails)
              .typography(Theme.shared.font.bodyLarge)
              .fontWeight(.medium)
              .foregroundStyle(Theme.shared.color.accent)
              .frame(maxWidth: .infinity)
          }.gone(if: isExpanded)

          if isExpanded {
            VStack(spacing: .zero) {
              ForEach(Array(transactionDetailsCardData.details.enumerated()), id: \.offset) { index, group in
                ForEach(group) { field in
                  WrapListItemView(
                    listItem: field.listItem,
                    mainTextVerticalPadding: SPACING_EXTRA_SMALL,
                    minHeight: false
                  ) {
                    if let url = field.url {
                      openURL(url)
                    }
                  }
                }
                if index < transactionDetailsCardData.details.count - 1 {
                  ListDividerView()
                }
              }

              Button {
                withAnimation { isExpanded.toggle() }
              } label: {
                Text(isExpanded ? .hideDetails : .viewDetails)
                  .typography(Theme.shared.font.bodyLarge)
                  .fontWeight(.medium)
                  .foregroundStyle(Theme.shared.color.accent)
                  .frame(maxWidth: .infinity)
              }.gone(if: !isExpanded)
            }
          }
        }
      }
      .padding(.all, SPACING_MEDIUM)
    }
    .shimmer(isLoading: isLoading)
  }
}

#Preview {
  VStack(spacing: 16) {
    TransactionCardView(
      transactionDetailsCardData: TransactionDetailsCardData(
        transactionTypeLabel: .custom("Presentation"),
        transactionStatusLabel: .custom("Completed"),
        transactionIsCompleted: true,
        transactionDate: .custom("16 Feb 2024 11:07 AM"),
        partyName: .custom("TravelBook"),
        partyType: .custom("ServiceProvider"),
        details: [
          [.field(id: "purpose", label: .transactionDetailsPurposeLabel, value: "Age verification")],
          [.field(id: "privacy", label: .transactionDetailsPrivacyPolicyLabel, value: "https://verifier.example/privacy", url: URL(string: "https://verifier.example/privacy"))]
        ]
      )
    )
  }
  .padding()
}
