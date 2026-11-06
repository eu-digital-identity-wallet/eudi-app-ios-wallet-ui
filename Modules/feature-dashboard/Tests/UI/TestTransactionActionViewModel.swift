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
@testable import logic_resources
@testable import feature_dashboard
@testable import logic_test
@testable import feature_test

final class TestTransactionActionViewModel: EudiTest {

  private let contactUrl = URL(string: "mailto:dpo@verifier.example")!

  @MainActor
  func testOpenActionChannel_WhenTheHandOffFails_ThenRecordsNothing() async {
    let fixture = makeFixture(opens: false, recordResult: .success)

    await fixture.viewModel.openActionChannel(contactUrl, contactUrl: contactUrl)

    verify(fixture.interactor, never()).recordDataProtectionAction(transactionId: any(), action: any(), contactUrl: any())
    XCTAssertEqual(fixture.viewModel.viewState.error?.description, .transactionDetailsActionOpenFailed)
  }

  @MainActor
  func testOpenActionChannel_WhenTheHandOffSucceeds_ThenRecordsItAfterwards() async {
    let fixture = makeFixture(opens: true, recordResult: .success)

    await fixture.viewModel.openActionChannel(contactUrl, contactUrl: contactUrl)

    XCTAssertEqual(fixture.opener.urls, [contactUrl])
    verify(fixture.interactor).recordDataProtectionAction(transactionId: any(), action: any(), contactUrl: any())
    XCTAssertNil(fixture.viewModel.viewState.error)
    XCTAssertEqual(fixture.viewModel.viewState.externalAction, .opened)
  }

  @MainActor
  func testOpenActionChannel_WhenTheRecordFails_ThenOffersToRecordAgainWithoutOpeningAgain() async {
    let fixture = makeFixture(opens: true, recordResult: .failure(error: WalletCoreError.unableToIssueAndStore))

    await fixture.viewModel.openActionChannel(contactUrl, contactUrl: contactUrl)

    XCTAssertEqual(fixture.viewModel.viewState.error?.description, .transactionDetailsActionError)
    XCTAssertNotNil(fixture.viewModel.viewState.error?.action)
    XCTAssertEqual(fixture.opener.urls, [contactUrl])
  }
}

@MainActor
private final class RecordingUrlOpener {

  private let opens: Bool
  private(set) var urls: [URL] = []

  init(opens: Bool) {
    self.opens = opens
  }

  func open(_ url: URL) async -> Bool {
    urls.append(url)
    return opens
  }
}

private extension TestTransactionActionViewModel {

  struct Fixture {
    let viewModel: TransactionActionViewModel<MockRouterHost>
    let interactor: MockTransactionDetailsInteractor
    let opener: RecordingUrlOpener
  }

  @MainActor
  func makeFixture(opens: Bool, recordResult: TransactionDataProtectionRecordPartialState) -> Fixture {
    let interactor = MockTransactionDetailsInteractor()
    stub(interactor) { mock in
      when(mock.recordDataProtectionAction(transactionId: any(), action: any(), contactUrl: any())).thenReturn(recordResult)
    }
    let opener = RecordingUrlOpener(opens: opens)
    let viewModel = TransactionActionViewModel(
      router: MockRouterHost(),
      interactor: interactor,
      transactionId: "transaction",
      action: .requestDataDeletion,
      openURL: { await opener.open($0) }
    )
    return Fixture(viewModel: viewModel, interactor: interactor, opener: opener)
  }
}
