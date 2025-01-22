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
  @State private var showFilterIndicator: Bool = false
  @State private var sortAscending: Bool = true

  public init(with viewModel: DashboardViewModel<Router>) {
    self.viewModel = viewModel
  }

  var body: some View {
    ContentScreenView(
      padding: .zero,
      canScroll: false,
      navigationTitle: getNavigationTitle(selectedTab: viewModel.selectedTab),
      toolbarContent: .init(
        trailingActions: trailingActions(selectedTab: viewModel.selectedTab),
        leadingActions: [
          Action(image: Theme.shared.image.menuIcon) {
            viewModel.onMyWallet()
          }
        ]
      )
    ) {
      content(
        viewState: viewModel.viewState,
        addDocument: $viewModel.addDocument,
        selectedTab: $viewModel.selectedTab,
        onMore: viewModel.onMore,
        onDocumentDetails: { id in
          viewModel.onDocumentDetails(documentId: id)
        },
        onDeleteDeferredDocument: { doc in
          viewModel.onDeleteDeferredDocument(with: doc)
        },
        onAdd: viewModel.onAdd,
        onShare: viewModel.onShare,
        signDocument: { viewModel.openSignDocument() },
        filteredDocsCallback: { filterDocs in
          viewModel.updateFilteredDocuments(filteredDocuments: filterDocs)
        }
      )
    }
    .confirmationDialog(
      LocalizableString.shared.get(with: .authenticate),
      isPresented: $viewModel.addDocument,
      titleVisibility: .visible
    ) {
      Button(LocalizableString.shared.get(with: .cancelButton), role: .cancel) {}
      Button(LocalizableString.shared.get(with: .inPerson)) {
        viewModel.onShare()
      }
      Button(LocalizableString.shared.get(with: .online)) {
        viewModel.onShowScanner()
      }
    } message: {
      Text(.authenticateAuthoriseTransactions)
    }
    .sheet(isPresented: $viewModel.isFilterModalShowing) {
      FilterListView(
        sortAscending: $sortAscending,
        showFilterIndicator: $showFilterIndicator,
        selectedOptions: $selectedOptions,
        sections: viewModel.viewState.documentSections
      )
    }
    .sheetDialog(isPresented: $viewModel.isMoreModalShowing) {
      SheetContentView {
        VStack(spacing: .zero) {

          ContentTitleView(
            title: .moreOptions
          )

          VSpacer.medium()

          ForEach(viewModel.viewState.moreOptions, id: \.id) { option in

            switch option {
              case .changeQuickPin:
                WrapButtonView(
                  title: .changeQuickPinOption,
                  backgroundColor: .clear,
                  icon: Theme.shared.image.pencil,
                  gravity: .start,
                  onAction: viewModel.onUpdatePin()
                )
              case .scanQrCode:
                WrapButtonView(
                  title: .scanQrCode,
                  backgroundColor: .clear,
                  icon: Theme.shared.image.qrScan,
                  gravity: .start,
                  onAction: viewModel.onShowScanner()
                )
              case .signDocument:
                WrapButtonView(
                  title: .signDocument,
                  backgroundColor: .clear,
                  icon: Theme.shared.image.signDocument,
                  gravity: .start,
                  onAction: viewModel.openSignDocument()
                )
              case .retrieveLogs(let url):
                shareLogs(with: url)
            }
          }

          HStack {
            Spacer()
            Text(viewModel.viewState.appVersion)
              .typography(Theme.shared.font.bodyLarge)
              .foregroundColor(Theme.shared.color.onSurface)
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
    .onChange(of: showFilterIndicator, perform: { _ in
      if showFilterIndicator {
        viewModel.applyFilters(sortAscending: sortAscending)
      }
    })
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

  func trailingActions(selectedTab: SelectedTab) -> [Action]? {
    switch selectedTab {
      case .documents:
        return [
          Action(image: Theme.shared.image.plus) {
            viewModel.onAdd()
          },
          Action(image: Theme.shared.image.filterMenuIcon, hasIndicator: showFilterIndicator) {
            viewModel.showFilters()
          }
        ]
      case .home:
        return nil
      case .transactions:
        return nil
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
  addDocument: Binding<Bool>,
  selectedTab: Binding<SelectedTab>,
  onMore: @escaping () -> Void,
  onDocumentDetails: @escaping (String) -> Void,
  onDeleteDeferredDocument: @escaping (DocumentUIModel) -> Void,
  onAdd: @escaping () -> Void,
  onShare: @escaping () -> Void,
  signDocument: @escaping () -> Void,
  filteredDocsCallback: @escaping (String) -> Void
) -> some View {
  TabView(selection: selectedTab) {
    HomeView(
      username: viewState.username,
      addDocument: {
        addDocument.wrappedValue.toggle()
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
      DocumentListView(
        filteredItems: viewState.filteredDocuments,
        isLoading: viewState.isLoading
      ) { document in
        switch document.value.state {
        case .issued:
          onDocumentDetails(document.value.id)
        case .pending, .failed:
          onDeleteDeferredDocument(document)
        }
      }
      filteredDocsCallback: { filteredDocs in
        filteredDocsCallback(filteredDocs)
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
  }
}

#Preview {
  let viewState = DashboardState(
    isLoading: false,
    documents: DocumentUIModel.mocks(),
    filteredDocuments: DocumentUIModel.mocks(),
    username: "First name",
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
      addDocument: .constant(false),
      selectedTab: .constant(.home),
      onMore: {},
      onDocumentDetails: { _ in },
      onDeleteDeferredDocument: { _ in },
      onAdd: {},
      onShare: {},
      signDocument: {},
      filteredDocsCallback: { _ in }
    )
  }
}
