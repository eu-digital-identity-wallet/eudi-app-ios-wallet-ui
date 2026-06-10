/*
 * Copyright (c) 2026 European Commission
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
import logic_resources
import Observation

@Copyable
struct BiometryState: ViewState {
  let config: UIConfig.Biometry
  let areBiometricsEnabled: Bool
  let pinError: LocalizableStringKey?
  let throttlePinInput: Bool
  let scenePhase: ScenePhase
  let pendingNavigation: UIConfig.ThreeWayNavigationType?
  let autoBiometryInitiated: Bool
  let biometryImage: Image?
  let isCancellable: Bool
  let quickPinSize: Int
  let contentHeaderConfig: ContentHeaderConfig
  let isLockedOut: Bool
  let lockoutMessage: LocalizableStringKey?
}

@Observable
final class BiometryViewModel<Router: RouterHost>: ViewModel<Router, BiometryState> {

  @ObservationIgnored
  private let AUTO_VERIFY_ON_APPEAR_DELAY = 250

  @ObservationIgnored
  private let PIN_INPUT_DEBOUNCE = 250

  var uiPinInputField: String = "" {
    didSet {
      guard !viewState.isLockedOut else { return }
      if !uiPinInputField.isEmpty && viewState.pinError != nil {
        setState { $0.copy(pinError: nil) }
      }
      debouncedPinInputField.send(uiPinInputField)
    }
  }
  var biometryError: SystemBiometryError?

  @ObservationIgnored
  private let interactor: BiometryInteractor

  @ObservationIgnored
  private var debouncedPinInputField = CurrentValueSubject<String, Never>("")

  @ObservationIgnored
  private var lockoutTickTask: Task<Void, Never>?

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
        areBiometricsEnabled: false,
        pinError: nil,
        throttlePinInput: throttlePinInput,
        scenePhase: .active,
        pendingNavigation: nil,
        autoBiometryInitiated: false,
        biometryImage: nil,
        isCancellable: config.navigationBackType != nil,
        quickPinSize: 6,
        contentHeaderConfig: .init(
          appIconAndTextData: AppIconAndTextData(
            appIcon: ThemeManager.shared.image.logoEuDigitalIndentityWallet
          )
        ),
        isLockedOut: false,
        lockoutMessage: nil
      )
    )

    self.subscribeToPinInput()
  }

  deinit {
    lockoutTickTask?.cancel()
  }

  func initialize() async {

    let biometricsImage = await interactor.getBiometricsImage()
    let isBiometryEnabled = await interactor.isBiometryEnabled()

    setState {
      $0.copy(
        areBiometricsEnabled: isBiometryEnabled,
        biometryImage: biometricsImage
      )
    }

    let lockoutState = await interactor.getPinLockoutState()
    if case .active(let remaining, _) = lockoutState {
      startLockoutTick(initialRemaining: remaining)
    }

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
    Task {
      switch await interactor.authenticate() {
      case .authenticated:
        await interactor.resetPinThrottle()
        stopLockoutTick()
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

  func setPhase(with phase: ScenePhase) {
    setState { $0.copy(scenePhase: phase) }
    if let pending = viewState.pendingNavigation {
      doNavigation(navigationType: pending)
    }
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
    guard !viewState.isLockedOut, value.count == viewState.quickPinSize else { return }
    Task {
      switch await interactor.isPinValid(with: uiPinInputField) {
      case .success:
        await interactor.resetPinThrottle()
        stopLockoutTick()
        self.authenticated()
      case .failure(let error):
        let lockoutState = await interactor.recordPinFailure()
        switch lockoutState {
        case .active(let remaining, _):
          startLockoutTick(initialRemaining: remaining)
        case .idle:
          setState { $0.copy(pinError: .custom(error.errorMessage)) }
          uiPinInputField = ""
        }
      }
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
          image: Theme.shared.image.chevronLeft,
          accessibilityLocator: ToolbarLocators.chevronLeft
        ) {
          self.onPop()
      })

      return .init(
        leadingActions: leadingActions
      )
    }

    return nil
  }

  private func startLockoutTick(initialRemaining: TimeInterval) {

    lockoutTickTask?.cancel()

    let initialRemainingSeconds = Int(ceil(initialRemaining))

    guard initialRemainingSeconds > 0 else {
      stopLockoutTick()
      return
    }

    uiPinInputField = ""
    setState {
      $0
        .copy(
          isLockedOut: true,
          lockoutMessage: buildLockoutMessage(remainingSeconds: initialRemainingSeconds)
        )
        .copy(pinError: nil)
    }

    lockoutTickTask = Task { @MainActor [weak self] in
      while !Task.isCancelled {
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        guard let self else { return }
        let state = await self.interactor.getPinLockoutState()
        guard !Task.isCancelled else { return }
        switch state {
        case .active(let remaining, _):
          self.setState {
            $0.copy(lockoutMessage: self.buildLockoutMessage(remainingSeconds: Int(ceil(remaining))))
          }
        case .idle:
          self.stopLockoutTick()
          return
        }
      }
    }
  }

  private func stopLockoutTick() {
    lockoutTickTask?.cancel()
    lockoutTickTask = nil
    setState {
      $0
        .copy(isLockedOut: false)
        .copy(lockoutMessage: nil)
    }
  }

  private func buildLockoutMessage(remainingSeconds: Int) -> LocalizableStringKey {
    let safeRemaining = max(0, remainingSeconds)
    let minutes = safeRemaining / 60
    let seconds = safeRemaining % 60
    let mmss = String(format: "%02d:%02d", minutes, seconds)
    return LocalizableStringKey.quickPinLockedOut(["\(interactor.maxFailedPinAttempts)", mmss])
  }
}
