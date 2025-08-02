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
import logic_ui
import logic_resources

struct TransactionTabView<Router: RouterHost>: View {

  @ObservedObject private var viewModel: TransactionTabViewModel<Router>

  public init(with viewModel: TransactionTabViewModel<Router>) {
    self.viewModel = viewModel
  }

  var body: some View {
    content(
      state: viewModel.viewState,
      searchQuery: $viewModel.searchQuery,
      onAction: {
        viewModel.onTransactionDetails(transactionId: $0)
      }
    )
    .sheet(isPresented: $viewModel.isFilterModalShowing) {
      FiltersListView(
        sections: viewModel.viewState.filterUIModel,
        minStartDate: viewModel.viewState.minStartDate,
        maxEndDate: viewModel.viewState.maxEndDate
      ) {
        viewModel.resetFilters()
      } applyFiltersAction: {
        viewModel.fetch()
      } showIndicator: {
        viewModel.showIndicator()
      } revertFilters: {
        viewModel.revertFilters()
      }
      updateFiltersCallback: { sectionID, filterID in
        viewModel.updateFilters(sectionID: sectionID, filterID: filterID)
      }
      updateDateFiltersCallback: { sectionID, filterID, startDate, endDate in
        viewModel.updateDateFilters(sectionID: sectionID, filterID: filterID, startDate: startDate, endDate: endDate)
      }
    }
    .onAppear {
      viewModel.onCreate()
    }
    .onDisappear {
      viewModel.onPause()
    }
  }
}

@MainActor
@ViewBuilder
private func content(
  state: TransactionTabState,
  searchQuery: Binding<String>,
  onAction: @escaping (String) -> Void
) -> some View {
  VStack {
    if state.transactions.isEmpty && !searchQuery.wrappedValue.isEmpty {
      ContentUnavailableView(
        title: .noResults,
        description: .noResultsTransactionsDescription
      )
    } else if !state.transactions.isEmpty {
      List {
        ForEach(state.transactions.keys.sorted(by: { state.sortIsDescending ? $0.order < $1.order : $0.order > $1.order }), id: \.self) { category in
          Section(header: Text(category.title)) {
            WrapCardView {
              VStack(spacing: .zero) {
                WrapListItemsView(
                  listItems: state.transactions[category]?.map({ transaction in
                    transaction.listItem
                  }) ?? []
                ) { item in
                  onAction(item.id)
                }
              }
            }
            .listRowBackground(Theme.shared.color.background)
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
      .shimmer(isLoading: state.isLoading)
      .listStyle(.plain)
      .scrollContentBackground(.hidden)
      .scrollIndicators(.hidden)
      .clipped()
    } else if !state.isLoading {
      ContentUnavailableView(
        title: .noResults,
        description: .noResultsTransactionsDescription
      )
    } else {
      ContentLoaderView(showLoader: .constant(true))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
  }
  .searchable(
    searchText: searchQuery,
    placeholder: .searchTransactions,
    backgroundColor: Theme.shared.color.background
  )
  .background(Theme.shared.color.background)
}

#Preview {
  let state = TransactionTabState(
    isLoading: false,
    transactions: [:],
    filterUIModel: [],
    isPaused: false,
    hasDefaultFilters: false,
    dateHasChanged: false,
    sortIsDescending: true,
    minStartDate: Date(),
    maxEndDate: Date()
  )
  content(
    state: state,
    searchQuery: .constant(""),
    onAction: { _ in }
  )
}
