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
import logic_business
import feature_common
import logic_core

public struct DashboardView<Router: RouterHost>: View {

  @ObservedObject private var viewModel: DashboardViewModel<Router>
  @Environment(\.scenePhase) var scenePhase

  public init(
    with router: Router,
    and interactor: DashboardInteractor,
    deeplinkController: DeepLinkController,
    walletKit: WalletKitController
  ) {
    self.viewModel = .init(
      router: router,
      interactor: interactor,
      deepLinkController: deeplinkController,
      walletKit: walletKit
    )
  }

  @ViewBuilder
  func content() -> some View {
    VStack(spacing: .zero) {

      DocumentListView(
        items: viewModel.viewState.documents,
        isLoading: viewModel.viewState.isLoading
      ) { document in
        viewModel.onDocumentDetails(documentId: document.value.id)
      }
      .bottomFade()

      FloatingActionButtonBarView(
        isLoading: viewModel.viewState.isLoading,
        addAction: viewModel.onAdd(),
        shareAction: viewModel.onShare()
      )

      VSpacer.small()
    }
    .background(Theme.shared.color.backgroundPaper)
  }

  public var body: some View {
    ContentScreenView(
      padding: .zero,
      canScroll: false,
      background: Theme.shared.color.secondary
    ) {
      BearerHeaderView(
        item: viewModel.viewState.bearer,
        isLoading: viewModel.viewState.isLoading,
        onMoreClicked: viewModel.onMore()
      )
      content()
    }
    .sheetDialog(isPresented: $viewModel.isMoreModalShowing) {
      SheetContentView {
        VStack(spacing: .zero) {

          ContentTitleView(
            title: .moreOptions
          )

          VSpacer.medium()

          Group {
            WrapButtonView(
              title: .changeQuickPinOption,
              backgroundColor: .clear,
              icon: Theme.shared.image.pencil,
              gravity: .start,
              onAction: viewModel.onUpdatePin()
            )
            WrapButtonView(
              title: .scanQrCode,
              backgroundColor: .clear,
              icon: Theme.shared.image.qrScan,
              gravity: .start,
              onAction: viewModel.onShowScanner()
            )
          }

          HStack {
            Spacer()
            Text(viewModel.viewState.appVersion)
              .typography(Theme.shared.font.bodyMedium)
              .foregroundColor(Theme.shared.color.textSecondaryDark)
            Spacer()
          }
        }
      }
    }
    .sheetDialog(isPresented: $viewModel.isBleModalShowing) {
      SheetContentView {
        VStack(spacing: SPACING_MEDIUM) {

          ContentTitleView(
            title: .bleDisabledModalTitle,
            caption: .bleDisabledModalCaption
          )

          WrapButtonView(style: .primary, title: .bleDisabledModalButton, onAction: viewModel.onBleSettings())
          WrapButtonView(style: .secondary, title: .cancelButton, onAction: viewModel.toggleBleModal())
        }
      }
    }
    .task {
      await viewModel.fetch()
    }
    .onChange(of: scenePhase) { phase in
      self.viewModel.setPhase(with: phase)
    }
  }
}
