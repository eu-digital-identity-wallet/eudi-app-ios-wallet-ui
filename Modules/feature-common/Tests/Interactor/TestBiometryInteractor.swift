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
  var cancellables: Set<AnyCancellable> = []

  override func setUp() {
    self.prefsController = MockPrefsController()
    self.quickPinInteractor = MockQuickPinInteractor()
    self.systemBiometricController = MockSystemBiometryController()
    self.interactor = BiometryInteractorImpl(
      prefsController: self.prefsController,
      quickPinInteractor: self.quickPinInteractor,
      biometryController: self.systemBiometricController,
      useTestDispatcher: true
    )
  }
  
  override func tearDown() {
    self.cancellables.removeAll()
    self.interactor = nil
    self.prefsController = nil
    self.quickPinInteractor = nil
    self.systemBiometricController = nil
  }
  
  func testIsBiometryEnabled_WhenPrefsControllerReturnsTrue_ThenReturnEnabled() {
    // Given
    stub(prefsController) { mock in
      when(mock.getBool(forKey: Prefs.Key.biometryEnabled)).thenReturn(true)
    }
    // When
    let isEnabled = interactor.isBiometryEnabled()
    // Then
    XCTAssertTrue(isEnabled)
  }
  
  func testIsBiometryEnabled_WhenPrefsControllerReturnsFalse_ThenReturnIsNotEnabled() {
    // Given
    stub(prefsController) { mock in
      when(mock.getBool(forKey: Prefs.Key.biometryEnabled)).thenReturn(false)
    }
    // When
    let isEnabled = interactor.isBiometryEnabled()
    // Then
    XCTAssertFalse(isEnabled)
  }
  
  func testIsPinValid_WhenQuickPinInteractorReturnsValid_ThenReturnSuccessPartialState() {
    // Given
    let pin = "1234"
    stub(quickPinInteractor) { mock in
      when(mock.isPinValid(pin: pin)).thenReturn(.success)
    }
    // When
    let state = interactor.isPinValid(with: pin)
    // Then
    switch state {
    case .success:
      XCTAssertTrue(true)
    default:
      XCTFail("Wrong state \(state)")
    }
  }
  
  func testIsPinValid_WhenQuickPinInteractorReturnsNotValid_ThenReturnFailurePartialState() {
    // Given
    let pin = "1234"
    let mockedError = AuthenticationError.quickPinInvalid
    stub(quickPinInteractor) { mock in
      when(mock.isPinValid(pin: pin)).thenReturn(.failure(mockedError))
    }
    // When
    let state = interactor.isPinValid(with: pin)
    // Then
    switch state {
    case .failure(let error):
      XCTAssertEqual(error.localizedDescription, mockedError.localizedDescription)
    default:
      XCTFail("Wrong state \(state)")
    }
  }
  
  func testSetBiometrySelection_WhenMethodCalledWithTrue_ThenVerifyPrefsControllerSet() {
    // Given
    stub(prefsController) { mock in
      when(mock.setValue(any(), forKey: Prefs.Key.biometryEnabled)).thenDoNothing()
    }
    // When
    interactor.setBiometrySelection(isEnabled: true)
    // Then
    verify(prefsController).setValue(any(), forKey: Prefs.Key.biometryEnabled)
  }
  
  func testBiometricsImage_WhenControllerReturnsFaceIdType_ThenReturnFaceIdImage() {
    // Given
    stub(systemBiometricController) { mock in
      when(mock.biometryType.get).thenReturn(.faceID)
    }
    // When
    let biometryImage = interactor.biometricsImage
    // Then
    XCTAssertEqual(biometryImage, Theme.shared.image.faceId)
  }
  
  func testBiometricsImage_WhenControllerReturnsTouchIdType_ThenReturnTouchIdImage() {
    // Given
    stub(systemBiometricController) { mock in
      when(mock.biometryType.get).thenReturn(.touchID)
    }
    // When
    let biometryImage = interactor.biometricsImage
    // Then
    XCTAssertEqual(biometryImage, Theme.shared.image.touchId)
  }
  
  func testBiometricsImage_WhenControllerReturnsNotSupportedType_ThenReturnNil() {
    // Given
    stub(systemBiometricController) { mock in
      when(mock.biometryType.get).thenReturn(.none)
    }
    // When
    let biometryImage = interactor.biometricsImage
    // Then
    XCTAssertNil(biometryImage)
  }
  
  func testBiometricType_WhenControllerReturnsFaceIdType_ThenReturnFaceIdType() {
    // Given
    stub(systemBiometricController) { mock in
      when(mock.biometryType.get).thenReturn(.faceID)
    }
    // When
    let biometryType = interactor.biometryType
    // Then
    XCTAssertEqual(biometryType, .faceID)
  }
  
  func testBiometricType_WhenControllerReturnsTouchIdType_ThenReturnTouchIdType() {
    // Given
    stub(systemBiometricController) { mock in
      when(mock.biometryType.get).thenReturn(.touchID)
    }
    // When
    let biometryType = interactor.biometryType
    // Then
    XCTAssertEqual(biometryType, .touchID)
  }
  
  func testCurrentBiometricsMethod_WhenControllerReturnsFaceIdType_ThenReturnFaceIdStringLiteral() {
    // Given
    stub(systemBiometricController) { mock in
      when(mock.biometryType.get).thenReturn(.faceID)
    }
    // When
    let method = interactor.currentBiometricsMethod
    // Then
    XCTAssertEqual(method, "Face ID")
  }
  
  func testCurrentBiometricsMethod_WhenControllerReturnsTouchIdType_ThenReturnTouchIdStringLiteral() {
    // Given
    stub(systemBiometricController) { mock in
      when(mock.biometryType.get).thenReturn(.touchID)
    }
    // When
    let method = interactor.currentBiometricsMethod
    // Then
    XCTAssertEqual(method, "Touch ID")
  }
  
  func testCurrentBiometricsMethod_WhenControllerReturnsNotSupportedType_ThenReturnEmptyString() {
    // Given
    stub(systemBiometricController) { mock in
      when(mock.biometryType.get).thenReturn(.none)
    }
    // When
    let method = interactor.currentBiometricsMethod
    // Then
    XCTAssertEqual(method, "")
  }

  func testAuthenticate_WhenRequestBiometricUnlock_ThenEmitsAuthenticated() {
    // Given
    let successPub = Just(())
      .setFailureType(to: SystemBiometryError.self)
      .eraseToAnyPublisher()
    stub(systemBiometricController) { mock in
      when(mock.requestBiometricUnlock()).thenReturn(successPub)
    }

    let exp = expectation(description: "should get .authenticated")
    var received: [BiometricsState] = []

    // When
    interactor.authenticate()
      .sink { state in
        received.append(state)
        if state == .authenticated { exp.fulfill() }
      }
      .store(in: &cancellables)

    // Then
    wait(for: [exp], timeout: 0.5)
    XCTAssertEqual(received, [.authenticated])
  }

  func testAuthenticate_WhenRequestBiometrckUnlockFailure_ThenEmitsFailureWithError() {
    // Given
    let failPub = Fail<Void, SystemBiometryError>(
      error: .deniedAccess
    ).eraseToAnyPublisher()

    stub(systemBiometricController) { mock in
      when(mock.requestBiometricUnlock()).thenReturn(failPub)
    }

    let exp = expectation(description: "should get .failure(.deniedAccess)")
    var received: [BiometricsState] = []

    // When
    interactor.authenticate()
      .sink { state in
        received.append(state)
        if case .failure(.deniedAccess) = state { exp.fulfill() }
      }
      .store(in: &cancellables)

    // Then
    wait(for: [exp], timeout: 0.5)
    XCTAssertEqual(received, [.failure(.deniedAccess)])
  }

  func testAuthenticate_WhenRequestBiometricUnlockWithUseTestDispatcherTrue_ThenEmitsAuthenticated() {
      // Given
    self.interactor = BiometryInteractorImpl(
      prefsController: self.prefsController,
      quickPinInteractor: self.quickPinInteractor,
      biometryController: self.systemBiometricController,
      useTestDispatcher: false
    )

      let successPub = Just(())
        .setFailureType(to: SystemBiometryError.self)
        .eraseToAnyPublisher()
      stub(systemBiometricController) { mock in
        when(mock.requestBiometricUnlock()).thenReturn(successPub)
      }

      let exp = expectation(description: "should get .authenticated")
      var received: [BiometricsState] = []

      // When
      interactor.authenticate()
        .sink { state in
          received.append(state)
          if state == .authenticated { exp.fulfill() }
        }
        .store(in: &cancellables)

      // Then
      wait(for: [exp], timeout: 1.0)
      XCTAssertEqual(received, [.authenticated])
    }

  func testAuthenticate_WhenRequestBiometricUnlockWithUseTestDispatcherTrue_ThenEmitsFailure() {
    // Given
    self.interactor = BiometryInteractorImpl(
      prefsController: self.prefsController,
      quickPinInteractor: self.quickPinInteractor,
      biometryController: self.systemBiometricController,
      useTestDispatcher: false
    )

    let failPub = Fail<Void, SystemBiometryError>(
      error: .deniedAccess
    ).eraseToAnyPublisher()
    stub(systemBiometricController) { mock in
      when(mock.requestBiometricUnlock()).thenReturn(failPub)
    }

    let exp = expectation(description: "should get .failure(.deniedAccess)")
    var received: [BiometricsState] = []

    // When
    interactor.authenticate()
      .sink { state in
        received.append(state)
        if case .failure(.deniedAccess) = state { exp.fulfill() }
      }
      .store(in: &cancellables)

    // Then
    wait(for: [exp], timeout: 1.0)
    XCTAssertEqual(received, [.failure(.deniedAccess)])
  }
}
