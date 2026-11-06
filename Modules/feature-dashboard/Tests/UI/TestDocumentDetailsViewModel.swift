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

final class TestDocumentDetailsViewModel: EudiTest {

  @MainActor
  func testIssueNewDocument_WhenTheDocumentIsBlocked_ThenTheRefusalHasNoRetryAndClosingItReloadsTheDetails() async {
    let interactor = MockDocumentDetailsInteractor()
    let reloaded = expectation(description: "details reloaded")
    stub(interactor) { mock in
      when(mock.reIssueDocument(identifier: any())).thenReturn(.documentBlocked)
      when(mock.fetchStoredDocument(documentId: any())).then { _ in
        reloaded.fulfill()
        return .failure(WalletCoreError.unableFetchDocument)
      }
    }
    let viewModel = DocumentDetailsViewModel(router: MockRouterHost(), interactor: interactor, documentId: "pid")

    viewModel.issueNewDocument()
    let error = await waitForError(in: viewModel)

    XCTAssertNotNil(error)
    XCTAssertNil(error?.action)
    error?.cancelAction()
    await fulfillment(of: [reloaded], timeout: 5)
  }

  @MainActor
  func testIssueNewDocument_WhenTheReIssueFailsOtherwise_ThenTheErrorOffersARetry() async {
    let interactor = MockDocumentDetailsInteractor()
    stub(interactor) { mock in
      when(mock.reIssueDocument(identifier: any())).thenReturn(.failure(WalletCoreError.unableFetchDocument))
    }
    let viewModel = DocumentDetailsViewModel(router: MockRouterHost(), interactor: interactor, documentId: "pid")

    viewModel.issueNewDocument()
    let error = await waitForError(in: viewModel)

    XCTAssertNotNil(error?.action)
  }
}

private extension TestDocumentDetailsViewModel {

  @MainActor
  func waitForError(
    in viewModel: DocumentDetailsViewModel<MockRouterHost>
  ) async -> ContentErrorView.Config? {
    for _ in 0..<100 where viewModel.viewState.error == nil {
      try? await Task.sleep(seconds: 0.02)
    }
    return viewModel.viewState.error
  }
}
