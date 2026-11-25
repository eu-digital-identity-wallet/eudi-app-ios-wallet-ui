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
@testable import logic_test

final class TestSessionCoordinatorHolderClear: EudiTest {

  func testClear_WhenAProximitySessionIsHeld_ThenItIsStoppedBeforeItIsLetGo() async {
    // Given
    let holder = SessionCoordinatorHolderImpl()
    let coordinator = MockProximitySessionCoordinator(session: PresentationSession.fixture)
    stub(coordinator) { mock in
      when(mock.stopPresentation()).thenDoNothing()
    }
    await holder.setActiveProximityCoordinator(coordinator)

    // When
    await holder.clear()

    // Then
    verify(coordinator).stopPresentation()
  }

  func testClear_WhenAProximitySessionIsStopped_ThenItIsKeptUntilTheNextOneStarts() async {
    // Given
    let holder = SessionCoordinatorHolderImpl()
    var coordinator: MockProximitySessionCoordinator? = MockProximitySessionCoordinator(session: PresentationSession.fixture)
    weak let stopped = coordinator
    stub(coordinator!) { mock in
      when(mock.stopPresentation()).thenDoNothing()
    }
    await holder.setActiveProximityCoordinator(coordinator!)

    // When
    await holder.clear()
    coordinator = nil

    // Then
    XCTAssertNotNil(stopped)

    // When
    await holder.setActiveProximityCoordinator(MockProximitySessionCoordinator(session: PresentationSession.fixture))

    // Then
    XCTAssertNil(stopped)
  }

  func testClear_WhenCalledAgainAfterAStop_ThenTheStoppedSessionIsStillKept() async {
    // Given
    let holder = SessionCoordinatorHolderImpl()
    var coordinator: MockProximitySessionCoordinator? = MockProximitySessionCoordinator(session: PresentationSession.fixture)
    weak let stopped = coordinator
    stub(coordinator!) { mock in
      when(mock.stopPresentation()).thenDoNothing()
    }
    await holder.setActiveProximityCoordinator(coordinator!)
    await holder.clear()
    coordinator = nil

    // When
    await holder.clear()

    // Then
    XCTAssertNotNil(stopped)
  }

  func testClearRemoteCoordinator_WhenABluetoothSessionStartedMeanwhile_ThenItKeepsRunning() async {
    // Given
    let holder = SessionCoordinatorHolderImpl()
    let remote = MockRemoteSessionCoordinator(session: PresentationSession.fixture)
    let proximity = MockProximitySessionCoordinator(session: PresentationSession.fixture)
    stub(proximity) { mock in
      when(mock.stopPresentation()).thenDoNothing()
    }
    await holder.setActiveRemoteCoordinator(remote)
    await holder.clear()
    await holder.setActiveProximityCoordinator(proximity)

    // When
    await holder.clearRemoteCoordinator(remote)

    // Then
    verify(proximity, never()).stopPresentation()
  }

  func testClearRemoteCoordinator_WhenItIsTheActiveSession_ThenItIsLetGo() async {
    // Given
    let holder = SessionCoordinatorHolderImpl()
    var remote: MockRemoteSessionCoordinator? = MockRemoteSessionCoordinator(session: PresentationSession.fixture)
    weak let released = remote
    await holder.setActiveRemoteCoordinator(remote!)

    // When
    await holder.clearRemoteCoordinator(remote!)
    remote = nil

    // Then
    XCTAssertNil(released)
  }

  func testClearRemoteCoordinator_WhenAnotherSessionIsActive_ThenTheActiveOneIsKept() async {
    // Given
    let holder = SessionCoordinatorHolderImpl()
    var active: MockRemoteSessionCoordinator? = MockRemoteSessionCoordinator(session: PresentationSession.fixture)
    weak let kept = active
    await holder.setActiveRemoteCoordinator(active!)

    // When
    await holder.clearRemoteCoordinator(MockRemoteSessionCoordinator(session: PresentationSession.fixture))
    active = nil

    // Then
    XCTAssertNotNil(kept)
  }

  func testClearProximityCoordinator_WhenItIsTheActiveSession_ThenItIsStoppedAndKeptUntilTheNextOneStarts() async {
    // Given
    let holder = SessionCoordinatorHolderImpl()
    var coordinator: MockProximitySessionCoordinator? = MockProximitySessionCoordinator(session: PresentationSession.fixture)
    weak let stopped = coordinator
    stub(coordinator!) { mock in
      when(mock.stopPresentation()).thenDoNothing()
    }
    await holder.setActiveProximityCoordinator(coordinator!)

    // When
    await holder.clearProximityCoordinator(coordinator!)

    // Then
    verify(coordinator!).stopPresentation()
    coordinator = nil
    XCTAssertNotNil(stopped)

    // When
    await holder.setActiveProximityCoordinator(MockProximitySessionCoordinator(session: PresentationSession.fixture))

    // Then
    XCTAssertNil(stopped)
  }

  func testClearProximityCoordinator_WhenAnotherSessionIsActive_ThenTheActiveOneKeepsRunning() async {
    // Given
    let holder = SessionCoordinatorHolderImpl()
    let active = MockProximitySessionCoordinator(session: PresentationSession.fixture)
    let earlier = MockProximitySessionCoordinator(session: PresentationSession.fixture)
    stub(active) { mock in
      when(mock.stopPresentation()).thenDoNothing()
    }
    stub(earlier) { mock in
      when(mock.stopPresentation()).thenDoNothing()
    }
    await holder.setActiveProximityCoordinator(active)

    // When
    await holder.clearProximityCoordinator(earlier)

    // Then
    verify(active, never()).stopPresentation()
  }

  func testClearProximityCoordinator_WhenARemoteSessionIsActive_ThenItIsKept() async {
    // Given
    let holder = SessionCoordinatorHolderImpl()
    var remote: MockRemoteSessionCoordinator? = MockRemoteSessionCoordinator(session: PresentationSession.fixture)
    weak let kept = remote
    let proximity = MockProximitySessionCoordinator(session: PresentationSession.fixture)
    stub(proximity) { mock in
      when(mock.stopPresentation()).thenDoNothing()
    }
    await holder.setActiveRemoteCoordinator(remote!)
    await holder.setActiveProximityCoordinator(proximity)

    // When
    await holder.clearProximityCoordinator(proximity)
    remote = nil

    // Then
    XCTAssertNotNil(kept)
  }
}
