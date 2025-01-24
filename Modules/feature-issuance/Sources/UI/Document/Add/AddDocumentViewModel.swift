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

final class AddDocumentViewModel<Router: RouterHost>: ViewModel<Router, AddDocumentViewState> {

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
    switch await self.interactor.fetchScopedDocuments(
      with: viewState.config.flow
    ) {
    case .success(let documents):
      setState {
        $0.copy(
          addDocumentCellModels: documents
        )
        .copy(error: nil)
      }
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

  func onClick(for configId: String) {
    issueDocument(configId: configId)
  }

  func onScanClick() {
    router.push(with: .featureCommonModule(.qrScanner(config: ScannerUiConfig(flow: .issuing(viewState.config)))))
  }

  func pop() {
    router.popTo(with: .featureDashboardModule(.dashboard))
  }

  func toolbarContent() -> ToolBarContent? {
    return switch viewState.config.flow {
    case .noDocument:
      nil
    case .extraDocument:
      .init(
        trailingActions: [],
        leadingActions: [
          Action(image: Theme.shared.image.chevronLeft) {
            self.pop()
          }
        ]
      )
    }
  }

  private func handleResumeIssuance() async {

    setState {
      $0.copy(
        addDocumentCellModels: transformCellLoadingState(with: true)
      )
    }

    let state = await Task.detached { () -> IssueDynamicDocumentPartialState in
      return await self.interactor.resumeDynamicIssuance()
    }.value

    switch state {
    case .success(let docId):
      router.push(
        with: .featureIssuanceModule(
          .issuanceSuccess(
            config: viewState.config,
            documentIdentifiers: [docId]
          )
        )
      )
    case .deferredSuccess:
      router.push(
        with: onDeferredSuccess()
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

  private func issueDocument(configId: String) {
    Task {
      setState {
        $0.copy(
          addDocumentCellModels: transformCellLoadingState(with: true)
        )
        .copy(error: nil)
      }

      let state = await Task.detached { () -> IssueDocumentPartialState in
        return await self.interactor.issueDocument(configId: configId)
      }.value

      switch state {
      case .success(let docId):
        router.push(
          with: .featureIssuanceModule(
            .issuanceSuccess(
              config: viewState.config,
              documentIdentifiers: [docId]
            )
          )
        )
      case .dynamicIssuance(let session):
        setState {
          $0.copy(
            addDocumentCellModels: transformCellLoadingState(with: false)
          )
        }
        router.push(
          with: .featurePresentationModule(
            .presentationRequest(
              presentationCoordinator: session,
              originator: .featureIssuanceModule(.issuanceAddDocument(config: viewState.config))
            )
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
        let metaData = try await interactor.getScopedDocument(
          configId: configId
        )

        router.push(
          with: onDeferredSuccess(
            issuerName: metaData.issuer,
            documentName: metaData.name
          )
        )
      }
    }
  }

  private func onDeferredSuccess(
    issuerName: String = "",
    documentName: String = ""
  ) -> AppRoute {
    var navigationType: UIConfig.DeepLinkNavigationType {
      return switch viewState.config.flow {
      case .noDocument:
          .push(screen: .featureDashboardModule(.dashboard))
      case .extraDocument:
          .pop(screen: .featureDashboardModule(.dashboard))
      }
    }

    var subTitle: LocalizableString.Key {
      if documentName.isEmpty {
        return .scopedIssuanceSuccessDeferredCaptionDocName([documentName])
      } else if !documentName.isEmpty, !issuerName.isEmpty {
        return .scopedIssuanceSuccessDeferredCaptionDocNameAndIssuer([documentName, issuerName])
      } else {
        return .scopedIssuanceSuccessDeferredCaption
      }
    }

    return .featureCommonModule(
      .success(
        config: UIConfig.Success(
          title: .init(
            value: .inProgress,
            color: Theme.shared.color.pending
          ),
          subtitle: subTitle,
          buttons: [
            .init(
              title: .okButton,
              style: .primary,
              navigationType: navigationType
            )
          ],
          visualKind: .customIcon(
            Theme.shared.image.documentSuccessPending,
            Color.clear
          )
        )
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

  private func hasDeepLink() -> String? {
    guard let deepLink = deepLinkController.getPendingDeepLinkAction(), deepLink.action == .credential_offer else {
      return nil
    }
    deepLinkController.removeCachedDeepLinkURL()
    return deepLink.plainUrl.absoluteString
  }

  private func handleDeepLink(with uri: String) {
    router.push(
      with: .featureIssuanceModule(
        .credentialOfferRequest(
          config: UIConfig.Generic(
            arguments: ["uri": uri],
            navigationSuccessType: .push(.featureDashboardModule(.dashboard)),
            navigationCancelType: .pop
          )
        )
      )
    )
  }
}
