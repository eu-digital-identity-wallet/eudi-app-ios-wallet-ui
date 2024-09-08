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

public struct ScannerView<Router: RouterHost>: View {

  @ObservedObject private var viewmodel: ScannerViewModel<Router>

  private var cameraSurfaceSize: CGFloat = .zero

  public init(
    with router: Router,
    and config: any UIConfigType,
    also interactor: ScannerInteractor
  ) {
    self.viewmodel = .init(
      config: config,
      router: router,
      interactor: interactor
    )
    self.cameraSurfaceSize = getScreenRect().width - (Theme.shared.dimension.padding * 2)
  }

  public var body: some View {

    ContentScreenView {

      ContentHeaderView(
        dismissIcon: Theme.shared.image.xmark,
        onBack: { viewmodel.onDismiss() }
      )

      ContentTitleView(
        title: viewmodel.viewState.title,
        caption: viewmodel.viewState.caption
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
            viewmodel.onResult(scanResult: result.string)
          case .failure:
            viewmodel.onError()
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

        if let error = viewmodel.viewState.error {
          ContentEmptyView(
            title: error,
            iconColor: Theme.shared.color.white,
            textColor: Theme.shared.color.white,
            onClick: { viewmodel.onErrorClick() }
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

          Text(viewmodel.viewState.informativeTest)
            .typography(Theme.shared.font.bodyMedium)
            .foregroundStyle(Theme.shared.color.textPrimaryDark)
            .multilineTextAlignment(.center)

        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Theme.shared.color.backgroundDefault)
        .clipShape(Theme.shared.shape.highCornerRadiusShape)
        .opacity(viewmodel.viewState.showInformativeText ? 1.0 : 0.0)
      }
      .animation(.easeInOut, value: viewmodel.viewState.showInformativeText)

      Spacer()
    }
  }
}
