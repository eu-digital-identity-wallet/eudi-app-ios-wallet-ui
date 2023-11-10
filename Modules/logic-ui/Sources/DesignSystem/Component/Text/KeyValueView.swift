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

public struct KeyValueView: View {

  let title: LocalizableString.Key
  let subTitle: LocalizableString.Key
  let alignment: KeyValueView.Alignment
  let isLoading: Bool

  public init(
    title: LocalizableString.Key,
    subTitle: LocalizableString.Key,
    alignment: KeyValueView.Alignment = .start,
    isLoading: Bool = false
  ) {
    self.title = title
    self.subTitle = subTitle
    self.alignment = alignment
    self.isLoading = isLoading
  }

  public var body: some View {
    HStack {

      if alignment == .center || alignment == .end {
        Spacer()
      }

      VStack(alignment: .leading, spacing: SPACING_EXTRA_SMALL) {

        Text(title)
          .foregroundColor(Theme.shared.color.textSecondaryDark)
          .typography(ThemeManager.shared.font.bodyMedium)
          .if(isLoading) { view in
            view
              .lineLimit(1)
          }

        Text(subTitle)
          .foregroundColor(Theme.shared.color.textPrimaryDark)
          .typography(ThemeManager.shared.font.bodyLarge)
          .if(isLoading) { view in
            view
              .lineLimit(1)
          }

        Spacer()

      }

      if alignment == .center || alignment == .start {
        Spacer()
      }
    }
    .shimmer(isLoading: self.isLoading)
  }
}

public extension KeyValueView {
  enum Alignment {
    case start
    case center
    case end
  }

  struct Model: Identifiable {
    public init(title: String, value: String) {
      self.id = UUID().uuidString
      self.title = title
      self.value = value
    }

    public var id: String
    public var title: String
    public var value: String
  }
}
