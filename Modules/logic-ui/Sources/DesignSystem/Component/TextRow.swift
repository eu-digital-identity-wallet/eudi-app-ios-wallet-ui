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

public func textRow(
  _ value: LocalizableString.Key,
  textColor: Color = Theme.shared.color.textPrimaryDark,
  imageColor: Color = Theme.shared.color.textPrimaryDark,
  image: String? = nil
) -> some View {
  HStack {
    Text(value)
      .lineLimit(1)
      .minimumScaleFactor(0.5)
      .foregroundColor(textColor)
    Spacer()
    if let image {
      Image(systemName: image)
        .resizable()
        .scaledToFit()
        .foregroundColor(imageColor)
        .frame(height: 20)
    }
  }
}
