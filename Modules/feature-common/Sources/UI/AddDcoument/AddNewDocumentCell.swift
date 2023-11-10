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

public struct AddNewDocumentCell: View {

  let isEnabled: Bool
  let icon: Image
  let title: LocalizableString.Key
  let action: () -> Void
  let isLoading: Bool

  public init(
    isEnabled: Bool,
    icon: Image,
    title: LocalizableString.Key,
    isLoading: Bool,
    action: @escaping () -> Void
  ) {
    self.isEnabled = isEnabled
    self.icon = icon
    self.title = title
    self.isLoading = isLoading
    self.action = action
  }

  @ViewBuilder
  var iconStyle: some View {
    if !isEnabled {
      icon
        .renderingMode(.template)
        .resizable()
        .aspectRatio(contentMode: .fit)
    } else {
      icon
        .resizable()
        .aspectRatio(contentMode: .fit)
    }
  }

  public var body: some View {
    HStack {
      Button(action: action) {
        iconStyle
          .foregroundColor(isEnabled ? Theme.shared.color.primary : Theme.shared.color.textDisabledDark)
          .frame(maxWidth: 32)
        Text(title)
          .typography(Theme.shared.font.bodyLarge)
          .foregroundColor(isEnabled ? Theme.shared.color.textPrimaryDark : Theme.shared.color.textDisabledDark)
        Spacer()
        Theme.shared.image.plus
          .font(.body.bold())
          .foregroundColor(isEnabled ? Theme.shared.color.primary : Theme.shared.color.textDisabledDark)
      }
      .disabled(!isEnabled)
      .padding(SPACING_MEDIUM_LARGE)
      .background(Theme.shared.color.backgroundDefault)
      .tint(isEnabled ? nil : Theme.shared.color.textDisabledDark)
      .clipShape(.rect(cornerRadius: Theme.shared.shape.small))
      .shimmer(isLoading: isLoading)
    }
  }
}
