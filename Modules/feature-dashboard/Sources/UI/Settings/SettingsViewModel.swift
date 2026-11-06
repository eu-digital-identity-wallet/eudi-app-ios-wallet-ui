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
import SwiftUI
import logic_ui
import logic_core
import feature_common

@Copyable
struct SettingsViewState: ViewState {
  let items: [SettingMenuItemUIModel]
  let isBiometryEnabled: Bool
  let appVersion: String?
  let logsUrl: URL?
  let changelogUrl: URL?
}

@Observable
final class SettingsViewModel<Router: RouterHost>: ViewModel<Router, SettingsViewState> {
  var isBatchCounterEnabled: Bool = false {
    didSet {
      guard !isHydratingBatchCounter, oldValue != isBatchCounterEnabled else { return }
      updateBatchCounter(isBatchCounterEnabled)
    }
  }

  var isOfferingDocumentsToApps: Bool = true {
    didSet {
      guard !isHydratingDocumentOffering, oldValue != isOfferingDocumentsToApps else { return }
      updateDocumentOffering(isOfferingDocumentsToApps)
    }
  }

  var isIssuerRegistrationValidationEnabled: Bool = false {
    didSet {
      guard !isHydratingIssuerRegistration, oldValue != isIssuerRegistrationValidationEnabled else { return }
      updateIssuerRegistrationValidation(isIssuerRegistrationValidationEnabled)
    }
  }

  var isRestartRequiredAlertShowing: Bool = false

  var isResetConfirmationShowing: Bool = false

  @ObservationIgnored
  private var isHydratingBatchCounter = false

  @ObservationIgnored
  private var isHydratingIssuerRegistration = false
  @ObservationIgnored
  private var isHydratingDocumentOffering = false
  @ObservationIgnored
  private var isBiometrySwitchOpening = false

  private let interactor: SettingsInteractor
  private let walletKitController: WalletKitController

  init(
    router: Router,
    interactor: SettingsInteractor,
    walletKit: WalletKitController
  ) {
    self.interactor = interactor
    self.walletKitController = walletKit
    super.init(
      router: router,
      initialState: .init(
        items: [],
        isBiometryEnabled: false,
        appVersion: nil,
        logsUrl: nil,
        changelogUrl: nil
      )
    )
  }

  func initialize() async {
    isBiometrySwitchOpening = false
    await buildUi()
  }

  func toolbarContent() -> ToolBarContent {
    .init(
      trailingActions: [],
      leadingActions: [
        .init(
          image: Theme.shared.image.chevronLeft,
          accessibilityLocator: ToolbarLocators.chevronLeft
        ) {
          self.router.pop()
        }
      ]
    )
  }

  /// Opens the PIN or biometric check that must pass before biometric unlock is switched, as on Android: the PIN to
  /// turn it on, so that a biometric enrolled by someone holding the unlocked phone cannot turn it on, and the PIN or
  /// a biometric to turn it off. The screen after the check makes the change and returns here; Back changes nothing.
  /// A second tap while the check opens is ignored, since the router would queue a second screen; the switch takes
  /// taps again when the settings appear again.
  func onBiometrySwitch() {
    guard !isBiometrySwitchOpening else { return }
    isBiometrySwitchOpening = true
    let caption: LocalizableStringKey = viewState.isBiometryEnabled
      ? .biometryUnlockOffCaption
      : .biometryUnlockOnCaption
    router.push(
      with: .featureCommonModule(
        .biometry(
          config: UIConfig.Biometry(
            navigationTitle: .loginWithBiometrics,
            caption: caption,
            quickPinOnlyCaption: caption,
            pinTextFieldTitle: caption,
            navigationSuccessType: .push(
              .featureDashboardModule(.biometrySelection(isEnabled: !viewState.isBiometryEnabled))
            ),
            navigationBackType: .pop,
            isPreAuthorization: false,
            shouldInitializeBiometricOnCreate: true
          )
        )
      )
    )
  }

  private func buildUi() async {

    let appVersion = await interactor.getAppVersion()
    let logsUrl = await interactor.retrieveLogFileUrl()
    let changelogUrl = await interactor.retrieveChangeLogUrl()
    let isBiometryAvailable = await interactor.isBiometryAvailable()
    let isBiometryEnabled = await interactor.isBiometryEnabled()

    isHydratingBatchCounter = true
    isBatchCounterEnabled = await interactor.isBatchCounterEnabled()
    isHydratingBatchCounter = false

    isHydratingIssuerRegistration = true
    isIssuerRegistrationValidationEnabled = await interactor.isIssuerRegistrationValidationEnabled()
    isHydratingIssuerRegistration = false

    let isDocumentOfferingAvailable = await interactor.isDocumentOfferingAvailable()
    isHydratingDocumentOffering = true
    isOfferingDocumentsToApps = await interactor.isOfferingDocumentsToApps()
    isHydratingDocumentOffering = false

    var items: [SettingMenuItemUIModel] = []

    if isBiometryAvailable {
      items.append(
        .init(
          title: .loginWithBiometrics,
          icon: Theme.shared.image.faceIdMenu,
          isToggle: true,
          toggleBinding: Binding(
            get: { [weak self] in
              self?.viewState.isBiometryEnabled ?? false
            },
            set: { _ in }
          ),
          action: { [weak self] in
            self?.onBiometrySwitch()
          }
        )
      )
    }

    items.append(
      .init(
        title: .batchIssuanceCounter,
        icon: Theme.shared.image.batchCounter,
        showDivider: true,
        isToggle: true,
        toggleBinding: Binding(
          get: { [weak self] in
            self?.isBatchCounterEnabled ?? false
          },
          set: { [weak self] newValue in
            self?.isBatchCounterEnabled = newValue
          }
        ),
        action: {}
      )
    )

    items.append(
      .init(
        title: .validateIssuerRegistration,
        icon: Theme.shared.image.issuerRegistration,
        showDivider: true,
        isToggle: true,
        toggleBinding: Binding(
          get: { [weak self] in
            self?.isIssuerRegistrationValidationEnabled ?? false
          },
          set: { [weak self] newValue in
            self?.isIssuerRegistrationValidationEnabled = newValue
          }
        ),
        action: {}
      )
    )

    if isDocumentOfferingAvailable {
      items.append(
        .init(
          title: .offerDocumentsToAppsTitle,
          icon: Theme.shared.image.id.renderingMode(.template),
          showDivider: true,
          isToggle: true,
          toggleBinding: Binding(
            get: { [weak self] in
              self?.isOfferingDocumentsToApps ?? true
            },
            set: { [weak self] newValue in
              self?.isOfferingDocumentsToApps = newValue
            }
          ),
          action: {}
        )
      )
    }

    if logsUrl != nil {
      items.append(
        .init(
          title: .retrieveLogs,
          icon: Theme.shared.image.retrieveLogs,
          isShareLink: true,
          action: {}
        )
      )
    }

    if let changelogUrl = await interactor.retrieveChangeLogUrl() {
      items.append(
        .init(
          title: .changelog,
          icon: Theme.shared.image.changelog,
          action: { changelogUrl.open() }
        )
      )
    }

    items.append(
      .init(
        title: .resetWallet,
        icon: Theme.shared.image.trash,
        showDivider: false,
        action: { [weak self] in self?.isResetConfirmationShowing = true }
      )
    )

    setState {
      $0.copy(
        items: items,
        isBiometryEnabled: isBiometryEnabled,
        appVersion: appVersion,
        logsUrl: logsUrl,
        changelogUrl: changelogUrl
      )
    }
  }

  /// After the confirmation, the user verifies their identity; the reset screen then runs the reset.
  func onResetConfirmed() {
    isResetConfirmationShowing = false
    router.push(
      with: .featureCommonModule(
        .biometry(
          config: UIConfig.Biometry(
            navigationTitle: .resetWallet,
            caption: .resetWalletBiometryCaption,
            quickPinOnlyCaption: .resetWalletPinCaption,
            pinTextFieldTitle: .resetWalletPinCaption,
            navigationSuccessType: .push(.featureDashboardModule(.walletReset)),
            navigationBackType: .pop,
            isPreAuthorization: false,
            shouldInitializeBiometricOnCreate: true
          )
        )
      )
    )
  }

  private func updateBatchCounter(_ isEnabled: Bool) {
    Task {
      await interactor.setBatchCounter(isEnabled: isEnabled)
    }
  }

  private func updateDocumentOffering(_ isEnabled: Bool) {
    Task {
      await interactor.setOfferingDocumentsToApps(isEnabled: isEnabled)
    }
  }

  private func updateIssuerRegistrationValidation(_ isEnabled: Bool) {
    Task {
      await interactor.setIssuerRegistrationValidation(isEnabled: isEnabled)
      isRestartRequiredAlertShowing = true
    }
  }
}
