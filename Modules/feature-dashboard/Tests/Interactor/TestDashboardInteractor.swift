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
import logic_resources
import logic_core
@testable import feature_dashboard
@testable import logic_test
@testable import feature_test

final class TestDashboardInteractor: EudiTest {
  
  var interactor: DashboardInteractorType!
  var reachabilityController: MockReachabilityControllerType!
  var walletKitController: MockWalletKitControllerType!
  var configLogic: MockConfigLogic!
  
  override func setUp() {
    self.reachabilityController = MockReachabilityControllerType()
    self.walletKitController = MockWalletKitControllerType()
    self.configLogic = MockConfigLogic()
    self.interactor = DashboardInteractor(
      walletController: walletKitController,
      reachabilityController: reachabilityController,
      configLogic: configLogic
    )
  }
  
  override func tearDown() {
    self.interactor = nil
    self.reachabilityController = nil
    self.walletKitController = nil
    self.configLogic = nil
  }
  
  func testOpenBleSettings_WhenMethodIsCalled_ThenVerifyAtLeastOnce() {
    // Given
    stub(reachabilityController) { mock in
      when(mock).openBleSettings().thenDoNothing()
    }
    // When
    interactor.openBleSettings()
    // Then
    verify(reachabilityController).openBleSettings()
  }
  
  func testGetAppVersion_WhenConfigLogicHasAppVersion_ThenReturnAppVersion() {
    // Given
    let appVersion = "2024.2.1-dev"
    stub(configLogic) { mock in
      when(mock).appVersion.get.thenReturn(appVersion)
    }
    // When
    let version = interactor.getAppVersion()
    // Then
    XCTAssertEqual(version, appVersion)
  }
  
  func testGetBleAvailability_WhenBleIsAvailable_ThenReturnAvailableEnum() async {
    await checkBle(with: .available)
  }
  
  func testGetBleAvailability_WhenBleIsDisabled_ThenReturnDisabledEnum() async {
    await checkBle(with: .disabled)
  }
  
  func testFetchDashboard_WhenWalletKitControllerReturnsEmpty_ThenReturnError() async {
    // Given
    stubFetchDocuments(with: [])
    // When
    let state = await interactor.fetchDashboard()
    // Then
    switch state {
    case .failure(let error):
      XCTAssertEqual(error.localizedDescription, RuntimeError.unableFetchDocuments.localizedDescription)
    default:
      XCTFail("Wrong state \(state)")
    }
  }
  
  func testFetchDashboard_WhenWalletKitControllerReturnsData_ThenReturnUiModels() async {
    // Given
    let expectedDocuments: [DocumentUIModel] = [
      .init(
        id: Constants.randomIdentifier,
        value: .init(
          id: Constants.randomIdentifier,
          title: "National ID",
          expiresAt: "30 Mar 2050"
        )
      )
    ]
    let expectedBearer: BearerUIModel = .init(
      id: Constants.randomIdentifier,
      value: .init(
        name: "JAN",
        image: Theme.shared.image.user
      )
    )
    stubFetchDocuments(with: [Constants.euPidModel])
    // When
    let state = await interactor.fetchDashboard()
    // Then
    switch state {
    case .success(let bearer, let documents):
      XCTAssertEqual(expectedDocuments, documents)
      XCTAssertEqual(expectedBearer, bearer)
    default:
      XCTFail("Wrong state \(state)")
    }
  }
}

private extension TestDashboardInteractor {
  func checkBle(with status: ReachabilityController.BleAvailibity) async {
    // Given
    let publisher = Just(status).eraseToAnyPublisher()
    stub(reachabilityController) { mock in
      when(mock).getBleAvailibity().thenReturn(publisher)
    }
    // When
    let bleAvailability = await interactor.getBleAvailability()
    // Then
    XCTAssertEqual(bleAvailability, status)
  }
  
  func stubFetchDocuments(with documents: [MdocDecodable]) {
    stub(walletKitController) { mock in
      when(mock).fetchDocuments().thenReturn(documents)
    }
  }
}
