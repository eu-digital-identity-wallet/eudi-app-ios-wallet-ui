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
import SDWebImageSwiftUI
@testable import logic_ui
@testable import logic_test

final class TestRemoteImageView: EudiTest {

  private let logo = URL(string: "https://issuer.example/logo.png")!

  @MainActor
  func testLoadingContext_WhenTheImageIsHttps_ThenLoadsThroughTheBoundedOperation() {
    let context = RemoteImageView.loadingContext(for: logo)
    let downloader = context?[.imageLoader] as? SDWebImageDownloader
    XCTAssertTrue(downloader?.config.operationClass == RemoteImageDownloadOperation.self)
    XCTAssertEqual(context?[.imageScaleDownLimitBytes] as? UInt, RemoteImagePolicy.maxDecodedByteCount)
  }

  @MainActor
  func testLoadingContext_WhenTheImageIsNotHttps_ThenIsNil() {
    XCTAssertNil(RemoteImageView.loadingContext(for: URL(string: "http://issuer.example/logo.png")))
  }
}
