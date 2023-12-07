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

  public func getUserLocale() -> String {
    return getString(forKey: .language) ?? "en_GB"
  }
}

public extension PrefsController {
  enum Key: String {
    case biometryEnabled
    case cachedDeepLink
    case runAtLeastOnce
    case language
  }
}
