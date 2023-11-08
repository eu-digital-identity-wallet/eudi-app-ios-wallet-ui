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

public struct DocumentDetailsHeaderView: View {

  @State var holdersName: String
  @State var userIcon: Image

  public init(
    holdersName: String,
    userIcon: Image
  ) {
    self.holdersName = holdersName
    self.userIcon = userIcon
  }

  public var body: some View {
    VStack {
      DocumentDetailsHeaderCell(
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
      holdersName: String,
      userIcon: Image
    ) {
      self.holdersName = holdersName
      self.userIcon = userIcon
    }

  //  @State var documentType: DocumentTypeEnum
    @State var holdersName: String
    @State var userIcon: Image

    public var body: some View {
        VStack(alignment: .leading) {
          Text("")//TypographyText(text: documentType.title, style: .h5)
            .foregroundColor(Theme.shared.color.white)
            .padding(.bottom)
          Text("")//TypographyText(text: holdersName, style: .subtitle2)
            .foregroundColor(Theme.shared.color.textSecondaryLight)
            .padding(.bottom)
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
        .padding(32)
        .frame(maxWidth: .infinity)
        .background(Theme.shared.color.primary)
        .roundedCorner(16, corners: [.bottomLeft, .bottomRight])
    }
  }
}
