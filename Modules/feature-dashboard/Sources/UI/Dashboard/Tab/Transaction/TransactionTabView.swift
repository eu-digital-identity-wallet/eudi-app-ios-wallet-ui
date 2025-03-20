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
        viewModel.onTransactionDetails()
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
    .onAppear {
      viewModel.onCreate()
    }
  }
}

@MainActor
@ViewBuilder
private func content(
  state: TransactionTabState,
  searchQuery: Binding<String>,
  onAction: @escaping () -> Void
) -> some View {
  VStack {
    if state.transactions.isEmpty && !searchQuery.wrappedValue.isEmpty {
      ContentUnavailableView(
        title: .noResults,
        description: .noResultsDescription
      )
    } else if !state.transactions.isEmpty {
      let monthCategories = state.transactions.keys.filter { if case .month = $0 { return true } else { return false } }
      let nonMonthCategories = state.transactions.keys.filter { if case .month = $0 { return false } else { return true } }

      let sortedMonthCategories = monthCategories.sorted { $0.order > $1.order }

      List {
        ForEach(nonMonthCategories.sorted(by: { $0.order < $1.order }), id: \.self) { category in
          Section(header: Text(category.title)) {
            WrapCardView {
              VStack(spacing: .zero) {
                WrapListItemsView(
                  listItems: state.transactions[category]?.map({ transaction in
                    transaction.listItem
                  }) ?? []
                ) { _ in
                  onAction()
                }
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

        ForEach(sortedMonthCategories, id: \.self) { category in
          Section(header: Text(category.title)) {
            WrapCardView {
              VStack(spacing: .zero) {
                WrapListItemsView(
                  listItems: state.transactions[category]?.map({ transaction in
                    transaction.listItem
                  }) ?? []
                ) { _ in
                  onAction()
                }
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
      .shimmer(isLoading: state.isLoading)
      .listStyle(.plain)
      .scrollIndicators(.hidden)
      .clipped()
    } else if !state.isLoading {
      ContentUnavailableView(
        title: .noResults,
        description: .noResultsDescription
      )
    } else {
      ContentLoaderView(showLoader: .constant(true))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
  }
  .searchable(
    searchText: searchQuery,
    backgroundColor: Theme.shared.color.background,
    onSearchTextChange: { _ in }
  )
  .background(Theme.shared.color.background)
}

#Preview {
  let state = TransactionTabState(
    isLoading: false,
    transactions: [:],
    filterUIModel: [],
    failedTransactions: [],
    isFromOnPause: false,
    hasDefaultFilters: false
  )
  content(
    state: state,
    searchQuery: .constant(""),
    onAction: {}
  )
}
