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
import os
import logic_business
import logic_core
import logic_authentication
@testable import feature_startup
@testable import logic_test
@testable import feature_test
@testable import feature_common

final class TestStartupInteractor: EudiTest {
  
  var interactor: StartupInteractor!
  var walletKitController: MockWalletKitController!
  var quickPinInteractor: MockQuickPinInteractor!
  var keyChainController: MockKeyChainController!
  var prefsController: MockPrefsController!
  var configLogic: MockConfigLogic!
  
  override func setUp() {
    self.walletKitController = MockWalletKitController()
    self.quickPinInteractor = MockQuickPinInteractor()
    self.keyChainController = MockKeyChainController()
    self.prefsController = MockPrefsController()
    self.configLogic = MockConfigLogic()
    self.interactor = StartupInteractorImpl(
      walletKitController: walletKitController,
      quickPinInteractor: quickPinInteractor,
      keyChainController: keyChainController,
      prefsController: prefsController,
      configLogic: configLogic
    )
    
    stubConfigLogic()
    stubPrefsControllerSetValue()
    stubKeyChainClear()
    stubWalletKiControllerClearAllDocuments()
    stubTrustMarkIntroductionCompleted()
  }
  
  override func tearDown() {
    self.interactor = nil
    self.walletKitController = nil
    self.quickPinInteractor = nil
    self.keyChainController = nil
    self.prefsController = nil
    self.configLogic = nil
  }
  
  func testInitialize_WhenIsNotFirstBootAndPinIsNotSet_ThenReturnQuickPinAppRoute() async throws {
    // Given
    let expectedConfig = QuickPinUiConfig(flow: .setWithActivation)
    stubHasStoredDocuments(false)
    stubHasPin(with: false)
    stubRunAtLeastOnce()
    // When
    let state = await interactor.initialize(with: .zero)
    let route = try XCTUnwrap(successRoute(from: state))
    // Then
    switch route {
    case .featureCommonModule(let module):
      if case .quickPin(let config) = module {
        let receivedConfig = try XCTUnwrap(config as? QuickPinUiConfig)
        XCTAssertEqual(receivedConfig, expectedConfig)
      } else {
        XCTFail("Wrong route \(route)")
      }
      break
    default:
      XCTFail("Wrong route \(route)")
    }
    
    verifyFirstBootStorageManipulation(count: 0)
  }
  
  func testInitialize_WhenIsNotFirstBootAndPinIsSetAndHasIssuedDocuments_ThenReturnBiometricsAppRouteWithNavigationSuccessDashboard() async throws {
    // Given
    let expectedConfig = biometryConfig(with: true)
    stubHasStoredDocuments(true)
    stubHasPin(with: true)
    stubRunAtLeastOnce()
    // When
    let state = await interactor.initialize(with: .zero)
    let route = try XCTUnwrap(successRoute(from: state))
    // Then
    switch route {
    case .featureCommonModule(let module):
      if case .biometry(let config) = module {
        let receivedConfig = try XCTUnwrap(config as? UIConfig.Biometry)
        XCTAssertEqual(receivedConfig, expectedConfig)
      } else {
        XCTFail("Wrong route \(route)")
      }
      break
    default:
      XCTFail("Wrong route \(route)")
    }
    
    verifyFirstBootStorageManipulation(count: 0)
  }
  
  func testInitialize_WhenIsNotFirstBootAndPinIsSetAndHasNoIssuedDocuments_ThenReturnBiometricsAppRouteWithNavigationSuccessAddDocument() async throws {
    // Given
    let expectedConfig = biometryConfig(with: false)
    stubHasStoredDocuments(false)
    stubHasPin(with: true)
    stubRunAtLeastOnce()
    // When
    let state = await interactor.initialize(with: .zero)
    let route = try XCTUnwrap(successRoute(from: state))
    // Then
    switch route {
    case .featureCommonModule(let module):
      if case .biometry(let config) = module {
        let receivedConfig = try XCTUnwrap(config as? UIConfig.Biometry)
        XCTAssertEqual(receivedConfig, expectedConfig)
      } else {
        XCTFail("Wrong route \(route)")
      }
      break
    default:
      XCTFail("Wrong route \(route)")
    }
    
    verifyFirstBootStorageManipulation(count: 0)
  }
  
  func testInitialize_WhenIsFirstBootAndPinIsNotSet_ThenClearDocumentStorageAndReturnQuickPinAppRoute() async throws {
    // Given
    let expectedConfig = QuickPinUiConfig(flow: .setWithActivation)
    stubHasStoredDocuments(false)
    stubHasPin(with: false)
    stubRunAtLeastOnce(false)
    // When
    let state = await interactor.initialize(with: .zero)
    let route = try XCTUnwrap(successRoute(from: state))
    // Then
    switch route {
    case .featureCommonModule(let module):
      if case .quickPin(let config) = module {
        let receivedConfig = try XCTUnwrap(config as? QuickPinUiConfig)
        XCTAssertEqual(receivedConfig, expectedConfig)
      } else {
        XCTFail("Wrong route \(route)")
      }
      break
    default:
      XCTFail("Wrong route \(route)")
    }
    
    verifyFirstBootStorageManipulation(count: 1)
  }

  func testInitialize_WhenTrustMarkIntroductionIsNotCompletedAndPinIsNotSet_ThenReturnTrustMarkWelcomeWithQuickPinContinuation() async throws {
    // Given
    let expectedConfig = TrustMarkUiConfig(
      mode: .welcome(
        continuationRoute: .featureCommonModule(
          .quickPin(config: QuickPinUiConfig(flow: .setWithActivation))
        )
      )
    )
    stubHasStoredDocuments(false)
    stubHasPin(with: false)
    stubRunAtLeastOnce()
    stubTrustMarkIntroductionCompleted(false)
    // When
    let state = await interactor.initialize(with: .zero)
    let route = try XCTUnwrap(successRoute(from: state))
    // Then
    let receivedConfig = try XCTUnwrap(trustMarkConfig(from: route))
    XCTAssertEqual(receivedConfig, expectedConfig)
    verifyFirstBootStorageManipulation(count: 0)
  }

  func testInitialize_WhenTrustMarkIntroductionIsNotCompletedAndPinIsSet_ThenReturnTrustMarkWelcomeWithBiometryContinuation() async throws {
    // Given
    let expectedConfig = TrustMarkUiConfig(
      mode: .welcome(
        continuationRoute: .featureCommonModule(
          .biometry(config: biometryConfig(with: true))
        )
      )
    )
    stubHasStoredDocuments(true)
    stubHasPin(with: true)
    stubRunAtLeastOnce()
    stubTrustMarkIntroductionCompleted(false)
    // When
    let state = await interactor.initialize(with: .zero)
    let route = try XCTUnwrap(successRoute(from: state))
    // Then
    let receivedConfig = try XCTUnwrap(trustMarkConfig(from: route))
    XCTAssertEqual(receivedConfig, expectedConfig)
  }

  func testInitialize_WhenTrustMarkIntroductionIsNotCompletedAndIsFirstBoot_ThenClearDocumentStorageAndReturnTrustMarkWelcome() async throws {
    // Given
    stubHasStoredDocuments(false)
    stubHasPin(with: false)
    stubRunAtLeastOnce(false)
    stubTrustMarkIntroductionCompleted(false)
    // When
    let state = await interactor.initialize(with: .zero)
    let route = try XCTUnwrap(successRoute(from: state))
    // Then
    let receivedConfig = try XCTUnwrap(trustMarkConfig(from: route))
    XCTAssertTrue(receivedConfig.isWelcome)
    verifyFirstBootStorageManipulation(count: 1)
  }

  func testInitialize_WhenPinIsNotSetAndHasDocuments_ThenFailsWithPinNotFound() async {
    stubHasStoredDocuments(true)
    stubHasPin(with: false)
    stubRunAtLeastOnce()

    let state = await interactor.initialize(with: .zero)

    XCTAssertEqual(failureError(from: state) as? AuthenticationError, .pinNotFound)
  }

  func testInitialize_WhenPinRecordCannotBeRead_ThenFailsWithTheReadError() async {
    stubHasStoredDocuments(false)
    stub(quickPinInteractor) { mock in
      when(mock.hasPin()).thenThrow(KeyChainError.readFailed(status: errSecInteractionNotAllowed))
    }
    stubRunAtLeastOnce()

    let state = await interactor.initialize(with: .zero)

    XCTAssertEqual(failureError(from: state) as? KeyChainError, .readFailed(status: errSecInteractionNotAllowed))
  }

  func testInitialize_WhenPinIsNotSetAndDocumentsCannotBeChecked_ThenFailsWithTheCheckError() async {
    stubDocumentsCheckFailure()
    stubHasPin(with: false)
    stubRunAtLeastOnce()

    let state = await interactor.initialize(with: .zero)

    XCTAssertEqual(failureError(from: state) as? KeyChainError, Self.documentsCheckError)
  }

  func testInitialize_WhenFirstBootWipeFailsAndDocumentsRemain_ThenFailsAndWipesAgainNextTime() async {
    stubHasStoredDocuments(true)
    stubHasPin(with: false)
    stubRunAtLeastOnce(false)
    stubKeyChainClear(success: false)

    let state = await interactor.initialize(with: .zero)

    XCTAssertEqual(failureError(from: state) as? AuthenticationError, .pinNotFound)
    verify(prefsController, never()).setValue(any(), forKey: Prefs.Key.runAtLeastOnce)
  }

  func testInitialize_WhenTrustMarkIntroductionIsNotCompletedAndPinCannotBeRead_ThenFailsWithoutTrustMark() async {
    stubHasStoredDocuments(false)
    stub(quickPinInteractor) { mock in
      when(mock.hasPin()).thenThrow(KeyChainError.readFailed(status: errSecInteractionNotAllowed))
    }
    stubRunAtLeastOnce()
    stubTrustMarkIntroductionCompleted(false)

    let state = await interactor.initialize(with: .zero)

    XCTAssertEqual(failureError(from: state) as? KeyChainError, .readFailed(status: errSecInteractionNotAllowed))
  }

  func testInitialize_WhenPinIsSetAndDocumentsCannotBeChecked_ThenReturnBiometricsAppRoute() async throws {
    stubDocumentsCheckFailure()
    stubHasPin(with: true)
    stubRunAtLeastOnce()

    let state = await interactor.initialize(with: .zero)

    let route = try XCTUnwrap(successRoute(from: state))
    guard case .featureCommonModule(let module) = route, case .biometry(let config) = module else {
      return XCTFail("Wrong route \(route)")
    }
    XCTAssertEqual(config as? UIConfig.Biometry, biometryConfig(with: false))
  }

  func testInitialize_WhenFirstBootWipesTheDocuments_ThenChecksForDocumentsAfterTheWipe() async throws {
    let storage = RecordingWipe()
    stubHasPin(with: false)
    stubRunAtLeastOnce(false)
    stub(walletKitController) { mock in
      when(mock.clearAllDocuments()).then { storage.wipe() }
      when(mock.hasStoredDocuments()).then { storage.hasDocuments }
    }

    let state = await interactor.initialize(with: .zero)

    let route = try XCTUnwrap(successRoute(from: state))
    guard case .featureCommonModule(let module) = route, case .quickPin = module else {
      return XCTFail("Wrong route \(route)")
    }
  }

  func testInitialize_WhenPinIsSetAndHasDocuments_ThenLoadsNoDocumentBeforeLogin() async {
    stubHasStoredDocuments(true)
    stubHasPin(with: true)
    stubRunAtLeastOnce()

    _ = await interactor.initialize(with: .zero)

    verify(walletKitController).hasStoredDocuments()
    verify(walletKitController, never()).loadDocuments()
    verify(walletKitController, never()).fetchAllDocuments()
  }
}

private extension TestStartupInteractor {

  /// A document store that holds documents until the first-boot wipe clears it.
  final class RecordingWipe: Sendable {

    private let isWiped = OSAllocatedUnfairLock(initialState: false)

    var hasDocuments: Bool {
      isWiped.withLock { !$0 }
    }

    func wipe() {
      isWiped.withLock { $0 = true }
    }
  }

  static let documentsCheckError = KeyChainError.readFailed(status: errSecDecode)

  func successRoute(from state: StartupPartialState) -> AppRoute? {
    guard case .success(let route) = state else { return nil }
    return route
  }

  func failureError(from state: StartupPartialState) -> Error? {
    guard case .failure(let error) = state else { return nil }
    return error
  }

  func stubDocumentsCheckFailure() {
    stub(walletKitController) { mock in
      when(mock.hasStoredDocuments()).thenThrow(Self.documentsCheckError)
    }
  }

  func stubHasStoredDocuments(_ hasDocuments: Bool) {
    stub(walletKitController) { mock in
      when(mock.hasStoredDocuments()).thenReturn(hasDocuments)
    }
  }
  
  func stubHasPin(with hasPin: Bool) {
    stub(quickPinInteractor) { mock in
      when(mock.hasPin()).thenReturn(hasPin)
    }
  }
  
  func biometryConfig(with hasDocuments: Bool) -> UIConfig.Biometry {
    return UIConfig.Biometry(
      navigationTitle: .enterYourPin,
      title: .loginTitle,
      caption: .loginCaption,
      quickPinOnlyCaption: .loginCaptionQuickPinOnly,
      navigationSuccessType: .push(
        hasDocuments
        ? .featureDashboardModule(.dashboard)
        : .featureIssuanceModule(.issuanceAddDocument(config: IssuanceFlowUiConfig(flow: .noDocument)))
      ),
      navigationBackType: nil,
      isPreAuthorization: true,
      shouldInitializeBiometricOnCreate: true,
      displayNavigationBar: true
    )
  }
  
  func stubPrefsControllerSetValue() {
    stub(prefsController) { mock in
      when(mock.setValue(any(), forKey: any())).thenDoNothing()
    }
  }
  
  func stubConfigLogic() {
    stub(configLogic) { mock in
      when(mock.forcePidActivation.get).thenReturn(true)
    }
  }
  
  func stubRunAtLeastOnce(_ atLeastOnce: Bool = true) {
    stub(prefsController) { mock in
      when(mock.getBool(forKey: Prefs.Key.runAtLeastOnce)).thenReturn(atLeastOnce)
    }
  }
  
  func stubTrustMarkIntroductionCompleted(_ completed: Bool = true) {
    stub(prefsController) { mock in
      when(mock.getBool(forKey: Prefs.Key.trustMarkIntroductionCompleted)).thenReturn(completed)
    }
  }

  func trustMarkConfig(from route: AppRoute) -> TrustMarkUiConfig? {
    guard case .featureCommonModule(let module) = route,
          case .trustMark(let config) = module
    else {
      return nil
    }
    return config as? TrustMarkUiConfig
  }

  func stubKeyChainClear(success: Bool = true) {
    stub(keyChainController) { mock in
      when(mock.clear()).thenReturn(success)
    }
  }
  
  func stubWalletKiControllerClearAllDocuments() {
    stub(walletKitController) { mock in
      when(mock.clearAllDocuments()).thenDoNothing()
    }
  }
  
  func verifyFirstBootStorageManipulation(count: Int) {
    verify(prefsController, times(count)).setValue(any(), forKey: Prefs.Key.runAtLeastOnce)
    verify(keyChainController, times(count)).clear()
    verify(walletKitController, times(count)).clearAllDocuments()
  }
}
