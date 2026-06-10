/*
 * Copyright (c) 2026 European Commission
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
import logic_resources
import logic_ui

struct DocumentTabView<Router: RouterHost>: View {

  @Environment(\.scenePhase) private var scenePhase

  @State private var viewModel: DocumentTabViewModel<Router>

  public init(with viewModel: DocumentTabViewModel<Router>) {
    self._viewModel = State(wrappedValue: viewModel)
  }

  var body: some View {
    DocumentTabViewContainer(
      state: viewModel.viewState,
      searchQuery: $viewModel.searchQuery,
      isFilterModalShowing: $viewModel.isFilterModalShowing,
      isDeleteDeferredModalShowing: $viewModel.isDeleteDeferredModalShowing,
      isSuccededDocumentsModalShowing: $viewModel.isSuccededDocumentsModalShowing,
      onAction: { item in
        switch item.value.state {
        case .issued, .revoked:
          viewModel.onDocumentDetails(documentId: item.value.id)
        case .pending, .failed:
          viewModel.onDeleteDeferredDocument(with: item)
        }
      },
      onDocumentDetails: { viewModel.onDocumentDetails(documentId: $0) },
      onResetFilters: viewModel.resetFilters,
      onApplyFilters: viewModel.fetch,
      onRevertFilters: viewModel.revertFilters,
      onUpdateFilters: { sectionID, filterID in
        viewModel.updateFilters(sectionID: sectionID, filterID: filterID)
      },
      onDeleteDeferredDocument: viewModel.deleteDeferredDocument
    )
    .onChange(of: scenePhase) {
      viewModel.setPhase(with: scenePhase)
    }
    .onAppear {
      viewModel.onAppear()
    }
    .onDisappear {
      viewModel.onDisappear()
    }
    .onReceive(NotificationCenter.default.publisher(for: NSNotification.DocumentTabRefresh)) { _ in
      viewModel.handleRefreshotification()
    }
  }
}

private struct DocumentTabViewContainer: View {

  let state: DocumentTabState
  @Binding var searchQuery: String
  @Binding var isFilterModalShowing: Bool
  @Binding var isDeleteDeferredModalShowing: Bool
  @Binding var isSuccededDocumentsModalShowing: Bool
  let onAction: (DocumentTabUIModel) -> Void
  let onDocumentDetails: (String) -> Void
  let onResetFilters: () -> Void
  let onApplyFilters: () -> Void
  let onRevertFilters: () -> Void
  let onUpdateFilters: (String, String) -> Void
  let onDeleteDeferredDocument: () -> Void

  var body: some View {
    content()
      .sheet(isPresented: $isFilterModalShowing) {
        FiltersListView(sections: state.filterUIModel) {
          onResetFilters()
        } applyFiltersAction: {
          onApplyFilters()
        } revertFilters: {
          onRevertFilters()
        }
        updateFiltersCallback: { sectionID, filterID in
          onUpdateFilters(sectionID, filterID)
        }
      }
      .dialogCompat(
        .issuanceDetailsDeletionTitle([state.pendingDocumentTitle]),
        isPresented: $isDeleteDeferredModalShowing,
        actions: {
          Button(.no, role: .cancel) {}
          Button(.yes, role: .destructive) {
            onDeleteDeferredDocument()
          }
        },
        message: {
          Text(.issuanceDetailsDeletionCaption([state.pendingDocumentTitle]))
        }
      )
      .sheetDialog(isPresented: $isSuccededDocumentsModalShowing) {
        VStack(spacing: .zero) {

          ContentTitleView(
            title: .deferredDocumentsIssuedModalTitle,
            caption: .defferedDocumentsIssuedModalCaption
          )

          deferredSuccessList()
        }
      }
  }

  @MainActor
  @ViewBuilder
  private func content() -> some View {
    VStack {
      if state.documents.isEmpty && !searchQuery.isEmpty {
        ContentUnavailableView(
          title: .noResults,
          description: .noResultsDocumentsDescription
        )
      } else if !state.documents.isEmpty {

        ScrollView {
          LazyVStack(alignment: .leading, spacing: .zero) {

            ForEach(state.documents.keys.sorted(by: { $0.order < $1.order }), id: \.self) { category in

              VStack(alignment: .leading, spacing: SPACING_SMALL) {

                WrapTextView(
                  text: category.title,
                  textConfig: TextConfig(
                    font: Theme.shared.font.bodySmall.font,
                    color: Theme.shared.color.secondaryLabel,
                    textAlign: .leading,
                    fontWeight: .semibold
                  )
                )
                .padding(.horizontal, SPACING_MEDIUM)
                .padding(.top, SPACING_SMALL)

                WrapCardView {
                  VStack(spacing: .zero) {
                    let categoryDocuments = state.documents[category] ?? []
                    WrapListItemsView(
                      listItems: categoryDocuments.map(\.listItem)
                    ) { listItem in
                      if let item = categoryDocuments.first(where: { $0.listItem.id == listItem.id }) {
                        onAction(item)
                      }
                    }
                  }
                }
                .padding(.horizontal, SPACING_MEDIUM)
              }
            }
          }
          .padding(.bottom, SPACING_MEDIUM)
        }
        .shimmer(isLoading: state.isLoading)
        .scrollIndicators(.hidden)

      } else if !state.isLoading {
        ContentUnavailableView(
          title: .noResults,
          description: .noResultsDocumentsDescription
        )
      } else {
        ContentLoaderView(showLoader: .constant(true))
          .frame(maxWidth: .infinity, maxHeight: .infinity)
      }
    }
    .searchable(
      searchText: $searchQuery,
      placeholder: .searchDocuments,
      backgroundColor: Theme.shared.color.background
    )
    .background(Theme.shared.color.background)
  }

  @MainActor
  @ViewBuilder
  private func deferredSuccessList() -> some View {
    VStack(spacing: SPACING_SMALL) {
      ForEach(state.succededIssuedDocuments) { item in

        HStack {
          Text(.custom(item.value.title))
            .typography(Theme.shared.font.bodyLarge)
            .foregroundColor(Theme.shared.color.primaryLabel)

          Spacer()

          Theme.shared.image.chevronRight
            .renderingMode(.template)
            .foregroundStyle(Theme.shared.color.accent)
        }
        .padding()
        .background(Theme.shared.color.groupedBackground)
        .clipShape(.rect(cornerRadius: 8))
        .onTapGesture {
          onDocumentDetails(item.value.id)
        }
      }
    }
    .padding(.vertical)
  }
}

#Preview {
  let state = DocumentTabState(
    isLoading: false,
    documents: [:],
    filterUIModel: [],
    lifecycle: .active,
    pendingDeletionDocument: nil,
    succededIssuedDocuments: [],
    failedDocuments: [],
    hasDefaultFilters: false
  )
  DocumentTabViewContainer(
    state: state,
    searchQuery: .constant(""),
    isFilterModalShowing: .constant(false),
    isDeleteDeferredModalShowing: .constant(false),
    isSuccededDocumentsModalShowing: .constant(false),
    onAction: { _ in },
    onDocumentDetails: { _ in },
    onResetFilters: {},
    onApplyFilters: {},
    onRevertFilters: {},
    onUpdateFilters: { _, _ in },
    onDeleteDeferredDocument: {}
  )
}
