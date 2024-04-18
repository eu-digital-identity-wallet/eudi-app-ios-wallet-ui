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
    also walletKitController: WalletKitController
  ) {
    self.viewmodel = .init(
      config: config,
      router: router,
      walletKitController: walletKitController
    )
    self.cameraSurfaceSize = getScreenRect().width - (Theme.shared.dimension.padding * 2)
  }

  public var body: some View {

    ContentScreenView(errorConfig: viewmodel.viewState.error) {

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

        CodeScannerView(codeTypes: [.qr]) { response in
          switch response {
          case .success(let result):
            viewmodel.onResult(scanResult: result.string)
          case .failure(let error):
            viewmodel.onError(with: error)
          }
        }
        .roundedCorner(Theme.shared.shape.xxxxLarge, corners: .allCorners)

        Theme.shared.image.viewFinder
          .resizable()
          .foregroundColor(Theme.shared.color.primary)
      }
      .frame(maxWidth: .infinity, maxHeight: cameraSurfaceSize)

      Spacer()
    }
  }
}
