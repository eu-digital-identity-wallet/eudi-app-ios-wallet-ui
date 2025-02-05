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

  private let content: Content
  private let padding: CGFloat
  private let canScroll: Bool
  private let spacing: CGFloat
  private let allowBackGesture: Bool
  private let errorConfig: ContentErrorView.Config?
  private let background: Color
  private let navigationTitle: LocalizableString.Key?
  private let isLoading: Bool
  private let toolbarContent: ToolBarContent?

  public init(
    padding: CGFloat = Theme.shared.dimension.padding,
    canScroll: Bool = false,
    spacing: CGFloat = .zero,
    allowBackGesture: Bool = false,
    errorConfig: ContentErrorView.Config? = nil,
    background: Color = Theme.shared.color.background,
    navigationTitle: LocalizableString.Key? = nil,
    isLoading: Bool = false,
    toolbarContent: ToolBarContent? = nil,
    @ViewBuilder content: () -> Content
  ) {
    self.content = content()
    self.padding = padding
    self.canScroll = canScroll
    self.allowBackGesture = allowBackGesture
    self.spacing = spacing
    self.errorConfig = errorConfig
    self.background = background
    self.navigationTitle = navigationTitle
    self.isLoading = isLoading
    self.toolbarContent = toolbarContent
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
    .navigationBarHidden(errorConfig == nil ? false : true)
    .if(navigationTitle != nil) {
      $0.navigationTitle(navigationTitle!)
    }
    .navigationBarTitleDisplayMode(.inline)
    .if(toolbarContent != nil) {
      $0.toolbar {
        toolbarContent
      }
      .disabled(isLoading)
    }
    .background(background)
    .if(allowBackGesture == false) {
      $0.navigationBarBackButtonHidden()
    }
    .fastenDynamicType()
  }
}
