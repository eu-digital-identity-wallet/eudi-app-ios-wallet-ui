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
import logic_business
@testable import logic_core
@testable import logic_test
@testable import feature_dashboard
@testable import feature_common

final class TestSettingsInteractor: EudiTest {

  var interactor: SettingsInteractor!
  var walletKitController: MockWalletKitController!
  var configLogic: MockConfigLogic!
  var biometryInteractor: MockBiometryInteractor!
  var prefsController: MockPrefsController!

  override func setUp() {
    self.walletKitController = MockWalletKitController()
    self.prefsController = MockPrefsController()
    self.configLogic = MockConfigLogic()
    self.biometryInteractor = MockBiometryInteractor()
    self.interactor = SettingsInteractorImpl(
      walletController: walletKitController,
      configLogic: configLogic,
      biometryInteractor: biometryInteractor,
      prefsController: prefsController
    )
  }

  override func tearDown() {
    self.interactor = nil
    self.walletKitController = nil
    self.configLogic = nil
    self.biometryInteractor = nil
  }

  func testGetAppVersion_WhenConfigLogicReturnsAppVersion_ThenReturnsExpectedVersion() async {
    // Given
    let appVersion = getAppVersion()

    // When
    let version = await interactor.getAppVersion()

    // Then
    XCTAssertEqual(version, appVersion)
  }

  func testRetrieveLogFileUrl_WhenWalletKitControllerReturnsLogFileUrl_ThenReturnsExpectedUrl() async {
    // Given
    let expectedUrl = stubLogFileUrl()

    // When
    let result = await interactor.retrieveLogFileUrl()

    // Then
    XCTAssertEqual(result, expectedUrl)
  }

  func testRetrieveChangelogUrl_WhenConfigLogicReturnsChangelogUrl_ThenReturnsExpectedUrl() async {
    // Given
    let expectedUrl = stubChangeLogUrl()

    // When
    let result = await interactor.retrieveChangeLogUrl()

    // Then
    XCTAssertEqual(result, expectedUrl)
  }

  func testIsBiometryAvailable_WhenDeviceSupportsFaceId_ThenReturnsTrue() async {
    // Given
    stub(biometryInteractor) { mock in
      when(mock.getBiometryType()).thenReturn(.faceID)
    }

    // When
    let result = await interactor.isBiometryAvailable()

    // Then
    XCTAssertTrue(result)
  }

  func testIsBiometryAvailable_WhenDeviceDoesNotSupportBiometry_ThenReturnsFalse() async {
    // Given
    stub(biometryInteractor) { mock in
      when(mock.getBiometryType()).thenReturn(.none)
    }

    // When
    let result = await interactor.isBiometryAvailable()

    // Then
    XCTAssertFalse(result)
  }

  func testIsBiometryEnabled_WhenBiometryInteractorReturnsEnabled_ThenReturnsTrue() async {
    // Given
    stub(biometryInteractor) { mock in
      when(mock.isBiometryEnabled()).thenReturn(true)
    }

    // When
    let result = await interactor.isBiometryEnabled()

    // Then
    XCTAssertTrue(result)
  }

  func testAuthenticateBiometry_WhenAuthenticationSucceeds_ThenReturnsAuthenticated() async {
    // Given
    stub(biometryInteractor) { mock in
      when(mock.authenticate()).thenReturn(.authenticated)
    }

    // When
    let state = await interactor.authenticateBiometry()

    // Then
    XCTAssertEqual(state, .authenticated)
    verify(biometryInteractor).authenticate()
  }

  func testAuthenticateBiometry_WhenAuthenticationFails_ThenReturnsFailure() async {
    // Given
    stub(biometryInteractor) { mock in
      when(mock.authenticate()).thenReturn(.failure(.deniedAccess))
    }

    // When
    let state = await interactor.authenticateBiometry()

    // Then
    XCTAssertEqual(state, .failure(.deniedAccess))
    verify(biometryInteractor).authenticate()
  }

  func testSetBiometrySelection_WhenCalled_ThenDelegatesToBiometryInteractor() async {
    // Given
    stub(biometryInteractor) { mock in
      when(mock.setBiometrySelection(isEnabled: true)).thenDoNothing()
    }

    // When
    await interactor.setBiometrySelection(isEnabled: true)

    // Then
    verify(biometryInteractor).setBiometrySelection(isEnabled: true)
  }

  func testOpenBiometrySettings_WhenCalled_ThenDelegatesToBiometryInteractor() async {
    // Given
    stub(biometryInteractor) { mock in
      when(mock.openSettings(action: any())).thenDoNothing()
    }

    // When
    await interactor.openBiometrySettings(action: {})

    // Then
    verify(biometryInteractor).openSettings(action: any())
  }
  
  
  func testIsBatchCounterEnabled_WhenPrefsControllerReturnsTrue_ThenReturnsTrue() async {
    // Given
    stub(prefsController) { mock in
      when(mock.getBool(forKey: Prefs.Key.batchCounter)).thenReturn(true)
    }

    // When
    let result = await interactor.isBatchCounterEnabled()

    // Then
    XCTAssertTrue(result)
  }

  func testIsBatchCounterEnabled_WhenPrefsControllerReturnsFalse_ThenReturnsFalse() async {
    // Given
    stub(prefsController) { mock in
      when(mock.getBool(forKey: Prefs.Key.batchCounter)).thenReturn(false)
    }

    // When
    let result = await interactor.isBatchCounterEnabled()

    // Then
    XCTAssertFalse(result)
  }

  func testBatchCounter_WhenSetToTrue_CallsPrefsControllerWithTrue() async {
    // Given
    stub(prefsController) { mock in
      when(mock.setValue(any(), forKey: Prefs.Key.batchCounter)).thenDoNothing()
    }

    // When
    await interactor.setBatchCounter(isEnabled: true)
    
    // Then
    verify(prefsController).setValue(any(), forKey: Prefs.Key.batchCounter)
  }

}

extension TestSettingsInteractor {
  func getAppVersion() -> String {
    // Given
    let version = "1.0.0"

    //When
    stub(configLogic) { mock in
      when(mock.appVersion.get).thenReturn(version)
    }

    //Then
    return version
  }

  func stubLogFileUrl() -> URL {
    // Given
    let url = URL(string: "file.url")!

    // When
    stub(walletKitController) { mock in
      when(mock.retrieveLogFileUrl()).thenReturn(url)
    }

    // Then
    return url
  }

  func stubChangeLogUrl() -> URL {
    // Given
    let url = URL(string: "log.url")!

    // When
    stub(configLogic) { mock in
      when(mock.changelogUrl.get).thenReturn(url)
    }

    // Then
    return url
  }
}
