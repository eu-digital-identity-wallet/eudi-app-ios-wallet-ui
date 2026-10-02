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
import MdocDataModel18013
@testable import logic_business
@testable import logic_test

final class TestRQESConfig: EudiTest {
  private actor RecordingTransactionLogger: TransactionLogger {
    func log(transaction: TransactionEntry) async throws {}
  }

  func testTransactionLogger_WhenProvidedToConfigLogic_ThenReachesTheRqesConfig() {
    // Given
    let logger = RecordingTransactionLogger()
    let configLogic = ConfigLogicImpl(transactionLogger: logger)

    // When
    let rqesConfig = configLogic.rqesConfig

    // Then
    XCTAssertTrue(rqesConfig.transactionLogger === logger)
  }

  func testTransactionLogger_WhenNotProvided_ThenRqesConfigHasNone() {
    // Given
    let configLogic = ConfigLogicImpl()

    // Then
    XCTAssertNil(configLogic.rqesConfig.transactionLogger)
  }

  func testRssps_WhenBuilt_ThenSigningServiceHasAName() {
    // Given
    let config = RQESConfig(buildVariant: .DEV, buildType: .DEBUG)

    // Then
    XCTAssertEqual(config.rssps.first?.name, "Wallet-Centric")
    XCTAssertTrue(config.printLogs)
  }
}
