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
import logic_ui
import logic_business

@MainActor
final class BiometryViewModel<Router: RouterHostType, Interactor: BiometryInteractorType>: BaseViewModel<Router> {

  private let AUTO_VERIFY_ON_APPEAR_DELAY = 250

  @Published var config: UIConfig.Biometry

  @Published var uiPinInputField: String = ""
  @Published var pinError: String?

  @Published var biometryError: SystemBiometricsError?
  @Published var areBiometricsEnabled: Bool = false

  private let interactor: Interactor
  private let throttlePinInput: Bool

  private var scenePhase: ScenePhase = .active
  private var pendingNavigation: UIConfig.NavigationConfig?
  private var autoBiometryInitiated: Bool = false

  init(
    router: Router,
    interactor: Interactor,
    config: any UIConfigType,
    throttlePinInput: Bool = true
  ) {
    guard let config = config as? UIConfig.Biometry else {
      fatalError("BiometryViewModel:: Invalid configuraton")
    }
    self.config = config
    self.interactor = interactor
    self.throttlePinInput = throttlePinInput
    super.init(router: router)

    self.initialize()
  }

  func onAppearBiometry() {
    if self.config.shouldInitializeBiometricOnCreate, self.areBiometricsEnabled, !self.autoBiometryInitiated {
      self.autoBiometryInitiated = true
      DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(AUTO_VERIFY_ON_APPEAR_DELAY)) {
        self.onBiometry()
      }
    }
  }

  func getBiometryImage() -> Image? {
    return interactor.biometricsImage
  }

  func onPop() {
    doNavigation(config: config.navigationBackConfig)
  }

  func onBiometry() {
    interactor.authenticate()
      .sink { _ in } receiveValue: { [weak self] (state) in
        guard let self = self else { return }
        switch state {
        case .authenticated:
          self.authenticated()
        case .failure(let error):
          if error != .biometricError {
            self.biometryError = error
          }
        default: break
        }
      }.store(in: &cancellables)
  }

  func onSettings() {
    interactor.openSettingsURL {}
  }

  func setPhase(with phase: ScenePhase) {
    self.scenePhase = phase
    if let pending = self.pendingNavigation {
      doNavigation(config: pending)
    }
  }

  private func initialize() {
    areBiometricsEnabled = interactor.isBiometryEnabled()
    subscribeToPinInput()
  }

  private func subscribeToPinInput() {

    let publisher = self.$uiPinInputField.dropFirst()

    if self.throttlePinInput {
      publisher
        .debounce(for: .milliseconds(250), scheduler: RunLoop.main)
        .removeDuplicates()
        .sink { [weak self] value in
          guard let self = self else { return }
          self.processPin(value: value)
        }.store(in: &cancellables)
    } else {
      publisher
        .removeDuplicates()
        .sink { [weak self] value in
          guard let self = self else { return }
          self.processPin(value: value)
        }.store(in: &cancellables)
    }
  }

  private func processPin(value: String) {
    if value.count == 4 {
      switch interactor.isPinValid(with: uiPinInputField) {
      case .success:
        self.authenticated()
      case .failure(let error):
        self.pinError = error.localizedDescription
      }
    } else {
      self.pinError = nil
    }
  }

  private func authenticated() {
    doNavigation(config: config.navigationSuccessConfig)
  }

  private func doNavigation(config: UIConfig.NavigationConfig) {

    guard self.scenePhase == .active else {
      self.pendingNavigation = config
      return
    }

    switch config.navigationType {
    case .pop:
      router.popTo(with: config.screen)
    case .push:
      router.push(with: config.screen)
    }
  }
}
