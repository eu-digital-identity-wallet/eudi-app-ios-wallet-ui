/*
 * Copyright (c) 2023 European Commission
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

final class TestSettingsInteractor: EudiTest {

  var interactor: SettingsInteractor!
  var walletKitController: MockWalletKitController!
  var prefsController: MockPrefsController!
  var configLogic: MockConfigLogic!

  override func setUp() {
    self.walletKitController = MockWalletKitController()
    self.prefsController = MockPrefsController()
    self.configLogic = MockConfigLogic()
    self.interactor = SettingsInteractorImpl(
      prefsController: prefsController,
      walletController: walletKitController,
      configLogic: configLogic
    )
  }

  override func tearDown() {
    self.interactor = nil
    self.walletKitController = nil
    self.configLogic = nil
    self.prefsController = nil
  }

  func testGetAppVersion_WhenConfigLogicReturnsAppVersion_ThenReturnsExpectedVersion() {
    // Given
    let appVersion = getAppVersion()

    // When
    let version = interactor.getAppVersion()

    // Then
    XCTAssertEqual(version, appVersion)
  }

  func testRetrieveLogFileUrl_WhenWalletKitControllerReturnsLogFileUrl_ThenReturnsExpectedUrl() {
    // Given
    let expectedUrl = stubLogFileUrl()

    // When
    let result = interactor.retrieveLogFileUrl()

    // Then
    XCTAssertEqual(result, expectedUrl)
  }

  func testRetrieveChangelogUrl_WhenConfigLogicReturnsChangelogUrl_ThenReturnsExpectedUrl() {
    // Given
    let expectedUrl = stubChangeLogUrl()

    // When
    let result = interactor.retrieveChangeLogUrl()

    // Then
    XCTAssertEqual(result, expectedUrl)
  }

  func testIsBatchCounterEnabled_WhenPrefsControllerReturnsTrue_ThenReturnsTrue() {
    // Given
    stub(prefsController) { mock in
      when(mock.getBool(forKey: Prefs.Key.batchCounter)).thenReturn(true)
    }

    // When
    let result = interactor.isBatchCounterEnabled()

    // Then
    XCTAssertTrue(result)
  }

  func testIsBatchCounterEnabled_WhenPrefsControllerReturnsFalse_ThenReturnsFalse() {
    // Given
    stub(prefsController) { mock in
      when(mock.getBool(forKey: Prefs.Key.batchCounter)).thenReturn(false)
    }

    // When
    let result = interactor.isBatchCounterEnabled()

    // Then
    XCTAssertFalse(result)
  }

  func testBatchCounter_WhenSetToTrue_CallsPrefsControllerWithTrue() {
    // Given
    stub(prefsController) { mock in
      when(mock.setValue(any(), forKey: Prefs.Key.batchCounter)).thenDoNothing()
    }

    // When
    interactor.setBatchCounter(isEnabled: true)
    
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
