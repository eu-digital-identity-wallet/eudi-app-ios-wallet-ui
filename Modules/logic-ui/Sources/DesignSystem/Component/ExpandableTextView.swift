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

public struct ExpandableTextView: View {
  @State private var isExpanded = false
  var title: String
  var content: String
  let isloading: Bool

  public init(
    isExpanded: Bool = false,
    title: String,
    content: String,
    isloading: Bool
  ) {
    self.isExpanded = isExpanded
    self.title = title
    self.content = content
    self.isloading = isloading
  }

  public var body: some View {
    VStack(spacing: SPACING_MEDIUM_SMALL) {
      Group {
        HStack {
          Text(title)
            .bold()
          Spacer()
          Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
            .foregroundColor(Theme.shared.color.primary)
        }
        .padding(isExpanded ? [.horizontal, .top] : [.all])

        if isExpanded {
          HStack {
            Text(content)
              .foregroundColor(.gray)
            Spacer()
          }
          .padding([.horizontal, .bottom])
        }
      }
    }
    .padding()
    .background(Color(red: 0.9, green: 0.9, blue: 0.9))
    .cornerRadius(10)
    .onTapGesture {
      withAnimation {
        isExpanded.toggle()
      }
    }
    .shimmer(isLoading: isloading)
  }
}
