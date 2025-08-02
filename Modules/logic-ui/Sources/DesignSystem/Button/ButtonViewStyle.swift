/*
 * Copyright (c) 2025 European Commission
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
  case custom(
    textColor: Color,
    backgroundColor: Color,
    borderColor: Color,
    useBorder: Bool
  )
  case error
  case success

  var textColor: Color {
    switch self {
    case .primary:
      Theme.shared.color.onPrimary
    case .secondary:
      Theme.shared.color.primary
    case .error:
      Theme.shared.color.error
    case .success:
      Theme.shared.color.surfaceContainerLowest
    case .custom(let textColor, _, _, _):
      textColor
    }
  }
  var backgroundColor: Color {
    switch self {
    case .primary:
      Theme.shared.color.primary
    case .secondary:
        .clear
    case .error:
      Theme.shared.color.background
    case .success:
      Theme.shared.color.success
    case .custom(_, let background, _, _):
      background
    }
  }
  var borderWidth: CGFloat {
    switch self {
    case .primary:
      0
    case .secondary, .success, .error:
      1
    case .custom(_, _, _, let useBorder):
      useBorder ? 1 : 0
    }
  }
  var borderColor: Color {
    switch self {
    case .primary, .success:
        .clear
    case .secondary:
      Theme.shared.color.primary
    case .error:
      Theme.shared.color.error
    case .custom(_, _, let borderColor, _):
      borderColor
    }
  }
}
