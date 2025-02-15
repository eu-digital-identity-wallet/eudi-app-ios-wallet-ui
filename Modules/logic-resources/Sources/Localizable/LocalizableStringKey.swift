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
import SwiftUI

public enum LocalizableStringKey: Equatable, Sendable {
  case dynamic(key: String)
  case custom(String)
  case space
  case search
  case genericErrorTitle
  case genericErrorDesc
  case biometryOpenSettings
  case biometryConfirmRequest
  case invalidQuickPin
  case tryAgain
  case shareButton
  case cancelButton
  case requestDataCaption
  case requestDataInfoNotice
  case requestDataTitle([String])
  case documentAdded
  case requestDataSheetCaption
  case okButton
  case shareDataReview
  case success
  case successfullySharedFollowingInformation
  case incompleteRequestDataSelection
  case addDoc
  case filters
  case sortByIssuedDateSectionTitle
  case issuerSectionTitle
  case showResults
  case showQRTap
  case welcomeBack([String])
  case viewDocumentDetails
  case pleaseWait
  case requestDataShareQuickPinCaption
  case requestDataShareBiometryCaption
  case addDocumentTitle
  case addDocumentSubtitle
  case addDocumentRequest
  case proximityConnectivityCaption
  case unavailableField
  case requestDataVerifiedEntity
  case requestDataVerifiedEntityMessage
  case moreOptions
  case changeQuickPinOption
  case quickPinSetTitle
  case quickPinEnterPin
  case quickPinConfirmPin
  case quickPinSetCaptionOne
  case quickPinSetCaptionTwo
  case quickPinNextButton
  case quickPinConfirmButton
  case quickPinSetSuccess
  case loginTitle
  case loginCaptionQuickPinOnly
  case loginCaption
  case quickPinSetSuccessButton
  case quickPinDoNotMatch
  case quickPinUpdateTitle
  case quickPinUpdateCaptionOne
  case quickPinUpdateCaptionTwo
  case quickPinUpdateCaptionThree
  case quickPinUpdateSuccess
  case quickPinUpdateSuccessButton
  case quickPinUpdateCancellationTitle
  case quickPinUpdateCancellationCaption
  case quickPinUpdateCancellationContinue
  case issuanceDetailsContinueButton
  case successTitlePunctuated
  case issuanceSuccessCaption([String])
  case issuanceSuccessNextButton
  case issuerWantWalletAddition
  case unknownVerifier
  case unknownIssuer
  case genericIssuer
  case filterByIssuer
  case yes
  case no
  case scanQrCode
  case signDocument
  case signDocumentSubtitle
  case selectDocument
  case validUntil([String])
  case bleDisabledModalTitle
  case bleDisabledModalCaption
  case bleDisabledModalButton
  case requestDataNoDocument
  case issuanceDetailsDeletionTitle([String])
  case deleteDocument
  case issuanceDetailsDeletionCaption([String])
  case errorUnableFetchDocuments
  case errorUnableFetchDocument
  case scannerQrTitleIssuing
  case scannerQrTitlePresentation
  case scannerQrCaptionIssuing
  case scannerQrCaptionPresentation
  case scannerQrTitle
  case scannerQrCaption
  case cameraError
  case missingPid
  case requestCredentialOfferTitle([String])
  case requestCredentialOfferCaption
  case requestCredentialOfferNoDocument
  case unableToIssueAndStore
  case issueButton
  case cancelIssueSheetTitle
  case cancelIssueSheetCaption
  case cancelIssueSheetContinue
  case credentialOfferSuccessButton
  case credentialOfferSuccessCaption([String])
  case credentialOfferPartialSuccessCaption([String])
  case issuanceCodeTitle([String])
  case issuanceCodeCaption([String])
  case transactionCodeFormatError([String])
  case inProgress
  case scopedIssuanceSuccessDeferredCaption
  case scopedIssuanceSuccessDeferredCaptionDocName([String])
  case scopedIssuanceSuccessDeferredCaptionDocNameAndIssuer([String])
  case issuanceSuccessDeferredCaption([String])
  case pending
  case issuanceFailed
  case deferredDocumentsIssuedModalTitle
  case defferedDocumentsIssuedModalCaption
  case retrieveLogs
  case qrScanInformativeText
  case unableToPresentAndShare
  case itemNotFoundInStorage
  case itemsNotFoundInStorage
  case home
  case documents
  case transactions
  case authenticateAuthoriseTransactions
  case electronicallySignDigitalDocuments
  case learnMore
  case chooseFromList
  case chooseFromListTitle
  case addDocumentsToWallet
  case details
  case dataSharingRequest
  case dataShared
  case doneButton
  case dataSharingTitle
  case close
  case reset
  case all
  case descending
  case ascending
  case issuanceSuccessHeaderDescriptionWhenError
  case trustedRelyingParty
  case trustedRelyingPartyDescription
  case alertAccessOnlineServices
  case alertAccessOnlineServicesMessage
  case alertSignDocumentsSafely
  case alertSignDocumentsSafelyMessage
  case authenticate
  case inPerson
  case online
  case fromDevice
  case autodashboardAuthenticateDialogMessage
  case deleteButton
  case savedToFavorites
  case succesfullyAddedFollowingToWallet
  case removedFromFavorites
  case savedToFavoritesMessage
  case removedFromFavoritesMessages
  case viewDetails
  case requestsTheFollowing
  case walletIsSecured
  case noResults
  case noResultsDescription
  case proximityConnectionNfcDescription
  case orShareViaNfc
  case expiryPeriodSectionTitle
  case selectExpiryPeriod
  case filterByState
  case sortBy
  case deleteDocumentConfirmDialog
  case defaultLabel
  case valid
  case revoke
  case expired
  case dateIssued
  case expiryDate
  case nextSevenDays
  case nextThirtyDays
  case beyondThiryDays
  case beforeToday
  case issuanceRequest
  case myEuWallet
  case categoryGovernment
  case categoryHealth
  case categoryEducation
  case categoryFinance
  case categoryRetail
  case categoryOther
  case categorySocialSecurity
  case categoryTravel
  case changelog
  case orderBy
  case filterByCategory
  case searchDocuments
}

public extension LocalizableStringKey {
  var toString: String {
    LocalizableManager.shared.get(with: self)
  }
  var toLocalizedStringKey: LocalizedStringKey {
    LocalizedStringKey(self.toString)
  }
}
