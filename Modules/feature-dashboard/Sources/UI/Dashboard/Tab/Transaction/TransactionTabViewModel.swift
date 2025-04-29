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
import logic_ui
import logic_resources

@Copyable
struct TransactionTabState: ViewState {
  let isLoading: Bool
  let transactions: [TransactionCategory: [TransactionTabUIModel]]
  let filterUIModel: [FilterUISection]
  let isPaused: Bool
  let hasDefaultFilters: Bool
  let dateHasChanged: Bool
  let sortIsDescending: Bool
  let minStartDate: Date
  let maxEndDate: Date
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
        isPaused: true,
        hasDefaultFilters: true,
        dateHasChanged: false,
        sortIsDescending: false,
        minStartDate: Date(),
        maxEndDate: Date()
      )
    )

    onFiltersChangeState()
    subscribeToSearch()
  }

  func onCreate() {
    updateToolBar()
    fetch()
  }

  func fetch() {
    Task {

      do {
        let state = try await Task.detached {
          try await self.interactor.fetchTransactions()
        }.value

        switch state {
        case .success(let transactions, let minStartDate, let maxEndDate):

          if viewState.isPaused {
            await interactor.initializeFilters(
              filterableList: transactions,
              minStartDate: minStartDate,
              maxEndDate: maxEndDate
            )
          } else {
            await interactor.updateLists(
              filterableList: transactions,
              minStartDate: minStartDate,
              maxEndDate: maxEndDate
            )
          }

          await interactor.applyFilters()

          setState {
            $0.copy(
              isLoading: false,
              isPaused: false,
              minStartDate: minStartDate,
              maxEndDate: maxEndDate
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
      } catch {
        setState {
          $0.copy(
            isLoading: false,
            transactions: [:]
          )
        }
      }
    }
  }

  func showIndicator() {
    setState {
      $0.copy(
        dateHasChanged: true
      )
    }
  }

  func showFilters() {
    isFilterModalShowing = true
  }

  func resetFilters() {
    setState {
      $0.copy(
        dateHasChanged: false
      )
    }

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

  func onPause() {
    self.setState { $0.copy(isPaused: true) }
  }

  func updateDateFilters(
    sectionID: String,
    filterID: String,
    startDate: Date,
    endDate: Date
  ) {
    Task {
      await interactor.updateDateFilters(
        sectionID: sectionID,
        filterID: filterID,
        startDate: startDate,
        endDate: endDate
      )
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

  func onTransactionDetails(transactionId: String) {
    router.push(
      with: .featureDashboardModule(
        .transactionDetails(id: transactionId)
      )
    )
  }

  private func updateToolBar() {
    self.onUpdateToolbar(
      .init(
        trailingActions: [
          .init(
            image: Theme.shared.image.filterMenuIcon,
            hasIndicator: !viewState.hasDefaultFilters,
            disabled: viewState.filterUIModel.isEmpty
          ) {
            self.showFilters()
          }
        ],
        leadingActions: [
          .init(image: Theme.shared.image.menuIcon) {
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
              hasDefaultFilters: viewState.dateHasChanged ? false : hasDefaultFilters,
              sortIsDescending: sortIsDescending(filterSections)
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

  private func sortIsDescending(_ filterSections: [FilterUISection]) -> Bool {
    guard let firstFilter = filterSections.first?.filters.first else {
      return false
    }
    return firstFilter.selected
  }
}
