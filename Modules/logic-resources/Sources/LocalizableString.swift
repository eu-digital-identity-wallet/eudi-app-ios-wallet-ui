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
import SwiftUI

public protocol LocalizableStringType {
  static var shared: LocalizableStringType { get }
  func get(with key: LocalizableString.Key) -> String
  func get(with key: LocalizableString.Key) -> LocalizedStringKey
}

public final class LocalizableString: LocalizableStringType {

  public static let shared: LocalizableStringType = LocalizableString()

  private let bundle: Bundle

  private init() {
    self.bundle = .assetsBundle
  }

  public func get(with key: Key) -> String {
    return switch key {
    case .dynamic(let key):
      bundle.localizedString(forKey: key)
    case .custom(let literal):
      literal
    case .space:
      " "
    case .screenCaptureSecurityWarning:
      bundle.localizedString(forKey: "screen_recording_security_warning")
    case .faqs:
      bundle.localizedString(forKey: "faq_title")
    case .search:
      bundle.localizedString(forKey: "search")
    case .genericErrorTitle:
      bundle.localizedString(forKey: "generic_error_title")
    case .genericErrorDesc:
      bundle.localizedString(forKey: "generic_error_description")
    case .biometryOpenSettings:
      bundle.localizedString(forKey: "biometry_open_settings")
    case .invalidQuickPin:
      bundle.localizedString(forKey: "invalid_quick_pin")
    case .tryAgain:
      bundle.localizedString(forKey: "try_again")
    case .shareButton:
      bundle.localizedString(forKey: "share_button")
    case .cancelButton:
      bundle.localizedString(forKey: "cancel_button")
    case .requestDataCaption:
      bundle.localizedString(forKey: "request_data_share_caption")
    case .requestDataInfoNotice:
      bundle.localizedString(forKey: "request_data_info_notice")
    case .requestDataTitle(let args):
      bundle.localizedStringWithArguments(forKey: "request_data_share_title", arguments: args)
    case .cancelShareSheetTitle:
      bundle.localizedString(forKey: "cancel_share_sheet_title")
    case .cancelShareSheetCaption:
      bundle.localizedString(forKey: "cancel_share_sheet_caption")
    case .cancelShareSheetContinue:
      bundle.localizedString(forKey: "cancel_share_sheet_continue")
    case .requestDataSheetCaption:
      bundle.localizedString(forKey: "request_data_sheet_caption")
    case .okButton:
      bundle.localizedString(forKey: "ok_button")
    case .shareDataReview:
      bundle.localizedString(forKey: "share_data_review_title")
    case .success:
      bundle.localizedString(forKey: "success")
    case .requestDataShareSuccess(let args):
      bundle.localizedStringWithArguments(forKey: "request_data_share_sucess_title", arguments: args)
    case .requestDataShareButton:
      bundle.localizedString(forKey: "request_data_share_button")
    case .incompleteRequestDataSelection:
      bundle.localizedString(forKey: "incomplete_request_data_selecting")
    case .addDoc:
      bundle.localizedString(forKey: "add_doc")
    case .showQRTap:
      bundle.localizedString(forKey: "show_qr_tap")
    case .welcomeBack:
      bundle.localizedString(forKey: "welcome_back")
    case .pleaseWait:
      bundle.localizedString(forKey: "please_wait")
    case .requestDataShareQuickPinCaption:
      bundle.localizedString(forKey: "request_data_share_quick_pin_caption")
    case .requestDataShareBiometryCaption:
      bundle.localizedString(forKey: "request_data_share_biometry_caption")
    case .readFaqButton:
      bundle.localizedString(forKey: "read_faqs_button")
    case .loginButton:
      bundle.localizedString(forKey: "login_button")
    case .pid:
      bundle.localizedString(forKey: "pid")
    case .mdl:
      bundle.localizedString(forKey: "mdl")
    case .ageVerification:
      bundle.localizedString(forKey: "age_verification")
    case .photoId:
      bundle.localizedString(forKey: "photo_id")
    case .addDocumentTitle:
      bundle.localizedString(forKey: "add_document_title")
    case .addDocumentSubtitle:
      bundle.localizedString(forKey: "add_document_subtitle")
    case .proximityConnectivityTitle:
      bundle.localizedString(forKey: "proximity_connectivity_title")
    case .proximityConnectivityCaption:
      bundle.localizedString(forKey: "proxmity_connectivity_caption")
    case .verification:
      bundle.localizedString(forKey: "request_data_verification")
    case .unavailableField:
      bundle.localizedString(forKey: "unavailable_field")
    case .requestDataVerifiedEntity:
      bundle.localizedString(forKey: "request_data_verified_entity")
    case .requestDataVerifiedEntityMessage:
      bundle.localizedString(forKey: "request_data_verified_entity_message")
    case .moreOptions:
      bundle.localizedString(forKey: "more_options")
    case .changeQuickPinOption:
      bundle.localizedString(forKey: "change_quick_pin_option")
    case .quickPinSetTitle:
      bundle.localizedString(forKey: "quick_pin_set_title")
    case .quickPinSetCaptionOne:
      bundle.localizedString(forKey: "quick_pin_set_step_one_caption")
    case .quickPinSetCaptionTwo:
      bundle.localizedString(forKey: "quick_pin_set_step_two_caption")
    case .quickPinNextButton:
      bundle.localizedString(forKey: "quick_pin_next_button")
    case .quickPinConfirmButton:
      bundle.localizedString(forKey: "quick_pin_confirm_button")
    case .quickPinSetSuccess:
      bundle.localizedString(forKey: "quick_pin_set_success")
    case .loginTitle:
      bundle.localizedString(forKey: "login_title")
    case .loginCaptionQuickPinOnly:
      bundle.localizedString(forKey: "login_caption_quick_pin_only")
    case .loginCaption:
      bundle.localizedString(forKey: "login_caption")
    case .quickPinSetSuccessButton:
      bundle.localizedString(forKey: "quick_pin_set_success_button")
    case .quickPinDoNotMatch:
      bundle.localizedString(forKey: "quick_pin_dont_match")
    case .quickPinUpdateTitle:
      bundle.localizedString(forKey: "quick_pin_update_title")
    case .quickPinUpdateCaptionOne:
      bundle.localizedString(forKey: "quick_pin_update_step_one_caption")
    case .quickPinUpdateCaptionTwo:
      bundle.localizedString(forKey: "quick_pin_update_step_two_caption")
    case .quickPinUpdateCaptionThree:
      bundle.localizedString(forKey: "quick_pin_update_step_three_caption")
    case .quickPinUpdateSuccess:
      bundle.localizedString(forKey: "quick_pin_update_success")
    case .quickPinUpdateSuccessButton:
      bundle.localizedString(forKey: "quick_pin_update_success_button")
    case .quickPinUpdateCancellationTitle:
      bundle.localizedString(forKey: "quick_pin_update_cancellation_title")
    case .quickPinUpdateCancellationCaption:
      bundle.localizedString(forKey: "quick_pin_update_cancellation_caption")
    case .quickPinUpdateCancellationContinue:
      bundle.localizedString(forKey: "quick_pin_update_cancellation_continue")
    case .issuanceDetailsContinueButton:
      bundle.localizedString(forKey: "issuance_details_continue_button")
    case .issuanceExternalLoadingTitle(let args):
      bundle.localizedStringWithArguments(forKey: "issuance_external_loading_title", arguments: args)
    case .issuanceExternalLoadingCaption:
      bundle.localizedString(forKey: "issuance_external_loading_caption")
    case .issuanceSuccessTitle:
      bundle.localizedString(forKey: "issuance_success_title")
    case .issuanceSuccessCaption(let args):
      bundle.localizedStringWithArguments(forKey: "issuance_success_caption", arguments: args)
    case .issuanceSuccessNextButton:
      bundle.localizedString(forKey: "issuance_success_next_button")
    case .unknownVerifier:
      bundle.localizedString(forKey: "unknown_verifier")
    case .unknownIssuer:
      bundle.localizedString(forKey: "unknown_issuer")
    case .expiry:
      bundle.localizedString(forKey: "expiry")
    case .issuedAt:
      bundle.localizedString(forKey: "issued_at")
    case .yes:
      bundle.localizedString(forKey: "yes")
    case .no:
      bundle.localizedString(forKey: "no")
    case .scanQrCode:
      bundle.localizedString(forKey: "scan_qr_code")
    case .validUntil(let args):
      bundle.localizedStringWithArguments(forKey: "valid_until", arguments: args)
    case .vehicleCategory:
      bundle.localizedString(forKey: "vehicle_category_code")
    case .dateOfIssue:
      bundle.localizedString(forKey: "date_of_issue")
    case .dateOfExpiry:
      bundle.localizedString(forKey: "date_of_expiry")
    case .bleDisabledModalTitle:
      bundle.localizedString(forKey: "ble_disabled_modal_title")
    case .bleDisabledModalCaption:
      bundle.localizedString(forKey: "ble_disabled_modal_content")
    case .bleDisabledModalButton:
      bundle.localizedString(forKey: "ble_disabled_modal_button")
    case .shownAbove:
      bundle.localizedString(forKey: "shown_above")
    case .loadSampleData:
      bundle.localizedString(forKey: "load_sample_data")
    case .requestDataNoDocument:
      bundle.localizedString(forKey: "request_data_no_document")
    case .issuanceDetailsDeletionTitle(let args):
      bundle.localizedStringWithArguments(forKey: "issuance_details_doc_deletion_title", arguments: args)
    case .issuanceDetailsDeletionCaption(let args):
      bundle.localizedStringWithArguments(forKey: "issuance_details_doc_deletion_caption", arguments: args)
    case .errorUnableFetchDocuments:
      bundle.localizedString(forKey: "error_unable_fetch_documents")
    case .errorUnableFetchDocument:
      bundle.localizedString(forKey: "error_unable_fetch_document")
    case .expired:
      bundle.localizedString(forKey: "expired")
    case .onExpired(let args):
      bundle.localizedStringWithArguments(forKey: "on_expired", arguments: args)
    case .or:
      bundle.localizedString(forKey: "or")
    case .issuanceScanQr:
      bundle.localizedString(forKey: "issuance_scan_qr")
    case .scannerQrTitle:
      bundle.localizedString(forKey: "scanner_qr_title")
    case .scannerQrCaption:
      bundle.localizedString(forKey: "scanner_qr_caption")
    case .cameraError:
      bundle.localizedString(forKey: "camera_error")
    case .missingPid:
      bundle.localizedString(forKey: "missing_pid")
    case .requestCredentialOfferTitle(let args):
      bundle.localizedStringWithArguments(forKey: "request_credential_offer_title", arguments: args)
    case .requestCredentialOfferCaption:
      bundle.localizedString(forKey: "request_credential_offer_caption")
    case .requestCredentialOfferNoDocument:
      bundle.localizedString(forKey: "request_credential_offer_no_document")
    case .unableToIssueAndStore:
      bundle.localizedString(forKey: "unable_to_issue_and_store_documents")
    case .issueButton:
      bundle.localizedString(forKey: "issue_button")
    case .cancelIssueSheetTitle:
      bundle.localizedString(forKey: "cancel_issuance_sheet_title")
    case .cancelIssueSheetCaption:
      bundle.localizedString(forKey: "cancel_issuance_sheet_caption")
    case .cancelIssueSheetContinue:
      bundle.localizedString(forKey: "cancel_issuance_sheet_continue")
    case .credentialOfferSuccessButton:
      bundle.localizedString(forKey: "credential_offer_success_button")
    case .credentialOfferSuccessCaption(let args):
      bundle.localizedStringWithArguments(forKey: "credential_offer_success_caption", arguments: args)
    case .credentialOfferPartialSuccessCaption(let args):
      bundle.localizedStringWithArguments(forKey: "credential_offer_partial_success_caption", arguments: args)
    case .issuanceCodeTitle(let args):
      bundle.localizedStringWithArguments(forKey: "issuance_code_title", arguments: args)
    case .issuanceCodeCaption(let args):
      bundle.localizedStringWithArguments(forKey: "issuance_code_caption", arguments: args)
    case .transactionCodeFormatError(let args):
      bundle.localizedStringWithArguments(forKey: "transaction_code_format_error", arguments: args)
    case .inProgress:
      bundle.localizedString(forKey: "in_progress")
    case .scopedIssuanceSuccessDeferredCaption:
      bundle.localizedString(forKey: "scoped_issuance_success_deferred_caption")
    case .issuanceSuccessDeferredCaption(let args):
      bundle.localizedStringWithArguments(forKey: "issuance_success_deferred_caption", arguments: args)
    case .issuanceFailed:
      bundle.localizedString(forKey: "issuance_failed")
    case .pending:
      bundle.localizedString(forKey: "pending")
    case .deferredDocumentsIssuedModalTitle:
      bundle.localizedString(forKey: "deferred_document_issued_modal_title")
    case .defferedDocumentsIssuedModalCaption:
      bundle.localizedString(forKey: "deferred_document_issued_modal_caption")
    case .retrieveLogs:
      bundle.localizedString(forKey: "retrieve_logs")
    }
  }

  public func get(with key: Key) -> LocalizedStringKey {
    return self.get(with: key).toLocalizedStringKey
  }
}

public extension LocalizableString {
  enum Key: Equatable {
    case dynamic(key: String)
    case custom(String)
    case space
    case screenCaptureSecurityWarning
    case faqs
    case search
    case genericErrorTitle
    case genericErrorDesc
    case biometryOpenSettings
    case invalidQuickPin
    case tryAgain
    case shareButton
    case cancelButton
    case requestDataCaption
    case requestDataInfoNotice
    case requestDataTitle([String])
    case cancelShareSheetTitle
    case cancelShareSheetCaption
    case cancelShareSheetContinue
    case requestDataSheetCaption
    case okButton
    case shareDataReview
    case success
    case requestDataShareSuccess([String])
    case requestDataShareButton
    case incompleteRequestDataSelection
    case addDoc
    case showQRTap
    case welcomeBack
    case pleaseWait
    case requestDataShareQuickPinCaption
    case requestDataShareBiometryCaption
    case readFaqButton
    case loginButton
    case pid
    case mdl
    case ageVerification
    case photoId
    case addDocumentTitle
    case addDocumentSubtitle
    case proximityConnectivityTitle
    case proximityConnectivityCaption
    case verification
    case unavailableField
    case requestDataVerifiedEntity
    case requestDataVerifiedEntityMessage
    case moreOptions
    case changeQuickPinOption
    case quickPinSetTitle
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
    case issuanceExternalLoadingTitle([String])
    case issuanceExternalLoadingCaption
    case issuanceSuccessTitle
    case issuanceSuccessCaption([String])
    case issuanceSuccessNextButton
    case unknownVerifier
    case unknownIssuer
    case expiry
    case issuedAt
    case yes
    case no
    case scanQrCode
    case validUntil([String])
    case vehicleCategory
    case dateOfIssue
    case dateOfExpiry
    case bleDisabledModalTitle
    case bleDisabledModalCaption
    case bleDisabledModalButton
    case shownAbove
    case loadSampleData
    case requestDataNoDocument
    case issuanceDetailsDeletionTitle([String])
    case issuanceDetailsDeletionCaption([String])
    case errorUnableFetchDocuments
    case errorUnableFetchDocument
    case expired
    case onExpired([String])
    case or
    case issuanceScanQr
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
    case issuanceSuccessDeferredCaption([String])
    case pending
    case issuanceFailed
    case deferredDocumentsIssuedModalTitle
    case defferedDocumentsIssuedModalCaption
    case retrieveLogs
  }
}

fileprivate extension String {
  var toLocalizedStringKey: LocalizedStringKey {
    LocalizedStringKey(self)
  }
}

fileprivate extension Bundle {
  func localizedString(forKey key: String) -> String {
    self.localizedString(forKey: key, value: nil, table: nil)
  }
  func localizedStringWithArguments(forKey key: String, arguments: [CVarArg]) -> String {
    String(format: self.localizedString(forKey: key), locale: nil, arguments: arguments)
  }
}
