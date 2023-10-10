/*
 * Copyright (c) 2023 European Commission
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
import SwiftUI
import logic_resources

public enum ButtonStyleEnum {
  case primary
  case secondary

  var textColor: Color {
    switch self {
    case .primary:
      Theme.shared.color.textPrimaryDark
    case .secondary:
      Theme.shared.color.textPrimaryDark
    }
  }
  var backgroundColor: Color {
    switch self {
    case .primary:
      Theme.shared.color.tertiaryMain
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
