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
import Foundation
import SwiftUI

public extension UIDevice {

  enum UIHomeIndicator {
    case unknown
    case available
    case unavailable
  }

  enum UINotch {
    case unknown
    case available
    case unavailable
  }

  var uiHomeIndicator: UIHomeIndicator {

    guard let window = UIApplication.shared.currentUIWindow else {
      return .unknown
    }

    return window.safeAreaInsets.bottom > 0 ? .available : .unavailable
  }

  var uiNotch: UINotch {

    guard let window = UIApplication.shared.currentUIWindow else {
      return .unknown
    }

    return window.safeAreaInsets.top > 20 ? .available : .unavailable
  }
}
