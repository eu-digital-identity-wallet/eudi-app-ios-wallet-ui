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

public enum TabViewLocators: String, LocatorType {
  case home
  case documents
  case transactions

  public var id: String {
    switch self {
    case .home:
      return "home_tab"
    case .documents:
      return "documents_tab"
    case .transactions:
      return "transactions_tab"
    }
  }

  public var trait: AccessibilityTraits? {
    .isTabBar
  }
}
