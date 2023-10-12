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
import SwiftUI
import logic_ui
import logic_business

@MainActor
final class BiometryViewModel<Router: RouterHostType, Interactor: BiometryInteractorType>: BaseViewModel<Router> {

  @Published var config: UIConfig.Biometry

  @Published var uiPinInputField: String = ""
  @Published var pinError: String?

  @Published var biometryError: SystemBiometricsError?
  @Published var areBiometricsEnabled: Bool = false

  let interactor: Interactor

  init(router: Router, interactor: Interactor, config: any UIConfigType) {
    guard let config = config as? UIConfig.Biometry else {
      fatalError("BiometryViewModel:: Invalid configuraton")
    }
    self.config = config
    self.interactor = interactor
    super.init(router: router)

    self.initialize()
  }

  private func initialize() {
    areBiometricsEnabled = interactor.areBiometricsEnabled()
  }

  func getBiometryImage() -> Image? {
    return interactor.biometricsImage
  }

  func onPop() {

  }

}
