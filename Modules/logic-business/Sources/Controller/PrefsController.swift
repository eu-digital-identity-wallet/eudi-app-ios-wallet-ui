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
  func setValue(_ value: Any?, forKey: String)
  func getString(forKey: String) -> String?
  func getOptionalString(forKey: String) -> String
  func getBool(forKey: String) -> Bool
  func getFloat(forKey: String) -> Float
  func getInt(forKey: String) -> Int
  func remove(forKey: String)
  func getValue(forKey: String) -> Any?
}

public class PrefsController: PrefsControllerType {

  public static let shared = PrefsController()

  private lazy var userDefaultsWrapper: UserDefaults = {
    UserDefaults.standard
  }()

  public init() {}

  public func setValue(_ value: Any?, forKey: String) {
    userDefaultsWrapper.setValue(value, forKey: forKey)
  }

  public func getString(forKey: String) -> String? {
    return userDefaultsWrapper.string(forKey: forKey)
  }

  public func getOptionalString(forKey: String) -> String {
    return userDefaultsWrapper.string(forKey: forKey) ?? ""
  }

  public func getFloat(forKey: String) -> Float {
    return userDefaultsWrapper.float(forKey: forKey)
  }

  public func getBool(forKey: String) -> Bool {
    return userDefaultsWrapper.bool(forKey: forKey)
  }

  public func remove(forKey: String) {
    userDefaultsWrapper.removeObject(forKey: forKey)
  }

  public func getValue(forKey: String) -> Any? {
    return userDefaultsWrapper.value(forKey: forKey)
  }

  public func getInt(forKey: String) -> Int {
    return userDefaultsWrapper.integer(forKey: forKey)
  }
}
