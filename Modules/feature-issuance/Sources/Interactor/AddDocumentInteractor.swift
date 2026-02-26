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
import logic_resources
import feature_common
import logic_core
import OrderedCollections

public protocol AddDocumentInteractor: Sendable {
  func fetchScopedDocuments(with flow: IssuanceFlowUiConfig.Flow) async -> ScopedDocumentsPartialState
  func issueDocument(
    issuerId: String,
    configIds: [String],
    docTypeIdentifier: DocumentTypeIdentifier
  ) async -> IssueResultPartialState
  func resumeDynamicIssuance() async -> IssueDynamicDocumentPartialState
  func fetchStoredDocuments(documentIds: [String]) async -> IssueDocumentsPartialState
}

final actor AddDocumentInteractorImpl: AddDocumentInteractor {

  private let walletController: WalletKitController

  init(
    walletController: WalletKitController
  ) {
    self.walletController = walletController
  }

  public func fetchScopedDocuments(
    with flow: IssuanceFlowUiConfig.Flow
  ) async -> ScopedDocumentsPartialState {

    struct IssuerBucket {
      var items: [AddDocumentUIModel] = []
      var pidConfigIds: [String] = []
      var pidDocTypeIdentifier: DocumentTypeIdentifier = .other(formatType: "")
      var issuerId: String = ""
    }

    do {
      let scoped = try await walletController.getScopedDocuments()
      var buckets: [String: IssuerBucket] = [:]

      for doc in scoped {
        switch flow {
        case .noDocument:
          guard doc.isPid else { continue }

        case .extraDocument(let identifier):
          if let identifier, doc.docTypeIdentifier != identifier { continue }
        }

        let issuerId = doc.issuer
        var bucket = buckets[issuerId, default: IssuerBucket()]

        if doc.isPid {
          bucket.pidConfigIds.append(doc.configId)
          bucket.pidDocTypeIdentifier = doc.docTypeIdentifier
          bucket.issuerId = issuerId
        } else {
          bucket.items.append(
            AddDocumentUIModel(
              listItem: .init(
                mainContent: .text(.custom(doc.name)),
                trailingContent: .icon(Theme.shared.image.plus)
              ),
              isEnabled: true,
              configIds: [doc.configId],
              issuerId: issuerId,
              docTypeIdentifier: doc.docTypeIdentifier
            )
          )
        }

        buckets[issuerId] = bucket
      }

      let grouped: [String: [AddDocumentUIModel]] = buckets.mapValues { bucket in

        var items = bucket.items

        if !bucket.pidConfigIds.isEmpty {
          items.append(
            AddDocumentUIModel(
              listItem: .init(
                mainContent: .text(.pidCombined),
                trailingContent: .icon(Theme.shared.image.plus)
              ),
              isEnabled: true,
              configIds: bucket.pidConfigIds,
              issuerId: bucket.issuerId,
              docTypeIdentifier: bucket.pidDocTypeIdentifier
            )
          )
        }

        return items.sorted(by: compare)
      }

      let ordered = OrderedDictionary<String, [AddDocumentUIModel]>(
        uniqueKeysWithValues: grouped.sorted {
          $0.key.localizedCompare($1.key) == .orderedAscending
        }
      )

      return .success(ordered)
    } catch {
      return .failure(error)
    }

    func compare(_ a: AddDocumentUIModel, _ b: AddDocumentUIModel) -> Bool {
      a.listItem.mainContent.asString
        .localizedCaseInsensitiveCompare(b.listItem.mainContent.asString) == .orderedAscending
    }
  }

  public func issueDocument(
    issuerId: String,
    configIds: [String],
    docTypeIdentifier: DocumentTypeIdentifier
  ) async -> IssueResultPartialState {
    do {

      let docs = try await walletController.issueDocuments(
        issuerId: issuerId,
        identifiers: configIds,
        docTypeIdentifier: docTypeIdentifier
      )

      guard !docs.isEmpty else {
        return .failure(WalletCoreError.unableToIssueAndStore)
      }

      var deferredDocument: ScopedDocument?
      var successIds: [String] = []
      var dynamicIssuanceCoordinator: RemoteSessionCoordinator?
      var error: Error?

      for doc in docs {
        if doc.isDeferred {
          guard
            let configId = DocMetadata(from: doc.metadata)?.configurationIdentifier,
            let document = try? await getScopedDocument(configId: configId)
          else {
            error = WalletCoreError.unableToIssueAndStore
            continue
          }
          deferredDocument = document
        } else if let authorizePresentationUrl = doc.authorizePresentationUrl {
          guard dynamicIssuanceCoordinator == nil else { continue }
          guard
            let presentationUrl = authorizePresentationUrl.toCompatibleUrl(),
            let presentationComponents = URLComponents(url: presentationUrl, resolvingAgainstBaseURL: true)
          else {
            error = WalletCoreError.unableToIssueAndStore
            continue
          }
          let session = await walletController.startSameDevicePresentation(deepLink: presentationComponents)
          dynamicIssuanceCoordinator = session
        } else {
          successIds.append(doc.id)
        }
      }

      if let error {
        return .failure(error)
      } else if !successIds.isEmpty {
        return .success(successIds)
      } else if let deferredDocument {
        return .deferredSuccess(deferredDocument)
      } else if let session = dynamicIssuanceCoordinator {
        return .dynamicIssuance(session)
      } else {
        return .failure(WalletCoreError.unableToIssueAndStore)
      }

    } catch {
      return .failure(error)
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
      return .failure(error)
    }
  }

  func fetchStoredDocuments(documentIds: [String]) async -> IssueDocumentsPartialState {
    let documents = await walletController.fetchDocuments(with: documentIds)
    let documentsDetails = documents.compactMap {
      $0.transformToDocumentUi(isSensitive: false)
    }

    if documentsDetails.isEmpty {
      return .failure(WalletCoreError.unableFetchDocument)
    }
    return .success(documentsDetails)
  }

  private func getScopedDocument(configId: String) async throws -> ScopedDocument {
    try await walletController.getScopedDocuments().first {
      $0.configId == configId
    } ?? ScopedDocument.empty()
  }
}

public enum ScopedDocumentsPartialState: Sendable {
  case success(OrderedDictionary<String, [AddDocumentUIModel]>)
  case failure(Error)
}

public enum IssueResultPartialState: Sendable {
  case success([String])
  case deferredSuccess(ScopedDocument)
  case dynamicIssuance(RemoteSessionCoordinator)
  case failure(Error)
}

public enum IssueDynamicDocumentPartialState: Sendable {
  case success(String)
  case noPending
  case deferredSuccess
  case failure(Error)
}

public enum IssueDocumentsPartialState: Sendable {
  case success([DocumentUIModel])
  case failure(Error)
}
