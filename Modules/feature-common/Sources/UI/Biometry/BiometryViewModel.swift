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
import logic_ui
import logic_authentication

@Copyable
struct BiometryState: ViewState {
  let config: UIConfig.Biometry
  let areBiometricsEnabled: Bool
  let pinError: String?
  let throttlePinInput: Bool
  let scenePhase: ScenePhase
  let pendingNavigation: UIConfig.ThreeWayNavigationType?
  let autoBiometryInitiated: Bool
  let biometryImage: Image?
  let isCancellable: Bool
  let quickPinSize: Int
  let contentHeaderConfig: ContentHeaderConfig
}

final class BiometryViewModel<Router: RouterHost>: ViewModel<Router, BiometryState> {

  private let AUTO_VERIFY_ON_APPEAR_DELAY = 250
  private let PIN_INPUT_DEBOUNCE = 250

  @Published var uiPinInputField: String = ""
  @Published var biometryError: SystemBiometryError?

  private let interactor: BiometryInteractor

  init(
    router: Router,
    interactor: BiometryInteractor,
    config: any UIConfigType,
    throttlePinInput: Bool = true
  ) {
    guard let config = config as? UIConfig.Biometry else {
      fatalError("BiometryViewModel:: Invalid configuraton")
    }
    self.interactor = interactor
    super.init(
      router: router,
      initialState: .init(
        config: config,
        areBiometricsEnabled: interactor.isBiometryEnabled(),
        pinError: nil,
        throttlePinInput: throttlePinInput,
        scenePhase: .active,
        pendingNavigation: nil,
        autoBiometryInitiated: false,
        biometryImage: interactor.biometricsImage,
        isCancellable: config.navigationBackType != nil,
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

  func onAppearBiometry() {
    if viewState.config.shouldInitializeBiometricOnCreate, viewState.areBiometricsEnabled, !viewState.autoBiometryInitiated {
      setState { $0.copy(autoBiometryInitiated: true) }
      DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(AUTO_VERIFY_ON_APPEAR_DELAY)) {
        self.onBiometry()
      }
    }
  }

  func onPop() {
    if let backNavigation = viewState.config.navigationBackType {
      doNavigation(navigationType: backNavigation)
    }
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
    setState { $0.copy(scenePhase: phase) }
    if let pending = viewState.pendingNavigation {
      doNavigation(navigationType: pending)
    }
  }

  private func subscribeToPinInput() {

    let publisher = self.$uiPinInputField.dropFirst()

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
    if value.count == viewState.quickPinSize {
      switch interactor.isPinValid(with: uiPinInputField) {
      case .success:
        self.authenticated()
      case .failure(let error):
        setState { $0.copy(pinError: error.localizedDescription) }
      }
    } else {
      setState { $0.copy(pinError: nil) }
    }
  }

  private func authenticated() {
    doNavigation(navigationType: viewState.config.navigationSuccessType)
  }

  private func doNavigation(navigationType: UIConfig.ThreeWayNavigationType) {

    guard viewState.scenePhase == .active else {
      setState { $0.copy(pendingNavigation: navigationType) }
      return
    }

    switch navigationType {
    case .popTo(let route):
      router.popTo(with: route)
    case .push(let route):
      router.push(with: route)
    case .pop:
      router.pop()
    }
  }

  func toolbarContent() -> ToolBarContent? {
    var leadingActions: [ToolBarContent.Action] = []
    if viewState.isCancellable {
      leadingActions.append(
        .init(
          image: Theme.shared.image.chevronLeft
        ) {
          self.onPop()
      })

      return .init(
        leadingActions: leadingActions
      )
    }

    return nil
  }
}
