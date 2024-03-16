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
import Combine
import LocalAuthentication
import UIKit
import SwiftUI
import logic_resources
import logic_business

public enum BiometricsState: Equatable {
  case idle
  case loading
  case authenticated
  case failure(SystemBiometryError)
}

public protocol SystemBiometryInteractor {
  func authenticate() -> AnyPublisher<BiometricsState, Never>
  func openSettingsURL(action: @escaping () -> Void)
  var biometricsImage: Image? { get }
  var currentBiometricsMethod: String { get }
  var biometryType: LABiometryType { get }
}

open class SystemBiometryInteractorImpl: SystemBiometryInteractor {

  private let biometryController: SystemBiometryController
  private lazy var cancellables: Set<AnyCancellable> = []

  private var useTestDispatcher: Bool = false

  public var biometryType: LABiometryType {
    biometryController.biometryType
  }

  public init(
    with biometryController: SystemBiometryController,
    useTestDispatcher: Bool = false
  ) {
    self.biometryController = biometryController
    self.useTestDispatcher = useTestDispatcher
  }

  public func authenticate() -> AnyPublisher<BiometricsState, Never> {

    let publisher = biometryController.requestBiometricUnlock()
      .map { BiometricsState.authenticated }
      .catch { error -> AnyPublisher<BiometricsState, Never> in
        return Just(BiometricsState.failure(error)).eraseToAnyPublisher()
      }

    if !self.useTestDispatcher {
      return publisher
        .subscribe(on: DispatchQueue.global(qos: .userInitiated))
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    } else {
      return publisher.eraseToAnyPublisher()
    }
  }

  open var biometricsImage: Image? {
    return switch biometryController.biometryType {
    case .faceID:
      Theme.shared.image.faceId
    case .touchID:
      Theme.shared.image.touchId
    default: nil
    }
  }

  public var currentBiometricsMethod: String {
    switch biometryController.biometryType {
    case .faceID:
      return "Face ID"
    case .touchID:
      return "Touch ID"
    default:
      return ""
    }
  }

  public func openSettingsURL(action: @escaping () -> Void) {
    guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
    UIApplication.shared.open(url, options: [:]) { success in
      guard success else { return }
      action()
    }
  }
}
