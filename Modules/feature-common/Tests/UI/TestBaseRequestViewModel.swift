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
import logic_core
import logic_ui
import logic_resources
@testable import feature_common
@testable import logic_test

final class TestBaseRequestViewModel: EudiTest {

  @MainActor
  func testInitialState_whenCreated_thenTheContentIsNotTrustBlocked() {
    // When
    let viewModel = makeViewModel()

    // Then
    XCTAssertFalse(viewModel.viewState.isTrustBlocked)
    XCTAssertFalse(viewModel.isTrustBlockedAlertShowing)
  }

  @MainActor
  func testOnTrustBlocked_whenTheRequestIsBlocked_thenOnlyTheAlertIsShown() {
    // Given
    let viewModel = makeViewModel()

    // When
    viewModel.onTrustBlocked()

    // Then
    XCTAssertTrue(viewModel.viewState.isTrustBlocked)
    XCTAssertTrue(viewModel.isTrustBlockedAlertShowing)
    XCTAssertNil(viewModel.viewState.error)
    XCTAssertNil(viewModel.viewState.errorTitle)
    XCTAssertFalse(viewModel.viewState.isLoading)
    XCTAssertFalse(viewModel.viewState.allowShare)
  }

  @MainActor
  func testResetState_whenTheRequestWasBlocked_thenTheContentIsNoLongerTrustBlocked() {
    // Given
    let viewModel = makeViewModel()
    viewModel.onTrustBlocked()

    // When
    viewModel.resetState()

    // Then
    XCTAssertFalse(viewModel.viewState.isTrustBlocked)
  }
}

private extension TestBaseRequestViewModel {
  @MainActor
  func makeViewModel() -> BaseRequestViewModel<MockRouterHost> {
    BaseRequestViewModel(
      router: MockRouterHost(),
      originator: .featureDashboardModule(.dashboard)
    )
  }
}
