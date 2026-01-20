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

public enum IssuanceOptionLocators: String, LocatorType {
  case chooseFromList
  case scanQrCode
  case optionScreenTitle

  public var id: String {
    switch self {
    case .chooseFromList:
      return "options_screen_from_list_button"
    case .scanQrCode:
      return "options_screen_scan_qr_code_button"
    case .optionScreenTitle:
      return "options_screen_scan_qr_code_button"
    }
  }

  public var trait: AccessibilityTraits? {
    switch self {
    case .chooseFromList:
      return .isButton
    case .scanQrCode:
      return .isButton
    case .optionScreenTitle:
      return .isStaticText
    }
  }
}
