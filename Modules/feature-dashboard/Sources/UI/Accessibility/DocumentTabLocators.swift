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

public enum DocumentTabLocators: String, LocatorType {
  case plusButton
  case filterButton

  public var id: String {
    switch self {
    case .plusButton:
      return "documents_screen_plus_button"
    case .filterButton:
      return "documents_screen_filters_button"
    }
  }

  public var trait: AccessibilityTraits? {
    .isButton
  }
}
