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
import Foundation
import logic_core
import logic_resources

public enum TransactionDetailsInteractorPartialState: Sendable {
  case success(transactionDetailsUi: TransactionDetailsUiModel)
  case failure(error: Error)
}

public enum TransactionDeletionPartialState: Sendable {
  case success
  case failure(error: Error)
}

public enum TransactionDataProtectionPartialState: Sendable {
  case success(url: URL)
  case unavailable
  case failure(error: Error)
}

public enum TransactionActionPartialState: Sendable {
  case success(ui: TransactionActionUiModel)
  case failure(error: Error)
}

public enum TransactionActionHistoryPartialState: Sendable {
  case success(ui: TransactionActionHistoryUiModel)
  case failure(error: Error)
}

public protocol TransactionDetailsInteractor: Sendable {
  func getTransactionDetails(transactionId: String) async -> TransactionDetailsInteractorPartialState
  func deleteTransaction(transactionId: String) async -> TransactionDeletionPartialState
  func getDataProtectionAction(transactionId: String, action: TransactionDataProtectionAction) async -> TransactionActionPartialState
  func getDataProtectionActionHistory(transactionId: String, action: TransactionDataProtectionAction) async -> TransactionActionHistoryPartialState
  func performDataProtectionAction(
    transactionId: String,
    action: TransactionDataProtectionAction,
    contactUrl: URL
  ) async -> TransactionDataProtectionPartialState
}

final actor TransactionDetailsInteractorImpl: TransactionDetailsInteractor {

  private let walletController: WalletKitController

  init(
    walletController: WalletKitController
  ) {
    self.walletController = walletController
  }

  public func getTransactionDetails(transactionId: String) async -> TransactionDetailsInteractorPartialState {
    do {
      let transaction = try await walletController.fetchTransactionLog(with: transactionId)
      let actions: [TransactionLogDomain] = if case .presentation = transaction {
        (try? await walletController.fetchPresentationActions(parentPresentationId: transactionId)) ?? []
      } else {
        []
      }
      return .success(
        transactionDetailsUi: transaction.toUiModel(actions: actions)
      )
    } catch {
      return .failure(error: error)
    }
  }

  public func deleteTransaction(transactionId: String) async -> TransactionDeletionPartialState {
    do {
      try await walletController.deleteTransactionLog(with: transactionId)
      return .success
    } catch {
      return .failure(error: error)
    }
  }

  public func getDataProtectionAction(
    transactionId: String,
    action: TransactionDataProtectionAction
  ) async -> TransactionActionPartialState {
    do {
      guard case .presentation(let presentation) = try await walletController.fetchTransactionLog(with: transactionId) else {
        return .failure(error: WalletCoreError.unableToFetchTransactionLog)
      }
      return .success(ui: presentation.toActionUiModel(transactionId: transactionId, action: action))
    } catch {
      return .failure(error: error)
    }
  }

  public func getDataProtectionActionHistory(
    transactionId: String,
    action: TransactionDataProtectionAction
  ) async -> TransactionActionHistoryPartialState {
    do {
      guard case .presentation(let presentation) = try await walletController.fetchTransactionLog(with: transactionId) else {
        return .failure(error: WalletCoreError.unableToFetchTransactionLog)
      }
      let actions = (try? await walletController.fetchPresentationActions(parentPresentationId: transactionId)) ?? []
      return .success(ui: presentation.toActionHistoryUiModel(action: action, actions: actions))
    } catch {
      return .failure(error: error)
    }
  }

  public func performDataProtectionAction(
    transactionId: String,
    action: TransactionDataProtectionAction,
    contactUrl: URL
  ) async -> TransactionDataProtectionPartialState {
    do {
      guard
        case .presentation(let presentation) = try await walletController.fetchTransactionLog(with: transactionId),
        presentation.contacts(for: action).contains(where: { $0.url == contactUrl })
      else {
        return .unavailable
      }
      let date = presentation.time.formattedTimestamp().toString
      let url: URL
      switch action {
      case .requestDataDeletion:
        try await walletController.recordDataDeletionRequest(for: presentation, contactUrl: contactUrl)
        url = contactUrl.withMailContent(
          subject: LocalizableStringKey.transactionDetailsDeletionEmailSubject([date]).toString,
          body: LocalizableStringKey.transactionDetailsDeletionEmailBody([presentation.partyIdentity, date]).toString
        )
      case .reportSuspiciousTransaction:
        try await walletController.recordDpaReport(for: presentation, contactUrl: contactUrl)
        url = contactUrl.withMailContent(
          subject: LocalizableStringKey.transactionDetailsReportEmailSubject([date]).toString,
          body: LocalizableStringKey.transactionDetailsReportEmailBody([presentation.partyIdentity, date]).toString
        )
      }
      return .success(url: url)
    } catch {
      return .failure(error: error)
    }
  }
}
