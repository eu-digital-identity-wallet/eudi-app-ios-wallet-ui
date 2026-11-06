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
import Foundation
import SDWebImageSwiftUI

/// The download behind `RemoteImageView`, as the Android wallet's image client: it stops a response once it
/// exceeds `RemoteImagePolicy.maxImageByteCount`, whether its size is declared or not, and follows a redirect
/// only within the image's origin and over `https` (`RemoteImagePolicy`).
///
/// SDWebImage changes a download only through its operation class, and Foundation declares `Operation`
/// `@unchecked Sendable`, which Swift 6 makes every subclass restate. This one adds no stored state.
final class RemoteImageDownloadOperation: SDWebImageDownloaderOperation, @unchecked Sendable {

  override func addHandlers(
    forProgress progressBlock: SDWebImageDownloaderProgressBlock?,
    completed completedBlock: SDWebImageDownloaderCompletedBlock?,
    decodeOptions: [SDImageCoderOption: Any]?
  ) -> Any? {
    super.addHandlers(
      forProgress: { [weak self] receivedSize, expectedSize, url in
        guard RemoteImagePolicy.isWithinLimit(receivedByteCount: receivedSize, expectedByteCount: expectedSize) else {
          self?.dataTask?.cancel()
          return
        }
        progressBlock?(receivedSize, expectedSize, url)
      },
      completed: completedBlock,
      decodeOptions: decodeOptions
    )
  }

  override func urlSession(
    _ session: URLSession,
    task: URLSessionTask,
    willPerformHTTPRedirection response: HTTPURLResponse,
    newRequest request: URLRequest,
    completionHandler: @escaping @Sendable (URLRequest?) -> Void
  ) {
    completionHandler(
      RemoteImagePolicy.followsRedirect(from: task.originalRequest?.url, to: request.url) ? request : nil
    )
  }
}
