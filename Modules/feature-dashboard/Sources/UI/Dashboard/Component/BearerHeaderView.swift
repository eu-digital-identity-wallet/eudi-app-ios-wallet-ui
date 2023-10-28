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
