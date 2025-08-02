/*
 * Copyright (c) 2025 European Commission
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
import ActivityIndicatorView
import logic_resources

public struct ContentLoaderView: View {

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
    .foregroundColor(Theme.shared.color.primary)
  }
}

#Preview {
  Group {
    ContentLoaderView(showLoader: .constant(true))
      .lightModePreview()
    ContentLoaderView(showLoader: .constant(true))
      .darkModePreview()
  }
}
