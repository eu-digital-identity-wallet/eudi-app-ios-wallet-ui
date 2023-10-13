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

public protocol LocalizableStringType {
  static var shared: LocalizableStringType { get }
  func get(with key: LocalizableString.Key) -> String
  func get(with key: LocalizableString.Key) -> LocalizedStringKey
}

public final class LocalizableString: LocalizableStringType {

  public static var shared: LocalizableStringType = LocalizableString()

  private let bundle: Bundle

  private init() {
    self.bundle = .assetsBundle
  }

  public func get(with key: Key) -> String {
    return switch key {
    case .custom(let literal):
      literal
    case .screenCaptureSecurityWarning:
      bundle.localizedString(forKey: "screen_recording_security_warning")
    case .faqs:
      bundle.localizedString(forKey: "faq_title")
    case .search:
      bundle.localizedString(forKey: "search")
    case .genericErrorTitle:
      bundle.localizedString(forKey: "generic_error_title")
    case .genericErrorDesc:
      bundle.localizedString(forKey: "generic_error_description")
    case .biometryOpenSettings:
      bundle.localizedString(forKey: "biometry_open_settings")
    case .invalidQuickPin:
      bundle.localizedString(forKey: "invalid_quick_pin")
    case .tryAgain:
      bundle.localizedString(forKey: "try_again")
    }
  }

  public func get(with key: Key) -> LocalizedStringKey {
    return self.get(with: key).toLocalizedStringKey
  }
}

public extension LocalizableString {
  enum Key: Equatable {
    case custom(String)
    case screenCaptureSecurityWarning
    case faqs
    case search
    case genericErrorTitle
    case genericErrorDesc
    case biometryOpenSettings
    case invalidQuickPin
    case tryAgain
  }
}

fileprivate extension String {
  var toLocalizedStringKey: LocalizedStringKey {
    LocalizedStringKey(self)
  }
}

fileprivate extension Bundle {
  func localizedString(forKey key: String) -> String {
    self.localizedString(forKey: key, value: nil, table: nil)
  }
  func localizedStringWithArguments(forKey key: String, arguments: [CVarArg]) -> String {
    String(format: self.localizedString(forKey: key), locale: nil, arguments: arguments)
  }
}
