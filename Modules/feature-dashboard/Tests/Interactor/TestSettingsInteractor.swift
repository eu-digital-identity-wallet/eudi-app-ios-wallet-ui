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

  override func setUp() {
    self.walletKitController = MockWalletKitController()
    self.configLogic = MockConfigLogic()
    self.biometryInteractor = MockBiometryInteractor()
    self.interactor = SettingsInteractorImpl(
      walletController: walletKitController,
      configLogic: configLogic,
      biometryInteractor: biometryInteractor
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

  func testSetBiometryEnabled_WhenDisabling_ThenUpdatesPreference() async {
    // Given
    stub(biometryInteractor) { mock in
      when(mock.setBiometrySelection(isEnabled: false)).thenDoNothing()
    }

    // When
    let result = await interactor.setBiometryEnabled(isEnabled: false)

    // Then
    XCTAssertFalse(result.isEnabled)
    XCTAssertNil(result.error)
    verify(biometryInteractor).setBiometrySelection(isEnabled: false)
  }

  func testSetBiometryEnabled_WhenEnablingAndAuthenticationSucceeds_ThenEnablesBiometry() async {
    // Given
    stub(biometryInteractor) { mock in
      when(mock.authenticate()).thenReturn(.authenticated)
      when(mock.setBiometrySelection(isEnabled: true)).thenDoNothing()
    }

    // When
    let result = await interactor.setBiometryEnabled(isEnabled: true)

    // Then
    XCTAssertTrue(result.isEnabled)
    XCTAssertNil(result.error)
    verify(biometryInteractor).authenticate()
    verify(biometryInteractor).setBiometrySelection(isEnabled: true)
  }

  func testSetBiometryEnabled_WhenEnablingAndAuthenticationFails_ThenKeepsBiometryDisabled() async {
    // Given
    stub(biometryInteractor) { mock in
      when(mock.authenticate()).thenReturn(.failure(.deniedAccess))
    }

    // When
    let result = await interactor.setBiometryEnabled(isEnabled: true)

    // Then
    XCTAssertFalse(result.isEnabled)
    if case .deniedAccess? = result.error {} else {
      XCTFail("Expected deniedAccess error")
    }
    verify(biometryInteractor).authenticate()
    verify(biometryInteractor, never()).setBiometrySelection(isEnabled: true)
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
