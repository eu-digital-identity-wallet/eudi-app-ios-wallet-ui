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
import UIKit

struct BaseLoadingState: ViewState {
  let error: ContentError.Config?
  let title: LocalizableString.Key
  let caption: LocalizableString.Key
  let config: IssuanceFlowUiConfig
}

@MainActor
final class ExternalLoginViewModel<Router: RouterHostType, Interactor: ExternalLoginInteractorType>: BaseViewModel<Router, BaseLoadingState> {

  private let interactor: Interactor

  public init(router: Router, interactor: Interactor, config: any UIConfigType, documentName: String) {
    guard let config = config as? IssuanceFlowUiConfig else {
      fatalError("ExternalLoginViewModel:: Invalid configuraton")
    }
    self.interactor = interactor
    super.init(
      router: router,
      initialState: .init(
        error: nil,
        title: .issuanceExternalLoadingTitle([documentName]),
        caption: .issuanceExternalLoadingCaption,
        config: config
      )
    )
  }

  func onPop() {
    router.pop()
  }

  // MARK: - TODO Uncomment the interactor and connect with core once integration started
  func initialize() async {

    try? await Task.sleep(nanoseconds: 2.nanoseconds)
    router.push(with: .issuanceSuccess(config: viewState.config))

    //    switch await interactor.handleExternalLogin() {
    //    case .success(let url):
    //      await UIApplication.shared.open(url)
    //    case .failure(let error):
    //      self.setNewState(
    //        error: .init(
    //          description: .custom(error.localizedDescription),
    //          cancelAction: self.onErrorAction()
    //        )
    //      )
    //    }
  }

  private func onErrorAction() {
    setNewState(error: nil)
    Task {
      await self.initialize()
    }
  }

  private func setNewState(
    error: ContentError.Config? = nil
  ) {
    setState { previous in
        .init(
          error: error,
          title: previous.title,
          caption: previous.caption,
          config: previous.config
        )
    }
  }
}
