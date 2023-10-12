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

public enum AppBuildType: String {
  case RELEASE, DEBUG
}

public protocol ConfigLogic {

  /**
   * Server base url.
   */
  var baseHost: String { get }

  /**
   * Build type.
   */
  var appBuildType: AppBuildType { get }

  /**
   * App version.
   */
  var appVersion: String { get }
}

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
}
