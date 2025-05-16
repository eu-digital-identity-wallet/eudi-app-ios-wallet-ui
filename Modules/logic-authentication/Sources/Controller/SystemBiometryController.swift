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
@preconcurrency import LocalAuthentication
import Combine
import logic_business

internal final class BiometryError: @unchecked Sendable {
  internal var value: NSError?
}

public protocol SystemBiometryController: Sendable {
  var biometryType: LABiometryType { get }
  func requestBiometricUnlock() -> AnyPublisher<Void, SystemBiometryError>
}

public enum SystemBiometryError: Error, LocalizedError, Identifiable, Sendable {
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

final class SystemBiometryControllerImpl: SystemBiometryController {

  public var biometryType: LABiometryType { context.biometryType }

  private let context: LAContext
  private let keyChainController: KeyChainController

  private let biometricError: BiometryError = .init()

  public init(
    context: LAContext = LAContext(),
    keyChainController: KeyChainController
  ) {
    self.context = context
    self.keyChainController = keyChainController
    _ = canEvaluateForBiometrics()
  }

  deinit {
    self.context.invalidate()
  }

  public func requestBiometricUnlock() -> AnyPublisher<Void, SystemBiometryError> {
    canEvaluateForBiometrics()
      .flatMap { [weak self] (_) -> AnyPublisher<Void, SystemBiometryError> in
        guard let self = self else {
          return Fail(error: SystemBiometryError.biometricError).eraseToAnyPublisher()
        }
        return self.evaluateBiometrics()
      }
      .eraseToAnyPublisher()
  }

  private func canEvaluateForBiometrics() -> AnyPublisher<Bool, SystemBiometryError> {

    guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &biometricError.value) else {
      return Fail(error: SystemBiometryError.deniedAccess).eraseToAnyPublisher()
    }

    if let error = biometricError.value {
      switch error.code {
      case -6:
        return Fail(error: SystemBiometryError.deniedAccess).eraseToAnyPublisher()
      case -7:
        if context.biometryType == .faceID {
          return Fail(error: SystemBiometryError.noFaceIdEnrolled).eraseToAnyPublisher()
        } else {
          return Fail(error: SystemBiometryError.noFingerprintEnrolled).eraseToAnyPublisher()
        }
      default:
        return Fail(error: SystemBiometryError.biometricError).eraseToAnyPublisher()
      }
    }

    guard context.biometryType != .none else {
      return Fail(error: SystemBiometryError.biometryNotSupported).eraseToAnyPublisher()
    }

    return Just(true).setFailureType(to: SystemBiometryError.self).eraseToAnyPublisher()
  }

  private func evaluateBiometrics() -> AnyPublisher<Void, SystemBiometryError> {
    return Deferred {
      Future { [weak self] promise in
        guard let self = self else { return }
        do {
          try self.keyChainController.validateKeyChainBiometry()
          promise(.success(()))
        } catch {
          self.keyChainController.clearKeyChainBiometry()
          promise(.failure(SystemBiometryError.biometricError))
        }
      }
    }
    .eraseToAnyPublisher()
  }
}
