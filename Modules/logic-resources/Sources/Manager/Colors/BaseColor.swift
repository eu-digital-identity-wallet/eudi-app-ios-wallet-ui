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

public struct BaseColor {
  enum BaseColors: String {
    case black
    case white
    case blue
    case red
    case grey
    case darkGrey
  }

  var bundle: Bundle

  public var black: Color {
    Color(BaseColors.black.rawValue, bundle: bundle)
  }
  public var white: Color {
    Color(BaseColors.white.rawValue, bundle: bundle)
  }
  public var blue: Color {
    Color(BaseColors.blue.rawValue, bundle: bundle)
  }
  public var red: Color {
    Color(BaseColors.red.rawValue, bundle: bundle)
  }
  public var grey: Color {
    Color(BaseColors.grey.rawValue, bundle: bundle)
  }
  public var darkGrey: Color {
    Color(BaseColors.darkGrey.rawValue, bundle: bundle)
  }
}
