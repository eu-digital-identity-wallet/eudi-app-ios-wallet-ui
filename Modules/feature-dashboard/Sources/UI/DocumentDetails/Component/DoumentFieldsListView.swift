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

struct DocumentFieldListView: View {

  let documentFields: [DocumentDetailsUIModel.DocumentField]
  let isLoading: Bool

  var body: some View {
    ScrollView {
      VStack {
        ForEach(documentFields.indices, id: \.self) { index in
          let documentFieldContent = documentFields[index]

          if index == 0 {
            VSpacer.extraLarge()
          }

          KeyValueView(
            title: .custom(documentFieldContent.title),
            subTitle: .custom(documentFieldContent.value),
            isLoading: isLoading
          )
          .padding(Theme.shared.dimension.padding)

        }
      }
    }
  }
}
