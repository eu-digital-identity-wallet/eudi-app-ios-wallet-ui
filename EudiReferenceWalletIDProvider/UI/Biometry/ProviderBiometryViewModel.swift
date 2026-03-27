/*
 * Copyright (c) 2025 European Commission
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
import logic_authentication
import feature_common
import Observation

@Copyable
struct ProviderBiometryState: ViewState {
  let config: UIConfig.AuthorizeAction
  let areBiometricsEnabled: Bool
  let pinError: String?
  let throttlePinInput: Bool
  let biometryImage: Image?
  let quickPinSize: Int
  let contentHeaderConfig: ContentHeaderConfig
}

@Observable
final class ProviderBiometryViewModel: ViewModel<ProviderBiometryState> {

  @ObservationIgnored
  private let AUTO_VERIFY_ON_APPEAR_DELAY = 250
  @ObservationIgnored
  private let PIN_INPUT_DEBOUNCE = 250

  var uiPinInputField: String = "" {
    didSet {
      debouncedPinInputField.send(uiPinInputField)
    }
  }
  var biometryError: SystemBiometryError?

  @ObservationIgnored
  private let interactor: BiometryInteractor = DIGraph.shared.resolver.force(
    BiometryInteractor.self
  )
  @ObservationIgnored
  private let onDismiss: () -> Void

  @ObservationIgnored
  private var debouncedPinInputField = CurrentValueSubject<String, Never>("")

  init(
    config: any UIConfigType,
    onDismiss: @escaping () -> Void = {}
  ) {
    self.onDismiss = onDismiss
    guard let config = config as? UIConfig.AuthorizeAction else {
      fatalError("BiometryViewModel:: Invalid configuraton")
    }
    super.init(
      initialState: .init(
        config: config,
        areBiometricsEnabled: true,
        pinError: nil,
        throttlePinInput: true,
        biometryImage: nil,
        quickPinSize: 6,
        contentHeaderConfig: .init(
          appIconAndTextData: AppIconAndTextData(
            appIcon: ThemeManager.shared.image.logoEuDigitalIndentityWallet,
            appText: ThemeManager.shared.image.euditext
          )
        )
      )
    )

    self.subscribeToPinInput()
  }

  func onAppearBiometry() async {
    uiPinInputField = ""
    setState {
      $0.copy(
        pinError: nil
      )
    }

    let biometricsImage = await interactor.getBiometricsImage()
    let isBiometryEnabled = await interactor.isBiometryEnabled()

    setState {
      $0.copy(
        areBiometricsEnabled: isBiometryEnabled,
        biometryImage: biometricsImage
      )
    }
  }

  func onBiometry() {
    Task {
      switch await interactor.authenticate() {
      case .authenticated:
        self.authenticated()
      case .failure(let error):
        if error != .biometricError {
          self.biometryError = error
        }
      }
    }
  }

  func onSettings() {
    Task { await interactor.openSettings {} }
  }

  private func subscribeToPinInput() {

    let publisher = self.debouncedPinInputField.dropFirst()

    if viewState.throttlePinInput {
      publisher
        .debounce(for: .milliseconds(PIN_INPUT_DEBOUNCE), scheduler: RunLoop.main)
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
    Task {
      if value.count == viewState.quickPinSize {
        switch await interactor.isPinValid(with: uiPinInputField) {
        case .success:
          self.authenticated()
        case .failure(let error):
          setState { $0.copy(pinError: error.errorMessage) }
        }
      } else {
        setState { $0.copy(pinError: nil) }
      }
    }
  }

  private func authenticated() {
    onDismiss()
    viewState.config.onAuthResult?(.success)
  }
}
