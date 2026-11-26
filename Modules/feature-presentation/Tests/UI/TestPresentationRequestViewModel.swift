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
import logic_business
@testable import logic_core
@testable import feature_common
@testable import feature_presentation
@testable import logic_test
@testable import feature_test

final class TestPresentationRequestViewModel: EudiTest {

  private let interactor = MockPresentationInteractor()

  @MainActor
  func testDoWork_WhenTheVerifierDidNotAuthenticate_ThenWarnsAboutItsAccessCertificate() async {
    // Given
    let viewModel = makeViewModel(isTrusted: false)

    // When
    await viewModel.doWork()

    // Then
    XCTAssertEqual(viewModel.viewState.registrationWarning, .accessCertificateNotTrusted)
  }

  @MainActor
  func testDoWork_WhenTheVerifierAuthenticated_ThenShowsNoWarning() async {
    // Given
    let viewModel = makeViewModel(isTrusted: true)

    // When
    await viewModel.doWork()

    // Then
    XCTAssertNil(viewModel.viewState.registrationWarning)
  }

  @MainActor
  func testOnShareClick_WhenThePortraitWouldBeShared_ThenAsksForConfirmationFirst() async {
    // Given
    let viewModel = makeViewModel(isTrusted: true, combinations: [RequestCombinationUiModel(documents: [portraitRequest()])])
    await viewModel.doWork()

    // When
    viewModel.onShareClick()

    // Then
    XCTAssertTrue(viewModel.isUserImageConfirmationShowing)
    verify(interactor, never()).onResponsePrepare(combinationIndex: any(), chosenDocumentIds: any())
  }

  @MainActor
  func testOnShareClick_WhenNoPortraitWouldBeShared_ThenSharesWithoutAConfirmation() async {
    // Given
    let viewModel = makeViewModel(isTrusted: true, combinations: [RequestCombinationUiModel(documents: [plainRequest()])])
    await viewModel.doWork()
    let shared = expectSharing()

    // When
    viewModel.onShareClick()

    // Then
    XCTAssertFalse(viewModel.isUserImageConfirmationShowing)
    await fulfillment(of: [shared], timeout: 3)
  }

  @MainActor
  func testOnUserImageShareConfirmed_WhenTheUserConfirms_ThenTheConfirmationClosesAndSharingGoesOn() async {
    // Given
    let viewModel = makeViewModel(isTrusted: true, combinations: [RequestCombinationUiModel(documents: [portraitRequest()])])
    await viewModel.doWork()
    viewModel.onShareClick()
    let shared = expectSharing()

    // When
    viewModel.onUserImageShareConfirmed()

    // Then
    XCTAssertFalse(viewModel.isUserImageConfirmationShowing)
    await fulfillment(of: [shared], timeout: 3)
  }

  @MainActor
  func testOnShareClick_WhenTheWarningIsNotAcknowledged_ThenDoesNotShare() async {
    // Given
    let viewModel = makeViewModel(isTrusted: false, combinations: [RequestCombinationUiModel(documents: [plainRequest()])])
    await viewModel.doWork()
    let shared = expectSharing()
    shared.isInverted = true

    // When
    viewModel.onShareClick()

    // Then
    XCTAssertFalse(viewModel.canShare)
    await fulfillment(of: [shared], timeout: 0.5)
  }

  @MainActor
  func testOnShareClick_WhenTheWarningIsAcknowledged_ThenShares() async {
    // Given
    let viewModel = makeViewModel(isTrusted: false, combinations: [RequestCombinationUiModel(documents: [plainRequest()])])
    await viewModel.doWork()
    viewModel.isRiskAcknowledged = true
    let shared = expectSharing()

    // When
    viewModel.onShareClick()

    // Then
    await fulfillment(of: [shared], timeout: 3)
  }

  @MainActor
  func testOnUserImageShareConfirmed_WhenSharingIsNoLongerAllowed_ThenDoesNotShare() async {
    // Given
    let viewModel = makeViewModel(isTrusted: false, combinations: [RequestCombinationUiModel(documents: [portraitRequest()])])
    await viewModel.doWork()
    viewModel.isRiskAcknowledged = true
    let shared = expectSharing()
    shared.isInverted = true

    // When
    viewModel.onShareClick()

    // Then
    XCTAssertTrue(viewModel.isUserImageConfirmationShowing)
    viewModel.isRiskAcknowledged = false

    viewModel.onUserImageShareConfirmed()

    XCTAssertFalse(viewModel.isUserImageConfirmationShowing)
    await fulfillment(of: [shared], timeout: 0.5)
  }

  @MainActor
  func testDoWork_WhenAQueryHasTwoMatchesToChooseFrom_ThenShareIsDisabled() async {
    // Given
    let viewModel = makeViewModel(isTrusted: true, combinations: [choiceCombination()])

    // When
    await viewModel.doWork()

    // Then
    XCTAssertFalse(viewModel.viewState.allowShare)
  }

  @MainActor
  func testDoWork_WhenAnotherDocumentIsSharedButNoMatchIsChosen_ThenShareIsDisabled() async {
    // Given
    let viewModel = makeViewModel(
      isTrusted: true,
      combinations: [
        RequestCombinationUiModel(
          documents: [plainRequest(), choosableRequest(id: "pid-1"), choosableRequest(id: "pid-2")]
        )
      ]
    )

    // When
    await viewModel.doWork()

    // Then
    XCTAssertFalse(viewModel.viewState.allowShare)
  }

  @MainActor
  func testOnCredentialChoiceToggled_WhenAMatchIsChosen_ThenShareIsEnabled() async {
    // Given
    let viewModel = makeViewModel(isTrusted: true, combinations: [choiceCombination()])
    await viewModel.doWork()

    // When
    viewModel.onCredentialChoiceToggled(combinationIndex: 0, documentId: "pid-1")

    // Then
    XCTAssertTrue(viewModel.viewState.allowShare)
    XCTAssertEqual(viewModel.viewState.items.map(\.isChosen), [true, false])
  }

  @MainActor
  func testOnCredentialChoiceToggled_WhenTheOnlyChosenMatchIsCleared_ThenShareIsDisabledAgain() async {
    // Given
    let viewModel = makeViewModel(isTrusted: true, combinations: [choiceCombination()])
    await viewModel.doWork()
    viewModel.onCredentialChoiceToggled(combinationIndex: 0, documentId: "pid-1")

    // When
    viewModel.onCredentialChoiceToggled(combinationIndex: 0, documentId: "pid-1")

    // Then
    XCTAssertFalse(viewModel.viewState.allowShare)
    XCTAssertEqual(viewModel.viewState.items.map(\.isChosen), [false, false])
  }

  @MainActor
  func testOnCredentialChoiceToggled_WhenTheOptionIsNotSelected_ThenNothingChanges() async {
    // Given
    let viewModel = makeViewModel(
      isTrusted: true,
      combinations: [RequestCombinationUiModel(documents: [plainRequest()]), choiceCombination()]
    )
    await viewModel.doWork()

    // When
    viewModel.onCredentialChoiceToggled(combinationIndex: 1, documentId: "pid-1")

    // Then
    XCTAssertEqual(viewModel.viewState.combinations[1].documents.map(\.isChosen), [false, false])
    XCTAssertTrue(viewModel.viewState.allowShare)
  }

  @MainActor
  func testOnCombinationSelected_WhenTheUserSwitchesOptions_ThenTheChoiceIsKept() async {
    // Given
    let viewModel = makeViewModel(
      isTrusted: true,
      combinations: [choiceCombination(), RequestCombinationUiModel(documents: [plainRequest()])]
    )
    await viewModel.doWork()
    viewModel.onCredentialChoiceToggled(combinationIndex: 0, documentId: "pid-2")

    // When
    viewModel.onCombinationSelected(index: 1)
    viewModel.onCombinationSelected(index: 0)

    // Then
    XCTAssertEqual(viewModel.viewState.items.map(\.isChosen), [false, true])
    XCTAssertTrue(viewModel.viewState.allowShare)
  }

  @MainActor
  func testOnShareClick_WhenThePortraitIsOnAMatchThatIsNotChosen_ThenSharesWithoutAConfirmation() async {
    // Given
    let viewModel = makeViewModel(
      isTrusted: true,
      combinations: [
        RequestCombinationUiModel(
          documents: [
            portraitRequest().copy(queryIds: ["pid"], isChosen: false),
            choosableRequest(id: "pid-2")
          ]
        )
      ]
    )
    await viewModel.doWork()
    viewModel.onCredentialChoiceToggled(combinationIndex: 0, documentId: "pid-2")
    let shared = expectSharing()

    // When
    viewModel.onShareClick()

    // Then
    XCTAssertFalse(viewModel.isUserImageConfirmationShowing)
    await fulfillment(of: [shared], timeout: 0.5)
  }

  @MainActor
  func testOnShareClick_WhenAMatchIsChosen_ThenTheInteractorGetsOnlyItsId() async {
    // Given
    let viewModel = makeViewModel(isTrusted: true, combinations: [choiceCombination()])
    await viewModel.doWork()
    viewModel.onCredentialChoiceToggled(combinationIndex: 0, documentId: "pid-2")
    let shared = expectSharing()

    // When
    viewModel.onShareClick()

    // Then
    await fulfillment(of: [shared], timeout: 0.5)
    verify(interactor).onResponsePrepare(
      combinationIndex: 0,
      chosenDocumentIds: ParameterMatcher { $0 == ["pid-2"] }
    )
  }
}

private extension TestPresentationRequestViewModel {

  /// An option whose query `pid` has two matches, `pid-1` and `pid-2`, neither chosen yet.
  func choiceCombination() -> RequestCombinationUiModel {
    RequestCombinationUiModel(documents: [choosableRequest(id: "pid-1"), choosableRequest(id: "pid-2")])
  }

  /// A PID that answers the query `pid` and that the user can choose, not chosen yet.
  func choosableRequest(id: String) -> RequestDataUiModel {
    let familyName: ExpandableListItem<DocumentElementClaim> = .single(
      .init(
        collapsed: .init(groupId: "\(id)-family-name", mainContent: .text(.custom("Doe")), overlineText: .custom("Family name")),
        domainModel: .primitive(
          id: "\(id)-family-name",
          title: "Family name",
          documentId: id,
          nameSpace: "eu.europa.ec.eudi.pid.1",
          path: ["eu.europa.ec.eudi.pid.1", "family_name"],
          type: .mdoc,
          value: .string("Doe"),
          status: .available(isRequired: false)
        )
      )
    )
    return RequestDataUiModel(
      section: .init(id: id, title: "PID", listItems: [familyName]),
      queryIds: ["pid"],
      isChosen: false
    )
  }

  @MainActor
  func makeViewModel(
    isTrusted: Bool,
    combinations: [RequestCombinationUiModel] = []
  ) -> PresentationRequestViewModel<MockRouterHost> {
    stub(interactor) { mock in
      when(mock.onResponsePrepare(combinationIndex: any(), chosenDocumentIds: any())).thenReturn(.failure(RuntimeError.genericError))
      when(mock.getCoordinator()).thenReturn(.failure(RuntimeError.genericError))
      when(mock.onDeviceEngagement()).thenReturn(
        .success(
          OnlineAuthenticationRequestSuccessModel(
            requestDataCombinations: combinations,
            relyingParty: "Verifier",
            dataRequestInfo: "",
            isTrusted: isTrusted,
            relyingPartyRegistration: RelyingPartyRegistration(
              name: nil,
              uniqueId: nil,
              isVerified: false,
              logoUrl: nil,
              registration: .notSupported
            )
          )
        )
      )
    }
    return PresentationRequestViewModel(
      router: MockRouterHost(),
      interactor: interactor,
      originator: .featureDashboardModule(.dashboard)
    )
  }

  /// A document whose portrait is requested; its claims are disclosed as a whole, as in a remote presentation.
  func portraitRequest() -> RequestDataUiModel {
    let portrait: ExpandableListItem<DocumentElementClaim> = .single(
      .init(
        collapsed: .init(groupId: "portrait-id", mainContent: .text(.custom("value")), overlineText: .custom("Portrait")),
        domainModel: .primitive(
          id: "portrait-id",
          title: "Portrait",
          documentId: "doc-id",
          nameSpace: "nameSpace",
          path: ["nameSpace", "portrait"],
          type: .mdoc,
          value: .string("value"),
          status: .available(isRequired: false)
        )
      )
    )
    return .init(
      section: .init(id: "doc-id", title: "Document", listItems: [portrait]),
      userImageItemIds: ["portrait-id"]
    )
  }

  func plainRequest() -> RequestDataUiModel {
    let familyName: ExpandableListItem<DocumentElementClaim> = .single(
      .init(
        collapsed: .init(groupId: "family-name-id", mainContent: .text(.custom("value")), overlineText: .custom("Family name")),
        domainModel: .primitive(
          id: "family-name-id",
          title: "Family name",
          documentId: "doc-id",
          nameSpace: "nameSpace",
          path: ["nameSpace", "family_name"],
          type: .mdoc,
          value: .string("value"),
          status: .available(isRequired: false)
        )
      )
    )
    return .init(section: .init(id: "doc-id", title: "Document", listItems: [familyName]))
  }

  /// Fulfilled when the view model prepares the response, the first step of sharing.
  func expectSharing() -> XCTestExpectation {
    let shared = expectation(description: "the response is prepared")
    stub(interactor) { mock in
      when(mock.onResponsePrepare(combinationIndex: any(), chosenDocumentIds: any())).then { _ in
        shared.fulfill()
        return .failure(RuntimeError.genericError)
      }
    }
    return shared
  }
}
