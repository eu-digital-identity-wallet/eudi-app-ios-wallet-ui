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
@testable import logic_core
@testable import logic_test

final class TestSerialCheckRunner: EudiTest {

  func testRun_WhenCalledDuringACheck_ThenTheCheckRunsOnceMoreAndNeverTwiceAtOnce() async {
    let runner = SerialCheckRunner()
    let log = RecordingCheckLog()
    let firstStarted = expectation(description: "first check started")
    let gate = AsyncGate()

    let first = Task {
      await runner.run {
        let count = await log.begin()
        if count == 1 {
          firstStarted.fulfill()
          await gate.wait()
        }
        await log.end()
      }
    }
    await fulfillment(of: [firstStarted], timeout: 5)

    await runner.run { XCTFail("a second check must not start beside the first") }
    await gate.open()
    await first.value

    let runs = await log.runs
    let maxAtOnce = await log.maxAtOnce
    XCTAssertEqual(runs, 2)
    XCTAssertEqual(maxAtOnce, 1)
  }

  func testRun_WhenNothingRuns_ThenTheCheckRunsOnce() async {
    let runner = SerialCheckRunner()
    let log = RecordingCheckLog()

    await runner.run {
      _ = await log.begin()
      await log.end()
    }

    let runs = await log.runs
    XCTAssertEqual(runs, 1)
  }

  func testWaitUntilIdle_WhenACheckRuns_ThenReturnsOnceItEnds() async {
    let runner = SerialCheckRunner()
    let gate = AsyncGate()
    let log = RecordingCheckLog()
    let started = expectation(description: "check started")

    Task {
      await runner.run {
        _ = await log.begin()
        started.fulfill()
        await gate.wait()
        await log.end()
      }
    }
    await fulfillment(of: [started], timeout: 5)
    let idle = expectation(description: "idle")
    let returnedEarly = expectation(description: "returned before the check ended")
    returnedEarly.isInverted = true
    Task {
      await runner.waitUntilIdle()
      returnedEarly.fulfill()
      idle.fulfill()
    }
    await fulfillment(of: [returnedEarly], timeout: 0.3)
    await gate.open()

    await fulfillment(of: [idle], timeout: 5)
    let runs = await log.runs
    XCTAssertEqual(runs, 1)
  }

  func testWaitUntilIdle_WhenNothingRuns_ThenReturnsAtOnce() async {
    await SerialCheckRunner().waitUntilIdle()
  }
}

private actor RecordingCheckLog {
  private(set) var runs = 0
  private(set) var maxAtOnce = 0
  private var atOnce = 0

  func begin() -> Int {
    runs += 1
    atOnce += 1
    maxAtOnce = max(maxAtOnce, atOnce)
    return runs
  }

  func end() {
    atOnce -= 1
  }
}
