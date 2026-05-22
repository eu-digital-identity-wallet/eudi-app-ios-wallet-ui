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
import logic_resources
import Observation

enum QuickPinStep {
  case validate
  case firstInput
  case retryInput(String)
}

@Copyable
struct QuickPinState: ViewState {
  let config: QuickPinUiConfig
  let navigationTitle: LocalizableStringKey
  let title: LocalizableStringKey
  let caption: LocalizableStringKey?
  let pinTextFieldTitle: LocalizableStringKey
  let buttonImage: Image
  let successTitle: LocalizableStringKey
  let successCaption: LocalizableStringKey
  let successButton: LocalizableStringKey
  let successNavigationType: UIConfig.DeepLinkNavigationType
  let isCancellable: Bool
  let pinError: LocalizableStringKey?
  let step: QuickPinStep
  let quickPinSize: Int
  let isLockedOut: Bool
  let lockoutMessage: LocalizableStringKey?
}

@Observable
final class QuickPinViewModel<Router: RouterHost>: ViewModel<Router, QuickPinState> {

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
  var isCancelModalShowing: Bool = false

  @ObservationIgnored
  private let interactor: QuickPinInteractor

  @ObservationIgnored
  private var debouncedPinInputField = CurrentValueSubject<String, Never>("")

  @ObservationIgnored
  private var lockoutTickTask: Task<Void, Never>?

  init(
    router: Router,
    interactor: QuickPinInteractor,
    config: any UIConfigType
  ) {
    guard let config = config as? QuickPinUiConfig else {
      fatalError("QuickPinViewModel:: Invalid configuraton")
    }
    self.interactor = interactor

    var successNavigation: UIConfig.DeepLinkNavigationType {
      switch config.flow {
      case .setWithActivation:
          .push(screen: .featureIssuanceModule(.issuanceAddDocument(config: IssuanceFlowUiConfig(flow: .noDocument))))
      case .setWithoutActivation:
          .push(screen: .featureDashboardModule(.dashboard))
      case .update:
          .pop(screen: .featureDashboardModule(.dashboard))
      }
    }

    var successButton: LocalizableStringKey {
      switch config.flow {
      case .setWithActivation:
          .quickPinSetSuccessButton
      case .setWithoutActivation:
          .quickPinSetNoActivationSuccessButton
      case .update:
          .quickPinUpdateSuccessButton
      }
    }

    var successCaption: LocalizableStringKey {
      switch config.flow {
      case .setWithActivation:
          .quickPinSetSuccess
      case .setWithoutActivation:
          .quickPinSetNoActivationSuccess
      case .update:
          .quickPinUpdateSuccess
      }
    }

    super.init(
      router: router,
      initialState: .init(
        config: config,
        navigationTitle: config.isSetFlow ? .quickPinNavigationEnterPin : .quickPinUpdateTitle,
        title: config.isSetFlow ? .quickPinSetTitle : .quickPinUpdateTitle,
        caption: .quickPinSetCaptionOne,
        pinTextFieldTitle: config.isSetFlow ? .quickPinEnterPin : .quickPinUpdateCaptionOne,
        buttonImage: Theme.shared.image.chevronRight,
        successTitle: config.isSetFlow
        ? .walletIsSecured
        : .successTitlePunctuated,
        successCaption: successCaption,
        successButton: successButton,
        successNavigationType: successNavigation,
        isCancellable: config.isUpdateFlow,
        pinError: nil,
        step: config.isSetFlow ? .firstInput : .validate,
        quickPinSize: 6,
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
    guard case .validate = viewState.step else { return }
    let state = await interactor.getPinLockoutState()
    if case .active(let remaining, _) = state {
      startLockoutTick(initialRemaining: remaining)
    }
  }

  var contentCaption: LocalizableStringKey? {
    viewState.caption
  }

  func onShowCancellationModal() {
    isCancelModalShowing = !isCancelModalShowing
  }

  func onPop() {
    isCancelModalShowing = false
    router.pop()
  }

  func toolbarContent() -> ToolBarContent? {
    guard showsLeadingBackButton else { return nil }
    return .init(
      leadingActions: [
        .init(
          image: Theme.shared.image.chevronLeft,
          accessibilityLocator: ToolbarLocators.chevronLeft
        ) {
          self.onLeadingBack()
        }
      ]
    )
  }

  private var showsLeadingBackButton: Bool {
    if viewState.isCancellable {
      return true
    }
    if viewState.config.isSetFlow, case .retryInput = viewState.step {
      return true
    }
    return false
  }

  private func onLeadingBack() {
    if viewState.isCancellable {
      onShowCancellationModal()
      return
    }
    guard viewState.config.isSetFlow, case .retryInput = viewState.step else { return }
    setState {
      $0
        .copy(
          navigationTitle: .quickPinNavigationEnterPin,
          pinTextFieldTitle: .quickPinEnterPin,
          step: .firstInput
        )
        .copy(pinError: nil)
    }
    uiPinInputField = ""
  }

  private func subscribeToPinInput() {
    debouncedPinInputField
      .dropFirst()
      .debounce(for: .milliseconds(PIN_INPUT_DEBOUNCE), scheduler: RunLoop.main)
      .removeDuplicates()
      .sink { [weak self] value in
        guard let self = self else { return }
        self.processPin(value: value)
      }.store(in: &cancellables)
  }

  private func processPin(value: String) {
    guard !viewState.isLockedOut, value.count == viewState.quickPinSize else { return }
    Task {
      switch viewState.step {
      case .validate:
        await onValidate()
      case .firstInput:
        advanceToRetryInput()
      case .retryInput(let previousPin):
        await confirmRetry(previousPin: previousPin)
      }
    }
  }

  private func onValidate() async {
    switch await interactor.isPinValid(pin: uiPinInputField) {
    case .success:
      await interactor.resetPinThrottle()
      stopLockoutTick()
      setState {
        $0
          .copy(
            pinTextFieldTitle: .quickPinUpdateCaptionTwo,
            buttonImage: Theme.shared.image.chevronRight,
            step: .firstInput
          )
          .copy(pinError: nil)
      }
      uiPinInputField = ""
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

  private func advanceToRetryInput() {
    if viewState.config.isUpdateFlow {
      setState {
        $0
          .copy(
            navigationTitle: .quickPinConfirmPin,
            title: .quickPinUpdateTitle,
            pinTextFieldTitle: .quickPinUpdateCaptionThree,
            step: .retryInput(uiPinInputField)
          )
          .copy(pinError: nil)
      }
    } else {
      setState {
        $0
          .copy(
            navigationTitle: .quickPinConfirmPin,
            pinTextFieldTitle: .quickPinSetCaptionTwo,
            step: .retryInput(uiPinInputField)
          )
          .copy(pinError: nil)
      }
    }
    uiPinInputField = ""
  }

  private func confirmRetry(previousPin: String) async {
    guard previousPin == uiPinInputField else {
      setState { $0.copy(pinError: .quickPinDoNotMatch) }
      uiPinInputField = ""
      return
    }
    await onSuccess()
  }

  private func onSuccess() async {
    await interactor.setPin(newPin: uiPinInputField)

    let visualKind: UIConfig.Success.VisualKind = viewState.config.isSetFlow ?
      .customIcon(
        Theme.shared.image.successSecuredWallet,
        Color.clear
      ) :
      .customIcon(
        Theme.shared.image.checkmarkCircleFill,
        Theme.shared.color.success
      )

    router.push(
      with: .featureCommonModule(
        .genericSuccess(
          config: UIConfig.Success(
            title: .init(value: viewState.successTitle),
            subtitle: viewState.successCaption,
            buttons: [
              .init(
                title: viewState.successButton,
                style: .primary,
                navigationType: viewState.successNavigationType
              )
            ],
            visualKind: visualKind
          )
        )
      )
    )
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
