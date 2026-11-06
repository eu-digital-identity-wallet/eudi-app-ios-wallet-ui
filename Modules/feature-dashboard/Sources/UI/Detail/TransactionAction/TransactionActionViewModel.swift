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
  @ObservationIgnored
  private let openURL: @MainActor (URL) async -> Bool

  /// - Parameter openURL: Hands a contact to the system, `UIApplication.open` by default; tests record it.
  init(
    router: Router,
    interactor: TransactionDetailsInteractor,
    transactionId: String,
    action: TransactionDataProtectionAction,
    openURL: @escaping @MainActor (URL) async -> Bool = { await UIApplication.shared.open($0) }
  ) {
    self.interactor = interactor
    self.openURL = openURL
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
        await openActionChannel(url, contactUrl: contact.url)
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

  /// Hands the request to the system and records it only once the hand-off succeeded, so a failed attempt and its
  /// retry leave exactly one record.
  func openActionChannel(_ url: URL, contactUrl: URL) async {
    let opened = await openURL(url)
    guard opened else {
      setState {
        $0.copy(isLoading: false, externalAction: .idle)
          .copy(
            error: .init(
              description: .transactionDetailsActionOpenFailed,
              cancelAction: self.dismissError(),
              action: { Task { await self.openActionChannel(url, contactUrl: contactUrl) } }
            )
          )
      }
      return
    }
    await recordActionChannel(contactUrl: contactUrl)
  }

  /// Records a request already handed off. A failed record offers to record it again, never to hand it off again,
  /// as on Android.
  private func recordActionChannel(contactUrl: URL) async {
    switch await interactor.recordDataProtectionAction(
      transactionId: viewState.transactionId,
      action: viewState.action,
      contactUrl: contactUrl
    ) {
    case .success:
      setState {
        $0.copy(isLoading: false, externalAction: .opened).copy(error: nil)
      }
    case .unavailable:
      setState {
        $0.copy(isLoading: false, externalAction: .idle)
          .copy(error: .init(description: .transactionDetailsActionUnavailable, cancelAction: self.dismissError()))
      }
    case .failure:
      setState {
        $0.copy(isLoading: false, externalAction: .idle)
          .copy(
            error: .init(
              description: .transactionDetailsActionError,
              cancelAction: self.dismissError(),
              action: { Task { await self.recordActionChannel(contactUrl: contactUrl) } }
            )
          )
      }
    }
  }

  private func dismissError() {
    setState { $0.copy(error: nil) }
  }
}
