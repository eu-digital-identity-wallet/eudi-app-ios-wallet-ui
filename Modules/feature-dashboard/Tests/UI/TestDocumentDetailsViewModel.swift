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
@testable import feature_common
@testable import feature_dashboard
@testable import logic_test
@testable import feature_test

final class TestDocumentDetailsViewModel: EudiTest {

  @MainActor
  func testIssueNewDocument_WhenTheDocumentIsBlocked_ThenTheRefusalHasNoRetryAndClosingItReloadsTheDetails() async {
    // Given
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

    // When
    viewModel.issueNewDocument()
    let error = await waitForError(in: viewModel)

    // Then
    XCTAssertNotNil(error)
    XCTAssertNil(error?.action)

    // When
    error?.cancelAction()

    // Then
    await fulfillment(of: [reloaded], timeout: 5)
  }

  @MainActor
  func testIssueNewDocument_WhenTheReIssueFailsOtherwise_ThenTheErrorOffersARetry() async {
    // Given
    let interactor = MockDocumentDetailsInteractor()
    stub(interactor) { mock in
      when(mock.reIssueDocument(identifier: any())).thenReturn(.failure(WalletCoreError.unableFetchDocument))
    }
    let viewModel = DocumentDetailsViewModel(router: MockRouterHost(), interactor: interactor, documentId: "pid")

    // When
    viewModel.issueNewDocument()
    let error = await waitForError(in: viewModel)

    // Then
    XCTAssertNotNil(error?.action)
  }

  @MainActor
  func testToggleIsVisible_WhenTheDataIsHidden_ThenItIsShown() async {
    // Given
    let viewModel = await viewModelShowingHiddenData()

    // When
    viewModel.toggleIsVisible()

    // Then
    XCTAssertFalse(viewModel.isVisible)
    XCTAssertEqual(Set(blurFlags(of: viewModel.viewState.document.documentFields)), [false])
  }

  @MainActor
  func testToggleIsVisible_WhenTheDataIsShown_ThenItIsHiddenAgain() async {
    // Given
    let viewModel = await viewModelShowingHiddenData()
    viewModel.toggleIsVisible()

    // When
    viewModel.toggleIsVisible()

    // Then
    XCTAssertTrue(viewModel.isVisible)
    XCTAssertEqual(Set(blurFlags(of: viewModel.viewState.document.documentFields)), [true])
  }

  @MainActor
  func testFetchDocumentDetails_WhenTheDataIsShownAndTheDocumentReloads_ThenItStaysShown() async {
    // Given
    let viewModel = await viewModelShowingHiddenData()
    viewModel.toggleIsVisible()

    // When
    await viewModel.fetchDocumentDetails()

    // Then
    XCTAssertFalse(viewModel.isVisible)
    XCTAssertEqual(Set(blurFlags(of: viewModel.viewState.document.documentFields)), [false])

    // When
    viewModel.toggleIsVisible()

    // Then
    XCTAssertEqual(Set(blurFlags(of: viewModel.viewState.document.documentFields)), [true])
  }
}

private extension TestDocumentDetailsViewModel {

  /// The details screen's view model once the document has loaded with its values hidden, as stored documents open.
  @MainActor
  func viewModelShowingHiddenData() async -> DocumentDetailsViewModel<MockRouterHost> {
    let document = DocumentUIModel.mock()
    let hidden = document.copy(documentFields: document.toggleVisibility(isVisible: true))
    let interactor = MockDocumentDetailsInteractor()
    stub(interactor) { mock in
      when(mock.fetchStoredDocument(documentId: any())).thenReturn(.success(hidden, nil, nil, false, false))
    }
    let viewModel = DocumentDetailsViewModel(router: MockRouterHost(), interactor: interactor, documentId: "pid")
    await viewModel.fetchDocumentDetails()
    return viewModel
  }

  /// Whether each row of the document's fields is blurred, nested rows included, in order.
  func blurFlags(of fields: [GenericExpandableItem]) -> [Bool] {
    fields.flatMap { field -> [Bool] in
      switch field {
      case .single(let item):
        return [item.collapsed.isBlur]
      case .nested(let item):
        return blurFlags(of: item.expanded)
      }
    }
  }

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
