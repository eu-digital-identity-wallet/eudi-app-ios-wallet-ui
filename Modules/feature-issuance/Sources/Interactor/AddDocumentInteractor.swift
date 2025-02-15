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
import feature_common
import logic_business
import logic_core

public protocol AddDocumentInteractor: Sendable {
  func fetchScopedDocuments(with flow: IssuanceFlowUiConfig.Flow) async -> StoredDocumentsPartialState
  func issueDocument(configId: String) async -> IssueDocumentPartialState
  func resumeDynamicIssuance() async -> IssueDynamicDocumentPartialState
  func getScopedDocument(configId: String) async throws -> ScopedDocument

  func getHoldersName(for documentIdentifier: String) -> String?
  func getDocumentSuccessCaption(for documentIdentifier: String) -> LocalizableStringKey?
  func fetchStoredDocuments(documentIds: [String]) async -> DocumentsPartialState
}

final class AddDocumentInteractorImpl: AddDocumentInteractor {

  private let walletController: WalletKitController

  init(
    walletController: WalletKitController
  ) {
    self.walletController = walletController
  }

  public func fetchScopedDocuments(with flow: IssuanceFlowUiConfig.Flow) async -> StoredDocumentsPartialState {
    do {
      let documents: [AddDocumentUIModel] = try await walletController.getScopedDocuments().compactMap { doc in
        if flow == .extraDocument || doc.isPid {
          return .init(
            listItem: .init(
              mainText: .custom(doc.name),
              trailingContent: .icon(Theme.shared.image.plus)
            ),
            isEnabled: true,
            configId: doc.configId
          )
        } else {
          return nil
        }
      }.sorted(by: compare)
      return .success(documents)
    } catch {
      return .failure(error)
    }

    func compare(_ first: AddDocumentUIModel, _ second: AddDocumentUIModel) -> Bool {
      return first.listItem.mainText.toString.lowercased() < second.listItem.mainText.toString.lowercased()
    }
  }

  public func issueDocument(configId: String) async -> IssueDocumentPartialState {
    do {
      let doc = try await walletController.issueDocument(identifier: configId)
      if doc.isDeferred {
        return .deferredSuccess
      } else if let authorizePresentationUrl = doc.authorizePresentationUrl {
        guard
          let presentationUrl = authorizePresentationUrl.toCompatibleUrl(),
          let presentationComponents = URLComponents(url: presentationUrl, resolvingAgainstBaseURL: true) else {
          return .failure(WalletCoreError.unableToIssueAndStore)
        }
        let session = await walletController.startSameDevicePresentation(deepLink: presentationComponents)
        return .dynamicIssuance(session)
      } else {
        return .success(doc.id)
      }
    } catch {
      return .failure(WalletCoreError.unableToIssueAndStore)
    }
  }

  func resumeDynamicIssuance() async -> IssueDynamicDocumentPartialState {

    guard let pendingData = await walletController.getDynamicIssuancePendingData() else {
      return .noPending
    }

    do {

      let doc = try await walletController.resumePendingIssuance(
        pendingDoc: pendingData.pendingDoc,
        webUrl: pendingData.url
      )

      if doc.status == .deferred {
        return .deferredSuccess
      } else if doc.status == .issued {
        return .success(doc.id)
      } else {
        return .failure(WalletCoreError.unableToIssueAndStore)
      }

    } catch {
      return .failure(WalletCoreError.unableToIssueAndStore)
    }
  }

  func getScopedDocument(configId: String) async throws -> ScopedDocument {
    try await walletController.getScopedDocuments().first {
      $0.configId == configId
    } ?? ScopedDocument.empty()
  }

  public func getHoldersName(for documentIdentifier: String) -> String? {
    guard
      let bearerName = walletController.fetchDocument(with: documentIdentifier)?.getBearersName()
    else {
      return nil
    }
    return  "\(bearerName.first) \(bearerName.last)"
  }

  public func getDocumentSuccessCaption(for documentIdentifier: String) -> LocalizableStringKey? {
    guard
      let document = walletController.fetchDocument(with: documentIdentifier)
    else {
      return nil
    }
    return .issuanceSuccessCaption([document.displayName.orEmpty])
  }

  func fetchStoredDocuments(documentIds: [String]) async -> DocumentsPartialState {
    let documents = walletController.fetchDocuments(with: documentIds)
    let documentsDetails = documents.compactMap {
      $0.transformToDocumentDetailsUi(isSensitive: false)
    }

    if documentsDetails.isEmpty {
      return .failure(WalletCoreError.unableFetchDocument)
    }
    return .success(documentsDetails)
  }
}

public enum StoredDocumentsPartialState: Sendable {
  case success([AddDocumentUIModel])
  case failure(Error)
}

public enum IssueDocumentPartialState: Sendable {
  case success(String)
  case deferredSuccess
  case dynamicIssuance(RemoteSessionCoordinator)
  case failure(Error)
}

public enum IssueDynamicDocumentPartialState: Sendable {
  case success(String)
  case noPending
  case deferredSuccess
  case failure(Error)
}
