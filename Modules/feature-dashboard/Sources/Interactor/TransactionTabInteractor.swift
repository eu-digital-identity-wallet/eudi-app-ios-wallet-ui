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
import logic_core
import logic_business
import logic_resources

public enum TransactionsPartialState: Sendable {
  case success(FilterableList)
  case failure(Error)
}

public enum TransactionFiltersPartialState: Sendable {
  case filterApplyResult([TransactionCategory: [TransactionUIModel]], [FilterUISection], Bool)
  case filterUpdateResult([FilterUISection])
  case cancelled
}

public protocol TransactionTabInteractor: Sendable {
  func fetchTransactions(failedTransactions: [String]) async -> TransactionsPartialState
  func fetchFilteredTransactions(failedTransactions: [String]) async -> FilterableList?
  func initializeFilters(filterableList: FilterableList) async
  func createFiltersGroup() -> Filters
  func applyFilters() async
  func updateLists(filterableList: FilterableList) async
  @MainActor func onFilterChangeState() -> AsyncStream<TransactionFiltersPartialState>
  func resetFilters() async
  func revertFilters() async
  func updateFilters(sectionID: String, filterID: String)  async
  func applySearch(query: String) async
}

final class TransactionTabInteractorImpl: TransactionTabInteractor {

  private let filterValidator: FilterValidator

  @MainActor
  private var filtersStateAsync: AsyncStream<TransactionFiltersPartialState>.Continuation?

  init(
    filterValidator: FilterValidator
  ) {
    self.filterValidator = filterValidator
  }

  deinit {
    filtersStateAsync?.finish()
  }

  func fetchTransactions(failedTransactions: [String]) async -> TransactionsPartialState {

    let transactions: FilterableList? = fetchFilteredTransactions(failedTransactions: failedTransactions)

    guard let transactions = transactions else {
      return .failure(WalletCoreError.unableFetchDocuments)
    }

    return .success(transactions)
  }

  public func fetchFilteredTransactions(failedTransactions: [String]) -> FilterableList? {

    let transactions = TransactionUIModel.mocks()

    guard !transactions.isEmpty else {
      return nil
    }

    let filterableItems = transactions.flatMap { (_, models) in
      models.map { transaction in
        let transactionSearchTags: [String] = {
          var tags = [transaction.name]
          let transactionName = transaction.name.trimmingCharacters(in: .whitespacesAndNewlines)
          if !transactionName.isEmpty {
            tags.append(transactionName)
          }
          return tags
        }()

        return FilterableItem(
          payload: transaction,
          attributes: TransactionFilterableAttributes(
            sortingKey: transaction.transactionDate,
            searchTags: transactionSearchTags,
            name: transaction.name,
            status: transaction.status,
            startDate: transaction.transactionDate,
            endDate: transaction.transactionDate
          )
        )
      }
    }

    return FilterableList(items: filterableItems)
  }

  func initializeFilters(filterableList: FilterableList) async {
    let filtersGroup = createFiltersGroup()
    await filterValidator.initializeValidator(filters: filtersGroup, filterableList: filterableList)
  }

  func createFiltersGroup() -> Filters {
    return Filters(
      filterGroups: [
        SingleSelectionFilterGroup(
          id: FilterIds.ASCENDING_DESCENDING_GROUP,
          name: LocalizableStringKey.orderBy.toString,
          filters: [
            FilterItem(
              id: FilterIds.ORDER_BY_ASCENDING,
              name: LocalizableStringKey.ascending.toString,
              selected: false,
              filterableAction: Sort<TransactionFilterableAttributes, String>(predicate: { attribute in
                attribute.sortingKey
              })
            ),
            FilterItem(
              id: FilterIds.ORDER_BY_DESCENDING,
              name: LocalizableStringKey.descending.toString,
              selected: true,
              isDefault: true,
              filterableAction: Sort<TransactionFilterableAttributes, String>(predicate: { attribute in
                attribute.sortingKey
              })
            )
          ],
          filterType: .orderBy
        ),
        MultipleSelectionFilterGroup(
          id: FilterIds.FILTER_BY_DATE,
          name: LocalizableStringKey.filterByDate.toString,
          filters: [
            FilterItem(
              id: FilterIds.FILTER_BY_START_DATE,
              name: LocalizableStringKey.startDate.toString,
              selected: false,
              isDefault: false,
              filterElementType: .picker,
              dateRangeType: .start
            ),
            FilterItem(
              id: FilterIds.FILTER_BY_END_DATE,
              name: LocalizableStringKey.endDate.toString,
              selected: false,
              isDefault: false,
              filterElementType: .picker,
              dateRangeType: .end
            )
          ],
          filterableAction: FilterMultipleAction<TransactionFilterableAttributes>(predicate: { attribute, _ in
            print("Start Date: \(attribute.startDate)")
            print("End Date: \(attribute.endDate)")
            return true
          }),
          filterType: .other
        ),
        MultipleSelectionFilterGroup(
          id: FilterIds.FILTER_BY_STATUS_ID,
          name: LocalizableStringKey.filterByStatus.toString,
          filters: [
            FilterItem(
              id: FilterIds.FILTER_BY_STATUS_COMPLETED,
              name: LocalizableStringKey.completed.toString,
              selected: true,
              isDefault: true
            ),
            FilterItem(
              id: FilterIds.FILTER_BY_STATUS_FAILED,
              name: LocalizableStringKey.failed.toString,
              selected: true,
              isDefault: true
            )
          ],
          filterableAction: FilterMultipleAction<TransactionFilterableAttributes>(predicate: { attribute, filter in
            switch filter.id {
            case FilterIds.FILTER_BY_STATUS_COMPLETED:
              attribute.status == .completed
            case FilterIds.FILTER_BY_STATUS_FAILED:
              attribute.status == .failed
            default:
              true
            }
          }),
          filterType: .other
        )
      ],
      sortOrder: SortOrderType.descending
    )
  }

  func applyFilters() async {
    await filterValidator.applyFilters(sortOrder: .descending)
  }

  func resetFilters() async {
    await filterValidator.resetFilters()
  }

  func revertFilters() async {
    await filterValidator.revertFilters()
  }

  func updateFilters(sectionID: String, filterID: String)  async {
    await filterValidator.updateFilter(filterGroupId: sectionID, filterId: filterID)
  }

  func updateLists(filterableList: FilterableList) async {
    let sortOrder = createFiltersGroup().sortOrder
    await filterValidator.updateLists(sortOrder: sortOrder, filterableList: filterableList)
  }

  func applySearch(query: String) async {
    await filterValidator.applySearch(query: query)
  }

  func onFilterChangeState() -> AsyncStream<TransactionFiltersPartialState> {
    return AsyncStream(bufferingPolicy: .bufferingNewest(1)) { continuation in
      self.filtersStateAsync = continuation
      Task {
        for try await state in filterValidator.getFilterResultStream() {
          switch state {
          case .success(let filterResult):
            switch filterResult {
            case .filterApplyResult(let filteredList, let updatedFilters, let hasDefaultFilters):
              let transactionsUI = filteredList.items.compactMap { filterableItem in
                return filterableItem.payload as? TransactionUIModel
              }
              let transactions = Dictionary(grouping: transactionsUI, by: { $0.transactionCategory })

              let filterSections = filterUISection(filters: updatedFilters)

              continuation.yield(.filterApplyResult(transactions, filterSections, hasDefaultFilters))
            case .filterUpdateResult(let updatedFilters):
              let filterSections = filterUISection(filters: updatedFilters)
              continuation.yield(.filterUpdateResult(filterSections))
            }
          case .completion:
            continuation.yield(.cancelled)
            continuation.finish()
          }
        }
      }
    }
  }

  private func filterUISection(filters: Filters) -> [FilterUISection] {
    filters.filterGroups.map { filteredGroup in
      FilterUISection(
        id: filteredGroup.id,
        filters: filteredGroup.filters.map { filter in
          FilterUIItem(
            id: filter.id,
            title: filter.name,
            selected: filter.selected,
            filterAction: filter.filterableAction,
            filterSectionType: filter.filterElementType,
            dateRangeType: filter.dateRangeType
          )
        },
        sectionTitle: filteredGroup.name
      )
    }
  }
}
