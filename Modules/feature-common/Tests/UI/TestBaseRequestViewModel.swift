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
  func testInitialState_WhenCreated_ThenTheContentIsNotTrustBlocked() {
    // When
    let viewModel = makeViewModel()

    // Then
    XCTAssertFalse(viewModel.viewState.isTrustBlocked)
    XCTAssertFalse(viewModel.isTrustBlockedAlertShowing)
  }

  @MainActor
  func testOnTrustBlocked_WhenTheRequestIsBlocked_ThenOnlyTheAlertIsShown() {
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
  func testOnCombinationItemClick_WhenAClaimIsFirstClicked_ThenOnlyTheMissingCredentialsNoticeIsShown() async {
    // Given
    let viewModel = makeViewModel()
    viewModel.onReceivedCombinations(
      with: [.init(documents: [selectableClaimRequest()])],
      title: .custom("Request"),
      relyingParty: .custom("Verifier"),
      isTrusted: true
    )

    // When
    await viewModel.onCombinationItemClick(combinationIndex: 0, id: "family-name")

    // Then
    XCTAssertTrue(viewModel.itemsChanged)
    XCTAssertFalse(viewModel.viewState.showMissingCredentials)
    XCTAssertTrue(viewModel.viewState.allowShare)
  }

  @MainActor
  func testOnCombinationItemClick_WhenTheDocumentHasNoSelectableClaims_ThenTheNoticeIsHidden() async {
    // Given
    let viewModel = makeViewModel()
    viewModel.onReceivedCombinations(
      with: [.init(documents: [selectableClaimRequest(isSelectable: false)])],
      title: .custom("Request"),
      relyingParty: .custom("Verifier"),
      isTrusted: true
    )

    // When
    await viewModel.onCombinationItemClick(combinationIndex: 0, id: "family-name")

    // Then
    XCTAssertFalse(viewModel.viewState.showMissingCredentials)
    XCTAssertFalse(viewModel.itemsChanged)
  }

  @MainActor
  func testOnCombinationItemClick_WhenTheOnlySelectedClaimIsClearedAfterTheNotice_ThenShareIsDisabled() async {
    // Given
    let viewModel = makeViewModel()
    viewModel.onReceivedCombinations(
      with: [.init(documents: [selectableClaimRequest()])],
      title: .custom("Request"),
      relyingParty: .custom("Verifier"),
      isTrusted: true
    )
    await viewModel.onCombinationItemClick(combinationIndex: 0, id: "family-name")

    // When
    await viewModel.onCombinationItemClick(combinationIndex: 0, id: "family-name")

    // Then
    XCTAssertFalse(viewModel.viewState.allowShare)
    XCTAssertFalse(viewModel.viewState.items.canShare())
    XCTAssertEqual(viewModel.viewState.combinations.first?.documents, viewModel.viewState.items)
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

  /// A document whose one claim is the family name: one the user can select (proximity), selected at first, or with
  /// `isSelectable` false one disclosed with the document (remote).
  func selectableClaimRequest(isSelectable: Bool = true) -> RequestDataUiModel {
    let familyName: ExpandableListItem<DocumentElementClaim> = .single(
      .init(
        collapsed: .init(
          groupId: "family-name",
          mainContent: .text(.custom("Doe")),
          overlineText: .custom("Family name"),
          trailingContent: isSelectable ? .checkbox(true, true, { _ in }) : .empty
        ),
        domainModel: .primitive(
          id: "family-name",
          title: "Family name",
          documentId: "mdl",
          nameSpace: "org.iso.18013.5.1",
          path: ["org.iso.18013.5.1", "family_name"],
          type: .mdoc,
          value: .string("Doe"),
          status: .available(isRequired: false)
        )
      )
    )
    return .init(section: .init(id: "mdl", title: "mDL", listItems: [familyName]))
  }
}
