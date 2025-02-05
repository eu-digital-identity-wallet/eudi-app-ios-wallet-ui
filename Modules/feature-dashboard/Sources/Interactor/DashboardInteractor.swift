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
  case filterResult([DocumentUIModel], [FilterUISection])
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
  func applyFiltersWithSorting(
    filterModel: FilterModel?,
    documents: [DocumentUIModel]
  ) async -> [DocumentUIModel]
  // MARK: - FILTER
  @MainActor func onFilterChangeState() -> AsyncStream<FiltersPartialState>
  func initializeFilters(filters: Filters, filterableList: FilterableList) async
  func applyFilters() async
  func resetFilters() async
  func updateFilters(sectionID: String, filterID: String) async
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

            let documentsUI = filterResult.filteredList.items.compactMap { filterableItem in
              filterableItem.data as? DocumentUIModel
            }

            let filterSections = filterResult.updatedFilters.filterGroups.map { filteredGroup in
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

            continuation.yield(.filterResult(documentsUI, filterSections))
          case .completion:
            continuation.yield(.cancelled)
            continuation.finish()
          }
        }
      }
    }
  }

  func initializeFilters(filters: Filters, filterableList: FilterableList) async {
    await filterValidator.initializeFilters(filters: filters, filterableList: filterableList)
  }

  func applyFilters() async {
    await filterValidator.applyFilters()
  }

  func resetFilters() async {
    await filterValidator.resetFilters()
  }

  func updateFilters(sectionID: String, filterID: String)  async {
    await filterValidator.updateFilter(filterGroupId: sectionID, filterId: filterID)
  }

  func fetchDashboard(failedDocuments: [String]) async -> DashboardPartialState {

    let documents: FilterableList? = await fetchFilteredDocuments(failedDocuments: failedDocuments)
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

  func applyFiltersWithSorting(
    filterModel: FilterModel?,
    documents: [DocumentUIModel]
  ) -> [DocumentUIModel] {

    guard let filterModel = filterModel else {
      return documents
    }

    let selectedIssuers = filterModel.sections
      .compactMap { filterSection -> [String]? in
        if case let .issuer(options: issuers) = filterSection {
          return issuers
        }
        return nil
      }
      .flatMap { $0 }

    var filteredDocuments: [DocumentUIModel] = documents

    if !selectedIssuers.isEmpty {
      filteredDocuments = filteredDocuments.filter { selectedIssuers.contains($0.value.heading) }
    }

    guard let selectedExpiryPeriod = filterModel.selectedExpiryOption else {
      return filteredDocuments
    }

    filteredDocuments = filteredDocuments.filter { document in
      return isDocumentWithinExpiryPeriod(document, expiryPeriod: selectedExpiryPeriod)
    }

    if filterModel.selectedStateOption == LocalizableString.shared.get(with: .valid) {
      filteredDocuments = filteredDocuments.filter { !$0.value.hasExpired && $0.value.state == .issued }
    } else if filterModel.selectedStateOption == LocalizableString.shared.get(with: .expired) {
      filteredDocuments = filteredDocuments.filter { $0.value.hasExpired }
    }

    switch filterModel.initialSorting {
    case LocalizableString.shared.get(with: .dateIssued):
      filteredDocuments = filterModel.sortAscending
      ? filteredDocuments.sorted { $0.value.createdAt < $1.value.createdAt }
      : filteredDocuments.sorted { $0.value.createdAt > $1.value.createdAt }
    case LocalizableString.shared.get(with: .expiryDate):
      filteredDocuments = filterModel.sortAscending
      ? filteredDocuments.sorted { ($0.value.expiresAt ?? "") < ($1.value.expiresAt ?? "") }
      : filteredDocuments.sorted { ($0.value.expiresAt ?? "") > ($1.value.expiresAt ?? "") }
    default:
      filteredDocuments = filterModel.sortAscending
      ? filteredDocuments.sorted { $0.value.title < $1.value.title }
      : filteredDocuments.sorted { $0.value.title > $1.value.title }
    }

    return filteredDocuments
  }

  private func fetchFilteredDocuments(failedDocuments: [String]) async -> FilterableList? {
    let documents = self.walletController.fetchAllDocuments()
    let categories = self.walletController.getDocumentCategories()

    guard !documents.isEmpty else {
      return nil
    }

    let documentUIModels = documents.transformToDocumentUi(with: failedDocuments, categories: categories)

    let filterableItems = documentUIModels.map { document in
      FilterableItem(
        data: document,
        attributes: DocumentFilterableAttributes(document: document)
      )
    }

    return FilterableList(items: filterableItems)
  }

  private func isDocumentWithinExpiryPeriod(_ document: DocumentUIModel, expiryPeriod: String) -> Bool {
    guard let expiresAtString = document.value.expiresAt else { return false }

    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd/MM/yyyy"
    guard let expiryDate = dateFormatter.date(from: expiresAtString) else { return false }

    let currentDate = Date()
    let calendar = Calendar.current

    switch expiryPeriod {
    case LocalizableString.shared.get(with: .nextSevenDays):
      return calendar.date(byAdding: .day, value: 7, to: currentDate)! >= expiryDate
    case LocalizableString.shared.get(with: .nextThirtyDays):
      return calendar.date(byAdding: .day, value: 30, to: currentDate)! >= expiryDate
    case LocalizableString.shared.get(with: .beyondThiryDays):
      return expiryDate > calendar.date(byAdding: .day, value: 30, to: currentDate)!
    case LocalizableString.shared.get(with: .beforeToday):
      return expiryDate < currentDate
    default:
      return true
    }
  }

  private func fetchUsername() -> String {
    let name = walletController.fetchMainPidDocument()?.getBearersName()?.first
    return name.orEmpty
  }
}
