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
  case secondaryWithColor(
    textColor: Color,
    backgroundColor: Color,
    borderColor: Color
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
    case .secondaryWithColor(let textColor, _, _):
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
    case .secondaryWithColor(_, let background, _):
      background
    }
  }
  var borderWidth: CGFloat {
    switch self {
    case .primary:
      0
    case .secondary, .success, .error, .secondaryWithColor:
      1
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
    case .secondaryWithColor(_, _, let borderColor):
      borderColor
    }
  }
}
