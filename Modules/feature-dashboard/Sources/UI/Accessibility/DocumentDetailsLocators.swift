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

public enum DocumentDetailsLocators: String, LocatorType {
  case deleteDocument
  case confirmDialogDeleteButton
  case confirmDialogCancelButton
  case bookmarkIcon
  case bookmarkIconFill
  case eyeSlash
  case eye

  public var id: String {
    switch self {
    case .deleteDocument:
      return "document_details_screen_delete_button"
    case .confirmDialogDeleteButton:
      return "document_details_screen_dialog_delete_document_negative_button"
    case .confirmDialogCancelButton:
      return "document_details_screen_dialog_delete_document_positive_button"
    case .bookmarkIcon:
      return "document_details_screen_bookmark_icon_button"
    case .bookmarkIconFill:
      return "document_details_screen_bookmark_icon_fill_button"
    case .eyeSlash:
      return "document_details_screen_eye_slash_button"
    case .eye:
      return "document_details_screen_eye_button"
    }
  }

  public var trait: AccessibilityTraits? {
    .isButton
  }
}
