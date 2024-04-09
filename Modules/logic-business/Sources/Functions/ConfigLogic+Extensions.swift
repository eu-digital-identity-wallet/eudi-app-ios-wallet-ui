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
import Foundation

extension ConfigLogic {

  func getBuildType() -> AppBuildType {
    guard
      let type = getBundleNullableValue(key: "Build Type"),
      let buildType = AppBuildType(rawValue: type)
    else {
      return AppBuildType.RELEASE
    }
    return buildType
  }

  func getBundleValue(key: String) -> String {
    return Bundle.main.infoDictionary?[key] as? String ?? ""
  }

  func getBundleNullableValue(key: String) -> String? {
    guard let value = Bundle.main.infoDictionary?[key] as? String, !value.isEmpty else {
      return nil
    }
    return value
  }

  func getBundleOptionalValue<T>(of type: T.Type, key: String) -> T? {
    guard let value = Bundle.main.infoDictionary?[key] as? T else {
      return nil
    }
    return value
  }
}
