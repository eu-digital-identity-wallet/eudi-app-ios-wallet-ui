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

public struct DocumentDetailsHeaderView: View {

  let documentName: String
  let holdersName: String
  let userIcon: Image
  let hasDocumentExpired: Bool
  let isLoading: Bool
  let actions: [ContentHeaderView.Action]?
  let onBack: (() -> Void)?

  public init(
    documentName: String,
    holdersName: String,
    userIcon: Image,
    hasDocumentExpired: Bool,
    isLoading: Bool,
    actions: [ContentHeaderView.Action]? = nil,
    onBack: (() -> Void)? = nil
  ) {
    self.holdersName = holdersName
    self.userIcon = userIcon
    self.documentName = documentName
    self.hasDocumentExpired = hasDocumentExpired
    self.isLoading = isLoading
    self.actions = actions
    self.onBack = onBack
  }

  public var body: some View {
    VStack {
      DocumentDetailsHeaderCellView(
        documentName: documentName,
        holdersName: holdersName,
        userIcon: userIcon,
        hasDocumentExpired: hasDocumentExpired,
        isLoading: isLoading,
        actions: actions,
        onBack: onBack
      )
    }
  }
}

#Preview {
  DocumentDetailsHeaderView(
    documentName: "National ID",
    holdersName: "Name",
    userIcon: Image(systemName: "person"),
    hasDocumentExpired: false,
    isLoading: false
  )
}

extension DocumentDetailsHeaderView {

  struct DocumentDetailsHeaderCellView: View {

    let documentName: String
    let holdersName: String
    let userIcon: Image
    let hasDocumentExpired: Bool
    let isLoading: Bool
    let actions: [ContentHeaderView.Action]?
    let onBack: (() -> Void)?

    public init(
      documentName: String,
      holdersName: String,
      userIcon: Image,
      hasDocumentExpired: Bool,
      isLoading: Bool,
      actions: [ContentHeaderView.Action]?,
      onBack: (() -> Void)?
    ) {
      self.documentName = documentName
      self.holdersName = holdersName
      self.userIcon = userIcon
      self.hasDocumentExpired = hasDocumentExpired
      self.isLoading = isLoading
      self.actions = actions
      self.onBack = onBack
    }

    public var body: some View {
      VStack(alignment: .leading, spacing: SPACING_SMALL) {

        if let onBack {
          ContentHeaderView(
            dismissIcon: Theme.shared.image.xmark,
            foregroundColor: Theme.shared.color.primary,
            actions: actions
          ) {
            onBack()
          }
        }

        Text(documentName)
          .typography(Theme.shared.font.headlineSmall)
          .foregroundColor(Theme.shared.color.black)
          .shimmer(isLoading: isLoading)

        Text(holdersName)
          .typography(Theme.shared.font.bodyLarge)
          .foregroundColor(Theme.shared.color.black)
          .padding(.bottom)
          .shimmer(isLoading: isLoading)

        HStack {
          userIcon
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(height: 120)
            .roundedCorner(Theme.shared.shape.small, corners: .allCorners)

          if !isLoading {
            ZStack(alignment: .topTrailing) {
              Theme.shared.image.idStroke
                .roundedCorner(Theme.shared.shape.small, corners: .allCorners)
              if hasDocumentExpired {
                Theme.shared.image.warning
                  .renderingMode(.template)
                  .foregroundColor(Theme.shared.color.warning)
                  .padding(2)
                  .background(Theme.shared.color.secondary)
                  .clipShape(Circle())
              }
            }
            .padding(.leading, -40)
          }
          Spacer()
        }
        .shimmer(isLoading: isLoading)
      }
      .padding(SPACING_MEDIUM)
      .frame(maxWidth: .infinity)
      .background(Theme.shared.color.secondary)
      .roundedCorner(Theme.shared.shape.small, corners: [.bottomLeft, .bottomRight])
    }
  }
}
