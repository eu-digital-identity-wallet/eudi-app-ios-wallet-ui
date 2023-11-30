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

public struct DashboardView<Router: RouterHostType, Interactor: DashboardInteractorType, DeepLinkController: DeepLinkControllerType>: View {

  @ObservedObject private var viewModel: DashboardViewModel<Router, Interactor, DeepLinkController>

  public init(with router: Router, and interactor: Interactor, also deepLinkController: DeepLinkController) {
    self.viewModel = .init(router: router, interactor: interactor, deepLinkController: deepLinkController)
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

      FloatingActionButtonBar(
        isLoading: viewModel.viewState.isLoading,
        addAction: viewModel.onAdd(),
        shareAction: viewModel.onShare()
      )
    }
    .background(ThemeManager.shared.color.backgroundPaper)
  }

  public var body: some View {
    ContentScreen(
      padding: .zero,
      canScroll: false,
      background: ThemeManager.shared.color.secondary
    ) {
      BearerHeaderView(
        item: viewModel.viewState.bearer,
        isLoading: viewModel.viewState.isLoading,
        onMoreClicked: viewModel.onMore()
      )
      content()
    }
    .sheetDialog(isPresented: $viewModel.isMoreModalShowing) {
      VStack(spacing: SPACING_MEDIUM) {

        ContentTitle(
          title: .moreOptions
        )

        WrapButtonView(
          title: .changeQuickPinOption,
          backgroundColor: .clear,
          icon: Theme.shared.image.pencil,
          gravity: .start,
          onAction: viewModel.onUpdatePin()
        )
      }
    }
    .viewDidLoad {
      Task {
        await viewModel.fetch()
      }
    }
  }
}
