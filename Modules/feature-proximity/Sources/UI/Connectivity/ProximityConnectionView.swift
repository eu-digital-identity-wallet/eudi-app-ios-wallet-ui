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
import logic_ui
import logic_resources

public struct ProximityConnectionView<Router: RouterHostType, Interactor: ProximityInteractorType>: View {

  @ObservedObject private var viewModel: ProximityConnectionViewModel<Router, Interactor>
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
      }

      Spacer()

      nfcFooter

    }
    .task {
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
