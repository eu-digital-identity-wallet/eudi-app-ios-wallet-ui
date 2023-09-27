/*
 * Copyright (c) 2023 European Commission
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import Foundation
import XCTest
import Cuckoo

@testable import feature_startup
@testable import logic_api

class BaseTests: XCTestCase {

  override func setUp() async throws {
    try await super.setUp()
  }

  override func tearDown() {
    super.tearDown()
  }

  func test() async {
    
    let mockedDto: SampleResponseDTO = .init()
    let mock = MockStartupInteractorType()
    
    stub(mock) { stub in
      when(stub.sampleCall()).thenReturn(.success(mockedDto))
    }
    
    let response = await mock.sampleCall()
    
    switch response {
    case .success(let dto):
      XCTAssertEqual(dto, mockedDto)
    case .failure(let error):
      XCTFail(error.localizedDescription)
    }
    
  }
  
  func testBusinessLogic() {

    let mock = MockConfigLogic()

    stub(mock) { stub in
      when(stub.baseHost.get).thenReturn("test.com")
    }

    XCTAssertEqual(mock.baseHost, "test.com")

    XCTAssertTrue(true, "test!")
  }
}
