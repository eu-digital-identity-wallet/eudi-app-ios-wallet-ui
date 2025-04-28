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
import logic_ui
import logic_resources

public extension UIConfig {
  struct Biometry: UIConfigType, Equatable {

    public let navigationTitle: LocalizableStringKey
    public let displayLogo: Bool
    public let title: LocalizableStringKey?
    public let caption: LocalizableStringKey
    public let quickPinOnlyCaption: LocalizableStringKey
    public let navigationSuccessType: ThreeWayNavigationType
    public let navigationBackType: ThreeWayNavigationType?
    public let isPreAuthorization: Bool
    public let shouldInitializeBiometricOnCreate: Bool

    public var log: String {
      return "navigationTitle: \(navigationTitle.toString)" +
      "displayLogo: \(displayLogo)" +
      "title: \(title?.toString ?? "none")" +
      " onSuccessNav: \(navigationSuccessType.key)" +
      " onBackNav: \(navigationBackType?.key ?? "none")" +
      " isPreAuthorization: \(isPreAuthorization)" +
      " shouldInitializeBiometricOnCreate: \(shouldInitializeBiometricOnCreate)"
    }

    public init(
      navigationTitle: LocalizableStringKey,
      displayLogo: Bool = true,
      title: LocalizableStringKey? = nil,
      caption: LocalizableStringKey,
      quickPinOnlyCaption: LocalizableStringKey,
      navigationSuccessType: ThreeWayNavigationType,
      navigationBackType: ThreeWayNavigationType?,
      isPreAuthorization: Bool,
      shouldInitializeBiometricOnCreate: Bool
    ) {
      self.navigationTitle = navigationTitle
      self.displayLogo = displayLogo
      self.title = title
      self.caption = caption
      self.quickPinOnlyCaption = quickPinOnlyCaption
      self.navigationSuccessType = navigationSuccessType
      self.navigationBackType = navigationBackType
      self.isPreAuthorization = isPreAuthorization
      self.shouldInitializeBiometricOnCreate = shouldInitializeBiometricOnCreate
    }
  }
}
