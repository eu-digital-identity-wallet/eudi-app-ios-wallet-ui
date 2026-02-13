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

public enum DocumentsPartialState: Sendable {
  case success(FilterableList)
  case failure(Error)
}

public enum DeleteDeferredPartialState: Sendable, Equatable {
  case success
  case noDocuments
  case failure(Error)
}

extension DeleteDeferredPartialState {
  public static func == (lhs: DeleteDeferredPartialState, rhs: DeleteDeferredPartialState) -> Bool {
    switch (lhs, rhs) {
    case (.success, .success), (.noDocuments, .noDocuments):
      return true
    case let (.failure(lhsError), .failure(rhsError)):
      return lhsError.localizedDescription == rhsError.localizedDescription
    default:
      return false
    }
  }
}

public enum DocumentFiltersPartialState: Sendable {
  case filterApplyResult([DocumentCategory: [DocumentTabUIModel]], [FilterUISection], Bool)
  case filterUpdateResult([FilterUISection])
  case cancelled
}

public enum DeferredPartialState: Sendable {
  case completion(issued: [DocumentTabUIModel], failed: [String])
  case cancelled
}

public protocol DocumentTabInteractor: Sendable {
  func fetchDocuments(failedDocuments: [String]) async -> DocumentsPartialState
  func hasDeferredDocuments() async -> Bool
  func deleteDeferredDocument(with id: String) async -> DeleteDeferredPartialState
  func requestDeferredIssuance() async -> DeferredPartialState
  func onFilterChangeState() async -> AsyncStream<DocumentFiltersPartialState>
  func initializeFilters(filterableList: FilterableList) async
  func applyFilters() async
  func resetFilters() async
  func revertFilters() async
  func applySearch(query: String) async
  func updateFilters(sectionID: String, filterID: String) async
  func updateLists(filterableList: FilterableList) async
  func addDynamicFilters(documents: FilterableList, filters: Filters) async -> Filters
}

final actor DocumentTabInteractorImpl: DocumentTabInteractor {

  private let walletKitController: WalletKitController
  private let filterValidator: FilterValidator

  private var filtersStateAsync: AsyncStream<DocumentFiltersPartialState>.Continuation?

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

  func hasDeferredDocuments() async -> Bool {
    return await !walletKitController.fetchDeferredDocuments().isEmpty
  }

  func onFilterChangeState() -> AsyncStream<DocumentFiltersPartialState> {
    return AsyncStream(bufferingPolicy: .bufferingNewest(1)) { continuation in
      self.filtersStateAsync = continuation
      Task {
        for try await state in filterValidator.getFilterResultStream() {
          switch state {
          case .success(let filterResult):
            switch filterResult {
            case .filterApplyResult(let filteredList, let updatedFilters, let hasDefaultFilters):
              let documentsUI = filteredList.items.compactMap { filterableItem in
                return filterableItem.payload as? DocumentTabUIModel
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

  func addDynamicFilters(documents: FilterableList, filters: Filters) -> Filters {
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
    let filters = addDynamicFilters(documents: filterableList, filters: filtersGroup)
    await filterValidator.initializeValidator(filters: filters, filterableList: filterableList)
  }

  func applyFilters() async {
    await filterValidator.applyFilters(sortOrder: .ascending)
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

  func fetchDocuments(failedDocuments: [String]) async -> DocumentsPartialState {

    let documents = await fetchFilteredDocuments(failedDocuments: failedDocuments)

    guard let documents = documents else {
      return .failure(WalletCoreError.unableFetchDocuments)
    }

    return .success(documents)
  }

  func deleteDeferredDocument(with id: String) async -> DeleteDeferredPartialState {
    do {
      try await walletKitController.deleteDocument(with: id, status: .deferred)
      return await walletKitController.fetchAllDocuments().isEmpty ? .noDocuments : .success
    } catch {
      return .failure(error)
    }
  }

  func requestDeferredIssuance() async -> DeferredPartialState {

    var issued: [DocumentTabUIModel] = []
    var failed: [String] = []

    let categories = await self.walletKitController.getDocumentCategories()
    let revokedDocuments = try? await self.walletKitController.fetchRevokedDocuments()

    for deferred in await walletKitController.fetchDeferredDocuments() {

      if Task.isCancelled { return .cancelled }

      do {
        let document = try await walletKitController.requestDeferredIssuance(with: deferred)
        if (document is DeferrredDocument) == false {
          let isRevoked = revokedDocuments?.first { $0 == deferred.id } != nil
          issued.append(
            document.transformToDocumentTabUi(
              categories: categories,
              isRevoked: isRevoked
            )
          )
        }
      } catch {
        failed.append(deferred.id)
      }
    }

    return .completion(issued: issued, failed: failed)
  }

  private func createFiltersGroup() -> Filters {
    return Filters(
      filterGroups: [
        SingleSelectionFilterGroup(
          id: FilterIds.ASCENDING_DESCENDING_GROUP,
          name: LocalizableStringKey.orderBy.toString,
          filters: [
            FilterItem(
              id: FilterIds.ORDER_BY_ASCENDING,
              name: LocalizableStringKey.ascending.toString,
              selected: true,
              isDefault: true,
              filterableAction: Sort<DocumentFilterableAttributes, String>(predicate: { attribute in
                attribute.sortingKey
              })
            ),
            FilterItem(
              id: FilterIds.ORDER_BY_DESCENDING,
              name: LocalizableStringKey.descending.toString,
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
          name: LocalizableStringKey.sortBy.toString,
          filters: [
            FilterItem(
              id: FilterIds.FILTER_SORT_DEFAULT,
              name: LocalizableStringKey.defaultLabel.toString,
              selected: true,
              isDefault: true,
              filterableAction: Sort<DocumentFilterableAttributes, String>(predicate: { attribute in
                attribute.sortingKey
              })
            ),
            FilterItem(
              id: FilterIds.FILTER_SORT_DATE_ISSUED,
              name: LocalizableStringKey.dateIssued.toString,
              selected: false,
              filterableAction: Sort<DocumentFilterableAttributes, Date>(predicate: { attribute in
                attribute.issuedDate
              })
            ),
            FilterItem(
              id: FilterIds.FILTER_SORT_EXPIRY_DATE,
              name: LocalizableStringKey.expiryDate.toString,
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
          name: LocalizableStringKey.selectExpiryPeriod.toString,
          filters: [
            FilterItem(
              id: FilterIds.FILTER_BY_PERIOD_DEFAULT,
              name: LocalizableStringKey.defaultLabel.toString,
              selected: true,
              isDefault: true,
              filterableAction: Filter<DocumentFilterableAttributes>(predicate: { _, _ in
                return true
              })
            ),
            FilterItem(
              id: FilterIds.FILTER_BY_PERIOD_NEXT_7,
              name: LocalizableStringKey.nextSevenDays.toString,
              selected: false,
              filterableAction: Filter<DocumentFilterableAttributes>(predicate: { attributes, _ in
                guard let date = attributes.expiryDate else { return false }
                return date.isWithinNextDays(7)
              })
            ),
            FilterItem(
              id: FilterIds.FILTER_BY_PERIOD_NEXT_30,
              name: LocalizableStringKey.nextThirtyDays.toString,
              selected: false,
              filterableAction: Filter<DocumentFilterableAttributes>(predicate: { attributes, _ in
                guard let date = attributes.expiryDate else { return false }
                return date.isWithinNextDays(30)
              })
            ),
            FilterItem(
              id: FilterIds.FILTER_BY_PERIOD_BEYOND_30,
              name: LocalizableStringKey.beyondThiryDays.toString,
              selected: false,
              filterableAction: Filter<DocumentFilterableAttributes>(predicate: { attributes, _ in
                guard let date = attributes.expiryDate else { return false }
                return date.isBeyondNextDays(30)
              })
            ),
            FilterItem(
              id: FilterIds.FILTER_BY_PERIOD_EXPIRED,
              name: LocalizableStringKey.beforeToday.toString,
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
          name: LocalizableStringKey.filterByIssuer.toString,
          filters: [],
          filterableAction: FilterMultipleAction<DocumentFilterableAttributes>(predicate: { attribute, filter in
            attribute.issuer == filter.name
          }),
          filterType: .issuer
        ),
        MultipleSelectionFilterGroup(
          id: FilterIds.FILTER_BY_DOCUMENT_CATEGORY_GROUP_ID,
          name: LocalizableStringKey.filterByCategory.toString,
          filters: [],
          filterableAction: FilterMultipleAction<DocumentFilterableAttributes>(predicate: { attribute, filter in
            attribute.category == filter.name
          }),
          filterType: .documentCategory
        ),
        MultipleSelectionFilterGroup(
          id: FilterIds.FILTER_BY_STATE_GROUP_ID,
          name: LocalizableStringKey.filterByState.toString,
          filters: [
            FilterItem(
              id: FilterIds.FILTER_BY_STATE_VALID,
              name: LocalizableStringKey.valid.toString,
              selected: true,
              isDefault: true
            ),
            FilterItem(
              id: FilterIds.FILTER_BY_STATE_EXPIRED,
              name: LocalizableStringKey.expired.toString,
              selected: false,
              isDefault: false
            ),
            FilterItem(
              id: FilterIds.FILTER_BY_STATE_REVOKED,
              name: LocalizableStringKey.revoked.toString,
              selected: false,
              isDefault: false
            )
          ],
          filterableAction: FilterMultipleAction<DocumentFilterableAttributes>(predicate: { attribute, filter in
            switch filter.id {
            case FilterIds.FILTER_BY_STATE_VALID:
              (attribute.expiryDate?.isValid() == true || attribute.expiryDate == nil) && !attribute.isRevoked
            case FilterIds.FILTER_BY_STATE_EXPIRED:
              attribute.expiryDate?.isExpired() == true && !attribute.isRevoked
            case FilterIds.FILTER_BY_STATE_REVOKED:
              attribute.isRevoked
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

  private func fetchFilteredDocuments(failedDocuments: [String]) async -> FilterableList? {
    let documents = await self.walletKitController.fetchAllDocuments()
    let revokedDocuments = try? await self.walletKitController.fetchRevokedDocuments()

    guard !documents.isEmpty else {
      return nil
    }

    var filterableItems: [FilterableItem] = []
    for document in documents {
      let isRevoked = revokedDocuments?.first { $0 == document.id } != nil

      let documentIsLowOnCredentials = await walletKitController.isDocumentLowOnCredentials(document: document)
      let documentPayload = await document.transformToDocumentTabUi(
        categories: self.walletKitController.getDocumentCategories(),
        isRevoked: isRevoked,
        documentIsLowOnCredentials: documentIsLowOnCredentials,
        usageCount: getCredentialsUsageCount(
          credentialsUsageCounts: document.credentialsUsageCounts,
          isDeferred: (document is DeferrredDocument) == true
        )
      )

      let documentSearchTags: [String] = {
        var tags = [document.displayName ?? ""]
        let issuerName = document.issuerName.trimmingCharacters(in: .whitespacesAndNewlines)
        if !issuerName.isEmpty {
          tags.append(issuerName)
        }
        return tags
      }()

      let item = FilterableItem(
        payload: documentPayload,
        attributes: DocumentFilterableAttributes(
          sortingKey: document.displayName?.lowercased() ?? "",
          searchTags: documentSearchTags,
          issuedDate: document.createdAt,
          expiryDate: document.validUntil,
          issuer: document.issuerName,
          name: document.displayName,
          category: documentPayload.value.documentCategory.filterAttribute.capitalizedFirst(),
          isRevoked: isRevoked
        )
      )
      filterableItems.append(item)
    }

    return FilterableList(items: filterableItems)
  }

  private func getCredentialsUsageCount(
    credentialsUsageCounts: CredentialsUsageCounts?,
    isDeferred: Bool
  ) -> (remaining: Int?, total: Int?) {
    guard !isDeferred else {
      return (remaining: nil, total: nil)
    }

    let remaining = credentialsUsageCounts?.remaining ?? 1
    let total = credentialsUsageCounts?.total ?? 1
    return (remaining, total)
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
            filterSectionType: filter.filterElementType
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
        id: category,
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
        id: issuer,
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
}
