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

public protocol DocumentOfferInteractor {
  func processOfferRequest(with uri: String) async -> OfferRequestPartialState
  func issueDocuments(with uri: String, and model: DocumentOfferUIModel) async -> IssueOfferDocumentsPartialState
}

final class DocumentOfferInteractorImpl: DocumentOfferInteractor {

  private let walletController: WalletKitController

  init(
    walletController: WalletKitController
  ) {
    self.walletController = walletController
  }

  func processOfferRequest(with uri: String) async -> OfferRequestPartialState {
    do {

      let offers = try await walletController.resolveOfferUrlDocTypes(uriOffer: uri)
      let hasPidStored = !walletController.fetchDocuments(with: .PID).isEmpty

      let hasPidInOffer = offers.first(
        where: {
          DocumentTypeIdentifier(rawValue: $0.docType) == .PID
        }
      ) != nil

      if !hasPidStored && !hasPidInOffer {
        return .failure(WalletCoreError.missingPid)
      }

      return .success(offers.transformToDocumentOfferUi())
    } catch {
      return .failure(error)
    }
  }

  func issueDocuments(with uri: String, and model: DocumentOfferUIModel) async -> IssueOfferDocumentsPartialState {
    do {

      let documents = try await walletController.issueDocumentsByOfferUrl(
        offerUri: uri,
        docTypes: model.docOffers,
        format: .cbor
      )

      if documents.isEmpty {
        return .failure(WalletCoreError.unableToIssueAndStore)
      } else if documents.count == model.docOffers.count {
        return .success
      } else {

        let notIssued = model.docOffers.filter { offer in
          documents.first(
            where: { $0.docType == offer.docType }
          ) == nil
        }.map {
          let identifier = DocumentTypeIdentifier(rawValue: $0.docType)
          if identifier.isSupported {
            return identifier.localizedTitle
          } else {
            return $0.displayName
          }
        }

        return .partialSuccess(notIssued)
      }

    } catch {
      return .failure(WalletCoreError.unableToIssueAndStore)
    }
  }
}

public enum OfferRequestPartialState {
  case success(DocumentOfferUIModel)
  case failure(Error)
}

public enum IssueOfferDocumentsPartialState {
  case success
  case partialSuccess([String])
  case failure(Error)
}
