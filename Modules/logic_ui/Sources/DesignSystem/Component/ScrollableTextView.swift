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

public struct ScrollViewSizeKey: PreferenceKey {
  public static var defaultValue: CGSize = .zero

  public static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
    value = nextValue()
  }
}

public struct ScrollableTextView: View {
  @State private var contentSize: CGSize = .zero
  var text: Text

  public init(_ title: LocalizedStringKey) {
    self.text = Text(title)
  }

  public init(_ title: String) {
    self.text = Text(title)
  }

  public var body: some View {
    GeometryReader { geometry in
      ScrollView(.vertical) {
        VStack {
          text
        }
        .frame(minHeight: geometry.size.height)
        .background(
          GeometryReader { proxy in
            Color.clear.preference(key: ScrollViewSizeKey.self, value: proxy.size)
          }
        )
      }
      .onPreferenceChange(ScrollViewSizeKey.self) { size in
        contentSize = size
      }
      .disabled(contentSize.height <= geometry.size.height)
    }
  }
}
