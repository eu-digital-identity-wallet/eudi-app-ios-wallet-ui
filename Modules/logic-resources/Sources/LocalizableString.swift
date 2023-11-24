/*
 * Copyright (c) 2023 European Commission
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import Foundation
import SwiftUI

public protocol LocalizableStringType {
  static var shared: LocalizableStringType { get }
  func get(with key: LocalizableString.Key) -> String
  func get(with key: LocalizableString.Key) -> LocalizedStringKey
}

public final class LocalizableString: LocalizableStringType {

  public static var shared: LocalizableStringType = LocalizableString()

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
    case .addDocumentTitle:
      bundle.localizedString(forKey: "add_document_title")
    case .addDocumentSubtitle:
      bundle.localizedString(forKey: "add_document_subtitle")
    case .proximityConnectivityTitle:
      bundle.localizedString(forKey: "proximity_connectivity_title")
    case .proximityConnectivityCaption:
      bundle.localizedString(forKey: "proxmity_connectivity_caption")
    case .proximityConnectivityNfc:
      bundle.localizedString(forKey: "proximity_connectivity_nfc")
    case .verification:
      bundle.localizedString(forKey: "request_data_verification")
    case .unavailableField:
      bundle.localizedString(forKey: "unavailable_field")
    case .requestDataVerifiedEntity:
      bundle.localizedString(forKey: "request_data_verified_entity")
    case .requestDataVerifiedEntityMessage:
      bundle.localizedString(forKey: "request_data_verified_entity_message")

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
    case addDocumentTitle
    case addDocumentSubtitle
    case proximityConnectivityTitle
    case proximityConnectivityCaption
    case proximityConnectivityNfc
    case verification
    case unavailableField
    case requestDataVerifiedEntity
    case requestDataVerifiedEntityMessage
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
