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
@testable import logic_core
@testable import logic_test
@testable import feature_test
@testable import logic_business
@testable import feature_dashboard

final class TestHomeTabInteractor: EudiTest {
  
  var interactor: HomeTabInteractor!
  var reachabilityController: MockReachabilityController!
  var walletKitController: MockWalletKitController!
  
  override func setUp() {
    self.reachabilityController = MockReachabilityController()
    self.walletKitController = MockWalletKitController()
    self.interactor = HomeTabInteractorImpl(
      walletKitController: walletKitController,
      reachabilityController: reachabilityController
    )
  }
  
  override func tearDown() {
    self.interactor = nil
    self.reachabilityController = nil
    self.walletKitController = nil
  }
  
  func testFetchUsername_WhenPidDocumentReturnsValidName_ThenReturnsThatName() async {
    // Given
    stubFetchMainPidDocument(with: Constants.createEuPidModel())
    
    // When
    let username = await interactor.fetchUsername()
    
    // Then
    XCTAssertEqual(username, "John")
  }
  
  func testGetWalletKitController_WhenInteractorReturnsWalletKitController_ThenVerifyControllerIsInjected() async {
    // When
    let result = await interactor.getWalletKitController()
    
    // Then
    XCTAssertTrue(result is MockWalletKitController, "The result should be of type MockWalletKitController")
  }
  
  func testOpenBleSettings_WhenReachabilityControllerFetchBleSettings_ThenVerifyBleSettingsOpen() async {
    // Given
    stub(reachabilityController) { mock in
      when(mock.openBleSettings()).thenDoNothing()
    }
    
    // When
    await interactor.openBleSettings()
    
    // Then
    verify(reachabilityController).openBleSettings()
  }
  
  func testGetBleAvailability_WhenReachabilityControllerReturnsBleAvailability_ThenVerifyAvailableEnum() async {
    await checkBle(with: Reachability.BleAvailibity.available)
  }
  
  func testGetBleAvailability_WhenReachabilityControllerReturnsBleAvailability_ThenVerifyDisabledEnum() async {
    await checkBle(with: Reachability.BleAvailibity.disabled)
  }
}

private extension TestHomeTabInteractor {
  func stubFetchMainPidDocument(with document: DocClaimsDecodable?) {
    stub(walletKitController) { mock in
      when(mock.fetchMainPidDocument()).thenReturn(document)
    }
  }
  
  func checkBle(with status: Reachability.BleAvailibity) async {
    // Given
    let publisher = Just(status).eraseToAnyPublisher()
    stub(reachabilityController) { mock in
      when(mock.getBleAvailibity()).thenReturn(publisher)
    }
    
    // When
    let bleAvailability = await interactor.getBleAvailability()
    
    // Then
    XCTAssertEqual(bleAvailability, status)
  }
}
