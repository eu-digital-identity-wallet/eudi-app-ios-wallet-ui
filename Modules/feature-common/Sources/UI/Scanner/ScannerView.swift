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
import logic_ui
import logic_resources
import CodeScanner

struct ScannerView<Router: RouterHost>: View {

  @ObservedObject private var viewModel: ScannerViewModel<Router>

  private var cameraSurfaceSize: CGFloat = .zero

  init(with viewModel: ScannerViewModel<Router>) {
    self.viewModel = viewModel
    self.cameraSurfaceSize = getScreenRect().width - (Theme.shared.dimension.padding * 2)
  }

  var body: some View {

    ContentScreenView(
      padding: SPACING_NONE,
      navigationTitle: viewModel.viewState.title,
      toolbarContent: toolbarContent()
    ) {
      content(
        viewState: viewModel.viewState,
        cameraSurfaceSize: cameraSurfaceSize,
        onError: viewModel.onError,
        onErrorClick: viewModel.onErrorClick) { scanResult in
          viewModel.onResult(scanResult: scanResult)
        }
    }
  }

  func toolbarContent() -> ToolBarContent {
    .init(
      trailingActions: [],
      leadingActions: [
        .init(image: Theme.shared.image.chevronLeft) {
          viewModel.pop()
        }
      ]
    )
  }
}

@MainActor
@ViewBuilder
private func content(
  viewState: ScannerState,
  cameraSurfaceSize: CGFloat,
  onError: @escaping () -> Void,
  onErrorClick: @escaping () -> Void,
  onResult: @escaping (_ scanResult: String) -> Void
) -> some View {
  VStack(spacing: SPACING_LARGE_MEDIUM) {
    ContentCaptionView(
      caption: viewState.caption
    )
    .padding(.horizontal, Theme.shared.dimension.padding)

    ZStack {
      CodeScannerView(
        codeTypes: [.qr],
        scanMode: .continuous,
        scanInterval: 1.0,
        showViewfinder: true,
        shouldVibrateOnSuccess: false
      ) { response in
        switch response {
        case .success(let result):
          onResult(result.string)
        case .failure:
          onError()
        }
      }

      if let error = viewState.error {
        ContentEmptyView(
          title: error,
          iconColor: Theme.shared.color.white,
          textColor: Theme.shared.color.white,
          onClick: { onErrorClick() }
        )
        .padding()
      }
      informativeText(viewState: viewState)
    }
    .animation(.easeInOut, value: viewState.showInformativeText)
  }
  .ignoresSafeArea(.all, edges: .bottom)
}

@MainActor
@ViewBuilder
private func informativeText(viewState: ScannerState) -> some View {
  ZStack {
    VStack {
      HStack(spacing: SPACING_MEDIUM) {

        Theme.shared.image.errorIndicator
          .renderingMode(.template)
          .foregroundStyle(Theme.shared.color.onSurface)

        Text(viewState.informativeTest)
          .typography(Theme.shared.font.bodyLarge)
          .foregroundStyle(Theme.shared.color.onSurface)
          .multilineTextAlignment(.center)

      }
    }
    .padding()
    .background(Theme.shared.color.surfaceContainer)
    .clipShape(Theme.shared.shape.highCornerRadiusShape)
    .opacity(viewState.showInformativeText ? 1.0 : 0.0)
  }
  .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
  .padding(.bottom, SPACING_LARGE)
}

#Preview {

  let config = ScannerUiConfig(flow: .presentation)

  let viewState = ScannerState(
    config: config,
    error: nil,
    showInformativeText: true,
    informativeTest: config.flow.informativeText,
    allowScanning: true,
    failedScanAttempts: 0
  )

  ContentScreenView {
    content(
      viewState: viewState,
      cameraSurfaceSize: .zero,
      onError: {},
      onErrorClick: {},
      onResult: { _ in }
    )
  }
}
