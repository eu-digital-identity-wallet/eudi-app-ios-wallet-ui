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

public protocol PrefsController {
  func setValue(_ value: Any?, forKey: Prefs.Key)
  func getString(forKey: Prefs.Key) -> String?
  func getOptionalString(forKey: Prefs.Key) -> String
  func getBool(forKey: Prefs.Key) -> Bool
  func getFloat(forKey: Prefs.Key) -> Float
  func getInt(forKey: Prefs.Key) -> Int
  func remove(forKey: Prefs.Key)
  func getValue(forKey: Prefs.Key) -> Any?
  func getUserLocale() -> String
}

final class PrefsControllerImpl: PrefsController {

  private lazy var userDefaultsWrapper: UserDefaults = {
    UserDefaults.standard
  }()

  public func setValue(_ value: Any?, forKey: Prefs.Key) {
    userDefaultsWrapper.setValue(value, forKey: forKey.rawValue)
  }

  public func getString(forKey: Prefs.Key) -> String? {
    return userDefaultsWrapper.string(forKey: forKey.rawValue)
  }

  public func getOptionalString(forKey: Prefs.Key) -> String {
    return userDefaultsWrapper.string(forKey: forKey.rawValue) ?? ""
  }

  public func getFloat(forKey: Prefs.Key) -> Float {
    return userDefaultsWrapper.float(forKey: forKey.rawValue)
  }

  public func getBool(forKey: Prefs.Key) -> Bool {
    return userDefaultsWrapper.bool(forKey: forKey.rawValue)
  }

  public func remove(forKey: Prefs.Key) {
    userDefaultsWrapper.removeObject(forKey: forKey.rawValue)
  }

  public func getValue(forKey: Prefs.Key) -> Any? {
    return userDefaultsWrapper.value(forKey: forKey.rawValue)
  }

  public func getInt(forKey: Prefs.Key) -> Int {
    return userDefaultsWrapper.integer(forKey: forKey.rawValue)
  }

  public func getUserLocale() -> String {
    return getString(forKey: .language) ?? "en_GB"
  }
}

public struct Prefs {}

public extension Prefs {
  enum Key: String {
    case biometryEnabled
    case cachedDeepLink
    case runAtLeastOnce
    case language
  }
}
