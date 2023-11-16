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

import EudiWalletKit
import logic_business

public struct ProximityConnectionView<Router: RouterHostType, Interactor: ProximityInteractorType>: View {

  @ObservedObject private var viewModel: ProximityConnectionViewModel<Router, Interactor>
  @EnvironmentObject private var wallet: EudiWallet
  @State var userIsEditingAlias = false

  var contentSize: CGFloat = 0.0

  public init(with router: Router, and interactor: Interactor) {
    self.viewModel = .init(router: router, interactor: interactor)
    self.contentSize = getScreenRect().width / 1.5
  }

  public var body: some View {
    ContentScreen(
      padding: .zero,
      canScroll: true,
      errorConfig: viewModel.viewState.error
    ) {

      ContentHeader(dismissIcon: Theme.shared.image.xmark) {
        viewModel.goBack()
      }
      .padding([.top, .horizontal], Theme.shared.dimension.padding)

      ContentTitle(
        title: .proximityConnectivityTitle,
        caption: .proximityConnectivityCaption
      )
      .padding(.horizontal, Theme.shared.dimension.padding)

      Spacer()

      if let image = viewModel.viewState.qrImage {

        Image(uiImage: image)
          .resizable()
          .frame(width: contentSize, height: contentSize)
          .transition(.opacity)
      } else {
        ContentLoader(showLoader: .constant(true))
      }

      Spacer()

      nfcFooter

    }
    .task {
      print(wallet.documentsViewModel)
      await viewModel.initialize()
    }
  }

  private var nfcFooter: some View {
    VStack(alignment: .center, spacing: SPACING_MEDIUM) {

      Text(.proximityConnectivityNfc)
        .typography(ThemeManager.shared.font.bodyMedium)
        .foregroundStyle(ThemeManager.shared.color.textSecondaryDark)

      Theme.shared.image.nfc
        .resizable()
        .scaledToFit()
        .frame(height: contentSize / 2)
    }
    .colorScheme(.light)
    .padding(.vertical, SPACING_EXTRA_LARGE)
    .frame(maxWidth: .infinity, maxHeight: contentSize)
    .background(Theme.shared.color.primary.opacity(0.12))
    .roundedCorner(SPACING_MEDIUM, corners: [.topLeft, .topRight])
  }
}
