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
import XCTest
import logic_business
@testable import feature_login
@testable import logic_test
@testable import feature_test

final class TestFAQsInteractor: EudiTest {
  
  var interactor: FAQsInteractor!
  
  override func setUp() {
    self.interactor = FAQsInteractorImpl()
  }
  
  override func tearDown() {
    self.interactor = nil
  }
  
  func testFetchFAQs_WhenRetrievalIsSuccessful_ThenReturnSuccessPartialState() async {
    // Given
    let expectedList = FAQUIModel.mocks()
    // When
    let state = await interactor.fetchFAQs()
    // Then
    switch state {
    case .success(let faqs):
      XCTAssertEqual(faqs, expectedList)
    default:
      XCTFail("Wrong state \(state)")
    }
  }
}
