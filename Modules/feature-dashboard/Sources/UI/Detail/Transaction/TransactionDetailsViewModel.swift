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
struct TransactionDetailsViewState: ViewState {
  let title: LocalizableStringKey
  let transactionDetailsUi: TransactionDetailsUiModel?
  let isLoading: Bool
  let error: ContentErrorView.Config?
  let transactionId: String
}

@Observable
final class TransactionDetailsViewModel<Router: RouterHost>: ViewModel<Router, TransactionDetailsViewState> {
  var isDeletionModalShowing: Bool = false

  @ObservationIgnored
  private let interactor: TransactionDetailsInteractor

  init(
    router: Router,
    interactor: TransactionDetailsInteractor,
    transactionId: String
  ) {
    self.interactor = interactor
    super.init(
      router: router,
      initialState: .init(
        title: .transactionInformation,
        transactionDetailsUi: TransactionDetailsUiModel.mock(),
        isLoading: true,
        error: nil,
        transactionId: transactionId
      )
    )
  }

  func getTransactionDetails() async {

    let transactionId = viewState.transactionId

    self.setState { $0.copy(isLoading: true).copy(error: nil) }

    let state = await interactor.getTransactionDetails(transactionId: transactionId)

    switch state {
    case .success(let transactions):
      self.setState {
        $0.copy(
          transactionDetailsUi: transactions,
          isLoading: false
        )
      }
    case .failure(let error):
      self.setState {
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

  func onShowDeleteModal() {
    guard !viewState.isLoading else { return }
    isDeletionModalShowing = true
  }

  func onDeleteTransaction() {
    isDeletionModalShowing = false
    self.setState { $0.copy(isLoading: true).copy(error: nil) }
    Task {
      switch await interactor.deleteTransaction(transactionId: viewState.transactionId) {
      case .success:
        pop()
      case .failure:
        self.setState {
          $0.copy(
            isLoading: false,
            error: .init(
              description: .transactionDetailsDeleteError,
              cancelAction: self.dismissError(),
              action: { self.onDeleteTransaction() }
            )
          )
        }
      }
    }
  }

  func onReportModal() {
    onDataProtectionAction(.reportSuspiciousTransaction)
  }

  func onRequestDataDeletion() {
    onDataProtectionAction(.requestDataDeletion)
  }

  func onPreviousActions(_ action: TransactionDataProtectionAction) {
    guard !viewState.isLoading, viewState.transactionDetailsUi?.presentationActions != nil else { return }
    router.push(with: .featureDashboardModule(.transactionActionHistory(id: viewState.transactionId, action: action)))
  }

  private func onDataProtectionAction(_ action: TransactionDataProtectionAction) {
    guard
      !viewState.isLoading,
      let actions = viewState.transactionDetailsUi?.presentationActions,
      !actions.contacts(for: action).isEmpty
    else {
      return
    }
    router.push(with: .featureDashboardModule(.transactionAction(id: viewState.transactionId, action: action)))
  }

  func toolbarContent() -> ToolBarContent? {
    .init(
      trailingActions: [
        .init(
          image: Theme.shared.image.trash,
          accessibilityLocator: TransactionDetailsLocators.deleteNavigationBarButton,
          disabled: viewState.isLoading || viewState.error != nil
        ) {
          self.onShowDeleteModal()
        }
      ],
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
    router.popTo(with: .featureDashboardModule(.dashboard))
  }

  private func dismissError() {
    self.setState { $0.copy(error: nil) }
  }
}
