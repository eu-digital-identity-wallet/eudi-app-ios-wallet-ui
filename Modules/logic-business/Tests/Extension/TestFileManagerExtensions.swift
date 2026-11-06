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
@testable import logic_business
@testable import logic_test

final class TestFileManagerExtensions: EudiTest {

  func testRemoveContents_WhenADirectoryHoldsFilesAndFolders_ThenEmptiesItAndKeepsIt() throws {
    let fileManager = FileManager.default
    let directory = fileManager.temporaryDirectory.appendingPathComponent(UUID().uuidString)
    try fileManager.createDirectory(at: directory, withIntermediateDirectories: true)
    try Data("log".utf8).write(to: directory.appendingPathComponent("wallet.log"))
    try fileManager.createDirectory(at: directory.appendingPathComponent("images"), withIntermediateDirectories: true)

    fileManager.removeContents(of: [directory])

    XCTAssertTrue(fileManager.fileExists(atPath: directory.path))
    XCTAssertEqual(try fileManager.contentsOfDirectory(atPath: directory.path), [])
    try fileManager.removeItem(at: directory)
  }

  func testRemoveContents_WhenADirectoryIsMissing_ThenDoesNothing() {
    let missing = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)

    FileManager.default.removeContents(of: [missing])

    XCTAssertFalse(FileManager.default.fileExists(atPath: missing.path))
  }
}
