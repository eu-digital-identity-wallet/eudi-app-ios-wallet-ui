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
@testable import feature_common
@testable import feature_test
@testable import logic_test

final class TestGenericSuccessViewModel: EudiTest {

  @MainActor
  func testOnButtonClicked_WhenTheButtonOpensAWebPage_ThenOpensItAndReturnsToItsScreen() throws {
    let redirect = try XCTUnwrap(URL(string: "https://verifier.example/done"))
    let fixture = makeFixture(redirect: redirect)

    fixture.viewModel.onButtonClicked(with: fixture.button)

    XCTAssertEqual(fixture.opened.urls, [redirect])
    verify(fixture.router).popTo(with: equal(to: AppRoute.featureDashboardModule(.dashboard)))
  }

  @MainActor
  func testOnButtonClicked_WhenTheButtonOpensAWalletLink_ThenOpensNothingAndReturnsToItsScreen() throws {
    let redirect = try XCTUnwrap(URL(string: "rqes://callback?code=abc"))
    let fixture = makeFixture(redirect: redirect)

    fixture.viewModel.onButtonClicked(with: fixture.button)

    XCTAssertTrue(fixture.opened.urls.isEmpty)
    verify(fixture.router).popTo(with: equal(to: AppRoute.featureDashboardModule(.dashboard)))
  }
}

private extension TestGenericSuccessViewModel {

  struct Fixture {
    let viewModel: GenericSuccessViewModel<MockRouterHost>
    let button: UIConfig.Success.Button
    let router: MockRouterHost
    let opened: RecordingLinkOpener
  }

  @MainActor
  func makeFixture(redirect: URL) -> Fixture {
    let router = MockRouterHost()
    stub(router) { mock in
      when(mock.popTo(with: any())).thenDoNothing()
    }
    let opened = RecordingLinkOpener()
    let button = UIConfig.Success.Button(
      title: .custom("Done"),
      style: .primary,
      navigationType: .deepLink(link: redirect, popToScreen: .featureDashboardModule(.dashboard))
    )
    let viewModel = GenericSuccessViewModel(
      config: UIConfig.Success(
        title: .init(value: .custom("Done")),
        subtitle: .custom(""),
        buttons: [button],
        visualKind: .defaultIcon
      ),
      router: router,
      openURL: { opened.open($0) }
    )
    return Fixture(viewModel: viewModel, button: button, router: router, opened: opened)
  }
}
