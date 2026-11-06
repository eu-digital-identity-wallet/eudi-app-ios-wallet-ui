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

final class TestDocumentSuccessViewModel: EudiTest {

  private var router: MockRouterHost!
  private var opened: RecordingLinkOpener!

  override func setUp() {
    super.setUp()
    router = MockRouterHost()
    opened = RecordingLinkOpener()
    stub(router) { mock in
      when(mock.popTo(with: any())).thenDoNothing()
    }
  }

  override func tearDown() {
    router = nil
    opened = nil
    super.tearDown()
  }

  @MainActor
  func testOnDone_WhenTheVerifierRedirectsToAWebPage_ThenOpensItAndReturnsToItsScreen() throws {
    let redirect = try XCTUnwrap(URL(string: "https://verifier.example/done"))

    makeViewModel(redirect: redirect).onDone()

    XCTAssertEqual(opened.urls, [redirect])
    verify(router).popTo(with: equal(to: AppRoute.featureDashboardModule(.dashboard)))
  }

  @MainActor
  func testOnDone_WhenTheVerifierRedirectsToAWalletLink_ThenOpensNothingAndReturnsToItsScreen() throws {
    let redirect = try XCTUnwrap(URL(string: "openid-credential-offer://?credential_offer_uri=https://issuer.example"))

    makeViewModel(redirect: redirect).onDone()

    XCTAssertTrue(opened.urls.isEmpty)
    verify(router).popTo(with: equal(to: AppRoute.featureDashboardModule(.dashboard)))
    verify(router, never()).push(with: any())
  }
}

private extension TestDocumentSuccessViewModel {

  @MainActor
  func makeViewModel(redirect: URL) -> DocumentSuccessViewModel<MockRouterHost, String> {
    let opened = opened!
    return DocumentSuccessViewModel(
      router: router,
      config: DocumentSuccessUIConfig(
        successNavigation: .deepLink(link: redirect, popToScreen: .featureDashboardModule(.dashboard)),
        relyingPartyIsTrusted: true,
        isIssuingDocument: false
      ),
      requestItems: [ListItemSection<String>](),
      openURL: { opened.open($0) }
    )
  }
}
