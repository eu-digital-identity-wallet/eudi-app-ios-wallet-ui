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
import logic_ui

public enum TransactionDetailsLocators: String, LocatorType {
  case deleteNavigationBarButton
  case confirmDialogDeleteButton
  case confirmDialogCancelButton

  public var id: String {
    switch self {
    case .deleteNavigationBarButton:
      return "transaction_details_delete_navigation_bar_button"
    case .confirmDialogDeleteButton:
      return "transaction_details_dialog_delete_transaction_positive_button"
    case .confirmDialogCancelButton:
      return "transaction_details_dialog_delete_transaction_negative_button"
    }
  }

  public var trait: AccessibilityTraits? {
    .isButton
  }
}
