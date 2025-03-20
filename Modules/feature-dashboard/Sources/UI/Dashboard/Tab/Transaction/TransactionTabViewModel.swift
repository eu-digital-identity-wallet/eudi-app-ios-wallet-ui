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
import Foundation
import logic_ui
import logic_core
import logic_resources

@Copyable
struct TransactionTabState: ViewState {
  let isLoading: Bool
  let transactions: [TransactionCategory: [TransactionUIModel]]
  let filterUIModel: [FilterUISection]
  let failedTransactions: [String]
  let isFromOnPause: Bool
  let hasDefaultFilters: Bool
}

final class TransactionTabViewModel<Router: RouterHost>: ViewModel<Router, TransactionTabState> {

  private let interactor: TransactionTabInteractor
  private let onUpdateToolbar: (ToolBarContent, LocalizableStringKey) -> Void
  private let SEARCH_INPUT_DEBOUNCE = 250

  @Published var isFilterModalShowing: Bool = false
  @Published var searchQuery: String = ""

  init(
    router: Router,
    interactor: TransactionTabInteractor,
    onUpdateToolbar: @escaping (ToolBarContent, LocalizableStringKey) -> Void
  ) {
    self.interactor = interactor
    self.onUpdateToolbar = onUpdateToolbar
    super.init(
      router: router,
      initialState: .init(
        isLoading: true,
        transactions: [:],
        filterUIModel: [],
        failedTransactions: [],
        isFromOnPause: true,
        hasDefaultFilters: false
      )
    )

    onFiltersChangeState()
    subscribeToSearch()
  }

  func onCreate() {
    onUpdateToolbar(
      .init(
        trailingActions: nil,
        leadingActions: [
          Action(image: Theme.shared.image.menuIcon) {
            self.onMyWallet()
          }
        ]
      ),
      .transactions
    )

    fetch()
  }

  func fetch() {
    Task {
      let failedTrasnactions = viewState.failedTransactions

      let state = await Task.detached { () -> TransactionsPartialState in
        return await self.interactor.fetchTransactions(failedTransactions: failedTrasnactions)
      }.value

      switch state {
      case .success(let transactions):
        if viewState.isFromOnPause {
          await interactor.initializeFilters(filterableList: transactions)
        } else {
          await interactor.updateLists(filterableList: transactions)
        }

        await interactor.applyFilters()

        setState {
          $0.copy(
            isLoading: false,
            isFromOnPause: false
          )
        }
      case .failure:
        setState {
          $0.copy(
            isLoading: false,
            transactions: [:]
          )
        }
      }
    }
  }

  func showFilters() {
    isFilterModalShowing = true
  }

  func resetFilters() {
    Task {
      await interactor.resetFilters()
    }
  }

  func revertFilters() {
    Task {
      await interactor.revertFilters()
    }
  }

  func updateFilters(sectionID: String, filterID: String) {
    Task {
      await interactor.updateFilters(sectionID: sectionID, filterID: filterID)
    }
  }

  private func onMyWallet() {
    router.push(
      with: .featureDashboardModule(
        .sideMenu
      )
    )
  }

  private func subscribeToSearch() {
    $searchQuery
      .dropFirst()
      .debounce(for: .milliseconds(SEARCH_INPUT_DEBOUNCE), scheduler: RunLoop.main)
      .removeDuplicates()
      .sink { [weak self] query in
        guard let self = self else { return }
        Task {
          await self.interactor.applySearch(query: query)
        }
      }.store(in: &cancellables)
  }

  func onTransactionDetails() {
    router.push(
      with: .featureIssuanceModule(
        .transactionDetails
      )
    )
  }

  private func updateToolBar() {
    self.onUpdateToolbar(
      .init(
        trailingActions: [
          Action(
            image: Theme.shared.image.filterMenuIcon,
            hasIndicator: !viewState.hasDefaultFilters
          ) {
            self.showFilters()
          }
        ],
        leadingActions: [
          Action(image: Theme.shared.image.menuIcon) {
            self.onMyWallet()
          }
        ]
      ),
      .transactions
    )
  }

  private func onFiltersChangeState() {
    Task {
      for await state in interactor.onFilterChangeState() {
        switch state {

        case .filterApplyResult(let transactions, let filterSections, let hasDefaultFilters):
          setState {
            $0.copy(
              transactions: transactions,
              filterUIModel: filterSections,
              hasDefaultFilters: hasDefaultFilters
            )
          }
          updateToolBar()
        case .filterUpdateResult(let filterSections):
          setState {
            $0.copy(
              filterUIModel: filterSections
            )
          }
        case .cancelled: break
        }
      }
    }
  }
}
