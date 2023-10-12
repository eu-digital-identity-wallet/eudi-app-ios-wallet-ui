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
import ActivityIndicatorView
import logic_resources

public struct ContentLoader: View {

  @Binding
  private var showLoader: Bool

  private let width: CGFloat
  private let height: CGFloat

  public init(
    showLoader: Binding<Bool>,
    width: CGFloat = 50,
    height: CGFloat = 50
  ) {
    self._showLoader = showLoader
    self.width = width
    self.height = height
  }

  @ViewBuilder
  public var body: some View {
    ActivityIndicatorView(
      isVisible: $showLoader,
      type: .default(count: 8)
    )
    .frame(width: width, height: height)
    .foregroundColor(Theme.shared.color.secondaryMain)
  }
}
