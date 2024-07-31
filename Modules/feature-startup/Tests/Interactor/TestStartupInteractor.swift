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
import logic_core
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
  
  override func setUp() {
    self.walletKitController = MockWalletKitController()
    self.quickPinInteractor = MockQuickPinInteractor()
    self.keyChainController = MockKeyChainController()
    self.prefsController = MockPrefsController()
    self.interactor = StartupInteractorImpl(
      walletKitController: walletKitController,
      quickPinInteractor: quickPinInteractor,
      keyChainController: keyChainController,
      prefsController: prefsController
    )
    
    stubPrefsControllerSetValue()
    stubKeyChainClear()
    stubWalletKiControllerClearAllDocuments()
  }
  
  override func tearDown() {
    self.interactor = nil
    self.walletKitController = nil
    self.quickPinInteractor = nil
    self.keyChainController = nil
    self.prefsController = nil
  }
  
  func testInitialize_WhenIsNotFirstBootAndPinIsNotSet_ThenReturnQuickPinAppRoute() async throws {
    // Given
    let expectedConfig = QuickPinUiConfig(flow: .set)
    stubFetchDocuments(with: [Constants.euPidModel, Constants.isoMdlModel])
    stubHasPin(with: false)
    stubRunAtLeastOnce()
    // When
    let route = await interactor.initialize(with: .zero)
    // Then
    switch route {
    case .quickPin(let config):
      let receivedConfig = try XCTUnwrap(config as? QuickPinUiConfig)
      XCTAssertEqual(receivedConfig, expectedConfig)
      break
    default:
      XCTFail("Wrong route \(route)")
    }
    
    verifyFirstBootStorageManipulation(count: 0)
  }
  
  func testInitialize_WhenIsNotFirstBootAndPinIsSetAndHasIssuedDocuments_ThenReturnBiometricsAppRouteWithNavigationSuccessDashboard() async throws {
    // Given
    let expectedConfig = biometryConfig(with: true)
    stubFetchDocuments(with: [Constants.euPidModel, Constants.isoMdlModel])
    stubHasPin(with: true)
    stubRunAtLeastOnce()
    // When
    let route = await interactor.initialize(with: .zero)
    // Then
    switch route {
    case .biometry(let config):
      let receivedConfig = try XCTUnwrap(config as? UIConfig.Biometry)
      XCTAssertEqual(receivedConfig, expectedConfig)
      break
    default:
      XCTFail("Wrong route \(route)")
    }
    
    verifyFirstBootStorageManipulation(count: 0)
  }
  
  func testInitialize_WhenIsNotFirstBootAndPinIsSetAndHasNoIssuedDocuments_ThenReturnBiometricsAppRouteWithNavigationSuccessAddDocument() async throws {
    // Given
    let expectedConfig = biometryConfig(with: false)
    stubFetchDocuments(with: [])
    stubHasPin(with: true)
    stubRunAtLeastOnce()
    // When
    let route = await interactor.initialize(with: .zero)
    // Then
    switch route {
    case .biometry(let config):
      let receivedConfig = try XCTUnwrap(config as? UIConfig.Biometry)
      XCTAssertEqual(receivedConfig, expectedConfig)
      break
    default:
      XCTFail("Wrong route \(route)")
    }
    
    verifyFirstBootStorageManipulation(count: 0)
  }
  
  func testInitialize_WhenIsFirstBootAndPinIsNotSet_ThenClearDocumentStorageAndReturnQuickPinAppRoute() async throws {
    // Given
    let expectedConfig = QuickPinUiConfig(flow: .set)
    stubFetchDocuments(with: [Constants.euPidModel, Constants.isoMdlModel])
    stubHasPin(with: false)
    stubRunAtLeastOnce(false)
    // When
    let route = await interactor.initialize(with: .zero)
    // Then
    switch route {
    case .quickPin(let config):
      let receivedConfig = try XCTUnwrap(config as? QuickPinUiConfig)
      XCTAssertEqual(receivedConfig, expectedConfig)
      break
    default:
      XCTFail("Wrong route \(route)")
    }
    
    verifyFirstBootStorageManipulation(count: 1)
  }
}

private extension TestStartupInteractor {
  
  func stubFetchDocuments(with documents: [MdocDecodable]) {
    stub(walletKitController) { mock in
      when(mock.loadDocuments()).thenDoNothing()
      when(mock.fetchAllDocuments()).thenReturn(documents)
    }
  }
  
  func stubHasPin(with hasPin: Bool) {
    stub(quickPinInteractor) { mock in
      when(mock.hasPin()).thenReturn(hasPin)
    }
  }
  
  func biometryConfig(with hasDocuments: Bool) -> UIConfig.Biometry {
    return UIConfig.Biometry(
      title: .loginTitle,
      caption: .loginCaption,
      quickPinOnlyCaption: .loginCaptionQuickPinOnly,
      navigationSuccessType: .push(
        hasDocuments
        ? .dashboard
        : .issuanceAddDocument(config: IssuanceFlowUiConfig(flow: .noDocument))
      ),
      navigationBackType: nil,
      isPreAuthorization: true,
      shouldInitializeBiometricOnCreate: true
    )
  }
  
  func stubPrefsControllerSetValue() {
    stub(prefsController) { mock in
      when(mock.setValue(any(), forKey: any())).thenDoNothing()
    }
  }
  
  func stubRunAtLeastOnce(_ atLeastOnce: Bool = true) {
    stub(prefsController) { mock in
      when(mock.getBool(forKey: Prefs.Key.runAtLeastOnce)).thenReturn(atLeastOnce)
    }
  }
  
  func stubKeyChainClear() {
    stub(keyChainController) { mock in
      when(mock.clear()).thenDoNothing()
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
