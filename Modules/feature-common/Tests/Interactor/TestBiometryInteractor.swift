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
import XCTest
import logic_business
import logic_authentication
@testable import feature_common
@testable import logic_test
@testable import feature_test

final class TestBiometryInteractor: EudiTest {
  
  var interactor: BiometryInteractor!
  var prefsController: MockPrefsController!
  var quickPinInteractor: MockQuickPinInteractor!
  var systemBiometricController: MockSystemBiometryController!
  
  override func setUp() {
    super.setUp()
    self.prefsController = MockPrefsController()
    self.quickPinInteractor = MockQuickPinInteractor()
    self.systemBiometricController = MockSystemBiometryController()
    self.interactor = BiometryInteractorImpl(
      prefsController: self.prefsController,
      quickPinInteractor: self.quickPinInteractor,
      biometryController: self.systemBiometricController
    )
  }
  
  override func tearDown() {
    self.interactor = nil
    self.prefsController = nil
    self.quickPinInteractor = nil
    self.systemBiometricController = nil
    super.tearDown()
  }
  
  // MARK: - isBiometryEnabled
  
  func testIsBiometryEnabled_WhenPrefsControllerReturnsTrue_ThenReturnEnabled() async {
    // Given
    stub(prefsController) { mock in
      when(mock.getBool(forKey: Prefs.Key.biometryEnabled)).thenReturn(true)
    }
    // When
    let isEnabled = await interactor.isBiometryEnabled()
    // Then
    XCTAssertTrue(isEnabled)
  }
  
  func testIsBiometryEnabled_WhenPrefsControllerReturnsFalse_ThenReturnIsNotEnabled() async {
    // Given
    stub(prefsController) { mock in
      when(mock.getBool(forKey: Prefs.Key.biometryEnabled)).thenReturn(false)
    }
    // When
    let isEnabled = await interactor.isBiometryEnabled()
    // Then
    XCTAssertFalse(isEnabled)
  }
  
  // MARK: - isPinValid
  
  func testIsPinValid_WhenQuickPinInteractorReturnsValid_ThenReturnSuccessPartialState() async {
    // Given
    let pin = "1234"
    stub(quickPinInteractor) { mock in
      when(mock.isPinValid(pin: pin)).thenReturn(.success)
    }
    // When
    let state = await interactor.isPinValid(with: pin)
    // Then
    switch state {
    case .success:
      XCTAssertTrue(true)
    default:
      XCTFail("Wrong state \(state)")
    }
  }
  
  func testIsPinValid_WhenQuickPinInteractorReturnsNotValid_ThenReturnFailurePartialState() async {
    // Given
    let pin = "1234"
    let mockedError = AuthenticationError.quickPinInvalid
    stub(quickPinInteractor) { mock in
      when(mock.isPinValid(pin: pin)).thenReturn(.failure(mockedError))
    }
    // When
    let state = await interactor.isPinValid(with: pin)
    // Then
    switch state {
    case .failure(let error):
      XCTAssertEqual(error.localizedDescription, mockedError.localizedDescription)
    default:
      XCTFail("Wrong state \(state)")
    }
  }
  
  // MARK: - setBiometrySelection
  
  func testSetBiometrySelection_WhenMethodCalledWithTrue_ThenVerifyPrefsControllerSet() async {
    // Given
    stub(prefsController) { mock in
      when(mock.setValue(any(), forKey: Prefs.Key.biometryEnabled)).thenDoNothing()
    }
    // When
    await interactor.setBiometrySelection(isEnabled: true)
    // Then
    verify(prefsController).setValue(any(), forKey: Prefs.Key.biometryEnabled)
  }
  
  // MARK: - getBiometricsImage
  
  func testBiometricsImage_WhenControllerReturnsFaceIdType_ThenReturnFaceIdImage() async {
    // Given
    stub(systemBiometricController) { mock in
      when(mock.getBiometryType()).thenReturn(.faceID)
    }
    // When
    let biometryImage = await interactor.getBiometricsImage()
    // Then
    XCTAssertEqual(biometryImage, Theme.shared.image.faceId)
  }
  
  func testBiometricsImage_WhenControllerReturnsTouchIdType_ThenReturnTouchIdImage() async {
    // Given
    stub(systemBiometricController) { mock in
      when(mock.getBiometryType()).thenReturn(.touchID)
    }
    // When
    let biometryImage = await interactor.getBiometricsImage()
    // Then
    XCTAssertEqual(biometryImage, Theme.shared.image.touchId)
  }
  
  func testBiometricsImage_WhenControllerReturnsNotSupportedType_ThenReturnNil() async {
    // Given
    stub(systemBiometricController) { mock in
      when(mock.getBiometryType()).thenReturn(.none)
    }
    // When
    let biometryImage = await interactor.getBiometricsImage()
    // Then
    XCTAssertNil(biometryImage)
  }
  
  // MARK: - getBiometryType
  
  func testBiometricType_WhenControllerReturnsFaceIdType_ThenReturnFaceIdType() async {
    // Given
    stub(systemBiometricController) { mock in
      when(mock.getBiometryType()).thenReturn(.faceID)
    }
    // When
    let biometryType = await interactor.getBiometryType()
    // Then
    XCTAssertEqual(biometryType, .faceID)
  }
  
  func testBiometricType_WhenControllerReturnsTouchIdType_ThenReturnTouchIdType() async {
    // Given
    stub(systemBiometricController) { mock in
      when(mock.getBiometryType()).thenReturn(.touchID)
    }
    // When
    let biometryType = await interactor.getBiometryType()
    // Then
    XCTAssertEqual(biometryType, .touchID)
  }
  
  // MARK: - getBiometricsMethod
  
  func testCurrentBiometricsMethod_WhenControllerReturnsFaceIdType_ThenReturnFaceIdStringLiteral() async {
    // Given
    stub(systemBiometricController) { mock in
      when(mock.getBiometryType()).thenReturn(.faceID)
    }
    // When
    let method = await interactor.getBiometricsMethod()
    // Then
    XCTAssertEqual(method, "Face ID")
  }
  
  func testCurrentBiometricsMethod_WhenControllerReturnsTouchIdType_ThenReturnTouchIdStringLiteral() async {
    // Given
    stub(systemBiometricController) { mock in
      when(mock.getBiometryType()).thenReturn(.touchID)
    }
    // When
    let method = await interactor.getBiometricsMethod()
    // Then
    XCTAssertEqual(method, "Touch ID")
  }
  
  func testCurrentBiometricsMethod_WhenControllerReturnsNotSupportedType_ThenReturnEmptyString() async {
    // Given
    stub(systemBiometricController) { mock in
      when(mock.getBiometryType()).thenReturn(.none)
    }
    // When
    let method = await interactor.getBiometricsMethod()
    // Then
    XCTAssertEqual(method, "")
  }
  
  // MARK: - authenticate
  
  func testAuthenticate_WhenRequestBiometricUnlockSucceeds_ThenEmitsAuthenticated() async {
    // Given
    stub(systemBiometricController) { mock in
      when(mock.requestBiometricUnlock()).thenDoNothing()
    }
    
    // When
    let state = await interactor.authenticate()
    
    // Then
    XCTAssertEqual(state, .authenticated)
  }
  
  func testAuthenticate_WhenRequestBiometricUnlockFails_ThenEmitsFailureWithError() async {
    // Given
    stub(systemBiometricController) { mock in
      when(mock.requestBiometricUnlock())
        .thenThrow(SystemBiometryError.deniedAccess)
    }
    
    // When
    let state = await interactor.authenticate()
    
    // Then
    switch state {
    case .failure(let error):
      XCTAssertEqual(error, .deniedAccess)
    default:
      XCTFail("Expected .failure(.deniedAccess) but got \(state)")
    }
  }
}
