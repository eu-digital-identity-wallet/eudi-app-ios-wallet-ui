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
import logic_ui
import logic_resources
import feature_common
import logic_core

@Copyable
struct AddDocumentViewState: ViewState {
  let addDocumentCellModels: [AddDocumentUIModel]
  let error: ContentErrorView.Config?
  let config: IssuanceFlowUiConfig
  let showFooterScanner: Bool

  var isFlowCancellable: Bool {
    return config.isExtraDocumentFlow
  }

  var isLoading: Bool {
    !addDocumentCellModels.isEmpty && addDocumentCellModels.allSatisfy { $0.isLoading }
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
        config: config,
        showFooterScanner: config.isNoDocumentFlow
      )
    )
  }

  func initialize() async {

    setState {
      $0
        .copy(
          addDocumentCellModels: viewState.addDocumentCellModels.isEmpty
          ? AddDocumentUIModel.mocks
          : viewState.addDocumentCellModels
        )
        .copy(error: nil)
    }

    let link = hasDeepLink()

    switch await self.interactor.fetchScopedDocuments(
      with: viewState.config.flow
    ) {
    case .success(let documents):
      setState {
        $0.copy(
          addDocumentCellModels: documents,
          showFooterScanner: viewState.addDocumentCellModels.isEmpty
        )
        .copy(error: nil)
      }
    case .failure(let error):
      setState {
        $0.copy(
          addDocumentCellModels: [],
          error: link == nil
          ? .init(
            description: .custom(error.localizedDescription),
            cancelAction: self.setState { $0.copy(error: nil) },
            action: { Task { await self.initialize() } }
          )
          : nil
        )
      }
    }
    if let link {
      handleDeepLink(with: link)
    } else {
      await handleResumeIssuance()
    }
  }

  func onClick(configId: String, docTypeIdentifier: DocumentTypeIdentifier) {
    issueDocument(configId: configId, docTypeIdentifier: docTypeIdentifier)
  }

  func onScanClick() {
    var successNavigation: UIConfig.TwoWayNavigationType {
      switch viewState.config.flow {
      case .noDocument:
        .push(.featureDashboardModule(.dashboard))
      case .extraDocument:
        .popTo(.featureDashboardModule(.dashboard))
      }
    }

    router.push(
      with: .featureCommonModule(
        .qrScanner(
          config: ScannerUiConfig(
            flow: .issuing(
              successNavigation: successNavigation,
              cancelNavigation: .popTo(
                .featureIssuanceModule(
                  .issuanceAddDocument(config: viewState.config)
                )
              )
            )
          )
        )
      )
    )
  }

  func pop() {
    router.pop()
  }

  func toolbarContent() -> ToolBarContent? {
    return switch viewState.config.flow {
    case .noDocument:
      nil
    case .extraDocument:
        .init(
          trailingActions: [],
          leadingActions: [
            .init(image: Theme.shared.image.chevronLeft) {
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
      await fetchStoredDocuments(docId: docId)
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

  private func issueDocument(configId: String, docTypeIdentifier: DocumentTypeIdentifier) {
    Task {
      setState {
        $0.copy(
          addDocumentCellModels: transformCellLoadingState(with: true)
        )
        .copy(error: nil)
      }

      let state = await Task.detached { () -> IssueResultPartialState in
        return await self.interactor.issueDocument(configId: configId, docTypeIdentifier: docTypeIdentifier)
      }.value

      switch state {
      case .success(let docId):
        await fetchStoredDocuments(docId: docId)
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

    var subTitle: LocalizableStringKey {
      if documentName.isEmpty {
        return .scopedIssuanceSuccessDeferredCaptionDocName([documentName])
      } else if !documentName.isEmpty, !issuerName.isEmpty {
        return .scopedIssuanceSuccessDeferredCaptionDocNameAndIssuer([documentName, issuerName])
      } else {
        return .scopedIssuanceSuccessDeferredCaption
      }
    }

    return .featureCommonModule(
      .genericSuccess(
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

  private func fetchStoredDocuments(docId: String) async {
    let state = await Task.detached { () -> IssueDocumentsPartialState in
      return await self.interactor.fetchStoredDocuments(
        documentIds: [docId]
      )
    }.value

    let onSuccesNavigation = switch viewState.config.flow {
    case .noDocument:
      UIConfig.DeepLinkNavigationType.push(screen: .featureDashboardModule(.dashboard))
    case .extraDocument:
      UIConfig.DeepLinkNavigationType.pop(screen: .featureDashboardModule(.dashboard))
    }

    switch state {
    case .success(let documents):
      router.push(
        with: .featureIssuanceModule(
          .issuanceSuccess(
            config: DocumentSuccessUIConfig(
              successNavigation: onSuccesNavigation,
              relyingParty: documents.first?.issuer?.name,
              issuerLogoUrl: documents.first?.issuer?.logoUrl,
              relyingPartyIsTrusted: false
            ),
            requestItems: documents.map { item in
              ListItemSection(
                id: item.id,
                title: item.documentName,
                listItems: item.documentFields
              )
            }
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
    }
  }
}
