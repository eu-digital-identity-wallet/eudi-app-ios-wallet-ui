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

public enum AddDocumentLocators: LocatorType {
  case subtitle
  case primaryButton
  case attestation(String)

  public var id: String {
    switch self {
    case .subtitle:
      return "add_document_screen_subtitle"
    case .primaryButton:
      return "add_document_primary_button"
    case let .attestation(index):
      return "add_document_screen_attestation_\(index)"
    }
  }

  public var trait: AccessibilityTraits? {
    switch self {
    case .subtitle:
      return .isStaticText
    case .primaryButton:
      return .isButton
    case .attestation:
      return .isButton
    }
  }
}
