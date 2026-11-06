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
@testable import logic_authentication
@testable import feature_common
@testable import feature_dashboard
@testable import logic_test
@testable import feature_test

final class TestBiometrySelectionViewModel: EudiTest {

  @MainActor
  func testSwitchBiometricUnlock_WhenTurningItOnAndTheBiometricPasses_ThenTurnsItOnAndReturnsToSettings() async {
    let fixture = makeFixture(isBiometryEnabled: false, isEnabled: true, outcome: .authenticated)

    await fixture.viewModel.switchBiometricUnlock()

    verify(fixture.interactor).setBiometrySelection(isEnabled: true)
    verify(fixture.router).popTo(with: equal(to: AppRoute.featureDashboardModule(.settingsMenu)))
    XCTAssertNil(fixture.viewModel.biometryError)
  }

  @MainActor
  func testSwitchBiometricUnlock_WhenTurningItOff_ThenTurnsItOffAndReturnsToSettings() async {
    let fixture = makeFixture(isBiometryEnabled: true, isEnabled: false, outcome: .authenticated)

    await fixture.viewModel.switchBiometricUnlock()

    verify(fixture.interactor).setBiometrySelection(isEnabled: false)
    verify(fixture.router).popTo(with: equal(to: AppRoute.featureDashboardModule(.settingsMenu)))
  }

  @MainActor
  func testSwitchBiometricUnlock_WhenTheSettingIsAlreadyWhatWasAskedFor_ThenChangesNothing() async {
    let fixture = makeFixture(isBiometryEnabled: true, isEnabled: true, outcome: .authenticated)

    await fixture.viewModel.switchBiometricUnlock()

    verify(fixture.interactor, never()).setBiometrySelection(isEnabled: any())
    verify(fixture.router).popTo(with: any())
  }

  @MainActor
  func testSwitchBiometricUnlock_WhenCalledAgain_ThenSwitchesOnce() async {
    let fixture = makeFixture(isBiometryEnabled: false, isEnabled: true, outcome: .authenticated)

    await fixture.viewModel.switchBiometricUnlock()
    await fixture.viewModel.switchBiometricUnlock()

    verify(fixture.interactor, times(1)).setBiometrySelection(isEnabled: any())
  }

  @MainActor
  func testSwitchBiometricUnlock_WhenTheBiometricIsCancelledOrNotMatched_ThenReturnsWithNoError() async {
    let fixture = makeFixture(isBiometryEnabled: false, isEnabled: true, outcome: .failure(.biometricError))

    await fixture.viewModel.switchBiometricUnlock()

    verify(fixture.router).popTo(with: any())
    XCTAssertNil(fixture.viewModel.biometryError)
  }

  @MainActor
  func testSwitchBiometricUnlock_WhenBiometricsCannotBeUsed_ThenShowsTheErrorUntilTheUserLeaves() async {
    let fixture = makeFixture(isBiometryEnabled: false, isEnabled: true, outcome: .failure(.noFaceIdEnrolled))

    await fixture.viewModel.switchBiometricUnlock()

    XCTAssertEqual(fixture.viewModel.biometryError, .noFaceIdEnrolled)
    XCTAssertFalse(fixture.viewModel.viewState.isLoading)
    verify(fixture.router, never()).popTo(with: any())
    fixture.viewModel.onCancel()
    verify(fixture.router).popTo(with: any())
  }

  @MainActor
  func testSwitchBiometricUnlock_WhenTheSettingsAreNoLongerOnTheStack_ThenClosesThisScreen() async {
    let fixture = makeFixture(
      isBiometryEnabled: false,
      isEnabled: true,
      outcome: .authenticated,
      isSettingsOnTheStack: false
    )

    await fixture.viewModel.switchBiometricUnlock()

    verify(fixture.router, never()).popTo(with: any())
    verify(fixture.router).pop()
  }

  @MainActor
  func testSwitchBiometricUnlock_WhenAnotherScreenIsInFrontAndNoSettings_ThenClosesNothing() async {
    let fixture = makeFixture(
      isBiometryEnabled: false,
      isEnabled: true,
      outcome: .authenticated,
      isSettingsOnTheStack: false,
      isInFront: false
    )

    await fixture.viewModel.switchBiometricUnlock()

    verify(fixture.router, never()).popTo(with: any())
    verify(fixture.router, never()).pop()
  }
}

private extension TestBiometrySelectionViewModel {

  struct Fixture {
    let viewModel: BiometrySelectionViewModel<MockRouterHost>
    let router: MockRouterHost
    let interactor: MockSettingsInteractor
  }

  @MainActor
  func makeFixture(
    isBiometryEnabled: Bool,
    isEnabled: Bool,
    outcome: BiometricsState,
    isSettingsOnTheStack: Bool = true,
    isInFront: Bool = true
  ) -> Fixture {
    let router = MockRouterHost()
    let interactor = MockSettingsInteractor()
    stub(router) { mock in
      when(mock.isScreenOnBackStack(with: any())).thenReturn(isSettingsOnTheStack)
      when(mock.isScreenForeground(with: any())).thenReturn(isInFront)
      when(mock.popTo(with: any())).thenDoNothing()
      when(mock.pop()).thenDoNothing()
    }
    stub(interactor) { mock in
      when(mock.isBiometryEnabled()).thenReturn(isBiometryEnabled)
      when(mock.setBiometrySelection(isEnabled: any())).thenReturn(outcome)
    }
    return Fixture(
      viewModel: BiometrySelectionViewModel(router: router, interactor: interactor, isEnabled: isEnabled),
      router: router,
      interactor: interactor
    )
  }
}
