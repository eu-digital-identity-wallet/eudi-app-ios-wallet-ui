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

final class TestDashboardInteractor: EudiTest {
  
  var interactor: DashboardInteractor!
  var walletKitController: MockWalletKitController!
  
  override func setUp() {
    self.walletKitController = MockWalletKitController()
    self.interactor = DashboardInteractorImpl(
      walletKitController: walletKitController
    )
  }
  
  override func tearDown() {
    self.interactor = nil
  }
  
  func testGetWalletKitController_WhenInteractorReturnsWalletKitController_ThenVerifyControllerIsInjected() {
    // Given / When
    let result = interactor.getWalletKitController()
    
    // Then
    XCTAssertTrue(result is MockWalletKitController, "The result should be of type MockWalletKitController")
  }
}
