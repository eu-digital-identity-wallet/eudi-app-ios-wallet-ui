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
import logic_resources
import feature_common
import logic_core
import logic_authentication
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
  private let sessionController: SessionController

  init(
    walletController: WalletKitController,
    sessionController: SessionController
  ) {
    self.walletController = walletController
    self.sessionController = sessionController
  }

  public func fetchScopedDocuments(
    with flow: IssuanceFlowUiConfig.Flow
  ) async -> ScopedDocumentsPartialState {

    struct IssuerBucket {
      var items: [AddDocumentUIModel] = []
      var pidConfigIds: [String] = []
      var pidDocTypeIdentifier: DocumentTypeIdentifier = .other(formatType: "")
      var issuerId: String = ""
      var order: Int = 0
    }

    let result = await walletController.getScopedDocuments()
    if result.allIssuersFailed {
      return result.errors.contains(where: { $0.isTrustBlocked })
      ? .issuerNotTrusted
      : .failure(result.errors.first ?? WalletCoreError.unableFetchDocuments)
    }

    let scoped = result.documents
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
        bucket.order = doc.order
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
            order: doc.order,
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
            order: bucket.order,
            docTypeIdentifier: bucket.pidDocTypeIdentifier
          )
        )
      }

      items.sort(by: compare)
      return items
    }

    let orderedPairs: [(String, [AddDocumentUIModel])] = grouped
      .sorted { lhs, rhs in
        let lhsOrder = lhs.value.map(\.order).max() ?? Int.min
        let rhsOrder = rhs.value.map(\.order).max() ?? Int.min

        if lhsOrder != rhsOrder { return lhsOrder > rhsOrder }
        return lhs.key.localizedCompare(rhs.key) == .orderedAscending
      }

    let ordered = OrderedDictionary<String, [AddDocumentUIModel]>(
      uniqueKeysWithValues: orderedPairs
    )

    return .success(ordered)

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
      if case .blocked(let reason) = try await walletController.getIssuerRegistration(
        issuerId: issuerId,
        configIds: configIds
      ) {
        return .registrationBlocked(reason)
      }

      let issuance = try await sessionController.duringExternalFlow {
        try await walletController.issueDocuments(
          issuerId: issuerId,
          identifiers: configIds,
          docTypeIdentifier: docTypeIdentifier
        )
      }
      let docs = issuance.documents

      if !issuance.issuerRegistration.vouchesForIssuer {
        await discard(docs)
        return .issuerNotTrusted
      }

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
        return .success(
          successIds,
          notIssuedDocumentNames: await notIssuedDocumentNames(
            requested: configIds,
            returned: docs.map { DocMetadata(from: $0.metadata)?.configurationIdentifier }
          )
        )
      } else if let deferredDocument {
        return .deferredSuccess(deferredDocument)
      } else if let session = dynamicIssuanceCoordinator {
        return .dynamicIssuance(session)
      } else {
        return .failure(WalletCoreError.unableToIssueAndStore)
      }

    } catch {
      return error.isTrustBlocked ? .issuerNotTrusted : .failure(error)
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
      return error.isTrustBlocked ? .issuerNotTrusted : .failure(error)
    }
  }

  func fetchStoredDocuments(documentIds: [String]) async -> IssueDocumentsPartialState {
    let documents = await walletController.fetchDocuments(with: documentIds)
    let issuerLogoOrigins = await walletController.issuerLogoOrigins()
    let documentsDetails = documents.compactMap {
      $0.transformToDocumentUi(isSensitive: false, issuerLogoOrigins: issuerLogoOrigins)
    }

    if documentsDetails.isEmpty {
      return .failure(WalletCoreError.unableFetchDocument)
    }
    return .success(documentsDetails)
  }

  private func discard(_ documents: [WalletStorage.Document]) async {
    for document in documents {
      try? await walletController.deleteDocument(with: document.id, status: document.status)
    }
  }

  /// The names of the requested configurations the issuer did not issue, from the issuer's list, as Android names
  /// them. Nothing is named when a returned document does not say which configuration it is.
  private func notIssuedDocumentNames(requested: [String], returned: [String?]) async -> [String] {
    let missing = Self.notIssuedConfigIds(requested: requested, returned: returned)
    guard !missing.isEmpty else { return [] }
    let scoped = await walletController.getScopedDocuments().documents
    return missing.map { configId in
      scoped.first { $0.configId == configId }?.name ?? configId
    }
  }

  /// The requested configuration ids that no returned document carries; empty when a returned document has no id.
  static func notIssuedConfigIds(requested: [String], returned: [String?]) -> [String] {
    let returnedIds = returned.compactMap { $0 }
    guard returnedIds.count == returned.count else { return [] }
    return requested.filter { !returnedIds.contains($0) }
  }

  private func getScopedDocument(configId: String) async throws -> ScopedDocument {
    await walletController.getScopedDocuments().documents.first {
      $0.configId == configId
    } ?? ScopedDocument.empty()
  }
}

public enum ScopedDocumentsPartialState: Sendable {
  case success(OrderedDictionary<String, [AddDocumentUIModel]>)
  case issuerNotTrusted
  case failure(Error)
}

public enum IssueResultPartialState: Sendable {
  /// The documents issued, and the names of those the request asked for that the issuer did not issue.
  case success([String], notIssuedDocumentNames: [String])
  case deferredSuccess(ScopedDocument)
  case dynamicIssuance(RemoteSessionCoordinator)
  case issuerNotTrusted
  case registrationBlocked(IssuerRegistration.BlockedReason)
  case failure(Error)
}

public enum IssueDynamicDocumentPartialState: Sendable {
  case success(String)
  case noPending
  case deferredSuccess
  case issuerNotTrusted
  case failure(Error)
}

public enum IssueDocumentsPartialState: Sendable {
  case success([DocumentUIModel])
  case failure(Error)
}
