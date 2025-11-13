/*
 * Copyright (c) 2025 European Commission
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
    content(
      state: viewModel.viewState,
      searchQuery: $viewModel.searchQuery,
      onAction: { item in
        switch item.value.state {
        case .issued, .revoked:
          viewModel.onDocumentDetails(documentId: item.value.id)
        case .pending, .failed:
          viewModel.onDeleteDeferredDocument(with: item)
        }
      }
    )
    .sheet(isPresented: $viewModel.isFilterModalShowing) {
      FiltersListView(sections: viewModel.viewState.filterUIModel) {
        viewModel.resetFilters()
      } applyFiltersAction: {
        viewModel.fetch()
      } revertFilters: {
        viewModel.revertFilters()
      }
      updateFiltersCallback: { sectionID, filterID in
        viewModel.updateFilters(sectionID: sectionID, filterID: filterID)
      }
    }
    .dialogCompat(
      .issuanceDetailsDeletionTitle([viewModel.viewState.pendingDocumentTitle]),
      isPresented: $viewModel.isDeleteDeferredModalShowing,
      actions: {
        Button(.no, role: .cancel) {}
        Button(.yes, role: .destructive) {
          viewModel.deleteDeferredDocument()
        }
      },
      message: {
        Text(.issuanceDetailsDeletionCaption([viewModel.viewState.pendingDocumentTitle]))
      }
    )
    .sheetDialog(isPresented: $viewModel.isSuccededDocumentsModalShowing) {
      VStack(spacing: .zero) {

        ContentTitleView(
          title: .deferredDocumentsIssuedModalTitle,
          caption: .defferedDocumentsIssuedModalCaption
        )

        deferredSuccessList(
          state: viewModel.viewState,
          onDocumentDetails: {
            viewModel.onDocumentDetails(documentId: $0)
          }
        )
      }
    }
    .onChange(of: scenePhase) {
      viewModel.setPhase(with: scenePhase)
    }
    .onAppear {
      viewModel.onCreate()
    }
    .onDisappear {
      viewModel.onPause()
    }
    .onReceive(NotificationCenter.default.publisher(for: NSNotification.RevocationDocumentTabRefresh)) { _ in
      viewModel.handleRevocationNotification()
    }
  }
}

@MainActor
@ViewBuilder
private func content(
  state: DocumentTabState,
  searchQuery: Binding<String>,
  onAction: @escaping (DocumentTabUIModel) -> Void
) -> some View {
  VStack {
    if state.documents.isEmpty && !searchQuery.wrappedValue.isEmpty {
      ContentUnavailableView(
        title: .noResults,
        description: .noResultsDocumentsDescription
      )
    } else if !state.documents.isEmpty {

      ScrollView {
        LazyVStack(alignment: .leading, spacing: .zero) {

          ForEach(state.documents.keys.sorted(by: { $0.order < $1.order }), id: \.self) { category in

            WrapTextView(
              text: category.title,
              textConfig: TextConfig(
                font: Theme.shared.font.bodySmall.font,
                color: Theme.shared.color.onSurface,
                textAlign: .leading,
                fontWeight: .semibold
              )
            )
            .padding(.horizontal, SPACING_MEDIUM)
            .padding(.top, SPACING_SMALL)

            ForEach(state.documents[category] ?? []) { item in
              WrapCardView {
                WrapListItemView(listItem: item.listItem) {
                  onAction(item)
                }
              }
              .padding(.horizontal, SPACING_MEDIUM)
              .padding(.top, SPACING_SMALL)
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
    searchText: searchQuery,
    placeholder: .searchDocuments,
    backgroundColor: Theme.shared.color.background
  )
  .background(Theme.shared.color.background)
}

@MainActor
@ViewBuilder
private func deferredSuccessList(
  state: DocumentTabState,
  onDocumentDetails: @escaping (String) -> Void
) -> some View {
  VStack(spacing: SPACING_SMALL) {
    ForEach(state.succededIssuedDocuments) { item in

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
      .background(Theme.shared.color.surfaceContainer)
      .clipShape(.rect(cornerRadius: 8))
      .onTapGesture {
        onDocumentDetails(item.value.id)
      }
    }
  }
  .padding(.vertical)
}

#Preview {
  let state = DocumentTabState(
    isLoading: false,
    documents: [:],
    filterUIModel: [],
    phase: .active,
    pendingDeletionDocument: nil,
    succededIssuedDocuments: [],
    failedDocuments: [],
    isPaused: false,
    hasDefaultFilters: false
  )
  content(
    state: state,
    searchQuery: .constant(""),
    onAction: { _ in }
  )
}
