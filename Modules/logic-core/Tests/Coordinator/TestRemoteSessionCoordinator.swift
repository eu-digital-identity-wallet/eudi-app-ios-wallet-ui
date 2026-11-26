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
import os
import EudiWalletKit
import OpenID4VP
@testable import logic_core
@testable import logic_test

final class TestRemoteSessionCoordinator: EudiTest {

  func testDeclineResponse_WhenTheWalletHasNotAnswered_ThenDeclinesOnce() async throws {
    // Given
    let answers = RecordingAnswers()
    let coordinator = RemoteSessionCoordinatorImpl(session: .answeringFixture { answers.record($0) })

    // When
    try await coordinator.declineResponse()
    try await coordinator.declineResponse()

    // Then
    XCTAssertEqual(answers.sent, [false])
  }

  func testDeclineResponse_WhenTheResponseFailed_ThenSendsNoSecondAnswer() async throws {
    // Given
    let answers = RecordingAnswers()
    let coordinator = RemoteSessionCoordinatorImpl(
      session: .answeringFixture { userAccepted in
        answers.record(userAccepted)
        guard !userAccepted else { throw SendFailure() }
      }
    )

    // When
    do {
      try await coordinator.sendResponse(response: StubResponse())

      // Then
      XCTFail("The response was expected to fail")
    } catch {
      XCTAssertTrue(error is SendFailure)
    }

    // When
    try await coordinator.declineResponse()

    // Then
    XCTAssertEqual(answers.sent, [true])
  }

  func testDeclineResponse_WhenTheResponseWasSent_ThenSendsNoSecondAnswer() async throws {
    // Given
    let answers = RecordingAnswers()
    let coordinator = RemoteSessionCoordinatorImpl(session: .answeringFixture { answers.record($0) })

    // When
    try await coordinator.sendResponse(response: StubResponse())
    try await coordinator.declineResponse()

    // Then
    XCTAssertEqual(answers.sent, [true])
  }

  func testSendResponse_WhenSharedAgainAfterAFailure_ThenSendsTheResponseAgain() async throws {
    // Given
    let answers = RecordingAnswers()
    let coordinator = RemoteSessionCoordinatorImpl(
      session: .answeringFixture { userAccepted in
        answers.record(userAccepted)
        guard answers.sent.count > 1 else { throw SendFailure() }
      }
    )

    // When
    try? await coordinator.sendResponse(response: StubResponse())
    try await coordinator.sendResponse(response: StubResponse())

    // Then
    XCTAssertEqual(answers.sent, [true, true])
  }

  func testDeclineResponse_WhenTwoDeclinesOverlap_ThenDeclinesOnce() async throws {
    // Given
    let answers = RecordingAnswers()
    let coordinator = RemoteSessionCoordinatorImpl(session: .answeringFixture { answers.record($0) })

    // When
    async let first: Void = coordinator.declineResponse()
    async let second: Void = coordinator.declineResponse()
    _ = try await (first, second)

    // Then
    XCTAssertEqual(answers.sent, [false])
  }

  @MainActor
  func testRequestReceived_WhenAnOptionNamesTheQueriesOfItsDocuments_ThenTheRequestCarriesThem() async throws {
    // Given
    let session = PresentationSession.stoppableFixture(onStop: nil)
    session.disclosedDocumentSets = [
      DisclosedDocumentSet(
        docElements: [.msoMdoc(.init(docId: "pid-1", docType: "eu.europa.ec.eudi.pid.1", nameSpacedElements: []))],
        warnings: nil,
        credentialSelections: [
          CredentialSelection(
            credentialId: "pid-1",
            docType: "eu.europa.ec.eudi.pid.1",
            queryId: try QueryId(value: "pid"),
            optionId: "option-1",
            claimQueries: []
          )
        ]
      )
    ]
    let coordinator = RemoteSessionCoordinatorImpl(session: session)

    // When
    let request = try await coordinator.requestReceived()

    // Then
    XCTAssertEqual(
      request.credentialQueries,
      [PresentationCredentialQueriesDomain(queryIdsByDocumentId: ["pid-1": ["pid"]])]
    )
  }
}

private extension TestRemoteSessionCoordinator {

  /// Records every answer the session is asked to send: true for a response, false for a decline.
  final class RecordingAnswers: Sendable {

    private let recorded = OSAllocatedUnfairLock<[Bool]>(initialState: [])

    var sent: [Bool] {
      recorded.withLock { $0 }
    }

    func record(_ userAccepted: Bool) {
      recorded.withLock { $0.append(userAccepted) }
    }
  }

  /// A response with nothing in it, enough for the coordinator to hand to the session.
  struct StubResponse: RequestItemConvertible {
    let items: RequestConvertibleItems = [:]
  }

  /// The failure the stub session throws for a response.
  struct SendFailure: Error {}
}
