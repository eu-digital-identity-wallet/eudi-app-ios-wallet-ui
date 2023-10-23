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
import logic_ui

public struct DocumentList: View {

  public let items: [DocumentUIModel]
  public let action: (DocumentUIModel) -> Void
  public let isLoading: Bool

  public init(
    items: [DocumentUIModel],
    isLoading: Bool,
    action: @escaping (DocumentUIModel) -> Void) {
    self.items = items
    self.action = action
    self.isLoading = isLoading
  }

  public var body: some View {
    ScrollView {
      LazyVGrid(
        columns: [GridItem(), GridItem()],
        spacing: 8
      ) {
        ForEach(items) { item in
          DocumentCell(
            item: item,
            isLoading: isLoading,
            action: { item in
              action(item)
            })
        }
      }
      .padding(32)
      VSpacer.largeMedium()
    }
  }
}
