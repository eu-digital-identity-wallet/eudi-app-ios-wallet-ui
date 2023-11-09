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

public struct WrapCheckBoxView: View {

  public typealias TapListener = ((String) -> Void)?

  let isSelected: Bool
  let isVisible: Bool
  let isEnabled: Bool
  let isLoading: Bool
  let id: String
  let title: String
  let value: String
  let onTap: TapListener

  var checkBoxColor: Color {
    if self.isEnabled {
      ThemeManager.shared.color.primary
    } else {
      ThemeManager.shared.color.textDisabledDark
    }
  }

  var titleTextColor: Color {
    if self.isEnabled {
      ThemeManager.shared.color.textPrimaryDark
    } else {
      ThemeManager.shared.color.textDisabledDark
    }
  }

  public init(
    isSelected: Bool,
    isVisible: Bool,
    isEnabled: Bool,
    isLoading: Bool,
    id: String,
    title: String,
    value: String,
    onTap: TapListener = nil
  ) {
    self.isSelected = isSelected
    self.isVisible = isVisible
    self.isEnabled = isEnabled
    self.isLoading = isLoading
    self.id = id
    self.title = title
    self.value = value
    self.onTap = onTap
  }

  public var body: some View {

    HStack(spacing: SPACING_SMALL) {

      let image: Image = self.isSelected
      ? ThemeManager.shared.image.checkmarkSquareFill
      : ThemeManager.shared.image.square

      image
        .resizable()
        .scaledToFit()
        .frame(height: 25)
        .foregroundStyle(self.checkBoxColor)

      if !self.isVisible {
        Text(self.title)
          .typography(ThemeManager.shared.font.titleMedium)
          .foregroundStyle(self.titleTextColor)
      } else {
        VStack(alignment: .leading, spacing: SPACING_EXTRA_SMALL) {

          Text(self.title)
            .typography(ThemeManager.shared.font.bodyMedium)
            .foregroundStyle(ThemeManager.shared.color.textSecondaryDark)

          Text(self.value)
            .typography(ThemeManager.shared.font.titleMedium)
            .foregroundStyle(ThemeManager.shared.color.textPrimaryDark)
        }
      }

      Spacer()
    }
    .frame(maxWidth: .infinity, maxHeight: 50)
    .if(self.onTap != nil && self.isEnabled && !self.isLoading) {
      $0.onTapGesture {
        self.onTap?(self.id)
      }
    }
    .disabled(!self.isEnabled || self.isLoading)
    .shimmer(isLoading: self.isLoading)
    .animation(.easeInOut, value: self.isVisible)
  }
}
