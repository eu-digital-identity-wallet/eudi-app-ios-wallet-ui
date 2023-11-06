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
import Foundation
import logic_resources

struct KeyValueView: View {

  let title: LocalizableString.Key
  let subTitle: LocalizableString.Key
  let isLoading: Bool

  init(
    title: LocalizableString.Key,
    subTitle: LocalizableString.Key,
    isLoading: Bool = false
  ) {
    self.title = title
    self.subTitle = subTitle
    self.isLoading = isLoading
  }


  var body: some View {
    HStack {

      VStack(alignment: .leading, spacing: SPACING_SMALL) {

        Text(title)
          .foregroundColor(ThemeManager.shared.color.textSecondaryDark)
          .typography(ThemeManager.shared.font.bodyMedium)
        Text(subTitle)
          .foregroundColor(ThemeManager.shared.color.textPrimaryDark)
          .typography(ThemeManager.shared.font.bodyLarge)

        Spacer()

      }
      .shimmer(isLoading: self.isLoading)
    }
  }
}

