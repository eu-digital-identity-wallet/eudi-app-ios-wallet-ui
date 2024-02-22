/*
 * Copyright (c) 2023 European Commission
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
import SwiftUI
import logic_resources

public enum ButtonViewStyle {
  case primary
  case secondary

  var textColor: Color {
    switch self {
    case .primary:
      Theme.shared.color.white
    case .secondary:
      Theme.shared.color.textPrimaryDark
    }
  }
  var backgroundColor: Color {
    switch self {
    case .primary:
      Theme.shared.color.primary
    case .secondary:
      Theme.shared.color.backgroundPaper
    }
  }
  var borderWidth: CGFloat {
    switch self {
    case .primary:
      0
    case .secondary:
      1
    }
  }
  var borderColor: Color {
    switch self {
    case .primary:
        .clear
    case .secondary:
      Theme.shared.color.dividerDark
    }
  }
}
