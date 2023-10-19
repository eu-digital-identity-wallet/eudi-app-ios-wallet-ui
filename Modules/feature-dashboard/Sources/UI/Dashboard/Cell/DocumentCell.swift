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

public struct DocumentCell: View {

  public let item: DocumentUIModel
  public let action: (DocumentUIModel) -> Void
  public let isLoading: Bool

  private let exrtaSpace: CGFloat = 10

  public init(
    item: DocumentUIModel,
    isLoading: Bool,
    action: @escaping (DocumentUIModel) -> Void
  ) {
    self.item = item
    self.isLoading = isLoading
    self.action = action
  }

  public var body: some View {
    Button(action: {
      action(item)
    }) {
      VStack {
        Spacer(minLength: exrtaSpace)
        Theme.shared.image.idStroke
          .foregroundColor(Theme.shared.color.primary)
          .aspectRatio(contentMode: .fit)
          .frame(maxWidth: 48)
        Text(.custom(item.value.title))
          .typography(ThemeManager.shared.font.bodyMedium)
          .foregroundColor(ThemeManager.shared.color.textPrimaryDark)
          .minimumScaleFactor(0.5)
          .lineLimit(1)
        Text(.custom(item.value.status))
          .typography(ThemeManager.shared.font.bodySmall)
          .foregroundColor(Theme.shared.color.success)
        Spacer(minLength: exrtaSpace)
      }
    }
    .frame(maxWidth: .infinity, alignment: .center)
    .padding()
    .background(Theme.shared.color.backgroundDefault)
    .clipShape(.rect(cornerRadius: 16))
    .shimmer(isLoading: isLoading)
  }
}
