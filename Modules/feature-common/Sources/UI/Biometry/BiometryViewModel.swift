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
  /// At login, the warning for a device without a passcode, or nil.
  let deviceLockNotice: LocalizableStringKey?
  /// At login, whether the PIN and biometrics wait until the device has a passcode (`requireDeviceSecure`).
  let isDeviceLockRequired: Bool
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

  @ObservationIgnored
  private var isFinished = false

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
        lockoutMessage: nil,
        deviceLockNotice: nil,
        isDeviceLockRequired: false
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

    await refreshDeviceLockState()

    if viewState.config.shouldInitializeBiometricOnCreate,
       viewState.areBiometricsEnabled,
       !viewState.autoBiometryInitiated,
       !viewState.isDeviceLockRequired {
      setState { $0.copy(autoBiometryInitiated: true) }
      DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(AUTO_VERIFY_ON_APPEAR_DELAY)) {
        self.onBiometry()
      }
    }
  }

  /// Back ends the screen; a PIN or biometric success still in progress then does nothing, so that Back after a
  /// correct PIN changes nothing.
  func onPop() {
    guard !isFinished, let backNavigation = viewState.config.navigationBackType else { return }
    isFinished = true
    doNavigation(navigationType: backNavigation)
  }

  func onBiometry() {
    guard !viewState.isDeviceLockRequired else { return }
    Task {
      switch await interactor.authenticate() {
      case .authenticated:
        await interactor.resetPinThrottle()
        stopLockoutTick()
        await self.authenticated()
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

  /// A navigation held while the scene was not active runs once when it becomes active, then is cleared, so a later
  /// phase change cannot repeat a success, as the ID Provider extension's two-step login would read it. Login checks
  /// the passcode again on return, for example from the device settings, as Android does on every resume.
  func setPhase(with phase: ScenePhase) async {
    setState { $0.copy(scenePhase: phase) }
    guard phase == .active else { return }
    if let pending = viewState.pendingNavigation {
      setState { $0.copy(pendingNavigation: nil) }
      doNavigation(navigationType: pending)
    }
    await refreshDeviceLockState()
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
    guard
      !viewState.isLockedOut,
      !viewState.isDeviceLockRequired,
      value.count == viewState.quickPinSize
    else {
      return
    }
    Task {
      switch await interactor.isPinValid(with: uiPinInputField) {
      case .success:
        await interactor.resetPinThrottle()
        stopLockoutTick()
        await self.authenticated()
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

  /// At login, as at setup, warns on a device without a passcode and, while the configuration requires one, refuses
  /// the PIN and biometrics until one is set, as Android does at every login, so that a passcode removed after setup
  /// is noticed. Confirmations, such as before a presentation, a reset or a change of settings, are not affected.
  private func refreshDeviceLockState() async {
    guard viewState.config.isPreAuthorization else { return }
    let (notice, isRequired): (LocalizableStringKey?, Bool) = switch await interactor.getDeviceLockState() {
    case .secure: (nil, false)
    case .missing: (.quickPinDeviceLockMissingWarning, false)
    case .required: (.quickPinDeviceLockRequiredWarning, true)
    }
    setState { $0.copy(deviceLockNotice: notice).copy(isDeviceLockRequired: isRequired) }
  }

  /// Login (`isPreAuthorization`) unlocks the session before the wallet opens; the confirmation before a
  /// presentation does not. On a screen with Back, the first success ends it, so Back before it, or a second success,
  /// changes nothing. Login has no Back and takes every success, so that one whose navigation a lock refused can be
  /// followed by another.
  private func authenticated() async {
    guard !isFinished else { return }
    isFinished = viewState.isCancellable
    if viewState.config.isPreAuthorization {
      await interactor.unlockSession()
    }
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
