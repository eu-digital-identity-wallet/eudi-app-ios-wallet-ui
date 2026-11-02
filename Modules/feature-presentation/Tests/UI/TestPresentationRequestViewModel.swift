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
    let viewModel = makeViewModel(isTrusted: false)

    await viewModel.doWork()

    XCTAssertEqual(viewModel.viewState.registrationWarning, .accessCertificateNotTrusted)
  }

  @MainActor
  func testDoWork_WhenTheVerifierAuthenticated_ThenShowsNoWarning() async {
    let viewModel = makeViewModel(isTrusted: true)

    await viewModel.doWork()

    XCTAssertNil(viewModel.viewState.registrationWarning)
  }

  @MainActor
  func testOnShareClick_WhenThePortraitWouldBeShared_ThenAsksForConfirmationFirst() async {
    let viewModel = makeViewModel(isTrusted: true, combinations: [RequestCombinationUiModel(documents: [portraitRequest()])])
    await viewModel.doWork()

    viewModel.onShareClick()

    XCTAssertTrue(viewModel.isUserImageConfirmationShowing)
    verify(interactor, never()).onResponsePrepare(combinationIndex: any())
  }

  @MainActor
  func testOnShareClick_WhenNoPortraitWouldBeShared_ThenSharesWithoutAConfirmation() async {
    let viewModel = makeViewModel(isTrusted: true, combinations: [RequestCombinationUiModel(documents: [plainRequest()])])
    await viewModel.doWork()
    let shared = expectSharing()

    viewModel.onShareClick()

    XCTAssertFalse(viewModel.isUserImageConfirmationShowing)
    await fulfillment(of: [shared], timeout: 3)
  }

  @MainActor
  func testOnUserImageShareConfirmed_WhenTheUserConfirms_ThenTheConfirmationClosesAndSharingGoesOn() async {
    let viewModel = makeViewModel(isTrusted: true, combinations: [RequestCombinationUiModel(documents: [portraitRequest()])])
    await viewModel.doWork()
    viewModel.onShareClick()
    let shared = expectSharing()

    viewModel.onUserImageShareConfirmed()

    XCTAssertFalse(viewModel.isUserImageConfirmationShowing)
    await fulfillment(of: [shared], timeout: 3)
  }

  @MainActor
  func testOnShareClick_WhenTheWarningIsNotAcknowledged_ThenDoesNotShare() async {
    let viewModel = makeViewModel(isTrusted: false, combinations: [RequestCombinationUiModel(documents: [plainRequest()])])
    await viewModel.doWork()

    viewModel.onShareClick()

    XCTAssertFalse(viewModel.canShare)
    verify(interactor, never()).onResponsePrepare(combinationIndex: any())
  }

  @MainActor
  func testOnShareClick_WhenTheWarningIsAcknowledged_ThenShares() async {
    let viewModel = makeViewModel(isTrusted: false, combinations: [RequestCombinationUiModel(documents: [plainRequest()])])
    await viewModel.doWork()
    viewModel.isRiskAcknowledged = true
    let shared = expectSharing()

    viewModel.onShareClick()

    await fulfillment(of: [shared], timeout: 3)
  }

  @MainActor
  func testOnUserImageShareConfirmed_WhenSharingIsNoLongerAllowed_ThenDoesNotShare() async {
    let viewModel = makeViewModel(isTrusted: false, combinations: [RequestCombinationUiModel(documents: [portraitRequest()])])
    await viewModel.doWork()
    viewModel.isRiskAcknowledged = true
    viewModel.onShareClick()
    XCTAssertTrue(viewModel.isUserImageConfirmationShowing)
    viewModel.isRiskAcknowledged = false

    viewModel.onUserImageShareConfirmed()

    XCTAssertFalse(viewModel.isUserImageConfirmationShowing)
    verify(interactor, never()).onResponsePrepare(combinationIndex: any())
  }
}

private extension TestPresentationRequestViewModel {

  @MainActor
  func makeViewModel(
    isTrusted: Bool,
    combinations: [RequestCombinationUiModel] = []
  ) -> PresentationRequestViewModel<MockRouterHost> {
    stub(interactor) { mock in
      when(mock.onResponsePrepare(combinationIndex: any())).thenReturn(.failure(RuntimeError.genericError))
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
      when(mock.onResponsePrepare(combinationIndex: any())).then { _ in
        shared.fulfill()
        return .failure(RuntimeError.genericError)
      }
    }
    return shared
  }
}
