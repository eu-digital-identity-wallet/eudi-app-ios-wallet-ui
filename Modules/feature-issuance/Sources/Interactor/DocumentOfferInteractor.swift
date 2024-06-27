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
  func issueDocuments(
    with uri: String,
    issuerName: String,
    docOffers: [OfferedDocModel],
    successNavigation: UIConfig.TwoWayNavigationType,
    txCodeValue: String?
  ) async -> IssueOfferDocumentsPartialState
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

      let codeMinLength = 4
      let codeMaxLength = 6

      let offer = try await walletController.resolveOfferUrlDocTypes(uriOffer: uri)
      let hasPidStored = !walletController.fetchDocuments(with: .PID).isEmpty

      if let spec = offer.txCodeSpec,
          let codeLength = spec.length,
         (!(codeMinLength...codeMaxLength).contains(codeLength) || spec.inputMode == .text) {
        return .failure(WalletCoreError.transactionCodeFormat(["\(codeMinLength)", "\(codeMaxLength)"]))
      }

      let hasPidInOffer = offer.docModels.first(
        where: {
          DocumentTypeIdentifier(rawValue: $0.docType) == .PID
        }
      ) != nil

      if !hasPidStored && !hasPidInOffer {
        return .failure(WalletCoreError.missingPid)
      }

      return .success(offer.transformToDocumentOfferUi())
    } catch {
      return .failure(error)
    }
  }

  func issueDocuments(
    with uri: String,
    issuerName: String,
    docOffers: [OfferedDocModel],
    successNavigation: UIConfig.TwoWayNavigationType,
    txCodeValue: String?
  ) async -> IssueOfferDocumentsPartialState {
    do {

      let documents = try await walletController.issueDocumentsByOfferUrl(
        offerUri: uri,
        docTypes: docOffers,
        format: .cbor,
        txCodeValue: txCodeValue
      )

      if documents.isEmpty {
        return .failure(WalletCoreError.unableToIssueAndStore)
      } else if documents.count == docOffers.count {
        return .success(
          retrieveSuccessRoute(
            with: .credentialOfferSuccessCaption([issuerName]),
            and: successNavigation
          )
        )
      } else {

        let notIssued = docOffers.filter { offer in
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

        return .partialSuccess(
          retrieveSuccessRoute(
            with: .credentialOfferPartialSuccessCaption(
              [
                issuerName, notIssued.joined(separator: ", ")
              ]
            ),
            and: successNavigation
          )
        )
      }

    } catch {
      return .failure(WalletCoreError.unableToIssueAndStore)
    }
  }

  private func retrieveSuccessRoute(
    with key: LocalizableString.Key,
    and successNavigation: UIConfig.TwoWayNavigationType
  ) -> AppRoute {

    var navigationType: UIConfig.DeepLinkNavigationType {
      return switch successNavigation {
      case .popTo(let route): .pop(screen: route)
      case .push(let route): .push(screen: route)
      }
    }

    return .success(
      config: UIConfig.Success(
        title: .success,
        subtitle: key,
        buttons: [
          .init(
            title: .credentialOfferSuccessButton,
            style: .primary,
            navigationType: navigationType
          )
        ],
        visualKind: .defaultIcon
      )
    )
  }
}

public enum OfferRequestPartialState {
  case success(DocumentOfferUIModel)
  case failure(Error)
}

public enum IssueOfferDocumentsPartialState {
  case success(AppRoute)
  case partialSuccess(AppRoute)
  case failure(Error)
}
