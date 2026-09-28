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
import Foundation

protocol LocalizableManagerType: Sendable {
  static var shared: LocalizableManagerType { get }
  func get(with key: LocalizableStringKey) -> String
}

final class LocalizableManager: LocalizableManagerType {

  static let shared: LocalizableManagerType = LocalizableManager()

  private let bundle: Bundle

  private init() {
    self.bundle = .assetsBundle
  }

  func get(with key: LocalizableStringKey) -> String {
    return switch key {
    case .dynamic(let key):
      bundle.localizedString(forKey: key)
    case .custom(let literal):
      literal
    case .space:
      " "
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
    case .requestDataInfoNotice:
      bundle.localizedString(forKey: "request_data_info_notice")
    case .requestDataTitle(let args):
      bundle.localizedStringWithArguments(forKey: "request_data_share_title", arguments: args)
    case .requestCombinationTitle(let args):
      bundle.localizedStringWithArguments(forKey: "request_combination_title", arguments: args)
    case .requestTransactionDataTitle:
      bundle.localizedString(forKey: "request_transaction_data_title")
    case .requestTransactionDataType:
      bundle.localizedString(forKey: "request_transaction_data_type")
    case .requestTransactionDataTypeQes:
      bundle.localizedString(forKey: "request_transaction_data_type_qes")
    case .requestTransactionDataTrustFramework:
      bundle.localizedString(forKey: "request_transaction_data_trust_framework")
    case .requestTransactionDataDocument:
      bundle.localizedString(forKey: "request_transaction_data_document")
    case .requestTransactionDataHash:
      bundle.localizedString(forKey: "request_transaction_data_hash")
    case .requestTransactionDataHashAlgorithm:
      bundle.localizedString(forKey: "request_transaction_data_hash_algorithm")
    case .requestTransactionDataNumberOfSignatures:
      bundle.localizedString(forKey: "request_transaction_data_number_of_signatures")
    case .documentAdded:
      bundle.localizedString(forKey: "document_added")
    case .okButton:
      bundle.localizedString(forKey: "ok_button")
    case .success:
      bundle.localizedString(forKey: "success")
    case .successfullySharedFollowingInformation:
      bundle.localizedString(forKey: "successfully_shared_following_information")
    case .incompleteRequestDataSelection:
      bundle.localizedString(forKey: "incomplete_request_data_selecting")
    case .addDoc:
      bundle.localizedString(forKey: "add_doc")
    case .welcomeBack(let args):
      bundle.localizedStringWithArguments(forKey: "welcome_back", arguments: args)
    case .pleaseWait:
      bundle.localizedString(forKey: "please_wait")
    case .requestDataShareQuickPinCaption:
      bundle.localizedString(forKey: "request_data_share_quick_pin_caption")
    case .requestDataShareBiometryCaption:
      bundle.localizedString(forKey: "request_data_share_biometry_caption")
    case .addDocumentTitle:
      bundle.localizedString(forKey: "add_document_title")
    case .addDocumentRequest:
      bundle.localizedString(forKey: "add_document_request")
    case .addDocumentSubtitle:
      bundle.localizedString(forKey: "add_document_subtitle")
    case .proximityConnectivityCaption:
      bundle.localizedString(forKey: "proxmity_connectivity_caption")
    case .unavailableField:
      bundle.localizedString(forKey: "unavailable_field")
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
    case .loginWithBiometrics:
      bundle.localizedString(forKey: "login_with_biometrics")
    case .loginCaptionQuickPinOnly:
      bundle.localizedString(forKey: "login_caption_quick_pin_only")
    case .loginCaption:
      bundle.localizedString(forKey: "login_caption")
    case .quickPinSetSuccessButton:
      bundle.localizedString(forKey: "quick_pin_set_success_button")
    case .quickPinDoNotMatch:
      bundle.localizedString(forKey: "quick_pin_dont_match")
    case .quickPinLockedOut(let args):
      bundle.localizedStringWithArguments(forKey: "quick_pin_locked_out", arguments: args)
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
    case .successTitlePunctuated:
      bundle.localizedString(forKey: "issuance_success_title_punctuated")
    case .unknownVerifier:
      bundle.localizedString(forKey: "unknown_verifier")
    case .unknownIssuer:
      bundle.localizedString(forKey: "unknown_issuer")
    case .genericIssuer:
      bundle.localizedString(forKey: "generic_issuer")
    case .yes:
      bundle.localizedString(forKey: "yes")
    case .no:
      bundle.localizedString(forKey: "no")
    case .scanQrCode:
      bundle.localizedString(forKey: "scan_qr_code")
    case .validUntil(let args):
      bundle.localizedStringWithArguments(forKey: "valid_until", arguments: args)
    case .bleDisabledModalTitle:
      bundle.localizedString(forKey: "ble_disabled_modal_title")
    case .bleDisabledModalCaption:
      bundle.localizedString(forKey: "ble_disabled_modal_content")
    case .bleDisabledModalButton:
      bundle.localizedString(forKey: "ble_disabled_modal_button")
    case .requestDataNoDocument:
      bundle.localizedString(forKey: "request_data_no_document")
    case .issuanceDetailsDeletionTitle(let args):
      bundle.localizedStringWithArguments(forKey: "issuance_details_doc_deletion_title", arguments: args)
    case .deleteDocument:
      bundle.localizedString(forKey: "delete_document")
    case .removeFromWallet:
      bundle.localizedString(forKey: "remove_from_wallet")
    case .issuanceDetailsDeletionCaption(let args):
      bundle.localizedStringWithArguments(forKey: "issuance_details_doc_deletion_caption", arguments: args)
    case .errorUnableFetchDocuments:
      bundle.localizedString(forKey: "error_unable_fetch_documents")
    case .errorUnableFetchDocument:
      bundle.localizedString(forKey: "error_unable_fetch_document")
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
    case .requestCredentialOfferNoDocument:
      bundle.localizedString(forKey: "request_credential_offer_no_document")
    case .unableToIssueAndStore:
      bundle.localizedString(forKey: "unable_to_issue_and_store_documents")
    case .missingMetadata:
      bundle.localizedString(forKey: "missing_metadata")
    case .issueButton:
      bundle.localizedString(forKey: "issue_button")
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
    case .scopedIssuanceSuccessDeferredCaptionDocName(let args):
      bundle.localizedStringWithArguments(forKey: "scoped_issuance_success_deferred_caption_docname", arguments: args)
    case .scopedIssuanceSuccessDeferredCaptionDocNameAndIssuer(let args):
      bundle.localizedStringWithArguments(forKey: "scoped_issuance_success_deferred_caption_docname_and_issuer_name", arguments: args)
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
    case .qrScanInformativeText:
      bundle.localizedString(forKey: "qr_scan_informative_text")
    case .unableToPresentAndShare:
      bundle.localizedString(forKey: "error_unable_present_documents")
    case .signDocument:
      bundle.localizedString(forKey: "sign_document")
    case .signDocumentSubtitle:
      bundle.localizedString(forKey: "sign_document_subtitle")
    case .selectDocument:
      bundle.localizedString(forKey: "select_document")
    case .itemNotFoundInStorage:
      bundle.localizedString(forKey: "item_not_found_in_storage")
    case .itemsNotFoundInStorage:
      bundle.localizedString(forKey: "items_not_found_in_storage")
    case .home:
      bundle.localizedString(forKey: "home")
    case .historyTitle:
      bundle.localizedString(forKey: "history")
    case .documents:
      bundle.localizedString(forKey: "documents")
    case .authenticateAuthoriseTransactions:
      bundle.localizedString(forKey: "authenticate_authorise_transactions")
    case .electronicallySignDigitalDocuments:
      bundle.localizedString(forKey: "electronically_sign_digital_documents")
    case .learnMore:
      bundle.localizedString(forKey: "learn_more")
    case .chooseFromList:
      bundle.localizedString(forKey: "choose_from_list")
    case .chooseFromListTitle:
      bundle.localizedString(forKey: "choose_from_list_title")
    case .addDocumentsToWallet:
      bundle.localizedString(forKey: "add_documents_to_wallet")
    case .details:
      bundle.localizedString(forKey: "details")
    case .dataSharingRequest:
      bundle.localizedString(forKey: "data_sharing_request")
    case .dataShared:
      bundle.localizedString(forKey: "data_shared")
    case .doneButton:
      bundle.localizedString(forKey: "done_button")
    case .dataSharingTitle:
      bundle.localizedString(forKey: "data_sharing_title")
    case .close:
      bundle.localizedString(forKey: "close")
    case .trustedRelyingParty:
      bundle.localizedString(forKey: "trusted_relying_party")
    case .trustedRelyingPartyDescription:
      bundle.localizedString(forKey: "trusted_relying_party_description")
    case .issuerWantWalletAddition:
      bundle.localizedString(forKey: "issuer_want_wallet_addition")
    case .filterByIssuer:
      bundle.localizedString(forKey: "filter_by_issuer")
    case .alertAccessOnlineServices:
      bundle.localizedString(forKey: "alert_access_online_services")
    case .alertAccessOnlineServicesMessage:
      bundle.localizedString(forKey: "alert_access_online_services_message")
    case .alertSignDocumentsSafely:
      bundle.localizedString(forKey: "alert_sign_documents_safely")
    case .alertSignDocumentsSafelyMessage:
      bundle.localizedString(forKey: "alert_sign_documents_safely_message")
    case .authenticate:
      bundle.localizedString(forKey: "authenticate")
    case .inPerson:
      bundle.localizedString(forKey: "in_person")
    case .online:
      bundle.localizedString(forKey: "Online")
    case .savedToFavorites:
      bundle.localizedString(forKey: "saved_to_favorites")
    case .succesfullyAddedFollowingToWallet:
      bundle.localizedString(forKey: "succesfully_added_following_to_wallet")
    case .removedFromFavorites:
      bundle.localizedString(forKey: "removed_from_favorites")
    case .savedToFavoritesMessage:
      bundle.localizedString(forKey: "saved_to_favorites_message")
    case .removedFromFavoritesMessages:
      bundle.localizedString(forKey: "removed_from_favorites_messages")
    case .scannerQrTitleIssuing:
      bundle.localizedString(forKey: "scanner_qr_title_issuing")
    case .scannerQrTitlePresentation:
      bundle.localizedString(forKey: "scanner_qr_title_presentation")
    case .scannerQrCaptionIssuing:
      bundle.localizedString(forKey: "scanner_qr_caption_issuing")
    case .scannerQrCaptionPresentation:
      bundle.localizedString(forKey: "scanner_qr_caption_presentation")
    case .quickPinEnterPin:
      bundle.localizedString(forKey: "quick_pin_enter_a_pin")
    case .quickPinNavigationEnterPin:
      bundle.localizedString(forKey: "quick_pin_navigation_enter_a_pin")
    case .quickPinConfirmPin:
      bundle.localizedString(forKey: "quick_pin_confirm_pin")
    case .biometryConfirmRequest:
      bundle.localizedString(forKey: "biometry_confirm_request")
    case .viewDetails:
      bundle.localizedString(forKey: "view_details")
    case .requestsTheFollowing:
      bundle.localizedString(forKey: "requests_the_following")
    case .walletIsSecured:
      bundle.localizedString(forKey: "wallet_is_secured")
    case .noResults:
      bundle.localizedString(forKey: "no_results")
    case .noResultsDocumentsDescription:
      bundle.localizedString(forKey: "no_results_documents_description")
    case .noResultsTransactionsDescription:
      bundle.localizedString(forKey: "no_results_transactions_description")
    case .proximityConnectionBleDescription:
      bundle.localizedString(forKey: "proximity_connection_ble_description")
    case .filters:
      bundle.localizedString(forKey: "filters")
    case .sortByIssuedDateSectionTitle:
      bundle.localizedString(forKey: "sort_by_issued_date")
    case .showResults:
      bundle.localizedString(forKey: "show_results")
    case .reset:
      bundle.localizedString(forKey: "reset")
    case .all:
      bundle.localizedString(forKey: "all")
    case .descending:
      bundle.localizedString(forKey: "descending")
    case .ascending:
      bundle.localizedString(forKey: "ascending")
    case .selectExpiryPeriod:
      bundle.localizedString(forKey: "expiry_period")
    case .filterByState:
      bundle.localizedString(forKey: "filter_by_state")
    case .sortBy:
      bundle.localizedString(forKey: "sort_by")
    case .deleteDocumentConfirmDialog:
      bundle.localizedString(forKey: "delete_document_confirm_dialog")
    case .defaultLabel:
      bundle.localizedString(forKey: "default")
    case .valid:
      bundle.localizedString(forKey: "valid")
    case .revoke:
      bundle.localizedString(forKey: "revoke")
    case .expired:
      bundle.localizedString(forKey: "expired")
    case .dateIssued:
      bundle.localizedString(forKey: "date_issued")
    case .expiryDate:
      bundle.localizedString(forKey: "expiry_date")
    case .nextSevenDays:
      bundle.localizedString(forKey: "next_seven_days")
    case .nextThirtyDays:
      bundle.localizedString(forKey: "next_thirty_days")
    case .beyondThiryDays:
      bundle.localizedString(forKey: "beyond_thirty_days")
    case .beforeToday:
      bundle.localizedString(forKey: "before_today")
    case .issuanceRequest:
      bundle.localizedString(forKey: "issuance_request")
    case .issuanceRequestTitle:
      bundle.localizedString(forKey: "issuance_request_title")
    case .myEuWallet:
      bundle.localizedString(forKey: "My EU Wallet")
    case .categoryGovernment:
      bundle.localizedString(forKey: "category_government")
    case .categoryHealth:
      bundle.localizedString(forKey: "category_health")
    case .categoryEducation:
      bundle.localizedString(forKey: "category_education")
    case .categoryFinance:
      bundle.localizedString(forKey: "category_finance")
    case .categoryRetail:
      bundle.localizedString(forKey: "category_retail")
    case .categoryOther:
      bundle.localizedString(forKey: "category_other")
    case .categorySocialSecurity:
      bundle.localizedString(forKey: "category_social_security")
    case .categoryTravel:
      bundle.localizedString(forKey: "category_travel")
    case .changelog:
      bundle.localizedString(forKey: "changelog")
    case .orderBy:
      bundle.localizedString(forKey: "order_by")
    case .filterByCategory:
      bundle.localizedString(forKey: "filter_by_category")
    case .searchDocuments:
      bundle.localizedString(forKey: "search_documents")
    case .searchTransactions:
      bundle.localizedString(forKey: "search_transactions")
    case .filterByStatus:
      bundle.localizedString(forKey: "filter_by_status")
    case .completed:
      bundle.localizedString(forKey: "completed")
    case .failed:
      bundle.localizedString(forKey: "failed")
    case .filterByDate:
      bundle.localizedString(forKey: "filter_by_date")
    case .startDate:
      bundle.localizedString(forKey: "start_date")
    case .endDate:
      bundle.localizedString(forKey: "end_date")
    case .resetDates:
      bundle.localizedString(forKey: "reset_dates")
    case .relyingParty:
      bundle.localizedString(forKey: "relying_party")
    case .signedDocuments:
      bundle.localizedString(forKey: "signed_documents")
    case .transactionInformation:
      bundle.localizedString(forKey: "transaction_information")
    case .transactionDetailsDataSigned:
      bundle.localizedString(forKey: "transaction_details_data_signed")
    case .transactionDetailsDataShare:
      bundle.localizedString(forKey: "transaction_details_data_shared")
    case .transactionDetailsScreenCardDateLabel:
      bundle.localizedString(forKey: "transaction_details_screen_card_date_label")
    case .transactionDetailsCompleted:
      bundle.localizedString(forKey: "transaction_details_completed")
    case .or:
      bundle.localizedString(forKey: "or")
    case .today:
      bundle.localizedString(forKey: "today")
    case .thisWeek:
      bundle.localizedString(forKey: "this_week")
    case .unknownDate:
      bundle.localizedString(forKey: "unknown_date")
    case .minutesAgo(let args):
      bundle.localizedStringWithArguments(forKey: "minutes_ago", arguments: args)
    case .minuteAgo(let args):
      bundle.localizedStringWithArguments(forKey: "minute_ago", arguments: args)
    case .transactionDate:
      bundle.localizedString(forKey: "transaction_date")
    case .filterByType:
      bundle.localizedString(forKey: "filter_by_type")
    case .presentation:
      bundle.localizedString(forKey: "presentation")
    case .signing:
      bundle.localizedString(forKey: "signing")
    case .issuance:
      bundle.localizedString(forKey: "issuance")
    case .deletion:
      bundle.localizedString(forKey: "deletion")
    case .errorFetchTransactionLog:
      bundle.localizedString(forKey: "fetch_error_transaction_log")
    case .incomplete:
      bundle.localizedString(forKey: "incomplete")
    case .justNow:
      bundle.localizedString(forKey: "just_now")
    case .revoked:
      bundle.localizedString(forKey: "revoked")
    case .revokedModalTitle:
      bundle.localizedString(forKey: "revoked_modal_title")
    case .revokedModalDescription:
      bundle.localizedString(forKey: "revoked_modal_description")
    case .issuanceBlockedTitle:
      bundle.localizedString(forKey: "issuance_blocked_bottom_sheet_title")
    case .issuanceBlockedMessage:
      bundle.localizedString(forKey: "issuance_blocked_bottom_sheet_message")
    case .presentationBlockedTitle:
      bundle.localizedString(forKey: "request_blocked_bottom_sheet_title")
    case .presentationBlockedMessage:
      bundle.localizedString(forKey: "request_blocked_bottom_sheet_message")
    case .transactionDetailsRequestDeletionMessage:
      bundle.localizedString(forKey: "transaction_details_eequest_deletion_message")
    case .transactionDetailsRequestDeletionButton:
      bundle.localizedString(forKey: "transaction_details_eequest_deletion_button")
    case .transactionDetailsReportTransactionMessage:
      bundle.localizedString(forKey: "transaction_details_report_transaction_message")
    case .transactionDetailsReportTransactionButton:
      bundle.localizedString(forKey: "transaction_detailsReport_transaction_button")
    case .settings:
      bundle.localizedString(forKey: "settings_menu")
    case .documentDetailsDocumentCredentialsText(let args):
      bundle.localizedStringWithArguments(forKey: "document_details_document_credentials_text", arguments: args)
    case .documentDetailsDocumentCredentialsExpandedTextSubtitle:
      bundle.localizedString(forKey: "document_details_document_credentials_expanded_text_subtitle")
    case .documentsListCredentialsUsageText(let args):
      bundle.localizedStringWithArguments(forKey: "documents_list_credentials_usage_text", arguments: args)
    case .expandableDocumentCredentialsIssueButton:
      bundle.localizedString(forKey: "expandable_document_credentials_issue_button")
    case .issuanceAddDocumentNoOptions:
      bundle.localizedString(forKey: "issuance_add_document_no_options")
    case .unknown:
      bundle.localizedString(forKey: "unknown")
    case .quickPinSetNoActivationSuccess:
      bundle.localizedString(forKey: "quick_pin_set_no_activation_success")
    case .quickPinSetNoActivationSuccessButton:
      bundle.localizedString(forKey: "quick_pin_set_no_activation_success_button")
    case .pidCombined:
      bundle.localizedString(forKey: "pid_combined")
    case .documentData:
      bundle.localizedString(forKey: "document_data")
    case .documentDetailsShow:
      bundle.localizedString(forKey: "document_details_show")
    case .documentDetailsHide:
      bundle.localizedString(forKey: "document_details_hide")
    case .issuanceSuccessHeaderDescription:
      bundle.localizedString(forKey: "issuance_success_header_description")
    case .documentDetailsReIssueButton:
      bundle.localizedString(forKey: "document_details_re_issue_button")
    case .documentDetailsRemoveButton:
      bundle.localizedString(forKey: "document_details_remove_button")
    case .documentDetailsExpiresOn(let args):
      bundle.localizedStringWithArguments(forKey: "document_details_expires_on", arguments: args)
    case .documentDetailsExpiredOn(let args):
      bundle.localizedStringWithArguments(forKey: "document_details_expired_on", arguments: args)
    case .documentDetailsIssuedOn(let args):
      bundle.localizedStringWithArguments(forKey: "document_details_issued_on", arguments: args)
    case .documentDetailsRevokedDocument:
      bundle.localizedString(forKey: "document_details_revoked_document")
    case .documentDetailsIssuerCardIssuedMessageText:
      bundle.localizedString(forKey: "document_details_issuer_card_issued_message_text")
    case .documentDetailsIssuerCardRevokedMessageText:
      bundle.localizedString(forKey: "document_details_issuer_card_revoked_message_text")
    case .documentDetailsIssuerCardExpiredMessageText:
      bundle.localizedString(forKey: "document_details_issuer_card_expired_message_text")
    case .documentDetailsIssuerCardIssuedActionButtonText:
      bundle.localizedString(forKey: "document_details_issuer_card_issued_action_btn_text")
    case .batchIssuanceCounter:
      bundle.localizedString(forKey: "batch_issuance_counter")
    case .validateIssuerRegistration:
      bundle.localizedString(forKey: "validate_issuer_registration")
    case .restartRequiredTitle:
      bundle.localizedString(forKey: "restart_required_title")
    case .restartRequiredMessage:
      bundle.localizedString(forKey: "restart_required_message")
    case .documentProviderExtensionAcceptButton:
      bundle.localizedString(forKey: "document_provider_extension_accept_button")
    case .documentProviderExtensionRejectButton:
      bundle.localizedString(forKey: "document_provider_extension_reject_button")
    case .enterYourPin:
      bundle.localizedString(forKey: "enter_your_pin")
    case .homeScreenAuthenticateDescription:
      bundle.localizedString(forKey: "home_screen_authenticate_description")
    case .relyingPartyId(let args):
      bundle.localizedStringWithArguments(forKey: "relying_party_id", arguments: args)
    case .privacyPolicy:
      bundle.localizedString(forKey: "privacy_policy")
    case .intendedUse:
      bundle.localizedString(forKey: "intended_use")
    case .understandRisksAgree:
      bundle.localizedString(forKey: "understand_risks_agree")
    case .relyingPartyNotVerifiedWarning:
      bundle.localizedString(forKey: "relying_party_not_verified_warning")
    case .relyingPartyOveraskedWarning:
      bundle.localizedString(forKey: "relying_party_overasked_warning")
    case .notRegisteredData:
      bundle.localizedString(forKey: "not_registered_data")
    case .issuanceRegistrationBlockedTitle:
      bundle.localizedString(forKey: "issuance_registration_blocked_title")
    case .issuanceRegistrationBlockedMessage:
      bundle.localizedString(forKey: "issuance_registration_blocked_message")
    case .notCompleted:
      bundle.localizedString(forKey: "not_completed")
    case .reissuance:
      bundle.localizedString(forKey: "reissuance")
    case .filterByParty:
      bundle.localizedString(forKey: "filter_by_party")
    case .withoutPartyName:
      bundle.localizedString(forKey: "without_party_name")
    case .transactionTypeDataDeletionRequest:
      bundle.localizedString(forKey: "transaction_type_data_deletion_request")
    case .transactionTypeDpaReport:
      bundle.localizedString(forKey: "transaction_type_dpa_report")
    case .transactionDetailsDeleteButton:
      bundle.localizedString(forKey: "transaction_details_delete_button")
    case .transactionDetailsDeleteTitle:
      bundle.localizedString(forKey: "transaction_details_delete_title")
    case .transactionDetailsDeleteMessage:
      bundle.localizedString(forKey: "transaction_details_delete_message")
    case .transactionDetailsDeleteError:
      bundle.localizedString(forKey: "transaction_details_delete_error")
    case .transactionDetailsDataRequested:
      bundle.localizedString(forKey: "transaction_details_data_requested")
    case .transactionDetailsIssuanceSection:
      bundle.localizedString(forKey: "transaction_details_issuance_section")
    case .transactionDetailsCredentialsSection:
      bundle.localizedString(forKey: "transaction_details_credentials_section")
    case .transactionDetailsTechnicalSection:
      bundle.localizedString(forKey: "transaction_details_technical_section")
    case .transactionDetailsDataDeletionSection:
      bundle.localizedString(forKey: "transaction_details_data_deletion_section")
    case .transactionDetailsNoDataRequested:
      bundle.localizedString(forKey: "transaction_details_no_data_requested")
    case .transactionDetailsNoDataShared:
      bundle.localizedString(forKey: "transaction_details_no_data_shared")
    case .transactionDetailsNoClaims:
      bundle.localizedString(forKey: "transaction_details_no_claims")
    case .transactionDetailsNoInformation:
      bundle.localizedString(forKey: "transaction_details_no_information")
    case .transactionDetailsUnknownClaim:
      bundle.localizedString(forKey: "transaction_details_unknown_claim")
    case .transactionDetailsIdentifierLabel:
      bundle.localizedString(forKey: "transaction_details_identifier_label")
    case .transactionDetailsIdentifierSchemeLabel:
      bundle.localizedString(forKey: "transaction_details_identifier_scheme_label")
    case .transactionDetailsContactLabel:
      bundle.localizedString(forKey: "transaction_details_contact_label")
    case .transactionDetailsPurposeLabel:
      bundle.localizedString(forKey: "transaction_details_purpose_label")
    case .transactionDetailsRegistrarLabel:
      bundle.localizedString(forKey: "transaction_details_registrar_label")
    case .transactionDetailsPrivacyPolicyLabel:
      bundle.localizedString(forKey: "transaction_details_privacy_policy_label")
    case .transactionDetailsIssuerTypeLabel:
      bundle.localizedString(forKey: "transaction_details_issuer_type_label")
    case .transactionDetailsIssuedCountLabel:
      bundle.localizedString(forKey: "transaction_details_issued_count_label")
    case .transactionDetailsRequestedCountLabel:
      bundle.localizedString(forKey: "transaction_details_requested_count_label")
    case .transactionDetailsCredentialsIssuedSection:
      bundle.localizedString(forKey: "transaction_details_credentials_issued_section")
    case .transactionDetailsTriggerLabel:
      bundle.localizedString(forKey: "transaction_details_trigger_label")
    case .transactionDetailsRequestedByYou:
      bundle.localizedString(forKey: "transaction_details_requested_by_you")
    case .transactionDetailsRenewedByWallet:
      bundle.localizedString(forKey: "transaction_details_renewed_by_wallet")
    case .transactionDetailsCertificateLabel:
      bundle.localizedString(forKey: "transaction_details_certificate_label")
    case .transactionDetailsFilenameLabel:
      bundle.localizedString(forKey: "transaction_details_filename_label")
    case .transactionDetailsFilesizeLabel:
      bundle.localizedString(forKey: "transaction_details_filesize_label")
    case .transactionDetailsDigestLabel:
      bundle.localizedString(forKey: "transaction_details_digest_label")
    case .transactionDetailsIssuedCount(let args):
      bundle.localizedStringWithArguments(forKey: "transaction_details_issued_count", arguments: args)
    case .transactionDetailsBytes(let args):
      bundle.localizedStringWithArguments(forKey: "transaction_details_bytes", arguments: args)
    case .transactionDetailsActionUnavailable:
      bundle.localizedString(forKey: "transaction_details_action_unavailable")
    case .transactionDetailsActionOpenFailed:
      bundle.localizedString(forKey: "transaction_details_action_open_failed")
    case .transactionDetailsActionError:
      bundle.localizedString(forKey: "transaction_details_action_error")
    case .transactionDetailsDeletionEmailSubject(let args):
      bundle.localizedStringWithArguments(forKey: "transaction_details_deletion_email_subject", arguments: args)
    case .transactionDetailsDeletionEmailBody(let args):
      bundle.localizedStringWithArguments(forKey: "transaction_details_deletion_email_body", arguments: args)
    case .transactionDetailsReportEmailSubject(let args):
      bundle.localizedStringWithArguments(forKey: "transaction_details_report_email_subject", arguments: args)
    case .transactionDetailsReportEmailBody(let args):
      bundle.localizedStringWithArguments(forKey: "transaction_details_report_email_body", arguments: args)
    case .hideDetails:
      bundle.localizedString(forKey: "hide_details")
    case .transactionDetailsRelyingPartyLabel:
      bundle.localizedString(forKey: "transaction_details_relying_party_label")
    case .transactionDetailsIssuerLabel:
      bundle.localizedString(forKey: "transaction_details_issuer_label")
    case .transactionDetailsSigningServiceLabel:
      bundle.localizedString(forKey: "transaction_details_signing_service_label")
    case .transactionDetailsAuthorityLabel:
      bundle.localizedString(forKey: "transaction_details_authority_label")
    case .transactionDetailsIntermediaryLabel:
      bundle.localizedString(forKey: "transaction_details_intermediary_label")
    case .transactionDetailsIntermediaryNameLabel:
      bundle.localizedString(forKey: "transaction_details_intermediary_name_label")
    case .transactionDetailsIntermediaryContactLabel:
      bundle.localizedString(forKey: "transaction_details_intermediary_contact_label")
    case .transactionDetailsSigningIdentifierLabel:
      bundle.localizedString(forKey: "transaction_details_signing_identifier_label")
    case .transactionDetailsRequestDeletionSection:
      bundle.localizedString(forKey: "transaction_details_request_deletion_section")
    case .transactionDetailsReportSection:
      bundle.localizedString(forKey: "transaction_details_report_section")
    case .transactionDetailsPreviousDeletionRequests(let args):
      bundle.localizedStringWithArguments(forKey: "transaction_details_previous_deletion_requests", arguments: args)
    case .transactionDetailsPreviousReports(let args):
      bundle.localizedStringWithArguments(forKey: "transaction_details_previous_reports", arguments: args)
    case .transactionActionReportTitle:
      bundle.localizedString(forKey: "transaction_action_report_title")
    case .transactionActionAuthorityLabel:
      bundle.localizedString(forKey: "transaction_action_authority_label")
    case .transactionActionReportMessageBold:
      bundle.localizedString(forKey: "transaction_action_report_message_bold")
    case .transactionActionReportMessage(let args):
      bundle.localizedStringWithArguments(forKey: "transaction_action_report_message", arguments: args)
    case .transactionActionReportMessageNoAuthority:
      bundle.localizedString(forKey: "transaction_action_report_message_no_authority")
    case .transactionActionReportFollowUp(let args):
      bundle.localizedStringWithArguments(forKey: "transaction_action_report_follow_up", arguments: args)
    case .transactionActionReportFollowUpNoAuthority:
      bundle.localizedString(forKey: "transaction_action_report_follow_up_no_authority")
    case .transactionActionCall:
      bundle.localizedString(forKey: "transaction_action_call")
    case .transactionActionOpenEmail:
      bundle.localizedString(forKey: "transaction_action_open_email")
    case .transactionActionVisitWebsite:
      bundle.localizedString(forKey: "transaction_action_visit_website")
    case .transactionActionUnknownParty:
      bundle.localizedString(forKey: "transaction_action_unknown_party")
    case .transactionHistoryDeletionTitle(let args):
      bundle.localizedStringWithArguments(forKey: "transaction_history_deletion_title", arguments: args)
    case .transactionHistoryReportTitle(let args):
      bundle.localizedStringWithArguments(forKey: "transaction_history_report_title", arguments: args)
    case .transactionHistoryDeletionDisclaimer:
      bundle.localizedString(forKey: "transaction_history_deletion_disclaimer")
    case .transactionHistoryReportDisclaimer:
      bundle.localizedString(forKey: "transaction_history_report_disclaimer")
    case .transactionHistoryDeletionMessage:
      bundle.localizedString(forKey: "transaction_history_deletion_message")
    case .transactionHistoryReportMessage:
      bundle.localizedString(forKey: "transaction_history_report_message")
    case .transactionHistoryChannelPhone:
      bundle.localizedString(forKey: "transaction_history_channel_phone")
    case .transactionHistoryChannelEmail:
      bundle.localizedString(forKey: "transaction_history_channel_email")
    case .transactionHistoryChannelWebsite:
      bundle.localizedString(forKey: "transaction_history_channel_website")
    case .transactionHistoryChannelOther:
      bundle.localizedString(forKey: "transaction_history_channel_other")
    case .transactionActionDeletionScreenTitle:
      bundle.localizedString(forKey: "transaction_action_deletion_screen_title")
    case .transactionActionDeletionIntroWebsite(let args):
      bundle.localizedStringWithArguments(forKey: "transaction_action_deletion_intro_website", arguments: args)
    case .transactionActionDeletionIntroEmail(let args):
      bundle.localizedStringWithArguments(forKey: "transaction_action_deletion_intro_email", arguments: args)
    case .transactionActionDeletionIntroPhone(let args):
      bundle.localizedStringWithArguments(forKey: "transaction_action_deletion_intro_phone", arguments: args)
    case .transactionActionDeletionNoticeBold:
      bundle.localizedString(forKey: "transaction_action_deletion_notice_bold")
    case .transactionActionDeletionNoticeWebsite:
      bundle.localizedString(forKey: "transaction_action_deletion_notice_website")
    case .transactionActionDeletionNoticeEmail:
      bundle.localizedString(forKey: "transaction_action_deletion_notice_email")
    case .transactionActionDeletionNoticePhone:
      bundle.localizedString(forKey: "transaction_action_deletion_notice_phone")
    case .transactionActionDeletionLegal(let args):
      bundle.localizedStringWithArguments(forKey: "transaction_action_deletion_legal", arguments: args)
    case .transactionActionContinueWebsite(let args):
      bundle.localizedStringWithArguments(forKey: "transaction_action_continue_website", arguments: args)
    case .transactionActionContinueEmail:
      bundle.localizedString(forKey: "transaction_action_continue_email")
    case .transactionActionContinuePhone(let args):
      bundle.localizedStringWithArguments(forKey: "transaction_action_continue_phone", arguments: args)
    case .continueButton:
      bundle.localizedString(forKey: "continue_button")
    }
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
