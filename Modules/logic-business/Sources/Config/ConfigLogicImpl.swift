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

public struct WalletConfig: ConfigLogic {

  public var baseHost: String {
    return getBundleValue(key: "Base Host")
  }

  public var networkLoggerExclusionList: [String] = [
    "https://region1.app-measurement.com",
    "https://app-measurement.com",
    "https://firebaselogging-pa.googleapis.com",
    "https://fcmtoken.googleapis.com",
    "https://static.realm.io"
  ]

  public var appBuildType: AppBuildType {
    return getBuildType()
  }

  public var appVersion: String {
    return getBundleValue(key: "CFBundleShortVersionString")
  }
}
