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
import LocalAuthentication
import Combine
import SwiftUI
import logic_business

public protocol SystemBiometricsControllerType {
  var biometryType: LABiometryType { get }
  func canEvaluateForBiometrics() -> AnyPublisher<Bool, SystemBiometricsError>
  func evaluateBiometrics() -> AnyPublisher<Void, SystemBiometricsError>
  func requestBiometricUnlock() -> AnyPublisher<Void, SystemBiometricsError>
}

public enum SystemBiometricsError: Error, LocalizedError, Identifiable {
  case deniedAccess
  case noFaceIdEnrolled
  case noFingerprintEnrolled
  case biometricError
  case biometryNotSupported

  public var id: String { localizedDescription }

  public var errorDescription: String? {
    switch self {
    case .deniedAccess:
      return NSLocalizedString("You have denied access. Please go to the settings, locate this application and turn the Face ID on", comment: "")
    case .noFaceIdEnrolled:
      return NSLocalizedString("You have not enabled Face ID yet", comment: "")
    case .noFingerprintEnrolled:
      return NSLocalizedString("You have not enabled fingerprint yet", comment: "")
    case .biometricError:
      return NSLocalizedString("Your biometric method has not been recognized", comment: "")
    case .biometryNotSupported:
      return NSLocalizedString("This device does not support biometry", comment: "")
    }
  }
}

public final class SystemBiometricsController: SystemBiometricsControllerType {

  public var biometryType: LABiometryType { context.biometryType }

  private lazy var context = LAContext()
  private lazy var keyChainController: KeyChainControllerType = KeyChainController.shared

  internal var biometricError: NSError?

  public init() {
    _ = canEvaluateForBiometrics()
  }

  deinit {
    self.context.invalidate()
  }

  public func canEvaluateForBiometrics() -> AnyPublisher<Bool, SystemBiometricsError> {

    guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &biometricError) else {
      return Fail(error: SystemBiometricsError.deniedAccess).eraseToAnyPublisher()
    }

    if let error = biometricError {
      switch error.code {
      case -6:
        return Fail(error: SystemBiometricsError.deniedAccess).eraseToAnyPublisher()
      case -7:
        if context.biometryType == .faceID {
          return Fail(error: SystemBiometricsError.noFaceIdEnrolled).eraseToAnyPublisher()
        } else {
          return Fail(error: SystemBiometricsError.noFingerprintEnrolled).eraseToAnyPublisher()
        }
      default:
        return Fail(error: SystemBiometricsError.biometricError).eraseToAnyPublisher()
      }
    }

    guard context.biometryType != .none else {
      return Fail(error: SystemBiometricsError.biometryNotSupported).eraseToAnyPublisher()
    }

    return Just(true).setFailureType(to: SystemBiometricsError.self).eraseToAnyPublisher()
  }

  public func evaluateBiometrics() -> AnyPublisher<Void, SystemBiometricsError> {
    return Deferred {
      Future { [weak self] promise in
        guard let self = self else { return }
        do {
          try self.keyChainController.validateKeyChainBiometry()
          promise(.success(()))
        } catch {
          self.keyChainController.clearKeyChainBiometry()
          promise(.failure(SystemBiometricsError.biometricError))
        }
      }
    }
    .eraseToAnyPublisher()
  }

  public func requestBiometricUnlock() -> AnyPublisher<Void, SystemBiometricsError> {
    canEvaluateForBiometrics()
      .flatMap { [weak self] (_) -> AnyPublisher<Void, SystemBiometricsError> in
        guard let self = self else { return Fail(error: SystemBiometricsError.biometricError).eraseToAnyPublisher() }
        return self.evaluateBiometrics()
      }.eraseToAnyPublisher()
  }
}
