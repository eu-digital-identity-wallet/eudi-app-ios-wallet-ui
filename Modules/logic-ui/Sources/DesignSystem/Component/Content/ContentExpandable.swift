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
import SwiftUI

import logic_resources

public struct ContentExpandable<Content: View>: View {

  @State private var isExpanded = false

  let title: LocalizableString.Key
  let content: Content

  public init(
    title: LocalizableString.Key,
    @ViewBuilder content: () -> Content
  ) {
    self.title = title
    self.content = content()
  }

  @ViewBuilder
  var chevron: some View {
    if isExpanded {
      Theme.shared.image.chevronUp
        .foregroundColor(Theme.shared.color.primary)
    } else {
      Theme.shared.image.chevronDown
        .foregroundColor(Theme.shared.color.primary)
    }
  }

  public var body: some View {
    VStack(spacing: SPACING_MEDIUM_SMALL) {
      Group {

        HStack {
          Text(title)
            .typography(Theme.shared.font.titleSmall)
            .foregroundColor(Theme.shared.color.textPrimaryDark)
          Spacer()
          chevron
        }
        .padding()

        if isExpanded {
          content
            .padding([.horizontal, .bottom])
        }
      }
    }
    .padding(SPACING_SMALL)
    .background(Theme.shared.color.backgroundDefault)
    .cornerRadius(10)
    .onTapGesture {
      withAnimation {
        isExpanded.toggle()
      }
    }
  }
}
