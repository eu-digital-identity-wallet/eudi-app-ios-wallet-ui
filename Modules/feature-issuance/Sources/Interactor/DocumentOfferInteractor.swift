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

public protocol DocumentOfferInteractor: Sendable {
  func processOfferRequest(with uri: String) async -> OfferRequestPartialState
  func issueDocuments(
    with uri: String,
    issuerName: String,
    docOffers: [OfferedDocModel],
    successNavigation: UIConfig.TwoWayNavigationType,
    txCodeValue: String?
  ) async -> IssueOfferDocumentsPartialState
  func resumeDynamicIssuance(
    issuerName: String,
    successNavigation: UIConfig.TwoWayNavigationType
  ) async -> OfferDynamicIssuancePartialState
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
      let hasPidStored = !walletController.fetchIssuedDocuments(with: [.mDocPid, .sdJwtPid]).isEmpty

      if let spec = offer.txCodeSpec,
         let codeLength = spec.length,
         !(codeMinLength...codeMaxLength).contains(codeLength) || spec.inputMode == .text {
        return .failure(WalletCoreError.transactionCodeFormat(["\(codeMinLength)", "\(codeMaxLength)"]))
      }

      let hasPidInOffer = offer.docModels.first(
        where: { offer in
          let identifier = DocumentTypeIdentifier(rawValue: offer.docType.ifNilOrEmpty { offer.credentialConfigurationIdentifier })
          // MARK: - TODO Re-activate once SD-JWT PID Rule book is in place in ARF.
          // return identifier == .mDocPid || identifier == .sdJwtPid
          return identifier == .mDocPid
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
        txCodeValue: txCodeValue
      )

      if documents.isEmpty {
        return .failure(WalletCoreError.unableToIssueAndStore)
      } else if documents.first(where: { $0.isDeferred }) != nil {
        return .deferredSuccess(
          retrieveSuccessRoute(
            caption: .issuanceSuccessDeferredCaption([issuerName]),
            successNavigation: successNavigation,
            title: .init(
              value: .inProgress,
              color: Theme.shared.color.pending
            ),
            buttonTitle: .okButton,
            visualKind: .customIcon(
              Theme.shared.image.documentSuccessPending,
              Color.clear
            )
          )
        )
      } else if let authorizePresentationUrl = documents.first?.authorizePresentationUrl {
        guard
          let presentationUrl = authorizePresentationUrl.toCompatibleUrl(),
          let presentationComponents = URLComponents(url: presentationUrl, resolvingAgainstBaseURL: true) else {
          return .failure(WalletCoreError.unableToIssueAndStore)
        }
        let session = await walletController.startSameDevicePresentation(deepLink: presentationComponents)
        return .dynamicIssuance(session)
      } else if documents.count == docOffers.count {
        return .success(
          .featureIssuanceModule(
            .issuanceSuccess(
              config: IssuanceFlowUiConfig(flow: .extraDocument),
              documentIdentifiers: documents.compactMap { $0.id }
            )
          )
        )
      } else {

        let notIssued = docOffers.filter { offer in
          documents.first(
            where: { $0.docType == offer.docType }
          ) == nil
        }.map {
          return $0.displayName
        }

        return .partialSuccess(
          retrieveSuccessRoute(
            caption: .credentialOfferPartialSuccessCaption(
              [
                issuerName, notIssued.joined(separator: ", ")
              ]
            ),
            successNavigation: successNavigation,
            title: .init(value: .success),
            buttonTitle: .credentialOfferSuccessButton,
            visualKind: .defaultIcon
          )
        )
      }

    } catch {
      return .failure(error)
    }
  }

  func resumeDynamicIssuance(
    issuerName: String,
    successNavigation: UIConfig.TwoWayNavigationType
  ) async -> OfferDynamicIssuancePartialState {

    guard let pendingData = await walletController.getDynamicIssuancePendingData() else {
      return .noPending
    }

    do {

      let doc = try await walletController.resumePendingIssuance(
        pendingDoc: pendingData.pendingDoc,
        webUrl: pendingData.url
      )

      if doc.status == .issued {
        return .success(
          retrieveSuccessRoute(
            caption: .credentialOfferSuccessCaption([issuerName]),
            successNavigation: successNavigation,
            title: .init(value: .success),
            buttonTitle: .credentialOfferSuccessButton,
            visualKind: .defaultIcon
          )
        )
      } else if doc.status == .deferred {
        return .success(
          retrieveSuccessRoute(
            caption: .issuanceSuccessDeferredCaption([issuerName]),
            successNavigation: successNavigation,
            title: .init(
              value: .inProgress,
              color: Theme.shared.color.pending
            ),
            buttonTitle: .okButton,
            visualKind: .customIcon(
              Theme.shared.image.documentSuccessPending,
              Color.clear
            )
          )
        )
      } else {
        return .failure(WalletCoreError.unableToIssueAndStore)
      }

    } catch {
      return .failure(WalletCoreError.unableToIssueAndStore)
    }
  }

  private func retrieveSuccessRoute(
    caption: LocalizableString.Key,
    successNavigation: UIConfig.TwoWayNavigationType,
    title: UIConfig.Success.Title,
    buttonTitle: LocalizableString.Key,
    visualKind: UIConfig.Success.VisualKind
  ) -> AppRoute {

    var navigationType: UIConfig.DeepLinkNavigationType {
      return switch successNavigation {
      case .popTo(let route): .pop(screen: route)
      case .push(let route): .push(screen: route)
      }
    }

    return .featureCommonModule(
      .success(
        config: UIConfig.Success(
          title: title,
          subtitle: caption,
          buttons: [
            .init(
              title: buttonTitle,
              style: .primary,
              navigationType: navigationType
            )
          ],
          visualKind: visualKind
        )
      )
    )
  }
}

public enum OfferRequestPartialState: Sendable {
  case success(DocumentOfferUIModel)
  case failure(Error)
}

public enum IssueOfferDocumentsPartialState: Sendable {
  case success(AppRoute)
  case partialSuccess(AppRoute)
  case deferredSuccess(AppRoute)
  case dynamicIssuance(RemoteSessionCoordinator)
  case failure(Error)
}

public enum OfferDynamicIssuancePartialState: Sendable {
  case success(AppRoute)
  case noPending
  case failure(Error)
}
