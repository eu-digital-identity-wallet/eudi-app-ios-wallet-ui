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
import logic_business
import feature_common
import logic_core

@Copyable
struct AddDocumentViewState: ViewState {
  let addDocumentCellModels: [AddDocumentUIModel]
  let error: ContentErrorView.Config?
  let config: IssuanceFlowUiConfig

  var isFlowCancellable: Bool {
    return config.isExtraDocumentFlow
  }

  var isLoading: Bool {
    addDocumentCellModels.allSatisfy { $0.isLoading }
  }
}

@MainActor
final class AddDocumentViewModel<Router: RouterHost>: BaseViewModel<Router, AddDocumentViewState> {

  private let interactor: AddDocumentInteractor
  private let deepLinkController: DeepLinkController

  init(
    router: Router,
    interactor: AddDocumentInteractor,
    deepLinkController: DeepLinkController,
    config: any UIConfigType
  ) {
    guard let config = config as? IssuanceFlowUiConfig else {
      fatalError("AddDocumentViewModel:: Invalid configuraton")
    }
    self.interactor = interactor
    self.deepLinkController = deepLinkController
    super.init(
      router: router,
      initialState: .init(
        addDocumentCellModels: AddDocumentUIModel.mocks,
        error: nil,
        config: config
      )
    )
  }

  func initialize() async {
    switch self.interactor.fetchStoredDocuments(with: viewState.config.flow) {
    case .success(let documents):
      setState { $0.copy(addDocumentCellModels: documents).copy(error: nil) }
      if let link = hasDeepLink() {
        handleDeepLink(with: link)
      } else {
        await handleResumeIssuance()
      }
    case .failure(let error):
      setState {
        $0.copy(
          error: .init(
            description: .custom(error.localizedDescription),
            cancelAction: self.pop(),
            action: { Task { await self.initialize() } }
          )
        )
      }
    }
  }

  func onClick(for documentIdentifier: DocumentTypeIdentifier) {
    switch documentIdentifier {
    case .GENERIC:
      loadSampleData()
    default:
      issueDocument(docType: documentIdentifier.rawValue)
    }
  }

  func onScanClick() {
    router.push(with: .qrScanner(config: ScannerUiConfig(flow: .issuing(viewState.config))))
  }

  func pop() {
    router.pop()
  }

  private func handleResumeIssuance() async {
    setState {
      $0.copy(
        addDocumentCellModels: transformCellLoadingState(with: true)
      )
    }
    switch await interactor.resumeDynamicIssuance() {
    case .success(let docId):
      router.push(
        with: .issuanceSuccess(
          config: viewState.config,
          documentIdentifier: docId
        )
      )
    case .noPending:
      setState {
        $0.copy(
          addDocumentCellModels: transformCellLoadingState(with: false)
        )
      }
    case .failure(let error):
      setState {
        $0.copy(
          addDocumentCellModels: transformCellLoadingState(with: false),
          error: .init(
            description: .custom(error.localizedDescription),
            cancelAction: self.setState { $0.copy(error: nil) }
          )
        )
      }
    }
  }

  private func issueDocument(docType: String) {
    Task {
      setState {
        $0
          .copy(
            addDocumentCellModels: transformCellLoadingState(with: true)
          )
          .copy(error: nil)
      }
      switch await interactor.issueDocument(docType: docType) {
      case .success(let docId):
        router.push(
          with: .issuanceSuccess(
            config: viewState.config,
            documentIdentifier: docId
          )
        )
      case .dynamicIssuance(let session):
        setState {
          $0.copy(
            addDocumentCellModels: transformCellLoadingState(with: false)
          )
        }
        router.push(
          with: .presentationRequest(
            presentationCoordinator: session,
            originator: .issuanceAddDocument(config: viewState.config)
          )
        )
      case .failure(let error):
        setState {
          $0.copy(
            addDocumentCellModels: transformCellLoadingState(with: false),
            error: .init(
              description: .custom(error.localizedDescription),
              cancelAction: self.setState { $0.copy(error: nil) }
            )
          )
        }
      case .deferredSuccess:
        router.push(with: onDeferredSuccess())
      }
    }
  }

  private func onDeferredSuccess() -> AppRoute {
    var navigationType: UIConfig.DeepLinkNavigationType {
      return switch viewState.config.flow {
      case .noDocument:
          .push(screen: .dashboard)
      case .extraDocument:
          .pop(screen: .dashboard)
      }
    }
    return .success(
      config: UIConfig.Success(
        title: .init(value: .inProgress, color: Theme.shared.color.warning),
        subtitle: .scopedIssuanceSuccessDeferredCaption,
        buttons: [
          .init(
            title: .okButton,
            style: .primary,
            navigationType: navigationType
          )
        ],
        visualKind: .customIcon(Theme.shared.image.clock, Theme.shared.color.warning)
      )
    )
  }

  private func transformCellLoadingState(with isLoading: Bool) -> [AddDocumentUIModel] {
    return viewState.addDocumentCellModels.map({
      var cell = $0
      cell.isLoading = isLoading
      return cell
    }
    )
  }

  private func loadSampleData() {
    Task {
      switch await interactor.loadSampleData() {
      case .success:
        router.push(with: .dashboard)
      case .failure(let error):
        setState {
          $0.copy(
            error: .init(
              description: .custom(error.localizedDescription),
              cancelAction: self.setState { $0.copy(error: nil) }
            )
          )
        }
      }
    }
  }

  private func hasDeepLink() -> String? {
    guard let deepLink = deepLinkController.getPendingDeepLinkAction(), deepLink.action == .credential_offer else {
      return nil
    }
    deepLinkController.removeCachedDeepLinkURL()
    return deepLink.plainUrl.absoluteString
  }

  private func handleDeepLink(with uri: String) {
    router.push(
      with: .credentialOfferRequest(
        config: UIConfig.Generic(
          arguments: ["uri": uri],
          navigationSuccessType: .push(.dashboard),
          navigationCancelType: .pop
        )
      )
    )
  }
}
