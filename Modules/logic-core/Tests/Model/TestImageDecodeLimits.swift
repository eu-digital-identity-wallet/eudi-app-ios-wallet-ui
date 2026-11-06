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
import UIKit
import Compression
@testable import logic_core
@testable import logic_test

final class TestImageDecodeLimits: EudiTest {

  func testIsWithinLimit_WhenTheImageHasMoreThanFortyMegapixels_ThenIsNotDecoded() {
    XCTAssertFalse(ImageDecodeLimits.isWithinLimit(width: 8_000, height: 6_000))
    XCTAssertFalse(ImageDecodeLimits.isWithinLimit(width: 0, height: 10))
    XCTAssertTrue(ImageDecodeLimits.isWithinLimit(width: 4_000, height: 3_000))
  }

  func testDecode_WhenASideIsLargerThanTheLimit_ThenScalesItDown() throws {
    let data = try XCTUnwrap(pngData(width: 4_096, height: 16))

    let image = try XCTUnwrap(ImageDecodeLimits.decode(data))

    XCTAssertLessThanOrEqual(Int(image.size.width * image.scale), ImageDecodeLimits.maxDimension)
  }

  func testDecode_WhenTheImageHasMoreThanFortyMegapixels_ThenDecodesNothing() throws {
    let data = try XCTUnwrap(blackPng(width: 6_400, height: 6_400))

    XCTAssertNil(ImageDecodeLimits.decode(data))
    XCTAssertNotNil(ImageDecodeLimits.decode(try XCTUnwrap(blackPng(width: 6_000, height: 6_000))))
  }

  func testDecode_WhenTheDataIsNotAnImage_ThenDecodesNothing() {
    XCTAssertNil(ImageDecodeLimits.decode(Data([0x00, 0x01, 0x02])))
  }
}

private extension TestImageDecodeLimits {

  func pngData(width: Int, height: Int) -> Data? {
    let format = UIGraphicsImageRendererFormat()
    format.scale = 1
    return UIGraphicsImageRenderer(size: CGSize(width: width, height: height), format: format).pngData { context in
      UIColor.gray.setFill()
      context.fill(CGRect(x: 0, y: 0, width: width, height: height))
    }
  }

  /// A valid 1-bit greyscale PNG of `width` by `height` black pixels, a few kilobytes once compressed.
  func blackPng(width: Int, height: Int) -> Data? {
    let raw = Data(count: (1 + (width + 7) / 8) * height)
    guard let deflated = raw.deflated else { return nil }
    let header = UInt32(width).bigEndianBytes + UInt32(height).bigEndianBytes + Data([1, 0, 0, 0, 0])
    return Data([0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A])
      + chunk("IHDR", header)
      + chunk("IDAT", Data([0x78, 0x01]) + deflated + raw.adler32.bigEndianBytes)
      + chunk("IEND", Data())
  }

  func chunk(_ type: String, _ content: Data) -> Data {
    let typedContent = Data(type.utf8) + content
    return UInt32(content.count).bigEndianBytes + typedContent + typedContent.crc32.bigEndianBytes
  }
}

private extension Data {

  var deflated: Data? {
    var output = Data(count: count + 1_024)
    let size = output.withUnsafeMutableBytes { destination in
      withUnsafeBytes { source in
        compression_encode_buffer(
          destination.bindMemory(to: UInt8.self).baseAddress!,
          destination.count,
          source.bindMemory(to: UInt8.self).baseAddress!,
          source.count,
          nil,
          COMPRESSION_ZLIB
        )
      }
    }
    return size > 0 ? output.prefix(size) : nil
  }

  var adler32: UInt32 {
    var low: UInt32 = 1
    var high: UInt32 = 0
    for byte in self {
      low = (low + UInt32(byte)) % 65_521
      high = (high + low) % 65_521
    }
    return high << 16 | low
  }

  var crc32: UInt32 {
    var crc = UInt32.max
    for byte in self {
      crc ^= UInt32(byte)
      for _ in 0..<8 {
        if crc & 1 == 1 {
          crc = (crc >> 1) ^ 0xEDB8_8320
        } else {
          crc >>= 1
        }
      }
    }
    return ~crc
  }
}

private extension UInt32 {

  var bigEndianBytes: Data {
    withUnsafeBytes(of: bigEndian) { Data($0) }
  }
}
