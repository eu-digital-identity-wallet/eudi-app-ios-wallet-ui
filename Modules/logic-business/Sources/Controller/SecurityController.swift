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
import IOSSecuritySuite
import Combine
import UIKit

public protocol SecurityControllerType {
  func isRunningOnEmulator() -> Bool
  func isDeviceJailBroken() -> Bool
  func isReverseEngineered() -> Bool
  func isSignatureValid() -> Bool
  func isDebuggable() -> Bool
  func isApplicationSecure() -> AnyPublisher<SecurityController.SecurityValidation, Never>
  func isScreenCaptureDisabled() -> Bool
  func isBlockUnsecureWebContentEnabled() -> Bool
  func isDeviceBindingValid() -> Bool
}

public final class SecurityController: SecurityControllerType {

  private lazy var configLogic: ConfigLogic = ConfigProvider.shared.getConfigLogic()
  private lazy var configSecurityLogic: ConfigSecurityLogic = ConfigProvider.shared.getConfigSecurityLogic()
  private lazy var keychainController: KeyChainControllerType = KeyChainController()

  public init() {}

  public func isDeviceBindingValid() -> Bool {
    guard configSecurityLogic.bindToDevice, configLogic.appBuildType == .RELEASE else {
      return true
    }
    guard let vendorId = UIDevice.current.identifierForVendor?.uuidString else {
      return false
    }
    if let id = keychainController.getValue(key: KeychainIdentifier.deviceVendorId) {
      return vendorId == id
    }
    keychainController.storeValue(key: KeychainIdentifier.deviceVendorId, value: vendorId)
    return true
  }

  public func isRunningOnEmulator() -> Bool {
    return configLogic.appBuildType == .RELEASE
    && configSecurityLogic.blockEmulator
    && IOSSecuritySuite.amIRunInEmulator()
  }

  public func isDeviceJailBroken() -> Bool {
    return configLogic.appBuildType == .RELEASE
    && configSecurityLogic.blockRootAccess
    && IOSSecuritySuite.amIJailbroken()
  }

  public func isSignatureValid() -> Bool {

    guard configLogic.appBuildType == .RELEASE, let info = configSecurityLogic.profileInformation else {
      return true
    }

    return !IOSSecuritySuite.amITampered([.bundleID(info.bundleId), .mobileProvision(info.signature)]).result
  }

  public func isReverseEngineered() -> Bool {
    return configLogic.appBuildType == .RELEASE
    && configSecurityLogic.blockReverseEngineering
    && IOSSecuritySuite.amIReverseEngineered()
  }

  public func isDebuggable() -> Bool {
    return configLogic.appBuildType == .RELEASE
    && configSecurityLogic.blockDebugMode
    && IOSSecuritySuite.amIDebugged()
  }

  public func isApplicationSecure() -> AnyPublisher<SecurityValidation, Never> {
    return Deferred {
      Future { [weak self] promise in

        guard let self = self else { return }

        let isRunningOnEmulator = self.isRunningOnEmulator()
        let isDeviceJailBroken = self.isDeviceJailBroken()
        let isReverseEngineered = self.isDeviceJailBroken()
        let isSignatureValid = self.isSignatureValid()
        let isDebuggable = self.isDebuggable()
        let isDeviceBindingValid = self.isDeviceBindingValid()

        var code: SecurityController.SecurityErrorCode = .UNKNOWN

        if isRunningOnEmulator {
          code = .EMULATOR
        } else if isDeviceJailBroken {
          code = .JAILBREAK
        } else if isReverseEngineered {
          code = .REVERSE
        } else if !isSignatureValid {
          code = .SIGNATURE
        } else if isDebuggable {
          code = .DEBBUGABLE
        } else if !isDeviceBindingValid {
          code = .DEVICE_BINDING
        }

        promise(.success(
          SecurityController.SecurityValidation(
            isRunningOnEmulator: isRunningOnEmulator,
            isDeviceJailBroken: isDeviceJailBroken,
            isReverseEngineered: isReverseEngineered,
            isSignatureValid: isSignatureValid,
            isDebuggable: isDebuggable,
            isDeviceBindingValid: isDeviceBindingValid,
            serviceErrorCode: code
          ))
        )
      }
    }.eraseToAnyPublisher()
  }

  public func isScreenCaptureDisabled() -> Bool {
    return configSecurityLogic.blockScreenCapture && configLogic.appBuildType == .RELEASE
  }

  public func isBlockUnsecureWebContentEnabled() -> Bool {
    return configSecurityLogic.blockUnsecureWebContent && configLogic.appBuildType == .RELEASE
  }
}

public extension SecurityController {

  struct SecurityValidation {
    public let isRunningOnEmulator: Bool
    public let isDeviceJailBroken: Bool
    public let isReverseEngineered: Bool
    public let isSignatureValid: Bool
    public let isDebuggable: Bool
    public let isDeviceBindingValid: Bool
    public let serviceErrorCode: SecurityErrorCode

    public init(
      isRunningOnEmulator: Bool,
      isDeviceJailBroken: Bool,
      isReverseEngineered: Bool,
      isSignatureValid: Bool,
      isDebuggable: Bool,
      isDeviceBindingValid: Bool,
      serviceErrorCode: SecurityErrorCode
    ) {
      self.isRunningOnEmulator = isRunningOnEmulator
      self.isDeviceJailBroken = isDeviceJailBroken
      self.isReverseEngineered = isReverseEngineered
      self.isSignatureValid = isSignatureValid
      self.isDebuggable = isDebuggable
      self.isDeviceBindingValid = isDeviceBindingValid
      self.serviceErrorCode = serviceErrorCode
    }
  }

  enum SecurityErrorCode: String {
    case EMULATOR = "1001"
    case JAILBREAK = "1002"
    case SIGNATURE = "1003"
    case REVERSE = "1004"
    case DEBBUGABLE = "1005"
    case DEVICE_BINDING = "1006"
    case UNKNOWN = "1000"
  }
}
