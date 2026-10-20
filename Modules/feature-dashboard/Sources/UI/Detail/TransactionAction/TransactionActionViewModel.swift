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
import SwiftUI
import UIKit
import logic_ui
import logic_core
import logic_resources
import feature_common

@Copyable
struct TransactionActionViewState: ViewState {
  let transactionId: String
  let action: TransactionDataProtectionAction
  let ui: TransactionActionUiModel
  let isLoading: Bool
  let error: ContentErrorView.Config?
  let externalAction: TransactionActionViewState.ExternalAction
}

extension TransactionActionViewState {
  enum ExternalAction {
    case idle
    case opened
    case leftApp
  }
}

@Observable
final class TransactionActionViewModel<Router: RouterHost>: ViewModel<Router, TransactionActionViewState> {

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
        ui: TransactionActionUiModel.mock(),
        isLoading: true,
        error: nil,
        externalAction: .idle
      )
    )
  }

  func getContent() async {
    setState { $0.copy(isLoading: true).copy(error: nil) }
    switch await interactor.getDataProtectionAction(transactionId: viewState.transactionId, action: viewState.action) {
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

  func onContactSelected(_ contact: TransactionActionContactUi) {
    guard !viewState.isLoading else { return }
    setState { $0.copy(isLoading: true).copy(error: nil).copy(externalAction: .idle) }
    Task {
      switch await interactor.performDataProtectionAction(
        transactionId: viewState.transactionId,
        action: viewState.action,
        contactUrl: contact.url
      ) {
      case .success(let url):
        await openActionChannel(url)
      case .unavailable:
        setState {
          $0.copy(
            isLoading: false,
            error: .init(
              description: .transactionDetailsActionUnavailable,
              cancelAction: self.dismissError()
            )
          )
        }
      case .failure:
        setState {
          $0.copy(
            isLoading: false,
            error: .init(
              description: .transactionDetailsActionError,
              cancelAction: self.dismissError(),
              action: { self.onContactSelected(contact) }
            )
          )
        }
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

  func setPhase(with phase: ScenePhase) {
    switch phase {
    case .background:
      if viewState.externalAction == .opened {
        setState { $0.copy(externalAction: .leftApp) }
      }
    case .active:
      if viewState.externalAction == .leftApp {
        setState { $0.copy(externalAction: .idle) }
        pop()
      }
    default:
      break
    }
  }

  private func openActionChannel(_ url: URL) async {
    let opened = await UIApplication.shared.open(url)
    guard opened else {
      setState {
        $0.copy(isLoading: false, externalAction: .idle)
          .copy(
            error: .init(
              description: .transactionDetailsActionOpenFailed,
              cancelAction: self.dismissError(),
              action: { Task { await self.openActionChannel(url) } }
            )
          )
      }
      return
    }
    setState {
      $0.copy(isLoading: false, externalAction: .opened).copy(error: nil)
    }
  }

  private func dismissError() {
    setState { $0.copy(error: nil) }
  }
}
