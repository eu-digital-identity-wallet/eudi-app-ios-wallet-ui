/*
 * Copyright (c) 2023 European Commission
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import SwiftUI
import logic_resources
import logic_ui

public struct DocumentDetailsHeaderView: View {

  let documentName: String
  let holdersName: String
  let userIcon: Image
  let isLoading: Bool
  let onBack: () -> Void

  public init(
    documentName: String,
    holdersName: String,
    userIcon: Image,
    isLoading: Bool,
    onBack: @escaping () -> Void
  ) {
    self.holdersName = holdersName
    self.userIcon = userIcon
    self.documentName = documentName
    self.isLoading = isLoading
    self.onBack = onBack
  }

  public var body: some View {
    VStack {
      DocumentDetailsHeaderCell(
        documentName: documentName,
        holdersName: holdersName,
        userIcon: userIcon,
        isLoading: isLoading,
        onBack: onBack
      )
    }
  }
}

extension DocumentDetailsHeaderView {

  struct DocumentDetailsHeaderCell: View {

    let documentName: String
    let holdersName: String
    let userIcon: Image
    let isLoading: Bool
    let onBack: () -> Void

    public init(
      documentName: String,
      holdersName: String,
      userIcon: Image,
      isLoading: Bool,
      onBack: @escaping () -> Void
    ) {
      self.documentName = documentName
      self.holdersName = holdersName
      self.userIcon = userIcon
      self.isLoading = isLoading
      self.onBack = onBack
    }

    public var body: some View {
      VStack(alignment: .leading, spacing: SPACING_SMALL) {

        ContentHeader(dismissIcon: Theme.shared.image.xmark, foregroundColor: Theme.shared.color.white) {
          onBack()
        }

        Text(documentName)
          .typography(Theme.shared.font.headlineSmall)
          .foregroundColor(Theme.shared.color.white)
          .shimmer(isLoading: isLoading)

        Text(holdersName)
          .typography(Theme.shared.font.bodyLarge)
          .foregroundColor(Theme.shared.color.textSecondaryLight)
          .padding(.bottom)
          .shimmer(isLoading: isLoading)

        HStack {
          userIcon
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(height: 120)
            .roundedCorner(Theme.shared.shape.small, corners: .allCorners)

          if !isLoading {
            Theme.shared.image.idStroke
              .roundedCorner(Theme.shared.shape.small, corners: .allCorners)
              .padding(.leading, -40)
          }
          Spacer()
        }
        .shimmer(isLoading: isLoading)
      }
      .padding(SPACING_MEDIUM)
      .frame(maxWidth: .infinity)
      .background(Theme.shared.color.primary)
      .roundedCorner(Theme.shared.shape.small, corners: [.bottomLeft, .bottomRight])
    }
  }
}
