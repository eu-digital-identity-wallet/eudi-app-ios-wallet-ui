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
import logic_resources
import feature_common

@Copyable
struct OfferCodeViewState: ViewState {
  let isLoading: Bool
  let error: ContentErrorView.Config?
  let config: IssuanceCodeUiConfig
  let title: LocalizableStringKey
  let caption: LocalizableStringKey
  let contentHeaderConfig: ContentHeaderConfig
}

final class OfferCodeViewModel<Router: RouterHost>: ViewModel<Router, OfferCodeViewState> {

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
        caption: .issuanceCodeCaption([config.txCodeLength.string]),
        contentHeaderConfig: .init(
          appIconAndTextData: AppIconAndTextData(
            appIcon: ThemeManager.shared.image.logoEuDigitalIndentityWallet,
            appText: ThemeManager.shared.image.euditext
          )
        )
      )
    )

    subscribeToCodeInput()
  }

  func checkPendingIssuance() async {

    let config: IssuanceCodeUiConfig = viewState.config
    let interactor = self.interactor

    let state = await Task.detached { () -> OfferDynamicIssuancePartialState in
      return await interactor.resumeDynamicIssuance(
        issuerName: config.issuerName,
        successNavigation: config.successNavigation
      )
    }.value

    switch state {
    case .success(let route):
      router.push(with: route)
    case .noPending: break
    case .failure(let error):
      setState {
        $0.copy(
          isLoading: false,
          error: .init(
            description: .custom(error.localizedDescription),
            cancelAction: self.setState { $0.copy(error: nil) }
          )
        )
      }
    }
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

  func toolbarContent() -> ToolBarContent {
    .init(
      trailingActions: [],
      leadingActions: [
        .init(image: Theme.shared.image.chevronLeft) {
          self.onPop()
        }
      ]
    )
  }

  private func onIssueDocuments() {
    Task {

      codeIsFocused = false
      setState { $0.copy(isLoading: true).copy(error: nil) }

      let config = viewState.config
      let interactor = self.interactor
      let codeInput = self.codeInput

      let state = await Task.detached { () -> OfferResultPartialState in
        return await interactor.issueDocuments(
          with: config.offerUri,
          issuerName: config.issuerName,
          docOffers: config.docOffers,
          successNavigation: config.successNavigation,
          txCodeValue: codeInput
        )
      }.value

      switch state {
      case .success(let route):
        router.push(with: route)
      case .dynamicIssuance(let session):
        setState {
          $0.copy(
            isLoading: false
          )
        }
        router.push(
          with: .featurePresentationModule(
            .presentationRequest(
              presentationCoordinator: session,
              originator: .featureIssuanceModule(
                .issuanceCode(config: viewState.config)
              )
            )
          )
        )
      case .failure(let error):
        setState {
          $0.copy(
            isLoading: false,
            error: .init(
              description: .custom(error.localizedDescription),
              cancelAction: self.resetError()
            )
          )
        }
      case .partialSuccess(let route):
        router.push(with: route)
      case .deferredSuccess(let route):
        router.push(with: route)
      }
    }
  }

  private func resetError() {
    self.setState { $0.copy(error: nil) }
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
}
