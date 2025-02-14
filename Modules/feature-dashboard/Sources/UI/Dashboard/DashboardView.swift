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

  public init(with viewModel: DashboardViewModel<Router>) {
    self.viewModel = viewModel
  }

  var body: some View {
    ContentScreenView(
      padding: .zero,
      canScroll: false,
      navigationTitle: viewModel.getNavigationTitle(),
      toolbarContent: viewModel.toolbarContent()
    ) {
      content(
        viewState: viewModel.viewState,
        isAuthenticateAlertShowing: $viewModel.isAuthenticateAlertShowing,
        selectedTab: $viewModel.selectedTab,
        searchQuery: $viewModel.searchQuery,
        onDocumentDetails: { id in
          viewModel.onDocumentDetails(documentId: id)
        },
        onDeleteDeferredDocument: { doc in
          viewModel.onDeleteDeferredDocument(with: doc)
        },
        onAdd: viewModel.onAdd,
        onShare: viewModel.onShare,
        signDocument: { viewModel.openSignDocument() },
        filteredDocsCallback: { _ in }
      )
    }
    .confirmationDialog(
      .authenticate,
      isPresented: $viewModel.isAuthenticateAlertShowing,
      titleVisibility: .visible
    ) {
      Button(.cancelButton, role: .cancel) {}
      Button(.inPerson) {
        viewModel.onShare()
      }
      Button(.online) {
        viewModel.onShowScanner()
      }
    } message: {
      Text(.authenticateAuthoriseTransactions)
    }
    .sheet(isPresented: $viewModel.isFilterModalShowing) {
      FiltersListView(sections: viewModel.viewState.filterUIModel) {
        viewModel.resetFilters()
        viewModel.enableFilterIndicator(showFilterIndicator: false)
      } applyFiltersAction: {
        viewModel.fetch()
        viewModel.enableFilterIndicator(showFilterIndicator: true)
      } revertFilters: {
        viewModel.revertFilters()
        viewModel.enableFilterIndicator(showFilterIndicator: true)
      }
      updateFiltersCallback: { sectionID, filterID in
        viewModel.updateFilters(sectionID: sectionID, filterID: filterID)
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
    .sheetDialog(isPresented: $viewModel.isDeleteDeferredModalShowing) {
      SheetContentView {
        VStack(spacing: SPACING_MEDIUM) {

          ContentTitleView(
            title: .issuanceDetailsDeletionTitle([viewModel.viewState.pendingDocumentTitle]),
            caption: .issuanceDetailsDeletionCaption([viewModel.viewState.pendingDocumentTitle])
          )

          WrapButtonView(
            style: .primary,
            title: .yes,
            onAction: viewModel.deleteDeferredDocument()
          )
          WrapButtonView(
            style: .secondary,
            title: .no,
            onAction: viewModel.toggleDeleteDeferredModal()
          )
        }
      }
    }
    .confirmationDialog(
      title: .bleDisabledModalTitle,
      message: .bleDisabledModalCaption,
      destructiveText: .cancelButton,
      baseText: .bleDisabledModalButton,
      isPresented: $viewModel.isBleModalShowing,
      destructiveAction: {
        viewModel.toggleBleModal()
      },
      baseAction: {
        viewModel.onBleSettings()
      }
    )
    .confirmationDialog(
      title: .issuanceDetailsDeletionTitle([viewModel.viewState.pendingDocumentTitle]),
      message: .issuanceDetailsDeletionCaption([viewModel.viewState.pendingDocumentTitle]),
      destructiveText: .no,
      baseText: .yes,
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
    .onAppear {
      viewModel.fetch()
    }
    .onChange(of: scenePhase) { phase in
      self.viewModel.setPhase(with: phase)
    }
    .onDisappear {
      self.viewModel.onPause()
    }
  }

  @ViewBuilder
  func deferredSuccessList() -> some View {
    VStack(spacing: SPACING_SMALL) {
      ForEach(viewModel.viewState.succededIssuedDocuments) { item in

        HStack {
          Text(.custom(item.value.title))
            .typography(Theme.shared.font.bodyLarge)
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
}

@MainActor
@ViewBuilder
private func content(
  viewState: DashboardState,
  isAuthenticateAlertShowing: Binding<Bool>,
  selectedTab: Binding<SelectedTab>,
  searchQuery: Binding<String>,
  onDocumentDetails: @escaping (String) -> Void,
  onDeleteDeferredDocument: @escaping (DocumentUIModel) -> Void,
  onAdd: @escaping () -> Void,
  onShare: @escaping () -> Void,
  signDocument: @escaping () -> Void,
  filteredDocsCallback: @escaping (String) -> Void
) -> some View {
  TabView(selection: selectedTab) {
    HomeTabView(
      username: viewState.username,
      contentHeaderConfig: viewState.contentHeaderConfig,
      addDocument: {
        isAuthenticateAlertShowing.wrappedValue.toggle()
      },
      signDocument: {
        signDocument()
      })
    .tabItem {
      Label(
        LocalizableString.shared.get(with: .home),
        systemImage: "house.fill"
      )
    }
    .tag(SelectedTab.home)

    VStack(spacing: .zero) {
      DocumentTabView(
        searchQuery: searchQuery,
        filteredItems: viewState.documents,
        isLoading: viewState.isLoading,
        action: { document in
          switch document.value.state {
          case .issued:
            onDocumentDetails(document.value.id)
          case .pending, .failed:
            onDeleteDeferredDocument(document)
          }
        },
        filteredDocsCallback: filteredDocsCallback
      )
      .background(Theme.shared.color.surface)
    }
    .tabItem {
      Label(
        LocalizableString.shared.get(with: .documents),
        systemImage: "doc.fill")
    }
    .tag(SelectedTab.documents)

    TransactionTabView()
      .tabItem {
        Label(
          LocalizableString.shared.get(with: .transactions),
          systemImage: "arrow.left.arrow.right"
        )
      }
  }
}

#Preview {
  let viewState = DashboardState(
    isLoading: false,
    documents: DocumentUIModel.mocks(),
    filterUIModel: [],
    username: "First name",
    phase: .active,
    pendingBleModalAction: false,
    showFilterIndicator: false,
    appVersion: "App version",
    allowUserInteraction: true,
    pendingDeletionDocument: nil,
    succededIssuedDocuments: [],
    failedDocuments: [],
    moreOptions: [.changeQuickPin, .scanQrCode],
    contentHeaderConfig: .init(
      appIconAndTextData: AppIconAndTextData(
        appIcon: ThemeManager.shared.image.logoEuDigitalIndentityWallet,
        appText: ThemeManager.shared.image.euditext
      )
    ),
    isFromOnPause: true,
    hasDefaultFilters: false
  )

  ContentScreenView(
    padding: .zero,
    canScroll: false,
    background: Theme.shared.color.surface
  ) {
    content(
      viewState: viewState,
      isAuthenticateAlertShowing: .constant(false),
      selectedTab: .constant(.home),
      searchQuery: .constant(""),
      onDocumentDetails: { _ in },
      onDeleteDeferredDocument: { _ in },
      onAdd: {},
      onShare: {},
      signDocument: {},
      filteredDocsCallback: { _ in }
    )
  }
}
