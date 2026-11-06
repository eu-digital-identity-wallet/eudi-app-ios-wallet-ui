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
    let holder = SessionCoordinatorHolderImpl()
    let coordinator = MockProximitySessionCoordinator(session: PresentationSession.fixture)
    stub(coordinator) { mock in
      when(mock.stopPresentation()).thenDoNothing()
    }
    await holder.setActiveProximityCoordinator(coordinator)

    await holder.clear()

    verify(coordinator).stopPresentation()
  }

  func testClear_WhenAProximitySessionIsStopped_ThenItIsKeptUntilTheNextOneStarts() async {
    let holder = SessionCoordinatorHolderImpl()
    var coordinator: MockProximitySessionCoordinator? = MockProximitySessionCoordinator(session: PresentationSession.fixture)
    weak let stopped = coordinator
    stub(coordinator!) { mock in
      when(mock.stopPresentation()).thenDoNothing()
    }
    await holder.setActiveProximityCoordinator(coordinator!)
    await holder.clear()
    coordinator = nil

    XCTAssertNotNil(stopped)

    await holder.setActiveProximityCoordinator(MockProximitySessionCoordinator(session: PresentationSession.fixture))

    XCTAssertNil(stopped)
  }

  func testClear_WhenCalledAgainAfterAStop_ThenTheStoppedSessionIsStillKept() async {
    let holder = SessionCoordinatorHolderImpl()
    var coordinator: MockProximitySessionCoordinator? = MockProximitySessionCoordinator(session: PresentationSession.fixture)
    weak let stopped = coordinator
    stub(coordinator!) { mock in
      when(mock.stopPresentation()).thenDoNothing()
    }
    await holder.setActiveProximityCoordinator(coordinator!)
    await holder.clear()
    coordinator = nil

    await holder.clear()

    XCTAssertNotNil(stopped)
  }

  func testClearRemoteCoordinator_WhenABluetoothSessionStartedMeanwhile_ThenItKeepsRunning() async {
    let holder = SessionCoordinatorHolderImpl()
    let remote = MockRemoteSessionCoordinator(session: PresentationSession.fixture)
    let proximity = MockProximitySessionCoordinator(session: PresentationSession.fixture)
    stub(proximity) { mock in
      when(mock.stopPresentation()).thenDoNothing()
    }
    await holder.setActiveRemoteCoordinator(remote)
    await holder.clear()
    await holder.setActiveProximityCoordinator(proximity)

    await holder.clearRemoteCoordinator(remote)

    verify(proximity, never()).stopPresentation()
  }

  func testClearRemoteCoordinator_WhenItIsTheActiveSession_ThenItIsLetGo() async {
    let holder = SessionCoordinatorHolderImpl()
    var remote: MockRemoteSessionCoordinator? = MockRemoteSessionCoordinator(session: PresentationSession.fixture)
    weak let released = remote
    await holder.setActiveRemoteCoordinator(remote!)

    await holder.clearRemoteCoordinator(remote!)
    remote = nil

    XCTAssertNil(released)
  }

  func testClearRemoteCoordinator_WhenAnotherSessionIsActive_ThenTheActiveOneIsKept() async {
    let holder = SessionCoordinatorHolderImpl()
    var active: MockRemoteSessionCoordinator? = MockRemoteSessionCoordinator(session: PresentationSession.fixture)
    weak let kept = active
    await holder.setActiveRemoteCoordinator(active!)

    await holder.clearRemoteCoordinator(MockRemoteSessionCoordinator(session: PresentationSession.fixture))
    active = nil

    XCTAssertNotNil(kept)
  }

  func testClearProximityCoordinator_WhenItIsTheActiveSession_ThenItIsStoppedAndKeptUntilTheNextOneStarts() async {
    let holder = SessionCoordinatorHolderImpl()
    var coordinator: MockProximitySessionCoordinator? = MockProximitySessionCoordinator(session: PresentationSession.fixture)
    weak let stopped = coordinator
    stub(coordinator!) { mock in
      when(mock.stopPresentation()).thenDoNothing()
    }
    await holder.setActiveProximityCoordinator(coordinator!)

    await holder.clearProximityCoordinator(coordinator!)

    verify(coordinator!).stopPresentation()
    coordinator = nil
    XCTAssertNotNil(stopped)

    await holder.setActiveProximityCoordinator(MockProximitySessionCoordinator(session: PresentationSession.fixture))

    XCTAssertNil(stopped)
  }

  func testClearProximityCoordinator_WhenAnotherSessionIsActive_ThenTheActiveOneKeepsRunning() async {
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

    await holder.clearProximityCoordinator(earlier)

    verify(active, never()).stopPresentation()
  }

  func testClearProximityCoordinator_WhenARemoteSessionIsActive_ThenItIsKept() async {
    let holder = SessionCoordinatorHolderImpl()
    var remote: MockRemoteSessionCoordinator? = MockRemoteSessionCoordinator(session: PresentationSession.fixture)
    weak let kept = remote
    let proximity = MockProximitySessionCoordinator(session: PresentationSession.fixture)
    stub(proximity) { mock in
      when(mock.stopPresentation()).thenDoNothing()
    }
    await holder.setActiveRemoteCoordinator(remote!)
    await holder.setActiveProximityCoordinator(proximity)

    await holder.clearProximityCoordinator(proximity)
    remote = nil

    XCTAssertNotNil(kept)
  }
}
