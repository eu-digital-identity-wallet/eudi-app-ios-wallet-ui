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

  func getBuildVariant() -> AppBuildVariant {
    guard
      let name = getBundleNullableValue(key: "Build Variant"),
      let variant = AppBuildVariant(rawValue: name)
    else {
      return AppBuildVariant.DEV
    }
    return variant
  }

  func getBundleValue(key: String) -> String {
    return key.valueFromBundle
  }

  func getBundleNullableValue(key: String) -> String? {
    key.optionalValueFromBundle
  }
}
