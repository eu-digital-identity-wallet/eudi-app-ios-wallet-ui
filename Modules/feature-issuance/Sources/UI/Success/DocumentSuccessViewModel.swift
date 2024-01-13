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

struct DocumentSuccessState: ViewState {
  let error: ContentError.Config?
  let title: LocalizableString.Key
  let caption: LocalizableString.Key
  let holderName: String?
  let config: IssuanceFlowUiConfig
  let documentIdentifier: String
}

@MainActor
final class DocumentSuccessViewModel<Router: RouterHostType, Interactor: DocumentSuccessInteractorType>: BaseViewModel<Router, DocumentSuccessState> {

  private let interactor: Interactor

  public init(router: Router, interactor: Interactor, config: any UIConfigType, documentIdentifier: String) {

    guard let config = config as? IssuanceFlowUiConfig else {
      fatalError("ExternalLoginViewModel:: Invalid configuraton")
    }

    self.interactor = interactor

    super.init(
      router: router,
      initialState: .init(
        error: nil,
        title: .issuanceSuccessTitle,
        caption: .custom(""),
        holderName: nil,
        config: config,
        documentIdentifier: documentIdentifier
      )
    )
  }

  // MARK: - TODO REWORK ONCE REAL DATA VIA ISSUING
  func initialize() async {
    await interactor.loadSampleData()
    setNewState(
      caption: .issuanceSuccessCaption([interactor.getDocumentName(for: viewState.documentIdentifier)]),
      holderName: interactor.getHoldersName(for: viewState.documentIdentifier)
    )
  }

  func onIssue() {

    var flow: IssuanceDetailUiConfig.Flow {
      switch viewState.config.flow {
      case .noDocument:
        return .noDocument(viewState.documentIdentifier)
      case .extraDocument:
        return .extraDocument(viewState.documentIdentifier)
      }
    }

    router.push(
      with: .issuanceDocumentDetails(
        config: IssuanceDetailUiConfig(
          flow: flow
        )
      )
    )
  }

  private func setNewState(
    error: ContentError.Config? = nil,
    caption: LocalizableString.Key? = nil,
    holderName: String? = nil
  ) {
    setState { previous in
        .init(
          error: error,
          title: previous.title,
          caption: caption ?? previous.caption,
          holderName: holderName ?? previous.holderName,
          config: previous.config,
          documentIdentifier: previous.documentIdentifier
        )
    }
  }
}