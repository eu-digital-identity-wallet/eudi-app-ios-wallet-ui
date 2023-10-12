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
import logic_ui
import logic_resources

public extension UIConfig {
  struct Biometry: UIConfigType, Equatable {

    public let title: LocalizableString.Key
    public let caption: LocalizableString.Key
    public let quickPinOnlyCaption: LocalizableString.Key
    public let navigationSuccessConfig: NavigationConfig
    public let navigationBackConfig: NavigationConfig
    public let isPreAuthorization: Bool
    public let shouldInitializeBiometricOnCreate: Bool

    public init(
      title: LocalizableString.Key,
      caption: LocalizableString.Key,
      quickPinOnlyCaption: LocalizableString.Key,
      navigationSuccessConfig: NavigationConfig,
      navigationBackConfig: NavigationConfig,
      isPreAuthorization: Bool,
      shouldInitializeBiometricOnCreate: Bool
    ) {
      self.title = title
      self.caption = caption
      self.quickPinOnlyCaption = quickPinOnlyCaption
      self.navigationSuccessConfig = navigationSuccessConfig
      self.navigationBackConfig = navigationBackConfig
      self.isPreAuthorization = isPreAuthorization
      self.shouldInitializeBiometricOnCreate = shouldInitializeBiometricOnCreate
    }
  }
}
