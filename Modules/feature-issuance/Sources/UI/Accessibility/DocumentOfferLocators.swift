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

public enum DocumentOfferLocators: String, LocatorType {
  case headerDescription
  case issueButton
  case cancelButton

  public var id: String {
    switch self {
    case .headerDescription:
      return "document_offer_screen_content_header_description"
    case .issueButton:
      return "document_offer_screen_issue_button"
    case .cancelButton:
      return "document_offer_screen_cancel_button"
    }
  }

  public var trait: AccessibilityTraits? {
    switch self {
    case .headerDescription:
      return .isStaticText
    case .issueButton:
      return .isButton
    case .cancelButton:
      return .isButton
    }
  }
}
