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
import logic_business

/// What `RemoteImageView` loads, as the Android wallet's image client: `https` only, within the origin of the image
/// first requested, and no more than `maxImageByteCount`, whether the response declares its size or not.
public enum RemoteImagePolicy {

  /// The largest image the wallet downloads, Android's limit for a logo.
  public static let maxImageByteCount = 2 * 1024 * 1024
  /// The decoded size above which an image is scaled down while it is decoded.
  public static let maxDecodedByteCount: UInt = 16 * 1024 * 1024

  /// The image's address if the wallet may load it: `https` with a host only, as on Android, whatever passed it.
  public static func loadableUrl(_ url: URL?) -> URL? {
    url?.httpsWebLink
  }

  /// True for a redirect to follow: `https`, on the origin of the image first requested.
  public static func followsRedirect(from requestedUrl: URL?, to redirectUrl: URL?) -> Bool {
    guard let requestedUrl, let redirectUrl else { return false }
    return redirectUrl.isHttpsWebLink && redirectUrl.hasSameOrigin(as: requestedUrl)
  }

  /// True while a download stays within `maxImageByteCount`: neither the bytes received so far nor the size the
  /// response declares exceed it.
  public static func isWithinLimit(receivedByteCount: Int, expectedByteCount: Int) -> Bool {
    receivedByteCount <= maxImageByteCount && expectedByteCount <= maxImageByteCount
  }
}
