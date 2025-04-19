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
import logic_resources
import logic_ui
import logic_core

struct DocumentTabView<Router: RouterHost>: View {

  @Environment(\.scenePhase) private var scenePhase

  @ObservedObject private var viewModel: DocumentTabViewModel<Router>

  public init(with viewModel: DocumentTabViewModel<Router>) {
    self.viewModel = viewModel
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
    .confirmationDialog(
      .issuanceDetailsDeletionTitle([viewModel.viewState.pendingDocumentTitle]),
      isPresented: $viewModel.isDeleteDeferredModalShowing,
      titleVisibility: .visible
    ) {
      Button(.no, role: .cancel) {}
      Button(.yes) {
        viewModel.deleteDeferredDocument()
      }
    } message: {
      Text(.issuanceDetailsDeletionCaption([viewModel.viewState.pendingDocumentTitle]))
    }
    .sheetDialog(isPresented: $viewModel.isSuccededDocumentsModalShowing) {
      SheetContentView {
        VStack(spacing: SPACING_MEDIUM) {

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
    }
    .onChange(of: scenePhase) { phase in
      viewModel.setPhase(with: phase)
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
  onAction: @escaping (DocumentUIModel) -> Void
) -> some View {
  VStack {
    if state.documents.isEmpty && !searchQuery.wrappedValue.isEmpty {
      contentUnavailableView()
    } else if !state.documents.isEmpty {
      List {
        ForEach(state.documents.keys.sorted(by: { $0.order < $1.order }), id: \.self) { category in
          Section(header: Text(category.title)) {
            ForEach(state.documents[category] ?? []) { item in
              WrapCardView {
                WrapListItemView(listItem: item.listItem) {
                  onAction(item)
                }
              }
              .listRowSeparator(.hidden)
            }
            .listRowInsets(.init(
              top: SPACING_SMALL,
              leading: SPACING_MEDIUM,
              bottom: .zero,
              trailing: SPACING_MEDIUM)
            )
          }
        }
      }
      .shimmer(isLoading: state.isLoading)
      .listStyle(.plain)
      .scrollIndicators(.hidden)
      .clipped()
    } else if !state.isLoading {
      contentUnavailableView()
    } else {
      loader()
    }
  }
  .searchable(
    searchText: searchQuery,
    backgroundColor: Theme.shared.color.background,
    onSearchTextChange: { _ in }
  )
  .background(Theme.shared.color.background)
}

@MainActor
@ViewBuilder
private func loader() -> some View {
  Spacer()
  ContentLoaderView(showLoader: .constant(true))
  Spacer()
}

@MainActor
@ViewBuilder
private func contentUnavailableView() -> some View {
  VStack(spacing: SPACING_SMALL) {
    Text(.noResults)
      .typography(Theme.shared.font.titleLarge)
      .fontWeight(.bold)

    Text(.noResultsDescription)
      .typography(Theme.shared.font.bodyLarge)
      .foregroundStyle(Theme.shared.color.onSurface)
      .multilineTextAlignment(.center)
  }
  .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
  .padding(.top, SPACING_LARGE_MEDIUM)
  .padding(.horizontal, SPACING_MEDIUM)
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
