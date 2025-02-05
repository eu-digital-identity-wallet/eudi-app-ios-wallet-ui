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

struct ProximityConnectionView<Router: RouterHost>: View {

  @ObservedObject private var viewModel: ProximityConnectionViewModel<Router>

  var contentSize: CGFloat = 0.0

  init(with viewModel: ProximityConnectionViewModel<Router>) {
    self.viewModel = viewModel
    self.contentSize = getScreenRect().width / 1.5
  }

  var body: some View {
    ContentScreenView(
      padding: .zero,
      errorConfig: viewModel.viewState.error,
      navigationTitle: .authenticate,
      toolbarContent: toolbarContent()
    ) {
      content(
        viewState: viewModel.viewState,
        contentSize: contentSize
      )
    }
    .task {
      await viewModel.initialize()
    }
  }

  func toolbarContent() -> ToolBarContent {
    .init(
      trailingActions: [],
      leadingActions: [
        Action(image: Theme.shared.image.chevronLeft) {
          viewModel.pop()
        }
      ]
    )
  }
}

@MainActor
@ViewBuilder
private func content(
  viewState: ProxmityConnectivityState,
  contentSize: CGFloat
) -> some View {
  VStack(spacing: SPACING_LARGE_MEDIUM) {
    HStack {
      Text(.proximityConnectivityCaption)
        .typography(Theme.shared.font.bodyLarge)
        .foregroundStyle(Theme.shared.color.onSurface)
      Spacer()
    }
    .frame(maxWidth: .infinity, alignment: .leading)

    Spacer()

    VStack(alignment: .center) {
      if let image = viewState.qrImage {
        Image(uiImage: image)
          .resizable()
          .transition(.opacity)
      } else {
        ContentLoaderView(showLoader: .constant(true))
      }
    }
    .frame(width: contentSize, height: contentSize)

    Spacer()

    Divider()

    nfcFooter(contentSize: contentSize)
  }
  .padding(.top, SPACING_LARGE_MEDIUM)
  .padding(.horizontal, Theme.shared.dimension.padding)
}

@MainActor
@ViewBuilder
private func nfcFooter(contentSize: CGFloat) -> some View {
  VStack(alignment: .center, spacing: SPACING_SMALL) {
    Text(.orShareViaNfc)
      .typography(Theme.shared.font.bodyLarge)
      .foregroundStyle(Theme.shared.color.onSurface)

    Theme.shared.image.nfc
      .resizable()
      .scaledToFit()
      .frame(width: 36, height: 36)

    Text(.proximityConnectionNfcDescription)
      .typography(Theme.shared.font.bodyMedium)
      .foregroundStyle(Theme.shared.color.onSurface)
  }
}

#Preview("Loading") {
  let viewState = ProxmityConnectivityState(
    error: nil,
    qrImage: nil,
    originator: .featureStartupModule(.startup)
  )

  ContentScreenView(
    padding: .zero,
    canScroll: true
  ) {
    content(
      viewState: viewState,
      contentSize: 0.0
    )
  }
}

#Preview {
  let viewState = ProxmityConnectivityState(
    error: nil,
    qrImage: UIImage(systemName: "qrcode"),
    originator: .featureStartupModule(.startup)
  )

  ContentScreenView(
    padding: .zero,
    canScroll: true
  ) {
    content(
      viewState: viewState,
      contentSize: 0.0
    )
  }
}
