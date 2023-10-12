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
import Combine
import LocalAuthentication
import UIKit
import SwiftUI
import logic_resources

public enum BiometricsState: Equatable {
  case idle
  case loading
  case authenticated
  case failure(SystemBiometricsError)
}

//sourcery: AutoMockable
public protocol SystemBiometricsInteractorType {
  func authenticate() -> AnyPublisher<BiometricsState, Never>
  func openSettingsURL(action: @escaping () -> Void)
  var biometricsImage: Image? { get }
  var currentBiometricsMethod: String { get }
  var biometryType: LABiometryType { get }
}

open class SystemBiometricsInteractor: SystemBiometricsInteractorType {

  private lazy var biometricsController: SystemBiometricsControllerType = SystemBiometricsController()
  private lazy var cancellables: Set<AnyCancellable> = []

  private var useTestDispatcher: Bool = false

  public var biometryType: LABiometryType {
    biometricsController.biometryType
  }

  public init() {}

  public init(
    with biometricsController: SystemBiometricsControllerType,
    useTestDispatcher: Bool = false
  ) {
    self.biometricsController = biometricsController
    self.useTestDispatcher = useTestDispatcher
  }

  public func authenticate() -> AnyPublisher<BiometricsState, Never> {

    let publisher = biometricsController.requestBiometricUnlock()
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
    return switch biometricsController.biometryType {
    case .faceID:
      ThemeManager.shared.image.faceId
    case .touchID:
      ThemeManager.shared.image.touchId
    default: nil
    }
  }

  public var currentBiometricsMethod: String {
    switch biometricsController.biometryType {
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
