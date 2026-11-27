/*
 * Copyright (c) 2026 European Commission
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
import feature_common
import Observation
import SwiftUI

@Copyable
struct DocumentTabState: ViewState {
  let isLoading: Bool
  let documents: [DocumentCategory: [DocumentTabUIModel]]
  let filterUIModel: [FilterUISection]
  let lifecycle: Lifecycle
  let pendingDeletionDocument: DocumentTabUIModel?
  let highlightedDocumentIds: Set<String>
  let hasDefaultFilters: Bool

  var pendingDocumentTitle: String {
    pendingDeletionDocument?.value.title ?? ""
  }
}

extension DocumentTabState {
  enum Lifecycle {
    case tabActivePaused
    case tabNotActivePaused
    case active
  }
}

@Observable
final class DocumentTabViewModel<Router: RouterHost>: ViewModel<Router, DocumentTabState> {

  @ObservationIgnored
  private let interactor: DocumentTabInteractor
  @ObservationIgnored
  private let SEARCH_INPUT_DEBOUNCE = 250
  @ObservationIgnored
  private let HIGHLIGHT_DELAY: TimeInterval = 0.15
  @ObservationIgnored
  private let HIGHLIGHT_DURATION: TimeInterval = 1.25
  @ObservationIgnored
  private let onUpdateToolbar: (ToolBarContent, LocalizableStringKey) -> Void

  var isFilterModalShowing: Bool = false
  var isDeleteDeferredModalShowing: Bool = false
  var searchQuery: String = "" {
    didSet {
      debouncedSearchQuery.send(searchQuery)
    }
  }

  @ObservationIgnored
  private var debouncedSearchQuery = CurrentValueSubject<String, Never>("")
  @ObservationIgnored
  private var didApplyFilters = false

  init(
    router: Router,
    interactor: DocumentTabInteractor,
    onUpdateToolbar: @escaping (ToolBarContent, LocalizableStringKey) -> Void
  ) {
    self.interactor = interactor
    self.onUpdateToolbar = onUpdateToolbar
    super.init(
      router: router,
      initialState: .init(
        isLoading: true,
        documents: [:],
        filterUIModel: [],
        lifecycle: .tabNotActivePaused,
        pendingDeletionDocument: nil,
        highlightedDocumentIds: [],
        hasDefaultFilters: true
      )
    )

    subscribeToSearch()
    onFiltersChangeState()
  }

  func onAppear() {
    updateToolBar()
    fetch()
  }

  func onDisappear() {
    self.setState { $0.copy(lifecycle: .tabNotActivePaused) }
  }

  func fetch() {
    guard !isFilterModalShowing else { return }
    Task {

      let state = await interactor.fetchDocuments(
        shouldRefreshCounters: viewState.lifecycle != .active
      )

      switch state {
      case .success(let documents):

        if viewState.lifecycle != .active {
          await interactor.initializeFilters(filterableList: documents)
        } else {
          await interactor.updateLists(filterableList: documents)
        }

        await interactor.applyFilters()

        setState {
          $0.copy(
            lifecycle: .active
          )
        }
      case .failure:
        setState {
          $0.copy(
            isLoading: false,
            documents: [:],
            lifecycle: .active
          )
        }
      }
    }
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

  func setPhase(with phase: ScenePhase) {
    if phase == .active, viewState.lifecycle == .tabActivePaused {
      onAppear()
    }
    if phase == .background, viewState.lifecycle == .active {
      onbackground()
    }
  }

  private func onbackground() {
    self.setState { $0.copy(lifecycle: .tabActivePaused) }
  }

  func onDocumentDetails(documentId: String) {
    router.push(
      with: .featureDashboardModule(
        .documentDetails(id: documentId)
      )
    )
  }

  func onDeleteDeferredDocument(with document: DocumentTabUIModel) {
    setState { $0.copy(pendingDeletionDocument: document) }
    toggleDeleteDeferredModal()
  }

  func toggleDeleteDeferredModal() {
    isDeleteDeferredModalShowing = !isDeleteDeferredModalShowing
  }

  func deleteDeferredDocument() {

    toggleDeleteDeferredModal()

    guard let document = viewState.pendingDeletionDocument else {
      return
    }

    setState { $0.copy(isLoading: true).copy(pendingDeletionDocument: nil) }

    Task {

      let state = await interactor.deleteDeferredDocument(with: document.value.id)

      switch state {
      case .success:
        fetch()
      case .noDocuments:
        router.popTo(with: .featureStartupModule(.startup))
      case .failure:
        setState { $0.copy(isLoading: false) }
      }
    }
  }

  func onAdd() {
    router.push(
      with: .featureDashboardModule(
        .issuanceOption
      )
    )
  }

  func showFilters() {
    isFilterModalShowing = true
    onbackground()
  }

  func applyFilters() {
    didApplyFilters = true
    isFilterModalShowing = false
    fetch()
  }

  func onFiltersDismissed() {
    if didApplyFilters {
      didApplyFilters = false
    } else {
      fetch()
    }
  }

  func handleRefreshotification() {
    if viewState.lifecycle == .active {
      fetch()
    }
  }

  private func subscribeToSearch() {
    debouncedSearchQuery
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

  private func onFiltersChangeState() {
    Task {
      for await state in await interactor.onFilterChangeState() {
        switch state {
        case .filterApplyResult(let documents, let filterSections, let hasDefaultFilters):
          setState {
            $0.copy(
              isLoading: false,
              documents: documents,
              filterUIModel: filterSections,
              hasDefaultFilters: hasDefaultFilters
            )
          }
          closeDeletionDialogIfNoLongerDeferred(in: documents)
          highlightIssuedDocuments(in: documents)
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

  private func closeDeletionDialogIfNoLongerDeferred(in documents: [DocumentCategory: [DocumentTabUIModel]]) {
    guard
      isDeleteDeferredModalShowing,
      let pendingDeletionId = viewState.pendingDeletionDocument?.id
    else {
      return
    }
    let isStillDeferred = documents.values.joined().contains {
      $0.id == pendingDeletionId && $0.value.state.isDeferred
    }
    guard !isStillDeferred else { return }
    isDeleteDeferredModalShowing = false
    setState { $0.copy(pendingDeletionDocument: nil) }
  }

  private func highlightIssuedDocuments(in documents: [DocumentCategory: [DocumentTabUIModel]]) {
    guard !isFilterModalShowing else { return }
    let issued = documents.values.joined().filter { !$0.value.state.isDeferred }
    guard !issued.isEmpty else { return }

    Task {
      let ids = await interactor.markIssuedDocumentsSeen(Set(issued.map(\.id)))
      guard !ids.isEmpty else { return }
      let announcement = LocalizableStringKey.deferredDocumentsIssuedAnnouncement(
        [issued.filter { ids.contains($0.id) }.map(\.value.title).joined(separator: ", ")]
      ).toString

      try? await Task.sleep(seconds: HIGHLIGHT_DELAY)
      setState { $0.copy(highlightedDocumentIds: $0.highlightedDocumentIds.union(ids)) }
      AccessibilityNotification.Announcement(announcement).post()
      try? await Task.sleep(seconds: HIGHLIGHT_DURATION)
      setState { $0.copy(highlightedDocumentIds: $0.highlightedDocumentIds.subtracting(ids)) }
    }
  }

  private func onMyWallet() {
    router.push(
      with: .featureDashboardModule(
        .sideMenu
      )
    )
  }

  private func updateToolBar() {
    self.onUpdateToolbar(
      .init(
        trailingActions: [
          .init(
            image: Theme.shared.image.plus,
            accessibilityLocator: DocumentTabLocators.plusButton,
            tintColor: Theme.shared.color.accent
          ) {
            self.onAdd()
          },
          .init(
            image: Theme.shared.image.filterMenuIcon,
            accessibilityLocator: DocumentTabLocators.filterButton,
            hasIndicator: !viewState.hasDefaultFilters,
            disabled: viewState.filterUIModel.isEmpty
          ) {
            self.showFilters()
          }
        ],
        leadingActions: [
          .init(
            image: Theme.shared.image.menuIcon,
            accessibilityLocator: ToolbarLocators.menuButton
          ) {
            self.onMyWallet()
          }
        ]
      ),
      .documents
    )
  }
}
