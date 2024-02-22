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
import UIPilot

public struct ContentScreenView<Content: View>: View {

  let content: Content
  let padding: CGFloat
  let canScroll: Bool
  let spacing: CGFloat
  let allowBackGesture: Bool
  let errorConfig: ContentErrorView.Config?
  let background: Color

  public init(
    padding: CGFloat = Theme.shared.dimension.padding,
    canScroll: Bool = false,
    spacing: CGFloat = .zero,
    allowBackGesture: Bool = false,
    errorConfig: ContentErrorView.Config? = nil,
    background: Color = Theme.shared.color.backgroundPaper,
    @ViewBuilder content: () -> Content
  ) {
    self.content = content()
    self.padding = padding
    self.canScroll = canScroll
    self.allowBackGesture = allowBackGesture
    self.spacing = spacing
    self.errorConfig = errorConfig
    self.background = background
  }

  public var body: some View {
    ZStack {
      if let errorConfig {
        ContentErrorView(config: errorConfig)
      } else {
        VStack(spacing: spacing) {
          content
        }
        .padding(canScroll ? [.horizontal, .top] : [.all], padding)
        .if(canScroll == true) {
          $0.ignoresSafeArea(edges: .bottom)
        }
      }
    }
    .background(background)
    .uipNavigationBarHidden(true)
    .if(allowBackGesture == false) {
      $0.navigationBarBackButtonHidden()
    }
    .fastenDynamicType()
  }
}
