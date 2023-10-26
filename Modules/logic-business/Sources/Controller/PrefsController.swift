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

public protocol PrefsControllerType {
  func setValue(_ value: Any?, forKey: PrefsController.Key)
  func getString(forKey: PrefsController.Key) -> String?
  func getOptionalString(forKey: PrefsController.Key) -> String
  func getBool(forKey: PrefsController.Key) -> Bool
  func getFloat(forKey: PrefsController.Key) -> Float
  func getInt(forKey: PrefsController.Key) -> Int
  func remove(forKey: PrefsController.Key)
  func getValue(forKey: PrefsController.Key) -> Any?
}

public class PrefsController: PrefsControllerType {

  public static let shared = PrefsController()

  private lazy var userDefaultsWrapper: UserDefaults = {
    UserDefaults.standard
  }()

  public init() {}

  public func setValue(_ value: Any?, forKey: PrefsController.Key) {
    userDefaultsWrapper.setValue(value, forKey: forKey.rawValue)
  }

  public func getString(forKey: PrefsController.Key) -> String? {
    return userDefaultsWrapper.string(forKey: forKey.rawValue)
  }

  public func getOptionalString(forKey: PrefsController.Key) -> String {
    return userDefaultsWrapper.string(forKey: forKey.rawValue) ?? ""
  }

  public func getFloat(forKey: PrefsController.Key) -> Float {
    return userDefaultsWrapper.float(forKey: forKey.rawValue)
  }

  public func getBool(forKey: PrefsController.Key) -> Bool {
    return userDefaultsWrapper.bool(forKey: forKey.rawValue)
  }

  public func remove(forKey: PrefsController.Key) {
    userDefaultsWrapper.removeObject(forKey: forKey.rawValue)
  }

  public func getValue(forKey: PrefsController.Key) -> Any? {
    return userDefaultsWrapper.value(forKey: forKey.rawValue)
  }

  public func getInt(forKey: PrefsController.Key) -> Int {
    return userDefaultsWrapper.integer(forKey: forKey.rawValue)
  }
}

public extension PrefsController {
  enum Key: String {
    case biometryEnabled
    case cachedDeepLink
  }
}
