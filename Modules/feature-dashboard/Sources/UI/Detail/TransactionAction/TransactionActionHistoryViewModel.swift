/*
 * Copyright (c) 2026 European Commission
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
import logic_core
import logic_resources
import feature_common

@Copyable
struct TransactionActionHistoryViewState: ViewState {
  let transactionId: String
  let action: TransactionDataProtectionAction
  let ui: TransactionActionHistoryUiModel
  let isLoading: Bool
  let error: ContentErrorView.Config?
}

@Observable
final class TransactionActionHistoryViewModel<Router: RouterHost>: ViewModel<Router, TransactionActionHistoryViewState> {

  @ObservationIgnored
  private let interactor: TransactionDetailsInteractor

  init(
    router: Router,
    interactor: TransactionDetailsInteractor,
    transactionId: String,
    action: TransactionDataProtectionAction
  ) {
    self.interactor = interactor
    super.init(
      router: router,
      initialState: .init(
        transactionId: transactionId,
        action: action,
        ui: TransactionActionHistoryUiModel.mock(),
        isLoading: true,
        error: nil
      )
    )
  }

  func getContent() async {
    setState { $0.copy(isLoading: true).copy(error: nil) }
    switch await interactor.getDataProtectionActionHistory(transactionId: viewState.transactionId, action: viewState.action) {
    case .success(let ui):
      setState { $0.copy(ui: ui, isLoading: false) }
    case .failure(let error):
      setState {
        $0.copy(
          isLoading: false,
          error: .init(
            description: .custom(error.errorMessage),
            cancelAction: self.router.pop()
          )
        )
      }
    }
  }

  func toolbarContent() -> ToolBarContent? {
    .init(
      leadingActions: [
        .init(
          image: Theme.shared.image.chevronLeft,
          accessibilityLocator: ToolbarLocators.chevronLeft
        ) {
          self.pop()
        }
      ]
    )
  }

  func pop() {
    router.pop()
  }
}
