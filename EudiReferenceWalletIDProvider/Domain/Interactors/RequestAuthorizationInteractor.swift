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
import IdentityDocumentServicesUI
import DcApi18013AnnexC
import IdentityDocumentServices
import Foundation

protocol RequestAuthorizationInteractor: Sendable {
  func loadRequestData(
    context: ISO18013MobileDocumentRequestContext
  ) async throws -> AuthorizationUIModel

  func acceptVerification(
    context: ISO18013MobileDocumentRequestContext
  ) async throws
}

final actor RequestAuthorizationInteractorImpl: RequestAuthorizationInteractor {

  private let dcApiHandler: DcApiHandler

  init(
    dcApiHandler: DcApiHandler
  ) {
    self.dcApiHandler = dcApiHandler
  }

  func loadRequestData(
    context: ISO18013MobileDocumentRequestContext
  ) async throws -> AuthorizationUIModel {
    let (set, _, rn) = try await dcApiHandler.validateRequest(context.request)
    let websiteName = context.requestingWebsiteOrigin?.absoluteString ?? rn ?? "Website name not available"

    return AuthorizationUIModel(
      issuerName: websiteName,
      document: set.requests.map { request in
        let requestedElements = request.namespaces.flatMap { namespace, elements in
          elements.keys.map { key in
            AuthorizationUIRequestedElement(
              namespace: namespace,
              elementKey: key
            )
          }
        }

        return AuthorizationUIDocument(
          name: request.documentType,
          requestedElements: requestedElements
        )
      }
    )
  }

  func acceptVerification(
    context: ISO18013MobileDocumentRequestContext
  ) async throws {
    try await context.sendResponse { rawRequest in

      try await self.dcApiHandler.validateConsistency(
        request: context.request,
        rawRequest: rawRequest
      )

      try await self.dcApiHandler.validateRawRequest(rawRequest: rawRequest)

      let responseData = try await self.dcApiHandler.buildAndEncryptResponse(
        rawRequest: rawRequest,
        originUrl: context.requestingWebsiteOrigin?.absoluteString
      )

      return ISO18013MobileDocumentResponse(responseData: responseData)
    }
  }
}
