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
import logic_ui
import logic_core
import feature_common

@Copyable
struct DocumentTabState: ViewState {
  let isLoading: Bool
  let documents: [DocumentCategory: [DocumentTabUIModel]]
  let filterUIModel: [FilterUISection]
  let phase: ScenePhase
  let pendingDeletionDocument: DocumentTabUIModel?
  let succededIssuedDocuments: [DocumentTabUIModel]
  let failedDocuments: [String]
  let isPaused: Bool
  let hasDefaultFilters: Bool

  var pendingDocumentTitle: String {
    pendingDeletionDocument?.value.title ?? ""
  }
}

final class DocumentTabViewModel<Router: RouterHost>: ViewModel<Router, DocumentTabState> {

  private let interactor: DocumentTabInteractor
  private let SEARCH_INPUT_DEBOUNCE = 250
  private let onUpdateToolbar: (ToolBarContent, LocalizableStringKey) -> Void

  @Published var isFilterModalShowing: Bool = false
  @Published var isDeleteDeferredModalShowing: Bool = false
  @Published var isSuccededDocumentsModalShowing: Bool = false
  @Published var searchQuery: String = ""

  private var deferredTask: Task<DeferredPartialState, Error>?

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
        phase: .active,
        pendingDeletionDocument: nil,
        succededIssuedDocuments: [],
        failedDocuments: [],
        isPaused: true,
        hasDefaultFilters: true
      )
    )

    listenForSuccededIssuedModalChanges()
    subscribeToSearch()
    onFiltersChangeState()
  }

  func onCreate() {
    updateToolBar()
    fetch()
  }

  func fetch() {
    Task {
      let failedDocuments = viewState.failedDocuments

      let state = await Task.detached { () -> DocumentsPartialState in
        return await self.interactor.fetchDocuments(failedDocuments: failedDocuments)
      }.value

      switch state {
      case .success(let documents):

        if viewState.isPaused {
          await interactor.initializeFilters(filterableList: documents)
        } else {
          await interactor.updateLists(filterableList: documents)
        }

        await interactor.applyFilters()

        setState {
          $0.copy(
            isPaused: false
          )
        }
        onDocumentsRetrievedPostActions()
      case .failure:
        setState {
          $0.copy(
            isLoading: false,
            documents: [:]
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
    setState { $0.copy(phase: phase) }
    if phase == .active {
      onDocumentsRetrievedPostActions()
    }
    if phase == .background {
      onPause()
    }
  }

  func onPause() {
    self.deferredTask?.cancel()
    self.setState { $0.copy(isPaused: true) }
  }

  func onDocumentDetails(documentId: String) {

    isSuccededDocumentsModalShowing = false

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

      let state = await Task.detached { () -> DeleteDeferredPartialState in
        return await self.interactor.deleteDeferredDocument(with: document.value.id)
      }.value

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
    onPause()
  }

  func handleRevocationNotification() {
    if !viewState.isPaused {
      fetch()
    }
  }

  private func listenForSuccededIssuedModalChanges() {
    $isSuccededDocumentsModalShowing
      .dropFirst()
      .removeDuplicates()
      .sink { [weak self] value in
        guard let self = self else { return }
        if !value {
          self.setState { $0.copy(succededIssuedDocuments: []) }
        }
      }.store(in: &cancellables)
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

  private func onFiltersChangeState() {
    Task {
      for await state in interactor.onFilterChangeState() {
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

  private func onDocumentsRetrievedPostActions() {
    if interactor.hasDeferredDocuments() && (self.deferredTask == nil || self.deferredTask?.isCancelled == true) {
      self.deferredTask = Task {
        try? await Task.sleep(seconds: 5)
        return await interactor.requestDeferredIssuance()
      }
      Task {
        guard let task = self.deferredTask else { return }
        let partialState = try? await task.value
        switch partialState {
        case .completion(let issued, let failed):
          self.deferredTask?.cancel()
          self.setState {
            $0.copy(
              succededIssuedDocuments: !isSuccededDocumentsModalShowing
              ? issued
              : $0.succededIssuedDocuments,
              failedDocuments: failed
            )
          }
          fetch()
        case .cancelled, .none: break
        }
      }
    }
    checkForSuccededIssuedDocuments()
  }

  private func checkForSuccededIssuedDocuments() {
    guard
      !viewState.succededIssuedDocuments.isEmpty,
      !isSuccededDocumentsModalShowing
    else {
      return
    }
    isDeleteDeferredModalShowing = false
    DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
      self.isSuccededDocumentsModalShowing = true
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
          .init(image: Theme.shared.image.plus) {
            self.onAdd()
          },
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
      .documents
    )
  }
}
