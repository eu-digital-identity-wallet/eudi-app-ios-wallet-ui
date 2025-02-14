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
import logic_core
import logic_business
import logic_resources
import Combine

public enum DashboardPartialState: Sendable {
  case success(String, FilterableList, Bool)
  case failure(Error)
}

public enum DashboardDeleteDeferredPartialState: Sendable {
  case success
  case noDocuments
  case failure(Error)
}

public enum FiltersPartialState: Sendable {
  case filterApplyResult([DocumentCategory: [DocumentUIModel]], [FilterUISection], Bool)
  case filterUpdateResult([FilterUISection])
  case cancelled
}

public enum DashboardDeferredPartialState: Sendable {
  case completion(issued: [DocumentUIModel], failed: [String])
  case cancelled
}

public protocol DashboardInteractor: Sendable {
  func fetchDashboard(failedDocuments: [String]) async -> DashboardPartialState
  func getBleAvailability() async -> Reachability.BleAvailibity
  @MainActor func openBleSettings()
  func getAppVersion() -> String
  func hasIssuedDocuments() -> Bool
  func hasDeferredDocuments() -> Bool
  func deleteDeferredDocument(with id: String) async -> DashboardDeleteDeferredPartialState
  func requestDeferredIssuance() async -> DashboardDeferredPartialState
  func retrieveLogFileUrl() -> URL?
  @MainActor func onFilterChangeState() -> AsyncStream<FiltersPartialState>
  func initializeFilters(filterableList: FilterableList) async
  func applyFilters() async
  func resetFilters() async
  func revertFilters() async
  func applySearch(query: String) async
  func updateFilters(sectionID: String, filterID: String) async
  func fetchFilteredDocuments(failedDocuments: [String]) -> FilterableList?
  func updateLists(filterableList: FilterableList) async
  func updateSortOrder(sortOrder: SortOrderType)
  func createFiltersGroup() -> Filters
  func addDynamicFilters(documents: FilterableList, filters: Filters) async -> Filters
}

final class DashboardInteractorImpl: DashboardInteractor {

  private let walletController: WalletKitController
  private let filterValidator: FilterValidator
  private let reachabilityController: ReachabilityController
  private let configLogic: ConfigLogic

  private let sendableAnyCancellable: SendableAnyCancellable = .init()

  @MainActor
  private var filtersStateAsync: AsyncStream<FiltersPartialState>.Continuation?

  init(
    walletController: WalletKitController,
    filterValidator: FilterValidator,
    reachabilityController: ReachabilityController,
    configLogic: ConfigLogic
  ) {
    self.walletController = walletController
    self.filterValidator = filterValidator
    self.reachabilityController = reachabilityController
    self.configLogic = configLogic
  }

  deinit {
    sendableAnyCancellable.cancel()
    filtersStateAsync?.finish()
  }

  func hasIssuedDocuments() -> Bool {
    return !walletController.fetchIssuedDocuments().isEmpty
  }

  func hasDeferredDocuments() -> Bool {
    return !walletController.fetchDeferredDocuments().isEmpty
  }

  func onFilterChangeState() -> AsyncStream<FiltersPartialState> {
    return AsyncStream(bufferingPolicy: .bufferingNewest(1)) { continuation in
      self.filtersStateAsync = continuation
      Task {
        for try await state in filterValidator.getFilterResultStream() {
          switch state {
          case .success(let filterResult):
            switch filterResult {
            case .filterApplyResult(let filteredList, let updatedFilters, let hasDefaultFilters):
              let documentsUI = filteredList.items.compactMap { filterableItem in
                return filterableItem.payload as? DocumentUIModel
              }
              let documents = Dictionary(grouping: documentsUI, by: { $0.value.documentCategory })
              let filterSections = filterUISection(filters: updatedFilters)

              continuation.yield(.filterApplyResult(documents, filterSections, hasDefaultFilters))
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

  func createFiltersGroup() -> Filters {
    return Filters(
      filterGroups: [
        SingleSelectionFilterGroup(
          id: FilterIds.ASCENDING_DESCENDING_GROUP,
          name: LocalizableString.shared.get(with: .orderBy),
          filters: [
            FilterItem(
              id: FilterIds.ORDER_BY_ASCENDING,
              name: LocalizableString.shared.get(with: .ascending),
              selected: true,
              isDefault: true,
              filterableAction: Sort<DocumentFilterableAttributes, String>(predicate: { attribute in
                attribute.sortingKey
              })
            ),
            FilterItem(
              id: FilterIds.ORDER_BY_DESCENDING,
              name: LocalizableString.shared.get(with: .descending),
              selected: false,
              filterableAction: Sort<DocumentFilterableAttributes, String>(predicate: { attribute in
                attribute.sortingKey
              })
            )
          ],
          filterType: .orderBy
        ),
        SingleSelectionFilterGroup(
          id: FilterIds.FILTER_SORT_GROUP_ID,
          name: LocalizableString.shared.get(with: .sortBy),
          filters: [
            FilterItem(
              id: FilterIds.FILTER_SORT_DEFAULT,
              name: LocalizableString.shared.get(with: .defaultLabel),
              selected: true,
              isDefault: true,
              filterableAction: Sort<DocumentFilterableAttributes, String>(predicate: { attribute in
                attribute.sortingKey
              })
            ),
            FilterItem(
              id: FilterIds.FILTER_SORT_DATE_ISSUED,
              name: LocalizableString.shared.get(with: .dateIssued),
              selected: false,
              filterableAction: Sort<DocumentFilterableAttributes, Date>(predicate: { attribute in
                attribute.issuedDate
              })
            ),
            FilterItem(
              id: FilterIds.FILTER_SORT_EXPIRY_DATE,
              name: LocalizableString.shared.get(with: .expiryDate),
              selected: false,
              filterableAction: Sort<DocumentFilterableAttributes, Date>(predicate: { attribute in
                attribute.expiryDate
              })
            )
          ],
          filterType: .other
        ),
        SingleSelectionFilterGroup(
          id: FilterIds.FILTER_BY_PERIOD_GROUP_ID,
          name: LocalizableString.shared.get(with: .selectExpiryPeriod),
          filters: [
            FilterItem(
              id: FilterIds.FILTER_BY_PERIOD_DEFAULT,
              name: LocalizableString.shared.get(with: .defaultLabel),
              selected: true,
              isDefault: true,
              filterableAction: Filter<DocumentFilterableAttributes>(predicate: { _, _ in
                return true
              })
            ),
            FilterItem(
              id: FilterIds.FILTER_BY_PERIOD_NEXT_7,
              name: LocalizableString.shared.get(with: .nextSevenDays),
              selected: false,
              filterableAction: Filter<DocumentFilterableAttributes>(predicate: { attributes, _ in
                guard let date = attributes.expiryDate else { return false }
                return date.isWithinNextDays(7)
              })
            ),
            FilterItem(
              id: FilterIds.FILTER_BY_PERIOD_NEXT_30,
              name: LocalizableString.shared.get(with: .nextThirtyDays),
              selected: false,
              filterableAction: Filter<DocumentFilterableAttributes>(predicate: { attributes, _ in
                guard let date = attributes.expiryDate else { return false }
                return date.isWithinNextDays(30)
              })
            ),
            FilterItem(
              id: FilterIds.FILTER_BY_PERIOD_BEYOND_30,
              name: LocalizableString.shared.get(with: .beyondThiryDays),
              selected: false,
              filterableAction: Filter<DocumentFilterableAttributes>(predicate: { attributes, _ in
                guard let date = attributes.expiryDate else { return false }
                return date.isBeyondNextDays(30)
              })
            ),
            FilterItem(
              id: FilterIds.FILTER_BY_PERIOD_EXPIRED,
              name: LocalizableString.shared.get(with: .beforeToday),
              selected: false,
              filterableAction: Filter<DocumentFilterableAttributes>(predicate: { attributes, _ in
                guard let date = attributes.expiryDate else { return false }
                return date.isBeforeToday()
              })
            )
          ],
          filterType: .other
        ),
        MultipleSelectionFilterGroup(
          id: FilterIds.FILTER_BY_ISSUER_GROUP_ID,
          name: LocalizableString.shared.get(with: .filterByIssuer),
          filters: [],
          filterableAction: Filter<DocumentFilterableAttributes>(predicate: { attribute, filter in
            attribute.name == filter.name
          }),
          filterType: .issuer
        ),
        MultipleSelectionFilterGroup(
          id: FilterIds.FILTER_BY_DOCUMENT_CATEGORY_GROUP_ID,
          name: LocalizableString.shared.get(with: .filterByCategory),
          filters: [],
          filterableAction: FilterMultipleAction<DocumentFilterableAttributes>(predicate: { attribute, filter in
            attribute.category == filter.name
          }),
          filterType: .documentCategory
        ),
        MultipleSelectionFilterGroup(
          id: FilterIds.FILTER_BY_STATE_GROUP_ID,
          name: LocalizableString.shared.get(with: .filterByState),
          filters: [
            FilterItem(
              id: FilterIds.FILTER_BY_STATE_VALID,
              name: LocalizableString.shared.get(with: .valid),
              selected: true,
              isDefault: true
            ),
            FilterItem(
              id: FilterIds.FILTER_BY_STATE_EXPIRED,
              name: LocalizableString.shared.get(with: .expired),
              selected: false,
              isDefault: false
            )
          ],
          filterableAction: FilterMultipleAction<DocumentFilterableAttributes>(predicate: { attribute, filter in
            switch filter.id {
            case FilterIds.FILTER_BY_STATE_VALID:
              attribute.expiryDate?.isValid() == true || attribute.expiryDate == nil
            case FilterIds.FILTER_BY_STATE_EXPIRED:
              attribute.expiryDate?.isExpired() == true
            default:
              true
            }
          }),
          filterType: .other
        )
      ],
      sortOrder: SortOrderType.ascending
    )
  }

  func addDynamicFilters(documents: FilterableList, filters: Filters) async -> Filters {
    let newFilterGroups: [FilterGroup] = filters.filterGroups.map { filterGroup in
      if let multipleGroup = filterGroup as? MultipleSelectionFilterGroup {
          switch multipleGroup.filterType {
          case .issuer:
              return multipleGroup.copy(filters: addIssuerFilter(documents: documents)) as any FilterGroup
          case .documentCategory:
              return multipleGroup.copy(filters: addCategoriesFilter(documents: documents)) as any FilterGroup
          default:
              return multipleGroup as any FilterGroup
          }
      }

      return filterGroup
    }

    return filters.copy(filterGroups: newFilterGroups)
  }

  func initializeFilters(filterableList: FilterableList) async {
    let filtersGroup = createFiltersGroup()
    let filters = await addDynamicFilters(documents: filterableList, filters: filtersGroup)
    await filterValidator.initializeValidator(filters: filters, filterableList: filterableList)
  }

  func applyFilters() async {
    await filterValidator.applyFilters()
  }

  func applySearch(query: String) async {
    await filterValidator.applySearch(query: query)
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

  func updateSortOrder(sortOrder: SortOrderType) {
    Task {
      await filterValidator.updateSortOrder(sortOrder: sortOrder)
    }
  }

  func fetchDashboard(failedDocuments: [String]) async -> DashboardPartialState {

    let documents: FilterableList? = fetchFilteredDocuments(failedDocuments: failedDocuments)
    let username = fetchUsername()

    guard let documents = documents else {
      return .failure(WalletCoreError.unableFetchDocuments)
    }

    return .success(username, documents, hasIssuedDocuments())
  }

  func getBleAvailability() async -> Reachability.BleAvailibity {
    return await withCheckedContinuation { cont in
      reachabilityController.getBleAvailibity()
        .sink { cont.resume(returning: $0)}
        .store(in: &sendableAnyCancellable.cancellables)
    }
  }

  func openBleSettings() {
    reachabilityController.openBleSettings()
  }

  func getAppVersion() -> String {
    return configLogic.appVersion
  }

  func deleteDeferredDocument(with id: String) async -> DashboardDeleteDeferredPartialState {
    do {
      try await walletController.deleteDocument(with: id, status: .deferred)
      return walletController.fetchAllDocuments().isEmpty ? .noDocuments : .success
    } catch {
      return .failure(error)
    }
  }

  func requestDeferredIssuance() async -> DashboardDeferredPartialState {

    var issued: [DocumentUIModel] = []
    var failed: [String] = []

    let categories = self.walletController.getDocumentCategories()

    for deferred in walletController.fetchDeferredDocuments() {

      if Task.isCancelled { return .cancelled }

      do {
        let document = try await walletController.requestDeferredIssuance(with: deferred)
        if (document is DeferrredDocument) == false {
          issued.append(document.transformToDocumentUi(categories: categories))
        }
      } catch {
        failed.append(deferred.id)
      }
    }

    return .completion(issued: issued, failed: failed)
  }

  func retrieveLogFileUrl() -> URL? {
    return walletController.retrieveLogFileUrl()
  }

  public func fetchFilteredDocuments(failedDocuments: [String]) -> FilterableList? {
    let documents = self.walletController.fetchAllDocuments()

    guard !documents.isEmpty else {
      return nil
    }

    let filterableItems = documents.map { document in

      let documentPayload = document.transformToDocumentUi(categories: self.walletController.getDocumentCategories())

      let documentSearchTags: [String] = {
        var tags = [document.displayName ?? ""]
        let issuerName = document.issuerName.trimmingCharacters(in: .whitespacesAndNewlines)
        if !issuerName.isEmpty {
          tags.append(issuerName)
        }
          return tags
      }()

      return FilterableItem(
        payload: documentPayload,
        attributes: DocumentFilterableAttributes(
          sortingKey: document.displayName?.lowercased() ?? "",
          searchTags: documentSearchTags,
          issuedDate: document.createdAt,
          expiryDate: document.validUntil,
          issuer: document.issuerName,
          name: document.displayName,
          category: documentPayload.value.documentCategory.filterAttribute.capitalizedFirst()
        )
      )
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
            filterAction: filter.filterableAction
          )
        },
        sectionTitle: filteredGroup.name
      )
    }
  }

  private func addCategoriesFilter(documents: FilterableList) -> [FilterItem] {
    let distinctCategories = documents.items.compactMap {
      ($0.attributes as? DocumentFilterableAttributes)?.category
    }.reduce(into: [String]()) { unique, element in
      if !unique.contains(element) {
        unique.append(element)
      }
    }

    let filterItems = distinctCategories.map { category in
      return FilterItem(
        id: UUID().uuidString,
        name: category,
        selected: true,
        isDefault: true
      )
    }

    return filterItems
  }

  private func addIssuerFilter(documents: FilterableList) -> [FilterItem] {
    let distinctIssuers = documents.items.compactMap {
      ($0.attributes as? DocumentFilterableAttributes)?.issuer
    }.reduce(into: [String]()) { unique, element in
      if !unique.contains(element) {
        unique.append(element)
      }
    }

    let filterItems = distinctIssuers.map { issuer in
      return FilterItem(
        id: UUID().uuidString,
        name: issuer,
        selected: true,
        isDefault: true,
        filterableAction: Filter<DocumentFilterableAttributes>(predicate: { attributes, filter in
          attributes.issuer == filter.name
        })
      )
    }

    return filterItems
  }

  private func fetchUsername() -> String {
    let name = walletController.fetchMainPidDocument()?.getBearersName()?.first
    return name.orEmpty
  }
}
