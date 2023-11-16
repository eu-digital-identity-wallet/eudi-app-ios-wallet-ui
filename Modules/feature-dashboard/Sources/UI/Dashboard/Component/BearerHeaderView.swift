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

struct BearerHeaderView: View {

  let item: BearerUIModel
  let isLoading: Bool

  @ViewBuilder
  var userImage: some View {
    item.value.image
      .resizable()
      .aspectRatio(contentMode: .fit)
      .frame(maxWidth: 64.0)
      .cornerRadius(8.0)
  }

  init(item: BearerUIModel, isLoading: Bool) {
    self.item = item
    self.isLoading = isLoading
  }

  var body: some View {
    VStack(alignment: .leading) {
      BearerCell(item: item, isLoading: isLoading)
    }
    .colorScheme(.light)
    .padding(.vertical, SPACING_EXTRA_LARGE)
    .background(Theme.shared.color.primary)
    .roundedCorner(SPACING_MEDIUM, corners: [.bottomLeft, .bottomRight])
    .background(Theme.shared.color.backgroundPaper)
  }
}
