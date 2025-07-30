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

struct ExpandableDocumentCredentialsView: View {
  @State private var isExpanded: Bool = false

  private let backgroundColor: Color
  private let documentCredentialsInfo: DocumentCredentialsInfoUi
  private let onPrimaryButtonClicked: () -> Void

  init(
    backgroundColor: Color = Theme.shared.color.surfaceContainer,
    documentCredentialsInfo: DocumentCredentialsInfoUi,
    onPrimaryButtonClicked: @escaping () -> Void
  ) {
    self.isExpanded = documentCredentialsInfo.isExpanded
    self.backgroundColor = backgroundColor
    self.documentCredentialsInfo = documentCredentialsInfo
    self.onPrimaryButtonClicked = onPrimaryButtonClicked
  }

  var body: some View {
    if isExpanded {
      if let expandedInfo = documentCredentialsInfo.expandedInfo {
        expandedDocumentCredentials(info: expandedInfo)
      }
    } else {
      collapsedDocumentCredentials()
    }
  }

  @ViewBuilder
  private func expandedDocumentCredentials(info: ExpandedInfo) -> some View {
    WrapCardView(
      backgroundColor: backgroundColor
    ) {
      VStack(alignment: .leading, spacing: SPACING_LARGE) {
        VStack(alignment: .leading, spacing: SPACING_EXTRA_SMALL) {
          Text(documentCredentialsInfo.title)
            .font(Theme.shared.font.bodyLarge.font)
            .background(backgroundColor)
            .foregroundColor(Theme.shared.color.success)

          Text(info.subtitle)
            .font(Theme.shared.font.bodyMedium.font)
            .foregroundColor(Theme.shared.color.onSurfaceVariant)
            .multilineTextAlignment(.leading)
        }

        HStack(spacing: SPACING_MEDIUM) {
          Spacer()
          Button {
            withAnimation {
              isExpanded.toggle()
            }
          } label: {
            Text(info.hideButtonText)
              .font(Theme.shared.font.bodyLarge.font)
              .foregroundColor(Theme.shared.color.primary)
          }

          if let updateNowButtonText = info.updateNowButtonText {
            WrapButtonView(
              style: .primary,
              title: updateNowButtonText,
              gravity: .none,
              cornerRadius: Theme.shared.shape.large,
              onAction: onPrimaryButtonClicked()
            )
          }
        }
      }
      .padding(.vertical, SPACING_SMALL)
      .padding(.horizontal, SPACING_MEDIUM)
    }
  }

  @ViewBuilder
  private func collapsedDocumentCredentials() -> some View {
    HStack {
      Text(documentCredentialsInfo.title)
        .font(Theme.shared.font.bodyLarge.font)
        .padding(.vertical, SPACING_SMALL)
        .padding(.horizontal, SPACING_MEDIUM)
        .background(backgroundColor)
        .foregroundColor(Theme.shared.color.success)
        .cornerRadius(8)

      Spacer()

      if let collapsedInfo = documentCredentialsInfo.collapsedInfo {
        Button {
          withAnimation {
            isExpanded.toggle()
          }
        } label: {
          Text(collapsedInfo.moreInfoText)
            .font(Theme.shared.font.bodySmall.font)
            .foregroundColor(Theme.shared.color.primary)
            .underline()
        }
      }
    }
  }
}

#Preview {
  ExpandableDocumentCredentialsView(
    documentCredentialsInfo: DocumentCredentialsInfoUi(
      availableCredentials: 5,
      totalCredentials: 10,
      title: .custom("instances remaining"),
      collapsedInfo: CollapsedInfo(
        moreInfoText: .custom("More Info")
      ),
      expandedInfo: ExpandedInfo(
        subtitle: .custom("For security reasons, this document can be shared a limited number of times before it needs to be re-issued by the issuing authority."), updateNowButtonText: .custom("Update now"),
        hideButtonText: .custom("Hide")
      )
    ),
    onPrimaryButtonClicked: {}
  )
}
