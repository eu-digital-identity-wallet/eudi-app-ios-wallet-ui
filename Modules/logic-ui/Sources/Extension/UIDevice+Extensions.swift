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
