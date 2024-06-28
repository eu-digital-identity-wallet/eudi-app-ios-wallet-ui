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

struct OfferCodeViewState: ViewState {
  let isLoading: Bool
  let error: ContentErrorView.Config?
  let config: IssuanceCodeUiConfig
  let title: LocalizableString.Key
  let caption: LocalizableString.Key
}

@MainActor
final class OfferCodeViewModel<Router: RouterHost>: BaseViewModel<Router, OfferCodeViewState> {

  @Published var codeInput: String = ""
  @Published var codeIsFocused: Bool = true

  private let CODE_INPUT_DEBOUNCE = 250
  private let interactor: DocumentOfferInteractor

  init(
    router: Router,
    interactor: DocumentOfferInteractor,
    config: any UIConfigType
  ) {
    guard
      let config = config as? IssuanceCodeUiConfig
    else {
      fatalError("OfferCodeViewModel:: Invalid configuraton")
    }
    self.interactor = interactor
    super.init(
      router: router,
      initialState: .init(
        isLoading: false,
        error: nil,
        config: config,
        title: .issuanceCodeTitle([config.issuerName]),
        caption: .issuanceCodeCaption([config.txCodeLength.string])
      )
    )

    subscribeToCodeInput()
  }

  func onPop() {
    switch viewState.config.navigationCancelType {
    case .popTo(let route):
      router.popTo(with: route)
    case .push(let route):
      router.push(with: route)
    case .pop:
      router.pop()
    }
  }

  private func onIssueDocuments() {
    Task {
      codeIsFocused = false
      setNewState(isLoading: true)
      switch await self.interactor.issueDocuments(
        with: viewState.config.offerUri,
        issuerName: viewState.config.issuerName,
        docOffers: viewState.config.docOffers,
        successNavigation: viewState.config.successNavigation,
        txCodeValue: codeInput
      ) {
      case .success(let route):
        router.push(with: route)
      case .failure(let error):
        setNewState(
          error: ContentErrorView.Config(
            description: .custom(error.localizedDescription),
            cancelAction: self.resetError()
          )
        )
      case .partialSuccess(let route):
        router.push(with: route)
      }
    }
  }

  private func resetError() {
    self.setNewState(error: nil)
    self.codeInput = ""
    self.codeIsFocused = true
  }

  private func subscribeToCodeInput() {
    $codeInput
      .dropFirst()
      .debounce(for: .milliseconds(CODE_INPUT_DEBOUNCE), scheduler: RunLoop.main)
      .removeDuplicates()
      .sink { [weak self] value in
        guard let self = self else { return }
        self.processCode(value: value)
      }.store(in: &cancellables)
  }

  private func processCode(value: String) {
    if value.count == viewState.config.txCodeLength {
      onIssueDocuments()
    }
  }

  private func setNewState(
    isLoading: Bool = false,
    error: ContentErrorView.Config? = nil
  ) {
    setState { previousSate in
        .init(
          isLoading: isLoading,
          error: error,
          config: previousSate.config,
          title: previousSate.title,
          caption: previousSate.caption
        )
    }
  }
}
