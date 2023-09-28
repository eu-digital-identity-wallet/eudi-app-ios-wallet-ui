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

public protocol ColorManagerProtocol {

  var primary: Color { get }
  var primaryVariant: Color { get }
  var onPrimary: Color { get }
  var secondary: Color { get }
  var secondaryVariant: Color { get }
  var onSecondary: Color { get }
  var background: Color { get }
  var onBackground: Color { get }
  var surface: Color { get }
  var onSurface: Color { get }
  var error: Color { get }
  var onError: Color { get }
}

class ColorManager: ColorManagerProtocol {

  enum ColorEnum: String {
    case primary
    case primaryVariant
    case onPrimary
    case secondary
    case secondaryVariant
    case onSecondary
    case background
    case onBackground
    case surface
    case onSurface
    case error
    case onError
  }

  // MARK: - Properties

  var bundle: Bundle
  // MARK: - Lifecycle

  init(bundle: Bundle) {
    self.bundle = bundle
  }
  // MARK: - Colors

  var primary: Color {
    Color(ColorEnum.primary.rawValue, bundle: bundle)
  }

  var primaryVariant: Color {
    Color(ColorEnum.primaryVariant.rawValue, bundle: bundle)
  }

  var onPrimary: Color {
    Color(ColorEnum.onPrimary.rawValue, bundle: bundle)
  }

  var secondary: Color {
    Color(ColorEnum.secondary.rawValue, bundle: bundle)
  }

  var secondaryVariant: Color {
    Color(ColorEnum.secondaryVariant.rawValue, bundle: bundle)
  }

  var onSecondary: Color {
    Color(ColorEnum.onSecondary.rawValue, bundle: bundle)
  }

  var background: Color {
    Color(ColorEnum.background.rawValue, bundle: bundle)
  }

  var onBackground: Color {
    Color(ColorEnum.onBackground.rawValue, bundle: bundle)
  }

  var surface: Color {
    Color(ColorEnum.surface.rawValue, bundle: bundle)
  }

  var onSurface: Color {
    Color(ColorEnum.onSurface.rawValue, bundle: bundle)
  }

  var error: Color {
    Color(ColorEnum.error.rawValue, bundle: bundle)
  }

  var onError: Color {
    Color(ColorEnum.onError.rawValue, bundle: bundle)
  }

}
