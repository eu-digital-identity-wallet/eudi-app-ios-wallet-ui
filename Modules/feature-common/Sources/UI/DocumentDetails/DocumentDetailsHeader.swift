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

  public init(
    documentName: String,
    holdersName: String,
    userIcon: Image
  ) {
    self.holdersName = holdersName
    self.userIcon = userIcon
    self.documentName = documentName
  }

  public var body: some View {
    VStack {
      DocumentDetailsHeaderCell(
        documentName: documentName,
        holdersName: holdersName,
        userIcon: userIcon
      )
      Spacer()
    }
  }
}

extension DocumentDetailsHeaderView {
  struct DocumentDetailsHeaderCell: View {
    public init(
      documentName: String,
      holdersName: String,
      userIcon: Image
    ) {
      self.documentName = documentName
      self.holdersName = holdersName
      self.userIcon = userIcon
    }

    let documentName: String
    let holdersName: String
    let userIcon: Image

    public var body: some View {
      VStack(alignment: .leading) {
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
            .clipShape(.rect(cornerRadius: 16))

          Theme.shared.image.idStroke
            .padding(.leading, -40)
          Spacer()
        }
      }
      .padding(Theme.shared.dimension.padding)
      .frame(maxWidth: .infinity)
      .background(Theme.shared.color.primary)
      .roundedCorner(Theme.shared.shape.small,
                     corners: [.bottomLeft, .bottomRight])
    }
  }
}
