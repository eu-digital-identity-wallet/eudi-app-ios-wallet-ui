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

public struct DocumentDetailsHeaderView: View {

  let documentName: String
  let holdersName: String
  let userIcon: Image
  let isLoading: Bool

  public init(
    documentName: String,
    holdersName: String,
    userIcon: Image,
    isLoading: Bool
  ) {
    self.holdersName = holdersName
    self.userIcon = userIcon
    self.documentName = documentName
    self.isLoading = isLoading
  }

  public var body: some View {
    VStack {
      DocumentDetailsHeaderCell(
        documentName: documentName,
        holdersName: holdersName,
        userIcon: userIcon,
        isLoading: isLoading
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

    public init(
      documentName: String,
      holdersName: String,
      userIcon: Image,
      isLoading: Bool
    ) {
      self.documentName = documentName
      self.holdersName = holdersName
      self.userIcon = userIcon
      self.isLoading = isLoading
    }

    public var body: some View {
      VStack(alignment: .leading) {
        Group {
          Text(documentName)
            .typography(Theme.shared.font.headlineSmall)
            .foregroundColor(Theme.shared.color.white)
          VSpacer.small()
          Text(holdersName)
            .typography(Theme.shared.font.bodyLarge)
            .foregroundColor(Theme.shared.color.textSecondaryLight)
            .padding(.bottom)
          VSpacer.small()
          HStack {
            userIcon
              .resizable()
              .aspectRatio(contentMode: .fit)
              .frame(height: 120)
              .clipShape(.rect(cornerRadius: Theme.shared.shape.small))

            if isLoading == false {
              Theme.shared.image.idStroke
                .roundedCorner(16, corners: .allCorners)
                .padding(.leading, -40)
            }
            Spacer()
          }
        }
        .shimmer(isLoading: isLoading)
      }
      .padding(SPACING_MEDIUM)
      .frame(maxWidth: .infinity)
      .background(Theme.shared.color.primary)
      .roundedCorner(Theme.shared.shape.small,
                     corners: [.bottomLeft, .bottomRight])
    }
  }
}
