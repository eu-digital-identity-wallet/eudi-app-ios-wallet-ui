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
import Foundation
import logic_core
import logic_business
import logic_resources

public enum TransactionsPartialState: Sendable {
  case success(
    filterableList: FilterableList,
    minStartDate: Date,
    maxEndDate: Date
  )
  case failure(Error)
}

public enum TransactionFiltersPartialState: Sendable {
  case filterApplyResult([TransactionCategory: [TransactionTabUIModel]], [FilterUISection], Bool)
  case filterUpdateResult([FilterUISection])
  case cancelled
}

public protocol TransactionTabInteractor: Sendable {
  func fetchTransactions() async throws -> TransactionsPartialState
  func initializeFilters(
    filterableList: FilterableList,
    minStartDate: Date,
    maxEndDate: Date
  ) async
  func applyFilters() async
  func updateLists(
    filterableList: FilterableList,
    minStartDate: Date,
    maxEndDate: Date
  ) async
  func onFilterChangeState() async -> AsyncStream<TransactionFiltersPartialState>
  func resetFilters() async
  func revertFilters() async
  func updateFilters(sectionID: String, filterID: String)  async
  func updateDateFilters(sectionID: String, filterID: String, startDate: Date, endDate: Date)  async
  func applySearch(query: String) async
}

final actor TransactionTabInteractorImpl: TransactionTabInteractor {

  private let walletKitController: WalletKitController
  private let filterValidator: FilterValidator

  private var filtersStateAsync: AsyncStream<TransactionFiltersPartialState>.Continuation?

  init(
    walletKitController: WalletKitController,
    filterValidator: FilterValidator
  ) {
    self.walletKitController = walletKitController
    self.filterValidator = filterValidator
  }

  deinit {
    filtersStateAsync?.finish()
  }

  func fetchTransactions() async throws -> TransactionsPartialState {

    let transactions: FilterableList? = try await fetchFilteredTransactions()

    guard let transactions = transactions else {
      return .failure(WalletCoreError.unableToFetchTransactionLog)
    }

    return .success(
      filterableList: transactions,
      minStartDate: getEarliestTransactionDate(from: transactions),
      maxEndDate: getLatestTransactionDate(from: transactions)
    )
  }

  func initializeFilters(
    filterableList: FilterableList,
    minStartDate: Date,
    maxEndDate: Date
  ) async {
    let filtersGroup = createFiltersGroup(
      earliestDate: minStartDate,
      latestDate: maxEndDate
    )
    let filters = addDynamicFilters(transactions: filterableList, filters: filtersGroup)
    await filterValidator.initializeValidator(filters: filters, filterableList: filterableList)
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

  func updateDateFilters(
    sectionID: String,
    filterID: String,
    startDate: Date,
    endDate: Date
  )  async {
    await filterValidator.updateDateFilters(filterGroupId: sectionID, filterId: filterID, startDate: startDate, endDate: endDate)
  }

  func updateLists(
    filterableList: FilterableList,
    minStartDate: Date,
    maxEndDate: Date
  ) async {
    let sortOrder = createFiltersGroup(
      earliestDate: minStartDate,
      latestDate: maxEndDate
    ).sortOrder
    await filterValidator.updateLists(sortOrder: sortOrder, filterableList: filterableList)
  }

  func applySearch(query: String) async {
    await filterValidator.applySearch(query: query)
  }

  func addDynamicFilters(transactions: FilterableList, filters: Filters) -> Filters {
    let newFilterGroups: [FilterGroup] = filters.filterGroups.map { filterGroup in
      if let multipleGroup = filterGroup as? MultipleSelectionFilterGroup {
        switch multipleGroup.filterType {
        case .relyingParty:
          return multipleGroup.copy(filters: addRelyingPartyName(transactions: transactions)) as any FilterGroup
        default:
          return multipleGroup as any FilterGroup
        }
      }

      return filterGroup
    }

    return filters.copy(filterGroups: newFilterGroups)
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
                return filterableItem.payload as? TransactionTabUIModel
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

  private func createFiltersGroup(earliestDate: Date, latestDate: Date) -> Filters {
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
              filterableAction: Sort<TransactionFilterableAttributes, Date>(predicate: { attribute in
                attribute.creationDate
              })
            ),
            FilterItem(
              id: FilterIds.ORDER_BY_DESCENDING,
              name: LocalizableStringKey.descending.toString,
              selected: true,
              isDefault: true,
              filterableAction: Sort<TransactionFilterableAttributes, Date>(predicate: { attribute in
                attribute.creationDate
              })
            )
          ],
          filterType: .orderBy
        ),
        SingleSelectionFilterGroup(
          id: FilterIds.FILTER_SORT_GROUP_ID,
          name: LocalizableStringKey.sortBy.toString,
          filters: [
            FilterItem(
              id: FilterIds.ORDER_BY_DESCENDING,
              name: LocalizableStringKey.transactionDate.toString,
              selected: true,
              isDefault: true,
              filterableAction: Sort<TransactionFilterableAttributes, Date>(predicate: { attribute in
                attribute.creationDate
              })
            )
          ],
          filterType: .orderBy
        ),
        SingleSelectionFilterGroup(
          id: FilterIds.FILTER_BY_TRANSACTION_DATE_GROUP_ID,
          name: LocalizableStringKey.filterByDate.toString,
          filters: [
            FilterItem(
              id: FilterIds.FILTER_BY_TRANSACTION_DATE_RANGE,
              name: LocalizableStringKey.defaultLabel.toString,
              selected: true,
              isDefault: true,
              startDate: earliestDate,
              endDate: latestDate,
              filterElementType: .datePicker,
              filterableAction: Filter<TransactionFilterableAttributes>(predicate: { attribute, filter in
                guard let creationDate = attribute.creationDate else { return false }
                return creationDate.isBetween(filter.startDate, filter.endDate) ?? true
              })
            )
          ],
          filterType: .dateRange
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
        ),
        MultipleSelectionFilterGroup(
          id: FilterIds.FILTER_BY_RELYING_PARY_NAME,
          name: LocalizableStringKey.relyingParty.toString,
          filters: [],
          filterableAction: FilterMultipleAction<TransactionFilterableAttributes>(predicate: { attribute, filter in
            if filter.id == FilterIds.FILTER_BY_RELYING_PARTY_NONE {
               return attribute.relyingPartyName == nil
            }

            if attribute.relyingPartyName != nil {
              return attribute.relyingPartyName == filter.name
            }

            return false
          }),
          filterType: .relyingParty
        ),
        MultipleSelectionFilterGroup(
          id: FilterIds.FILTER_BY_TYPE_ID,
          name: LocalizableStringKey.filterByType.toString,
          filters: [
            FilterItem(
              id: FilterIds.FILTER_BY_TYPE_PRESENTATION,
              name: LocalizableStringKey.presentation.toString,
              selected: true,
              isDefault: true
            ),
            FilterItem(
              id: FilterIds.FILTER_BY_TYPE_ISSUANCE,
              name: LocalizableStringKey.issuance.toString,
              selected: true,
              isDefault: true
            ),
            FilterItem(
              id: FilterIds.FILTER_BY_TYPE_SIGNING,
              name: LocalizableStringKey.signing.toString,
              selected: true,
              isDefault: true
            )
          ],
          filterableAction: FilterMultipleAction<TransactionFilterableAttributes>(predicate: { attribute, filter in
            switch filter.id {
            case FilterIds.FILTER_BY_TYPE_PRESENTATION:
              attribute.transactionType == .presentation
            case FilterIds.FILTER_BY_TYPE_SIGNING:
              attribute.transactionType == .signing
            case FilterIds.FILTER_BY_TYPE_ISSUANCE:
              attribute.transactionType == .issuance
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

  private func fetchFilteredTransactions() async throws -> FilterableList? {
    let transactions: [TransactionLogItem]

    do {
      transactions = try await self.walletKitController.fetchTransactionLogs()
    } catch {
      return nil
    }

    guard !transactions.isEmpty else {
      return nil
    }

    let filterableItems = transactions.map { transaction in

      let transactionPayload = transaction.transformToTransactionUI()

      switch transaction.transactionLogData {
      case .presentation(let logData):

        var tags = [logData.relyingParty.name]

        let relyingPartyTrimmed = logData.relyingParty.name.trimmingCharacters(in: .whitespacesAndNewlines)

        let credentials: [String] = logData.documents
          .compactMap(\.displayName)

        let credentialsTrimmed = credentials.map {
          $0.trimmingCharacters(in: .whitespacesAndNewlines)
        }

        if !relyingPartyTrimmed.isEmpty {
          tags.append(relyingPartyTrimmed)
        }
        if !credentials.isEmpty {
          tags.append(contentsOf: credentials)
        }
        if !credentialsTrimmed.isEmpty {
          tags.append(contentsOf: credentialsTrimmed)
        }
        return FilterableItem(
          payload: transactionPayload,
          attributes: TransactionFilterableAttributes(
            sortingKey: logData.relyingParty.name.lowercased(),
            searchTags: tags,
            status: logData.status.mapToTransactionStatus(),
            creationDate: logData.timestamp,
            relyingPartyName: logData.relyingParty.name,
            transactionType: .presentation
          )
        )
      case .issuance, .signing:
        return FilterableItem(
          payload: transactionPayload,
          attributes: TransactionFilterableAttributes(
            sortingKey: "",
            searchTags: []
          )
        )
      }
    }

    return FilterableList(items: filterableItems)
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
            startDate: filter.startDate,
            endDate: filter.endDate,
            filterAction: filter.filterableAction,
            filterSectionType: filter.filterElementType
          )
        },
        sectionTitle: filteredGroup.name
      )
    }
  }

  private func addRelyingPartyName(transactions: FilterableList) -> [FilterItem] {
    let distinctRelyingPartyNames = transactions.items.compactMap {
      ($0.attributes as? TransactionFilterableAttributes)?.relyingPartyName
    }.reduce(into: [String]()) { unique, element in
      if !unique.contains(element) {
        unique.append(element)
      }
    }

    let filterItems = distinctRelyingPartyNames.map { relyingPartyName in
      return FilterItem(
        id: relyingPartyName,
        name: relyingPartyName,
        selected: true,
        isDefault: true
      )
    }.sorted { $0.name < $1.name }

    return [
      FilterItem(
        id: FilterIds.FILTER_BY_RELYING_PARTY_NONE,
        name: LocalizableStringKey.withoutRelyingName.toString,
        selected: true,
        isDefault: true
      )
    ] + filterItems
  }

  private func getEarliestTransactionDate(from transactions: FilterableList) -> Date {
    return transactions.items
      .compactMap { ($0.attributes as? TransactionFilterableAttributes)?.creationDate }
      .min() ?? Date()
  }

  private func getLatestTransactionDate(from transactions: FilterableList) -> Date {
    return transactions.items
      .compactMap { ($0.attributes as? TransactionFilterableAttributes)?.creationDate }
      .map { Calendar.current.date(byAdding: .minute, value: 1, to: $0) ?? $0 }
      .max() ?? Date()
  }
}
