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
import UIPilot

public struct ContentScreen<Content: View>: View {

  let content: Content
  let padding: CGFloat
  let canScroll: Bool
  let spacing: CGFloat

  public init(
    padding: CGFloat = Theme.shared.dimension.padding,
    canScroll: Bool = false,
    spacing: CGFloat = .zero,
    @ViewBuilder content: () -> Content
  ) {
    self.content = content()
    self.padding = padding
    self.canScroll = canScroll
    self.spacing = spacing
  }

  public var body: some View {
    VStack(spacing: spacing) {
      content
    }
    .padding(canScroll ? [.horizontal, .top] : [.all])
    .background(ThemeManager.shared.color.backgroundPaper)
    .uipNavigationBarHidden(true)
    .if(canScroll == true) { view in
      view.edgesIgnoringSafeArea(.bottom)
    }
  }
}
