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
import XCTest
import Cuckoo
@testable import logic_ui
@testable import logic_resources
@testable import feature_common
@testable import feature_dashboard
@testable import logic_test
@testable import feature_test

final class TestSettingsViewModel: EudiTest {

  @MainActor
  func testOnBiometrySwitch_WhenBiometricUnlockIsOff_ThenAsksForThePinBeforeTurningItOn() async {
    let fixture = makeFixture(isBiometryEnabled: false)
    await fixture.viewModel.initialize()

    fixture.viewModel.onBiometrySwitch()

    let config = biometryConfig(pushedOn: fixture.router)
    XCTAssertEqual(config?.pinTextFieldTitle, .biometryUnlockOnCaption)
    XCTAssertEqual(requestedSetting(after: config), true)
    XCTAssertEqual(config?.navigationBackType, .pop)
    XCTAssertEqual(config?.isPreAuthorization, false)
    verify(fixture.interactor, never()).setBiometrySelection(isEnabled: any())
  }

  @MainActor
  func testOnBiometrySwitch_WhenBiometricUnlockIsOn_ThenAcceptsThePinOrABiometricToTurnItOff() async {
    let fixture = makeFixture(isBiometryEnabled: true)
    await fixture.viewModel.initialize()

    fixture.viewModel.onBiometrySwitch()

    let config = biometryConfig(pushedOn: fixture.router)
    XCTAssertEqual(config?.pinTextFieldTitle, .biometryUnlockOffCaption)
    XCTAssertEqual(requestedSetting(after: config), false)
    XCTAssertEqual(config?.shouldInitializeBiometricOnCreate, true)
    verify(fixture.interactor, never()).setBiometrySelection(isEnabled: any())
  }

  @MainActor
  func testOnBiometrySwitch_WhenTappedAgainBeforeSettingsAppearAgain_ThenOpensOneCheck() async {
    let fixture = makeFixture(isBiometryEnabled: false)
    await fixture.viewModel.initialize()

    fixture.viewModel.onBiometrySwitch()
    fixture.viewModel.onBiometrySwitch()
    verify(fixture.router, times(1)).push(with: any())

    await fixture.viewModel.initialize()
    fixture.viewModel.onBiometrySwitch()
    verify(fixture.router, times(2)).push(with: any())
  }
}

private extension TestSettingsViewModel {

  struct Fixture {
    let viewModel: SettingsViewModel<MockRouterHost>
    let router: MockRouterHost
    let interactor: MockSettingsInteractor
  }

  /// The configuration of the last PIN or biometric check pushed on `router`, if one was.
  func biometryConfig(pushedOn router: MockRouterHost) -> UIConfig.Biometry? {
    let captor = ArgumentCaptor<AppRoute>()
    verify(router, atLeastOnce()).push(with: captor.capture())
    guard case .featureCommonModule(.biometry(let config)) = captor.value else { return nil }
    return config as? UIConfig.Biometry
  }

  /// The setting the screen after `config`'s check is to apply, when that screen is the biometric unlock switch's;
  /// routes compare by key only, so the value is read from the route itself.
  func requestedSetting(after config: UIConfig.Biometry?) -> Bool? {
    guard
      case .push(.featureDashboardModule(.biometrySelection(let isEnabled))) = config?.navigationSuccessType
    else {
      return nil
    }
    return isEnabled
  }

  @MainActor
  func makeFixture(isBiometryEnabled: Bool) -> Fixture {
    let router = MockRouterHost()
    let interactor = MockSettingsInteractor()
    stub(router) { mock in
      when(mock.push(with: any())).thenDoNothing()
    }
    stub(interactor) { mock in
      when(mock.getAppVersion()).thenReturn("1.0")
      when(mock.retrieveLogFileUrl()).thenReturn(nil)
      when(mock.retrieveChangeLogUrl()).thenReturn(nil)
      when(mock.isBiometryAvailable()).thenReturn(true)
      when(mock.isBiometryEnabled()).thenReturn(isBiometryEnabled)
      when(mock.isBatchCounterEnabled()).thenReturn(false)
      when(mock.isIssuerRegistrationValidationEnabled()).thenReturn(false)
      when(mock.isDocumentOfferingAvailable()).thenReturn(false)
      when(mock.isOfferingDocumentsToApps()).thenReturn(true)
      when(mock.setBiometrySelection(isEnabled: any())).thenReturn(.authenticated)
    }
    return Fixture(
      viewModel: SettingsViewModel(router: router, interactor: interactor, walletKit: MockWalletKitController()),
      router: router,
      interactor: interactor
    )
  }
}
