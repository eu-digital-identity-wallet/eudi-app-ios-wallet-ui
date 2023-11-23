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
import logic_resources
import feature_common

struct DocumentDetailsViewState: ViewState {
  let document: DocumentDetailsUIModel
  let isLoading: Bool
  let error: ContentError.Config?
  let config: IssuanceDetailUiConfig

  var isCancellable: Bool {
    return config.isExtraDocument
  }

  var hasContinueButton: Bool {
    return !config.isExtraDocument
  }
}

@MainActor
final class DocumentDetailsViewModel<Router: RouterHostType, Interactor: DocumentDetailsInteractorType>: BaseViewModel<Router, DocumentDetailsViewState> {

  private let interactor: Interactor

  init(
    router: Router,
    interactor: Interactor,
    config: any UIConfigType
  ) {
    guard let config = config as? IssuanceDetailUiConfig else {
      fatalError("DocumentDetailsViewModel:: Invalid configuraton")
    }
    self.interactor = interactor
    super.init(
      router: router,
      initialState: .init(
        document: DocumentDetailsUIModel.mock(),
        isLoading: true,
        error: nil,
        config: config
      )
    )
  }

  func fetchDocumentDetails() async {

    switch await self.interactor.fetchStoredDocument(documentId: viewState.config.documentId) {

    case .success(let document):
      self.setNewState(
        isLoading: false,
        document: document
      )
    case .failure(let error):
      self.setNewState(
        isLoading: true,
        error: ContentError.Config(
          description: .custom(error.localizedDescription),
          cancelAction: self.pop()
        )
      )
    }
  }

  func pop() {
    router.pop()
  }

  func onContinue() {
    router.push(with: .dashboard)
  }

  private func setNewState(
    isLoading: Bool = false,
    document: DocumentDetailsUIModel? = nil,
    error: ContentError.Config? = nil
  ) {
    setState { previous in
        .init(
          document: document ?? previous.document,
          isLoading: isLoading,
          error: error,
          config: previous.config
        )
    }
  }
}
