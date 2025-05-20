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
import logic_ui

public struct TransactionCardView: View {
  private let backgroundColor: Color
  private let transactionDetailsCardData: TransactionDetailsCardData
  private let isLoading: Bool

  public init(
    backgroundColor: Color = Theme.shared.color.surfaceContainer,
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
            .foregroundStyle(Theme.shared.color.onSurfaceVariant)
          if let relyingPartyName = transactionDetailsCardData.relyingPartyName {
            Text(relyingPartyName)
              .typography(Theme.shared.font.bodyLarge)
              .foregroundStyle(Theme.shared.color.onSurface)
              .if(transactionDetailsCardData.relyingPartyIsVerified ?? false) {
                $0.rightImage(
                  image: Theme.shared.image.verified,
                  spacing: SPACING_SMALL
                ).foregroundStyle(Theme.shared.color.success)
              }
          }
        }

        HStack {
          VStack(alignment: .leading, spacing: SPACING_EXTRA_SMALL) {
            Text(.transactionDetailsScreenCardDateLabel)
              .typography(Theme.shared.font.bodyMedium)
              .foregroundStyle(Theme.shared.color.onSurfaceVariant)
              .fontWeight(.semibold)
            Text(transactionDetailsCardData.transactionDate)
              .typography(Theme.shared.font.bodyMedium)
              .foregroundStyle(Theme.shared.color.onSurfaceVariant)
          }

          Spacer()

          HStack(spacing: SPACING_SMALL) {
            Text(transactionDetailsCardData.transactionStatusLabel)
              .typography(Theme.shared.font.labelLarge)
              .foregroundStyle(Theme.shared.color.surfaceContainerLowest)
          }
          .padding(.horizontal, SPACING_SMALL)
          .padding(.vertical, SPACING_SMALL)
          .background(transactionDetailsCardData.transactionIsCompleted ? Theme.shared.color.success : Theme.shared.color.error)
          .cornerRadius(8)
          .foregroundStyle(Theme.shared.color.onPrimary)
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
        transactionTypeLabel: .custom("Data sharing"),
        transactionStatusLabel: .custom("Completed"),
        transactionIsCompleted: true,
        transactionDate: .custom("16 February 2024"),
        relyingPartyName: .custom("Hellenic Government"),
        relyingPartyIsVerified: true
      )
    )
  }
  .padding()
}
