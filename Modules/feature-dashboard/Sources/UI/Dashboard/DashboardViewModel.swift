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

struct DashboardState: ViewState {
  let isLoading: Bool
  let documents: [DocumentUIModel]
  let bearer: BearerUIModel
}

@MainActor
final class DashboardViewModel<Router: RouterHostType, Interactor: DashboardInteractorType, DeepLinkController: DeepLinkControllerType>: BaseViewModel<Router, DashboardState> {

  private let interactor: Interactor
  private let deepLinkController: DeepLinkController

  @Published var isMoreModalShowing: Bool = false

  var bearerName: String {
    viewState.bearer.value.name
  }

  init(router: Router, interactor: Interactor, deepLinkController: DeepLinkController) {
    self.interactor = interactor
    self.deepLinkController = deepLinkController
    super.init(
      router: router,
      initialState: .init(
        isLoading: true,
        documents: DocumentUIModel.mocks(),
        bearer: BearerUIModel.mock()
      )
    )
  }

  func fetch() async {
    switch await interactor.fetchDashboard() {
    case .success(let bearer, let documents):
      setNewState(
        isLoading: false,
        documents: documents,
        bearer: bearer
      )
      handleDeepLink()
    case .failure:
      setNewState(
        isLoading: false,
        documents: [],
        bearer: nil
      )
    }
  }

  func onDocumentDetails(documentId: String) {
    router.push(with: .documentDetails(docoumentId: documentId))
  }
  func onShare() {
    router.push(with: .proximityConnection)
  }

  func onAdd() {
    router.push(with: .addDocument)
  }

  func onMore() {
    isMoreModalShowing = !isMoreModalShowing
  }

  func onUpdatePin() {
    isMoreModalShowing = false
  }

  private func handleDeepLink() {
    if let deepLink = deepLinkController.getPendingDeepLinkAction() {
      deepLinkController.handleDeepLinkAction(routerHost: router, deepLinkAction: deepLink)
    }
  }

  private func setNewState(
    isLoading: Bool? = nil,
    documents: [DocumentUIModel]? = nil,
    bearer: BearerUIModel? = nil
  ) {
    setState { previousSate in
        .init(
          isLoading: isLoading ?? previousSate.isLoading,
          documents: documents ?? previousSate.documents,
          bearer: bearer ?? previousSate.bearer
        )
    }
  }
}
