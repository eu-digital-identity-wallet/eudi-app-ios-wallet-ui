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
import SDWebImageSwiftUI
@testable import logic_ui
@testable import logic_test

final class TestRemoteImageDownloadOperation: EudiTest {

  private let logo = URL(string: "https://issuer.example/logo.png")!

  func testRedirect_WhenItLeavesTheOrigin_ThenIsNotFollowed() {
    assertRedirect(to: "https://elsewhere.example/logo.png", isFollowed: false)
    assertRedirect(to: "http://issuer.example/logo.png", isFollowed: false)
  }

  func testRedirect_WhenItStaysOnTheOrigin_ThenIsFollowed() {
    assertRedirect(to: "https://issuer.example/other.png", isFollowed: true)
  }

  func testRedirect_WhenTheSessionAsks_ThenTheOperationAnswers() {
    XCTAssertTrue(
      RemoteImageDownloadOperation.instancesRespond(
        to: #selector(URLSessionTaskDelegate.urlSession(_:task:willPerformHTTPRedirection:newRequest:completionHandler:))
      )
    )
  }

  func testProgress_WhenTheDataExceedsTheLimit_ThenTheDownloadStops() {
    let reported = expectation(description: "progress")
    reported.isInverted = true
    receive(byteCount: RemoteImagePolicy.maxImageByteCount + 1) { reported.fulfill() }
    wait(for: [reported], timeout: 0.2)
  }

  func testProgress_WhenTheDataIsWithinTheLimit_ThenItIsReported() {
    let reported = expectation(description: "progress")
    receive(byteCount: 1) { reported.fulfill() }
    wait(for: [reported], timeout: 1)
  }

  func testDownload_WhenTheDeclaredSizeExceedsTheLimit_ThenTheTaskIsCancelled() throws {
    let body = Data(count: RemoteImagePolicy.maxImageByteCount + 1).base64EncodedString()
    let image = try XCTUnwrap(URL(string: "data:application/octet-stream;base64,\(body)"))
    let operation = RemoteImageDownloadOperation(request: URLRequest(url: image), in: nil, options: [])
    let failure = OSAllocatedUnfairLock<URLError.Code?>(initialState: nil)
    let completed = expectation(description: "completed")
    _ = operation.addHandlers(forProgress: nil) { _, _, error, _ in
      failure.withLock { $0 = (error as? URLError)?.code }
      completed.fulfill()
    }

    operation.start()

    wait(for: [completed], timeout: 5)
    XCTAssertEqual(failure.withLock { $0 }, .cancelled)
  }
}

private extension TestRemoteImageDownloadOperation {

  func assertRedirect(to address: String, isFollowed: Bool, line: UInt = #line) {
    let operation = RemoteImageDownloadOperation(request: URLRequest(url: logo), in: nil, options: [])
    let redirect = URLRequest(url: URL(string: address)!)
    let answered = expectation(description: address)
    operation.urlSession(
      URLSession.shared,
      task: URLSession.shared.dataTask(with: logo),
      willPerformHTTPRedirection: HTTPURLResponse(url: logo, statusCode: 302, httpVersion: nil, headerFields: nil)!,
      newRequest: redirect
    ) { followed in
      XCTAssertEqual(followed, isFollowed ? redirect : nil, address, line: line)
      answered.fulfill()
    }
    wait(for: [answered], timeout: 1)
  }

  func receive(byteCount: Int, onProgress: @escaping () -> Void) {
    let operation = RemoteImageDownloadOperation(request: URLRequest(url: logo), in: nil, options: [])
    _ = operation.addHandlers(forProgress: { _, _, _ in onProgress() }, completed: nil)
    (operation as URLSessionDataDelegate).urlSession?(
      URLSession.shared,
      dataTask: URLSession.shared.dataTask(with: logo),
      didReceive: Data(count: byteCount)
    )
  }
}
