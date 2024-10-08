/*
 * Copyright (c) 2023 European Commission
 *
 * Licensed under the EUPL, Version 1.2 or - as soon they will be approved by the European
 * Commission - subsequent versions of the EUPL (the "Licence"); You may not use this work
 * except in compliance with the Licence.
 *
 * You may obtain a copy of the Licence at:
 * https://joinup.ec.europa.eu/software/page/eupl
 *
 * Unless required by applicable law or agreed to in writing, software distributed under
 * the Licence is distributed on an "AS IS" basis, WITHOUT WARRANTIES OR CONDITIONS OF
 * ANY KIND, either express or implied. See the Licence for the specific language
 * governing permissions and limitations under the Licence.
 */
import SwiftUI
import logic_resources

public struct ScrollViewSizeKey: PreferenceKey {

  public static let defaultValue: CGSize = .zero

  public static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
    value = nextValue()
  }
}

public struct ScrollableTextView: View {
  @State private var contentSize: CGSize = .zero
  var text: Text

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
