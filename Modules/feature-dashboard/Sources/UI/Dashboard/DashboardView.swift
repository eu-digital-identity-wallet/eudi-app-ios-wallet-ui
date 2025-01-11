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

struct DashboardView<Router: RouterHost>: View {
  @ObservedObject private var viewModel: DashboardViewModel<Router>

  @Environment(\.scenePhase) var scenePhase

  @State private var selectedOptions: Set<String> = []
  @State private var sortAscending: Bool = true

  public init(with viewModel: DashboardViewModel<Router>) {
    self.viewModel = viewModel
  }

  var body: some View {
    ContentScreenView(
      padding: .zero,
      canScroll: false,
      navigationTitle: getNavigationTitle(selectedTab: viewModel.selectedTab),
      toolbarContent: getToolbar(selectedTab: viewModel.selectedTab)
    ) {
      content(
        viewState: viewModel.viewState,
        selectedTab: $viewModel.selectedTab,
        onMore: viewModel.onMore,
        onDocumentDetails: { id in
          viewModel.onDocumentDetails(documentId: id)
        },
        onDeleteDeferredDocument: { doc in
          viewModel.onDeleteDeferredDocument(with: doc)
        },
        onAdd: viewModel.onAdd,
        onShare: viewModel.onShare
      )
    }
    .sheet(isPresented: $viewModel.isFilterModalShowing) {
      FilterListView(
        selectedOptions: $selectedOptions,
        sortAscending: $sortAscending,
        sections: viewModel.documentSections
      )
    }
    .confirmationDialog(
      title: LocalizableString.shared.get(with: .bleDisabledModalTitle),
      message: LocalizableString.shared.get(with: .bleDisabledModalCaption),
      destructiveText: LocalizableString.shared.get(with: .cancelButton).capitalized,
      baseText: LocalizableString.shared.get(with: .bleDisabledModalButton).capitalized,
      isPresented: $viewModel.isBleModalShowing,
      destructiveAction: {
        viewModel.toggleBleModal()
      },
      baseAction: {
        viewModel.onBleSettings()
      }
    )
    .confirmationDialog(
      title: LocalizableString.shared.get(with: .issuanceDetailsDeletionTitle([viewModel.viewState.pendingDocumentTitle])),
      message: LocalizableString.shared.get(with: .issuanceDetailsDeletionCaption([viewModel.viewState.pendingDocumentTitle])),
      destructiveText: LocalizableString.shared.get(with: .no),
      baseText: LocalizableString.shared.get(with: .yes),
      isPresented: $viewModel.isDeleteDeferredModalShowing,
      destructiveAction: {
        viewModel.toggleDeleteDeferredModal()
      },
      baseAction: {
        viewModel.deleteDeferredDocument()
      }
    )
    .sheetDialog(isPresented: $viewModel.isSuccededDocumentsModalShowing) {
      SheetContentView {
        VStack(spacing: SPACING_MEDIUM) {

          ContentTitleView(
            title: .deferredDocumentsIssuedModalTitle,
            caption: .defferedDocumentsIssuedModalCaption
          )

          deferredSuccessList()
        }
      }
    }
    .task {
      await viewModel.fetch()
    }
    .onChange(of: scenePhase) { phase in
      self.viewModel.setPhase(with: phase)
    }
    .onDisappear {
      self.viewModel.onPause()
    }
  }

  func getNavigationTitle(selectedTab: SelectedTab) -> String {
    switch selectedTab {
    case .documents:
      return LocalizableString.shared.get(with: .documents)
    case .home:
      return LocalizableString.shared.get(with: .home)
    case .transactions:
      return LocalizableString.shared.get(with: .transactions)
    }
  }

  func getToolbar(selectedTab: SelectedTab) -> ToolBarContent {
    switch selectedTab {
    case .documents:
      return ToolBarContent(
        trailingActions: [
          Action(image: Theme.shared.image.plus) {
            viewModel.onAdd()
          },
          Action(image: Theme.shared.image.filterMenuIcon) {
            viewModel.showFilters()
          }
        ],
        leadingActions: [
          Action(image: Theme.shared.image.menuIcon) {}
        ]
      )
    case .home:
      return ToolBarContent(
        trailingActions: [
          Action(image: Theme.shared.image.bell) {}
        ],
        leadingActions: [
          Action(image: Theme.shared.image.menuIcon) {}
        ]
      )
    case .transactions:
      return ToolBarContent(
        trailingActions: [
          Action(image: Theme.shared.image.bell) {}
        ],
        leadingActions: [
          Action(image: Theme.shared.image.menuIcon) {}
        ]
      )
    }
  }

  @ViewBuilder
  func deferredSuccessList() -> some View {
    VStack(spacing: SPACING_SMALL) {
      ForEach(viewModel.viewState.succededIssuedDocuments) { item in

        HStack {
          Text(.custom(item.value.title))
            .typography(Theme.shared.font.bodyMedium)
            .foregroundColor(Theme.shared.color.onSurface)

          Spacer()

          Theme.shared.image.chevronRight
            .renderingMode(.template)
            .foregroundStyle(Theme.shared.color.primary)
        }
        .padding()
        .background(Theme.shared.color.background)
        .clipShape(.rect(cornerRadius: 8))
        .onTapGesture {
          viewModel.onDocumentDetails(documentId: item.value.id)
        }

      }
    }
    .padding(.vertical)
  }

  @ViewBuilder
  func shareLogs(with fileUrl: URL) -> some View {
    ShareLink(item: fileUrl) {
      HStack {

        Theme.shared.image.share
          .resizable()
          .scaledToFit()
          .frame(width: 25, height: 25)
          .foregroundColor(Theme.shared.color.primary)

        HSpacer.medium()

        Text(.retrieveLogs)
          .typography(Theme.shared.font.labelLarge)
          .foregroundColor(Theme.shared.color.onSurface)

        Spacer()
      }
      .padding()
    }
  }
}

@MainActor
@ViewBuilder
private func content(
  viewState: DashboardState,
  selectedTab: Binding<SelectedTab>,
  onMore: @escaping () -> Void,
  onDocumentDetails: @escaping (String) -> Void,
  onDeleteDeferredDocument: @escaping (DocumentUIModel) -> Void,
  onAdd: @escaping () -> Void,
  onShare: @escaping () -> Void
) -> some View {
  TabView(selection: selectedTab) {
    HomeView(bearer: viewState.bearer)
      .tabItem {
        Label(
          LocalizableString.shared.get(with: .home),
          systemImage: "house.fill"
        )
      }
      .tag(SelectedTab.home)

    VStack(spacing: .zero) {
      DocumentListView(
        items: viewState.documents,
        isLoading: viewState.isLoading
      ) { document in
        switch document.value.state {
        case .issued:
          onDocumentDetails(document.value.id)
        case .pending, .failed:
          onDeleteDeferredDocument(document)
        }
      }
      .background(Theme.shared.color.surface)
    }
    .tabItem {
      Label(
        LocalizableString.shared.get(with: .documents),
        systemImage: "doc.fill")
    }
    .tag(SelectedTab.documents)

    TransactionsView()
      .tabItem {
        Label(
          LocalizableString.shared.get(with: .transactions),
          systemImage: "arrow.left.arrow.right"
        )
      }
      .tag(SelectedTab.transactions)
  }
}

#Preview {
  let viewState = DashboardState(
    isLoading: false,
    documents: DocumentUIModel.mocks(),
    bearer: BearerUIModel.mock(),
    phase: .active,
    pendingBleModalAction: false,
    appVersion: "App version",
    allowUserInteraction: true,
    pendingDeletionDocument: nil,
    succededIssuedDocuments: [],
    failedDocuments: [],
    moreOptions: [.changeQuickPin, .scanQrCode]
  )

  ContentScreenView(
    padding: .zero,
    canScroll: false,
    background: Theme.shared.color.surface
  ) {
    content(
      viewState: viewState,
      selectedTab: .constant(.home),
      onMore: {},
      onDocumentDetails: { _ in },
      onDeleteDeferredDocument: { _ in },
      onAdd: {},
      onShare: {}
    )
  }
}
