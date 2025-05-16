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
import logic_authentication
@testable import feature_common
@testable import logic_test
@testable import feature_test

final class TestScannerInteractor: EudiTest {
  var interactor: ScannerInteractor!
  var formValidator: MockFormValidator!
  var walletKitController: MockWalletKitController!

  override func setUp() {
    self.formValidator = MockFormValidator()
    self.walletKitController = MockWalletKitController()
    self.interactor = ScannerInteractorImpl(
      formValidator: formValidator,
      walletKitController: walletKitController
    )
  }

  override func tearDown() {
    self.formValidator = nil
    self.walletKitController = nil
    self.interactor = nil
  }

  func testValidateForm_WhenValidateForm_ThenReturnsSuccess() async {
    // Given
    let form = ValidatableForm(inputs: [:])
    let expected: FormValidationResult = .init(isValid: true, message: "message")

    stub(formValidator) { stub in
      when(stub.validateForm(form: any()))
        .thenReturn(expected)
    }

    // When
    let result = await interactor.validateForm(form: form)

    //Then
    XCTAssertEqual(result, expected)
    verify(formValidator).validateForm(form: any())
  }

  func testValidateForms_WhenValidateForm_ThenReturnsSuccess() async {
    // Given
    let form = ValidatableForm(inputs: [:])
    let expected: FormsValidationResult = .init(isValid: true, messages: ["messages"])

    stub(formValidator) { stub in
      when(stub.validateForms(forms: any()))
        .thenReturn(expected)
    }

    // When
    let result = await interactor.validateForms(forms: [form])

    //Then
    XCTAssertEqual(result, expected)
    verify(formValidator).validateForms(forms: any())
  }

  func testStartCrossDevicePresentation_WhenStartCrossDevicePresentation_ThenReturnSuccess() async {
    // Given
    let scanResult = "https://example.com/session"
    let coordinator = MockRemoteSessionCoordinator(
      session: Constants.mockPresentationSession
    )
    stub(walletKitController) { stub in
      when(stub.startCrossDevicePresentation(urlString: equal(to: scanResult)))
        .thenReturn(coordinator)
    }

    // When
    let _ = await interactor.startCrossDevicePresentation(scanResult: scanResult)

    // Then
    verify(walletKitController).startCrossDevicePresentation(urlString: equal(to: scanResult))
  }
}
