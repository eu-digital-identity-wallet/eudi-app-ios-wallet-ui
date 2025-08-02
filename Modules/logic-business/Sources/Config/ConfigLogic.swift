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
import EudiRQESUi

public enum AppBuildType: String, Sendable {
  case RELEASE, DEBUG
}

public enum AppBuildVariant: String, Sendable {
  case DEMO, DEV
}

public protocol ConfigLogic: Sendable {

  /**
   * Wallet base url for direct network operation.
   */
  var walletHostUrl: String { get }

  /**
   * Build type.
   */
  var appBuildType: AppBuildType { get }

  /**
   * Build Variant.
   */
  var appBuildVariant: AppBuildVariant { get }

  /**
   * App version.
   */
  var appVersion: String { get }

  /**
   * RQES Config
   */
  var rqesConfig: EudiRQESUiConfig { get }

  /**
   * Changelog URL
   */
  var changelogUrl: URL? { get }
}

struct ConfigLogicImpl: ConfigLogic {

  public var walletHostUrl: String {
    getBundleValue(key: "Wallet Host Url")
  }

  public var appBuildType: AppBuildType {
    getBuildType()
  }

  public var appVersion: String {
    getBundleValue(key: "CFBundleShortVersionString")
  }

  public var appBuildVariant: AppBuildVariant {
    getBuildVariant()
  }

  public var rqesConfig: EudiRQESUiConfig {
    RQESConfig(buildVariant: appBuildVariant, buildType: appBuildType)
  }

  public var changelogUrl: URL? {
    guard
      let value = getBundleNullableValue(key: "Changelog Url"),
      let url = URL(string: value)
    else {
      return nil
    }
    return url
  }
}
