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
import ImageIO
import UIKit

/// Limits for decoding an image a credential or an issuer supplies; Android's values.
public enum ImageDecodeLimits {

  public static let maxPixelCount = 40_000_000
  public static let maxDimension = 2_048

  /// True when an image of `width` by `height` pixels may be decoded.
  public static func isWithinLimit(width: Int, height: Int) -> Bool {
    width > 0 && height > 0 && width <= maxPixelCount / height
  }

  /// Decodes `data` within the limits, reading its size first; nil when it is not an image or is too large.
  public static func decode(_ data: Data) -> UIImage? {
    guard
      let source = CGImageSourceCreateWithData(data as CFData, nil),
      let properties = CGImageSourceCopyPropertiesAtIndex(source, 0, nil) as? [CFString: Any],
      let width = properties[kCGImagePropertyPixelWidth] as? Int,
      let height = properties[kCGImagePropertyPixelHeight] as? Int,
      isWithinLimit(width: width, height: height)
    else {
      return nil
    }
    let options: [CFString: Any] = [
      kCGImageSourceCreateThumbnailFromImageAlways: true,
      kCGImageSourceCreateThumbnailWithTransform: true,
      kCGImageSourceThumbnailMaxPixelSize: min(max(width, height), maxDimension)
    ]
    guard let image = CGImageSourceCreateThumbnailAtIndex(source, 0, options as CFDictionary) else { return nil }
    return UIImage(cgImage: image)
  }
}
