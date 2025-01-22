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
  case success(String, [DocumentUIModel], Bool)
  case failure(Error)
}

public enum DashboardDeleteDeferredPartialState: Sendable {
  case success
  case noDocuments
  case failure(Error)
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
    section: [FilterSections],
    sortAscending: Bool,
    initialSorting: String,
    selectedExpiryOption: String?,
    selectedStateOption: String,
    documents: [DocumentUIModel]
  ) -> [DocumentUIModel]
}

final class DashboardInteractorImpl: DashboardInteractor {

  private let walletController: WalletKitController
  private let reachabilityController: ReachabilityController
  private let configLogic: ConfigLogic

  private let sendableAnyCancellable: SendableAnyCancellable = .init()

  init(
    walletController: WalletKitController,
    reachabilityController: ReachabilityController,
    configLogic: ConfigLogic
  ) {
    self.walletController = walletController
    self.reachabilityController = reachabilityController
    self.configLogic = configLogic
  }

  deinit {
    sendableAnyCancellable.cancel()
  }

  func hasIssuedDocuments() -> Bool {
    return !walletController.fetchIssuedDocuments().isEmpty
  }

  func hasDeferredDocuments() -> Bool {
    return !walletController.fetchDeferredDocuments().isEmpty
  }

  public func fetchDashboard(failedDocuments: [String]) async -> DashboardPartialState {

    let documents: [DocumentUIModel]? = fetchDocuments(failedDocuments: failedDocuments)
    let username = fetchUsername()

    guard let documents = documents else {
      return .failure(WalletCoreError.unableFetchDocuments)
    }

    return .success(username, documents, hasIssuedDocuments())
  }

  public func getBleAvailability() async -> Reachability.BleAvailibity {
    return await withCheckedContinuation { cont in
      reachabilityController.getBleAvailibity()
        .sink { cont.resume(returning: $0)}
        .store(in: &sendableAnyCancellable.cancellables)
    }
  }

  public func openBleSettings() {
    reachabilityController.openBleSettings()
  }

  public func getAppVersion() -> String {
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

    for deferred in walletController.fetchDeferredDocuments() {

      if Task.isCancelled { return .cancelled }

      do {
        let document = try await walletController.requestDeferredIssuance(with: deferred)
        if (document is DeferrredDocument) == false {
          issued.append(document.transformToDocumentUi())
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
    section: [FilterSections],
    sortAscending: Bool,
    initialSorting: String,
    selectedExpiryOption: String?,
    selectedStateOption: String,
    documents: [DocumentUIModel]
  ) -> [DocumentUIModel] {

    let selectedIssuers = section
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

    guard let selectedExpiryPeriod = selectedExpiryOption else {
      return filteredDocuments
    }

    filteredDocuments = filteredDocuments.filter { document in
      return isDocumentWithinExpiryPeriod(document, expiryPeriod: selectedExpiryPeriod)
    }

    if selectedStateOption == "Valid" {
      filteredDocuments = filteredDocuments.filter { !$0.value.hasExpired && $0.value.state == .issued }
    } else if selectedStateOption == "Expired" {
      filteredDocuments = filteredDocuments.filter { $0.value.hasExpired }
    } else if selectedStateOption == "Revoke" {
      filteredDocuments = filteredDocuments.filter { $0.value.state == .failed }
    }

    switch initialSorting {
    case "Date Issued":
      filteredDocuments = sortAscending
      ? filteredDocuments.sorted { $0.value.createdAt < $1.value.createdAt }
      : filteredDocuments.sorted { $0.value.createdAt > $1.value.createdAt }
    case "Expiry Date":
      filteredDocuments = sortAscending
      ? filteredDocuments.sorted { ($0.value.expiresAt ?? "") < ($1.value.expiresAt ?? "") }
      : filteredDocuments.sorted { ($0.value.expiresAt ?? "") > ($1.value.expiresAt ?? "") }
    default:
      filteredDocuments = sortAscending
      ? filteredDocuments.sorted { $0.value.title < $1.value.title }
      : filteredDocuments.sorted { $0.value.title > $1.value.title }
    }

    return filteredDocuments
  }

  private func isDocumentWithinExpiryPeriod(_ document: DocumentUIModel, expiryPeriod: String) -> Bool {
    guard let expiresAtString = document.value.expiresAt else { return false }

    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd/MM/yyyy"
    guard let expiryDate = dateFormatter.date(from: expiresAtString) else { return false }

    let currentDate = Date()
    let calendar = Calendar.current

    switch expiryPeriod {
    case "Next 7 days":
      return calendar.date(byAdding: .day, value: 7, to: currentDate)! >= expiryDate
    case "Next 30 days":
      return calendar.date(byAdding: .day, value: 30, to: currentDate)! >= expiryDate
    case "Beyond 30 days":
      return expiryDate > calendar.date(byAdding: .day, value: 30, to: currentDate)!
    case "Before today":
      return expiryDate < currentDate
    default:
      return true
    }
  }

  private func fetchUsername() -> String {
    let name = walletController.fetchMainPidDocument()?.getBearersName()?.first
    return name.orEmpty
  }

  private func fetchDocuments(failedDocuments: [String]) -> [DocumentUIModel]? {
    let documents = self.walletController.fetchAllDocuments()
    guard !documents.isEmpty else {
      return nil
    }
    return documents.transformToDocumentUi(with: failedDocuments)
  }
}
