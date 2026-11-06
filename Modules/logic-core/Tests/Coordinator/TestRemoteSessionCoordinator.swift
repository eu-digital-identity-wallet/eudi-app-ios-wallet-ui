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
@testable import logic_core
@testable import logic_test

final class TestRemoteSessionCoordinator: EudiTest {

  func testDeclineResponse_WhenTheWalletHasNotAnswered_ThenDeclinesOnce() async throws {
    let answers = RecordingAnswers()
    let coordinator = RemoteSessionCoordinatorImpl(session: .answeringFixture { answers.record($0) })

    try await coordinator.declineResponse()
    try await coordinator.declineResponse()

    XCTAssertEqual(answers.sent, [false])
  }

  func testDeclineResponse_WhenTheResponseFailed_ThenSendsNoSecondAnswer() async throws {
    let answers = RecordingAnswers()
    let coordinator = RemoteSessionCoordinatorImpl(
      session: .answeringFixture { userAccepted in
        answers.record(userAccepted)
        guard !userAccepted else { throw SendFailure() }
      }
    )

    do {
      try await coordinator.sendResponse(response: StubResponse())
      XCTFail("The response was expected to fail")
    } catch {
      XCTAssertTrue(error is SendFailure)
    }
    try await coordinator.declineResponse()

    XCTAssertEqual(answers.sent, [true])
  }

  func testDeclineResponse_WhenTheResponseWasSent_ThenSendsNoSecondAnswer() async throws {
    let answers = RecordingAnswers()
    let coordinator = RemoteSessionCoordinatorImpl(session: .answeringFixture { answers.record($0) })

    try await coordinator.sendResponse(response: StubResponse())
    try await coordinator.declineResponse()

    XCTAssertEqual(answers.sent, [true])
  }

  func testSendResponse_WhenSharedAgainAfterAFailure_ThenSendsTheResponseAgain() async throws {
    let answers = RecordingAnswers()
    let coordinator = RemoteSessionCoordinatorImpl(
      session: .answeringFixture { userAccepted in
        answers.record(userAccepted)
        guard answers.sent.count > 1 else { throw SendFailure() }
      }
    )

    try? await coordinator.sendResponse(response: StubResponse())
    try await coordinator.sendResponse(response: StubResponse())

    XCTAssertEqual(answers.sent, [true, true])
  }

  func testDeclineResponse_WhenTwoDeclinesOverlap_ThenDeclinesOnce() async throws {
    let answers = RecordingAnswers()
    let coordinator = RemoteSessionCoordinatorImpl(session: .answeringFixture { answers.record($0) })

    async let first: Void = coordinator.declineResponse()
    async let second: Void = coordinator.declineResponse()
    _ = try await (first, second)

    XCTAssertEqual(answers.sent, [false])
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
