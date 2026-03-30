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
import logic_ui
import logic_resources

extension UIConfig {
  struct AuthorizeAction: UIConfigType, Equatable {

    public let displayLogo: Bool
    public let caption: LocalizableStringKey
    public let quickPinOnlyCaption: LocalizableStringKey
    public let navigationBackType: ThreeWayNavigationType?
    public let onAuthResult: (@Sendable (UIConfig.AuthorizeAction.AuthorizeActionResult) -> Void)?

    public var log: String {
      return "title: \(caption.toString)" +
      " description: \(quickPinOnlyCaption.toString)" +
      " onBackNav: \(navigationBackType?.key ?? "none")"
    }

    public init(
      displayLogo: Bool,
      caption: LocalizableStringKey,
      quickPinOnlyCaption: LocalizableStringKey,
      navigationBackType: ThreeWayNavigationType?,
      onAuthResult: (@Sendable (UIConfig.AuthorizeAction.AuthorizeActionResult) -> Void)? = nil
    ) {
      self.displayLogo = displayLogo
      self.caption = caption
      self.quickPinOnlyCaption = quickPinOnlyCaption
      self.navigationBackType = navigationBackType
      self.onAuthResult = onAuthResult
    }
  }
}

extension UIConfig.AuthorizeAction {
  static func == (lhs: UIConfig.AuthorizeAction, rhs: UIConfig.AuthorizeAction) -> Bool {
    return lhs.caption == rhs.caption &&
    lhs.quickPinOnlyCaption == rhs.quickPinOnlyCaption &&
    lhs.navigationBackType == rhs.navigationBackType
  }
}

extension UIConfig.AuthorizeAction {
  enum AuthorizeActionResult: Sendable {
    case success
    case cancelled
    case error(Error)
  }
}
