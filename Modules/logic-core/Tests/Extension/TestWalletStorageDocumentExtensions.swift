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

final class TestWalletStorageDocumentExtensions: EudiTest {

  func testTransformToDeferredDecodable_WhenTheDocumentIsDeferred_ThenItKeepsItsDocType() {
    // Given
    let document = deferredDocument(docType: DocumentTypeIdentifier.mDocPid.rawValue)

    // When
    let deferred = document.transformToDeferredDecodable()

    // Then
    XCTAssertEqual(deferred.docType, DocumentTypeIdentifier.mDocPid.rawValue)
    XCTAssertEqual(deferred.documentTypeIdentifier, .mDocPid)
  }
}

private extension TestWalletStorageDocumentExtensions {

  func deferredDocument(docType: String) -> WalletStorage.Document {
    WalletStorage.Document(
      docType: docType,
      docDataFormat: .cbor,
      data: Data(),
      docKeyInfo: nil,
      createdAt: nil,
      metadata: nil,
      displayName: nil,
      status: .deferred
    )
  }
}
