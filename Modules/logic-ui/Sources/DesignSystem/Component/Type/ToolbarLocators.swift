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
public enum ToolbarLocators: String, LocatorType {
  case chevronLeft
  case confirm
  case filterMenuIcon
  case plus
  case menuIcon
  case issueButton
  case cancelButton
  case doneButton
  case shareButton
  case xmark

  public var id: String {
    switch self {
    case .chevronLeft:
      return "chevron_left_button"
    case .confirm:
      return "confirm_button"
    case .filterMenuIcon:
      return "filter_menu_button"
    case .plus:
      return "documents_screen_plus_button"
    case .menuIcon:
      return "menu_icon_button"
    case .issueButton:
      return "issue_button"
    case .cancelButton:
      return "cancel_button"
    case .doneButton:
      return "done_button"
    case .shareButton:
      return "share_button"
    case .xmark:
      return "xmark_button"
    }
  }

  public var trait: AccessibilityTraits? {
    .isButton
  }
}
