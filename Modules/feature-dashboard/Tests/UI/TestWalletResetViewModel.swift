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
import Cuckoo
@testable import logic_core
@testable import logic_ui
@testable import feature_dashboard
@testable import logic_test
@testable import feature_test

final class TestWalletResetViewModel: EudiTest {

  @MainActor
  func testReset_WhenTheResetSucceeds_ThenForgetsTheKeptLinkAndReturnsToStartUp() async {
    let fixture = makeFixture(outcome: .success)

    await fixture.viewModel.reset()

    verify(fixture.deepLinkController).removeCachedDeepLinkURL()
    verify(fixture.router).restartAtStartup()
    XCTAssertNil(fixture.viewModel.viewState.error)
  }

  @MainActor
  func testReset_WhenTheResetFails_ThenOffersToTryAgainAndToGoBack() async {
    let fixture = makeFixture(outcome: .failure(WalletCoreError.unableToIssueAndStore))

    await fixture.viewModel.reset()

    let error = fixture.viewModel.viewState.error
    XCTAssertNotNil(error?.action)
    XCTAssertFalse(fixture.viewModel.viewState.isLoading)
    verify(fixture.deepLinkController).removeCachedDeepLinkURL()
    verify(fixture.router, never()).restartAtStartup()
    error?.cancelAction()
    verify(fixture.router).popTo(with: any())
  }

  @MainActor
  func testOnResetConfirmed_WhenTheUserConfirms_ThenAsksForTheirIdentityBeforeTheReset() {
    let router = MockRouterHost()
    stub(router) { mock in
      when(mock.push(with: any())).thenDoNothing()
    }
    let viewModel = SettingsViewModel(
      router: router,
      interactor: MockSettingsInteractor(),
      walletKit: MockWalletKitController()
    )
    viewModel.isResetConfirmationShowing = true

    viewModel.onResetConfirmed()

    XCTAssertFalse(viewModel.isResetConfirmationShowing)
    verify(router).push(with: any())
  }
}

private extension TestWalletResetViewModel {

  @MainActor
  func makeFixture(outcome: WalletResetPartialState) -> Fixture {
    let router = MockRouterHost()
    let interactor = MockSettingsInteractor()
    let deepLinkController = MockDeepLinkController()
    stub(router) { mock in
      when(mock.restartAtStartup()).thenDoNothing()
      when(mock.popTo(with: any())).thenDoNothing()
    }
    stub(interactor) { mock in
      when(mock.resetWallet()).thenReturn(outcome)
    }
    stub(deepLinkController) { mock in
      when(mock.removeCachedDeepLinkURL()).thenDoNothing()
    }
    let viewModel = WalletResetViewModel(
      router: router,
      interactor: interactor,
      deepLinkController: deepLinkController
    )
    return Fixture(viewModel: viewModel, router: router, deepLinkController: deepLinkController)
  }

  struct Fixture {
    let viewModel: WalletResetViewModel<MockRouterHost>
    let router: MockRouterHost
    let deepLinkController: MockDeepLinkController
  }
}
