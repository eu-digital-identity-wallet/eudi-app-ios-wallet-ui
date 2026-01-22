/*
 * Copyright (c) 2025 European Commission
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
import logic_ui

public enum HomeTabViewLocators: String, LocatorType {
  case userNameText
  case authenticateAuthoriseTransactions
  case electronicallySignDigitalDocuments
  case inPersonButton
  case onlineButton
  case cancelButton

  public var id: String {
    switch self {
    case .userNameText:
      return "home_tab_screen_username_text"
    case .authenticateAuthoriseTransactions:
      return "home_tab_screen_authorization_button"
    case .electronicallySignDigitalDocuments:
      return "home_tab_screen_dialog_sign_button"
    case .inPersonButton:
      return "home_tab_screen_dialog_in_person_button"
    case .onlineButton:
      return "home_tab_screen_dialog_online_button"
    case .cancelButton:
      return "home_tab_screen_dialog_cancel_button"
    }
  }

  public var trait: AccessibilityTraits? {
    switch self {
    case .userNameText:
      return .isStaticText
    case .authenticateAuthoriseTransactions:
      return .isButton
    case .electronicallySignDigitalDocuments:
      return .isButton
    case .inPersonButton:
      return .isButton
    case .onlineButton:
      return .isButton
    case .cancelButton:
      return .isButton
    }
  }
}
