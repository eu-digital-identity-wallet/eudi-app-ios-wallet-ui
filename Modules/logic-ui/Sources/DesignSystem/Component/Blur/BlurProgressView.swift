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

public struct BlurProgressView: View {

  let height: CGFloat
  let width: CGFloat

  public init(height: CGFloat = 72, width: CGFloat = 72) {
    self.width = width
    self.height = height
  }

  public var body: some View {
    ZStack {
      LoaderView(
        showLoader: .constant(true),
        width: self.width,
        height: self.height
      )
      .padding([.horizontal, .vertical], 10)
    }
    .background(Blur(style: .regular).cornerRadius(12))
  }
}

public struct NormalProgressView: View {

  let height: CGFloat
  let width: CGFloat

  public init(height: CGFloat = 72, width: CGFloat = 72) {
    self.width = width
    self.height = height
  }

  public var body: some View {
    LoaderView(
      showLoader: .constant(true),
      width: self.width,
      height: self.height
    )
  }
}
