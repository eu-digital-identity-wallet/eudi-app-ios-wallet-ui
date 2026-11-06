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

@testable import logic_core
@testable import logic_test
@testable import feature_test
@testable import logic_business
@testable import feature_dashboard

final class TestDashboardInteractor: EudiTest {
  
  var interactor: DashboardInteractor!
  var walletKitController: MockWalletKitController!
  var walletWorkScheduler: MockWalletWorkScheduler!
  
  override func setUp() {
    self.walletKitController = MockWalletKitController()
    self.walletWorkScheduler = MockWalletWorkScheduler()
    self.interactor = DashboardInteractorImpl(
      walletKitController: walletKitController,
      walletWorkScheduler: walletWorkScheduler
    )
  }
  
  override func tearDown() {
    self.interactor = nil
    self.walletKitController = nil
    self.walletWorkScheduler = nil
  }
  
  func testLoadDocuments_WhenCalled_ThenTheWalletLoadsItsDocuments() async {
    stub(walletKitController) { mock in
      when(mock.loadDocuments()).thenDoNothing()
    }

    await interactor.loadDocuments()

    verify(walletKitController).loadDocuments()
  }

  func testLoadDocuments_WhenLoadingFails_ThenSwallowsTheError() async {
    stub(walletKitController) { mock in
      when(mock.loadDocuments()).thenThrow(WalletCoreError.unableFetchDocument)
    }

    await interactor.loadDocuments()

    verify(walletKitController).loadDocuments()
  }

  func testReconcileRegistrations_WhenCalled_ThenTheControllerReconcilesThem() async {
    stub(walletKitController) { mock in
      when(mock.reconcileRegistrations()).thenDoNothing()
    }

    await interactor.reconcileRegistrations()

    verify(walletKitController).reconcileRegistrations()
  }

  func testStartWorkers_WhenCalled_ThenSchedulesTheBackgroundChecks() async {
    stub(walletWorkScheduler) { mock in
      when(mock.schedule()).thenDoNothing()
    }

    await interactor.startWorkers()

    verify(walletWorkScheduler).schedule()
  }
}
