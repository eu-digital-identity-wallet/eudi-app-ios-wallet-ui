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
import logic_ui
import logic_resources
import logic_core
import CodeScanner

struct ScannerView<Router: RouterHost>: View {

  @ObservedObject private var viewmodel: ScannerViewModel<Router>

  private var cameraSurfaceSize: CGFloat = .zero

  init(with viewmodel: ScannerViewModel<Router>) {
    self.viewmodel = viewmodel
    self.cameraSurfaceSize = getScreenRect().width - (Theme.shared.dimension.padding * 2)
  }

  var body: some View {

    ContentScreenView {
      content(
        viewState: viewmodel.viewState,
        cameraSurfaceSize: cameraSurfaceSize,
        onDismiss: viewmodel.onDismiss,
        onError: viewmodel.onError,
        onErrorClick: viewmodel.onErrorClick) { scanResult in
          viewmodel.onResult(scanResult: scanResult)
        }
    }
  }
}

@MainActor
@ViewBuilder
private func content(
  viewState: ScannerState,
  cameraSurfaceSize: CGFloat,
  onDismiss: @escaping () -> Void,
  onError: @escaping () -> Void,
  onErrorClick: @escaping () -> Void,
  onResult: @escaping (_ scanResult: String) -> Void
) -> some View {
  ContentHeaderView(
    dismissIcon: Theme.shared.image.xmark,
    onBack: { onDismiss() }
  )

  ContentTitleView(
    title: viewState.title,
    caption: viewState.caption
  )

  Spacer()

  ZStack {

    CodeScannerView(
      codeTypes: [.qr],
      scanMode: .continuous,
      scanInterval: 1.0,
      shouldVibrateOnSuccess: false
    ) { response in
      switch response {
      case .success(let result):
        onResult(result.string)
      case .failure:
        onError()
      }
    }
    .roundedCorner(Theme.shared.shape.xxxxLarge, corners: .allCorners)
    .padding(
      EdgeInsets(
        top: .zero,
        leading: .zero,
        bottom: 2,
        trailing: 2
      )
    )

    Theme.shared.image.viewFinder
      .resizable()
      .font(.system(size: SPACING_MEDIUM, weight: .ultraLight))
      .foregroundColor(Theme.shared.color.primary)

    if let error = viewState.error {
      ContentEmptyView(
        title: error,
        iconColor: Theme.shared.color.white,
        textColor: Theme.shared.color.white,
        onClick: { onErrorClick() }
      )
    }
  }
  .frame(maxWidth: .infinity, maxHeight: cameraSurfaceSize)

  VSpacer.large()

  ZStack {
    HStack(spacing: SPACING_MEDIUM) {

      Theme.shared.image.errorIndicator
        .renderingMode(.template)
        .foregroundStyle(Theme.shared.color.textPrimaryDark)

      Text(viewState.informativeTest)
        .typography(Theme.shared.font.bodyMedium)
        .foregroundStyle(Theme.shared.color.textPrimaryDark)
        .multilineTextAlignment(.center)

    }
    .padding()
    .frame(maxWidth: .infinity)
    .background(Theme.shared.color.backgroundDefault)
    .clipShape(Theme.shared.shape.highCornerRadiusShape)
    .opacity(viewState.showInformativeText ? 1.0 : 0.0)
  }
  .animation(.easeInOut, value: viewState.showInformativeText)

  Spacer()
}

#Preview {
  let config = ScannerUiConfig(
    flow: .issuing(
      IssuanceFlowUiConfig(flow: .extraDocument)
    )
  )
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
      onDismiss: {},
      onError: {},
      onErrorClick: {},
      onResult: { _ in }
    )
  }
}
