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
  let error: ContentErrorView.Config?
  let title: LocalizableString.Key
  let caption: LocalizableString.Key?
  let holderName: String?
  let config: IssuanceFlowUiConfig
  let documentIdentifier: String
}

final class DocumentSuccessViewModel<Router: RouterHost>: BaseViewModel<Router, DocumentSuccessState> {

  private let interactor: DocumentSuccessInteractor

  public init(
    router: Router,
    interactor: DocumentSuccessInteractor,
    config: any UIConfigType,
    documentIdentifier: String
  ) {

    guard let config = config as? IssuanceFlowUiConfig else {
      fatalError("ExternalLoginViewModel:: Invalid configuraton")
    }

    self.interactor = interactor

    super.init(
      router: router,
      initialState: .init(
        error: nil,
        title: .issuanceSuccessTitle,
        caption: nil,
        holderName: nil,
        config: config,
        documentIdentifier: documentIdentifier
      )
    )
  }

  func initialize() async {
    setNewState(
      caption: interactor.getDocumentSuccessCaption(for: viewState.documentIdentifier),
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
    error: ContentErrorView.Config? = nil,
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
