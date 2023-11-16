/*
 * Copyright (c) 2023 European Commission
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

@testable import feature_startup
@testable import logic_api
@testable import logic_test
@testable import feature_test

final class BaseTests: EudiTest {

  override func setUp() async throws {
    try await super.setUp()
  }

  override func tearDown() {
    super.tearDown()
  }

  func testBusinessLogic() {

    let mock = MockConfigLogic()

    stub(mock) { stub in
      when(stub.baseHost.get).thenReturn(SampleConstants.urlMock)
    }

    XCTAssertEqual(mock.baseHost, SampleConstants.urlMock)

    XCTAssertTrue(true, SampleConstants.urlMock)
  }
}
