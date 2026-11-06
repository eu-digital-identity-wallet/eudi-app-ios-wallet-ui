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
import IdentityDocumentServicesUI
import DcApi18013AnnexC
import IdentityDocumentServices
import Foundation
import feature_common
import logic_core

protocol RequestAuthorizationInteractor: Sendable {
  func loadRequestData(
    context: ISO18013MobileDocumentRequestContext
  ) async throws -> AuthorizationUIModel

  func acceptVerification(
    context: ISO18013MobileDocumentRequestContext,
    selection: DocumentProviderSelection
  ) async throws

  /// Records the request's history entry as not completed, then tells the system the user cancelled.
  func cancelRequest(context: ISO18013MobileDocumentRequestContext) async
}

final actor RequestAuthorizationInteractorImpl: RequestAuthorizationInteractor {

  private let dcApiHandler: DcApiHandler
  private let configUiLogic: ConfigUiLogic
  private let prefsController: PrefsController
  /// Set once the request's outcome is being recorded, by Accept, a decline or a cancel, so that a later Cancel cannot
  /// rewrite the history entry.
  private var isOutcomeRecorded = false

  private let interactor: WalletKitController = DIGraph.shared.resolver.force(
    WalletKitController.self
  )

  init(
    dcApiHandler: DcApiHandler,
    configUiLogic: ConfigUiLogic,
    prefsController: PrefsController
  ) {
    self.dcApiHandler = dcApiHandler
    self.configUiLogic = configUiLogic
    self.prefsController = prefsController
  }

  /// When the request is declined here, the history entry its validation wrote is recorded as not completed, with
  /// the reason.
  /// A request is declined while the user has turned off offering documents to apps and websites, since one may
  /// still arrive through a registration the system has not yet withdrawn.
  /// A request that would include a document with a revocation record (revoked, suspended or unrecognised) is
  /// declined, as the in-app flows refuse one; when the records cannot be read, the request is declined too.
  /// `DcApiHandler` validates no reader certificate chain and returns no trust verdict, so the relying
  /// party is never reported as verified. The authority key identifier is kept for a later lookup. Without
  /// a website origin the requester gets the generic name, not the one in its unvalidated certificate, as
  /// on Android.
  func loadRequestData(
    context: ISO18013MobileDocumentRequestContext
  ) async throws -> AuthorizationUIModel {
    isOutcomeRecorded = false
    let (docClaimsModels, _, authorityKeyIdentifier, _) = try await dcApiHandler.validateRequest(context.request)
    do {
      try await checkRequest(documentIds: docClaimsModels.map(\.id))
    } catch {
      isOutcomeRecorded = true
      await dcApiHandler.completeTransaction(reasonOfNoncompletion: error.localizedDescription)
      throw error
    }
    let websiteName = context.requestingWebsiteOrigin?.absoluteString ?? LocalizableStringKey.unknownVerifier.toString
    let requestsUserImage = DocumentProviderPolicy.requestsUserImage(
      claimNames: docClaimsModels.flatMap { $0.docClaims.map(\.name) },
      userImageClaimKeys: configUiLogic.userImageClaimKeys
    )
    let issuerLogoOrigins = await interactor.issuerLogoOrigins()
    let documents = docClaimsModels.compactMap {
      $0.transformToDocumentUi(isSensitive: false, issuerLogoOrigins: issuerLogoOrigins)
    }

    return AuthorizationUIModel(
      issuerName: websiteName,
      documents: documents.map { document in
        return AuthorizationUIDocument(
          id: document.id,
          name: document.documentName,
          requestedElements: document.documentFields
        )
      },
      isRelyingPartyVerified: false,
      requestsUserImage: requestsUserImage,
      authorityKeyIdentifier: authorityKeyIdentifier,
      selection: DocumentProviderSelection(documents: docClaimsModels)
    )
  }

  /// Sends only what the sheet showed (`selection`), after checking those documents' records again. The request is
  /// not validated a second time, since each validation starts a new history entry; the entry written when the
  /// request was loaded is completed once the system has taken the response, or given the reason it was not.
  func acceptVerification(
    context: ISO18013MobileDocumentRequestContext,
    selection: DocumentProviderSelection
  ) async throws {
    isOutcomeRecorded = true
    do {
      try await checkRequest(documentIds: Array(selection.documentIds))
      try await context.sendResponse { rawRequest in

        try await self.dcApiHandler.validateConsistency(
          request: context.request,
          rawRequest: rawRequest
        )

        let responseData = try await self.dcApiHandler.buildAndEncryptResponse(
          rawRequest: rawRequest,
          originUrl: context.requestingWebsiteOrigin?.absoluteString,
          selectedDocumentIds: selection.documentIds,
          selectedClaimsByDocumentId: selection.claimsByDocumentId
        )

        return ISO18013MobileDocumentResponse(responseData: responseData)
      }
      await dcApiHandler.completeTransaction()
    } catch {
      await dcApiHandler.completeTransaction(reasonOfNoncompletion: error.localizedDescription)
      throw error
    }
  }

  /// After Accept, a decline or an earlier cancel the outcome is already recorded, so only the sheet is closed.
  func cancelRequest(context: ISO18013MobileDocumentRequestContext) async {
    if !isOutcomeRecorded {
      isOutcomeRecorded = true
      await dcApiHandler.completeTransaction(reasonOfNoncompletion: Constants.cancelledByUser)
    }
    context.cancel()
  }

  /// Checks the setting and the revocation records again on every step, since either may change while the sheet is
  /// open (`DocumentProviderPolicy.checkRequest`); records that cannot be read decline the request.
  private func checkRequest(documentIds: [String]) async throws {
    let blocked = try await interactor.fetchRevokedDocumentStatuses()
    try DocumentProviderPolicy.checkRequest(
      isOffering: prefsController.getBool(forKey: .offerDocumentsToApps),
      requestedDocumentIds: documentIds,
      blockedDocumentIds: Set(blocked.keys)
    )
  }
}

private extension RequestAuthorizationInteractorImpl {

  enum Constants {
    /// The reason recorded for a request the user closed without sharing.
    static let cancelledByUser = "Cancelled by the user"
  }
}
