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

public struct BearerCell: View {
  public let item: BearerUIModel
  public let isLoading: Bool

  @ViewBuilder
  public var userImage: some View {
    item.value.image
      .resizable()
      .aspectRatio(contentMode: .fit)
      .frame(maxWidth: 64.0)
      .cornerRadius(8.0)
  }

  public init(
    item: BearerUIModel,
    isLoading: Bool
  ) {
    self.item = item
    self.isLoading = isLoading
  }

  public var body: some View {
    HStack {
      userImage
      VStack(alignment: .leading) {
        Text(.welcomeBack)
          .typography(ThemeManager.shared.font.bodyMedium)
          .minimumScaleFactor(0.5)
          .lineLimit(1)
          .foregroundColor(ThemeManager.shared.color.textSecondaryLight)
        Text(.custom(item.value.name))
          .typography(ThemeManager.shared.font.headlineMedium)
          .minimumScaleFactor(0.5)
          .lineLimit(1)
          .foregroundColor(ThemeManager.shared.color.textSecondaryLight)
      }
      .padding(.horizontal, 6)
      Spacer()
    }
    .padding(.horizontal, 32)
    .frame(maxWidth: .infinity)
    .shimmer(isLoading: isLoading)
  }
}
