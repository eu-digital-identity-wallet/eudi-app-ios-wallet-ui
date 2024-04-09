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
@testable import logic_business
@testable import logic_test

final class TestFormValidator: XCTestCase {
  
  private let plainErrorMessage = "generic_error_description"
  
  private var formValidator : FormValidator!
  
  private var validationError : FormValidationResult!
  private var validationSuccess : FormValidationResult!
  
  override func setUp() {
    formValidator = FormValidatorImpl()
    validationError = FormValidationResult(isValid: false, message: plainErrorMessage)
    validationSuccess = FormValidationResult(isValid: true)
  }
  
  func testValidateNotEmptyRule(){
    let rules = [Rule.ValidateNotEmpty(errorMessage: plainErrorMessage)]
    validateForm(
      rules,
      "",
      validationError
    )
    validateForm(
      rules,
      "test",
      validationSuccess
    )
  }
  
  func testValidateEmailRule(){
    let rules = [Rule.ValidateEmail(errorMessage: plainErrorMessage)]
    validateForm(
      rules,
      "test@test.com",
      validationSuccess
    )
    validateForm(
      rules,
      "test@",
      validationError
    )
  }
  
  func testValidatePhoneNumberRule(){
    let greekPhoneRule = [Rule.ValidatePhoneNumber(countryCode: "GR", errorMessage: plainErrorMessage)]
    let usPhoneRule = [Rule.ValidatePhoneNumber(countryCode: "US", errorMessage: plainErrorMessage)]
    validateForm(
      greekPhoneRule,
      "1111111111",
      validationError
    )
    validateForm(
      greekPhoneRule,
      "15223433333",
      validationError
    )
    validateForm(
      greekPhoneRule,
      "6941111111",
      validationSuccess
    )
    validateForm(
      usPhoneRule,
      "6941111111",
      validationError
    )
    validateForm(
      usPhoneRule,
      "6102458772",
      validationSuccess
    )
  }
  
  func testValidateStringMaxLengthRule(){
    let rules = [Rule.ValidateStringMaxLength(length: 10, errorMessage: plainErrorMessage)]
    validateForm(
      rules,
      "aaaaaaaaaaa",
      validationError
    )
    validateForm(
      rules,
      "aaaaaaaaaaaaaaa",
      validationError
    )
    validateForm(
      rules,
      "aaaaaaaaa",
      validationSuccess
    )
  }
  
  func testValidateStringMinLengthRule(){
    let rules = [Rule.ValidateStringMinLength(length: 5, errorMessage: plainErrorMessage)]
    validateForm(
      rules,
      "aaaa",
      validationError
    )
    validateForm(
      rules,
      "a",
      validationError
    )
    validateForm(
      rules,
      "aaaaa",
      validationSuccess
    )
  }
  
  func testValidateRegexRule(){
    let atLeastOneCapitalLetterRule = [Rule.ValidateRegex(regex: ".*[A-Z].*", errorMessage: plainErrorMessage)]
    let atLeastOneDigitRule = [Rule.ValidateRegex(regex: ".*(\\d).*", errorMessage: plainErrorMessage)]
    let atLeastOneSpecialCharRule = [Rule.ValidateRegex(regex: ".*[^a-zA-Z0-9].*", errorMessage: plainErrorMessage)]
    let onlyLettersNumbersSpaceAndDashesRule = [Rule.ValidateRegex(regex: "^[a-zA-Z0-9-\\s]+$", errorMessage: plainErrorMessage)]
    
    validateForm(
      atLeastOneCapitalLetterRule,
      "test",
      validationError
    )
    validateForm(
      atLeastOneCapitalLetterRule,
      "Test",
      validationSuccess
    )
    validateForm(
      atLeastOneDigitRule,
      "test",
      validationError
    )
    validateForm(
      atLeastOneDigitRule,
      "test1",
      validationSuccess
    )
    validateForm(
      atLeastOneSpecialCharRule,
      "test",
      validationError
    )
    validateForm(
      atLeastOneSpecialCharRule,
      "test1@",
      validationSuccess
    )
    
    validateForm(
      onlyLettersNumbersSpaceAndDashesRule,
      "NL86INGB7482085033",
      validationSuccess
    )
    
    validateForm(
      onlyLettersNumbersSpaceAndDashesRule,
      "CY82947517727631922532755722",
      validationSuccess
    )
    
    validateForm(
      onlyLettersNumbersSpaceAndDashesRule,
      "GB57BARC20040114216837",
      validationSuccess
    )
    
    validateForm(
      onlyLettersNumbersSpaceAndDashesRule,
      "123456789",
      validationSuccess
    )
    
    validateForm(
      onlyLettersNumbersSpaceAndDashesRule,
      "327821737812367126712",
      validationSuccess
    )
    
    validateForm(
      onlyLettersNumbersSpaceAndDashesRule,
      "3278 2173781 23671 26712",
      validationSuccess
    )
    
    validateForm(
      onlyLettersNumbersSpaceAndDashesRule,
      "3278-2173781-23671-26712",
      validationSuccess
    )
    
    validateForm(
      onlyLettersNumbersSpaceAndDashesRule,
      "3278-2173781 23671-26712",
      validationSuccess
    )
    
    validateForm(
      onlyLettersNumbersSpaceAndDashesRule,
      "3278-2173781&23671-26712",
      validationError
    )
    
    validateForm(
      onlyLettersNumbersSpaceAndDashesRule,
      "3278-21£73781£23671-26712",
      validationError
    )
  }
  
  func testValidateStringRangeRule(){
    let rules = [Rule.ValidateStringRange(minLength: 0, maxLength: 10, errorMessage: plainErrorMessage)]
    validateForm(
      rules,
      "aaaaaaaaaaa",
      validationError
    )
    validateForm(
      rules,
      "aaaaaaaaaa",
      validationSuccess
    )
    validateForm(
      rules,
      "",
      validationSuccess
    )
  }
  
  func testValidateStringMatchRule() {
    let isNotCaseSensitiveRule = [Rule.ValidateStringMatch(stringToMatch: "test", errorMessage: plainErrorMessage)]
    let isCaseSensitiveRule = [Rule.ValidateStringMatch(stringToMatch: "test", errorMessage: plainErrorMessage, isCaseSensitive: true)]
    validateForm(
      isNotCaseSensitiveRule,
      "testt",
      validationError
    )
    validateForm(
      isNotCaseSensitiveRule,
      "t!@#$",
      validationError
    )
    validateForm(
      isNotCaseSensitiveRule,
      "",
      validationError
    )
    validateForm(
      isNotCaseSensitiveRule,
      "TEST",
      validationSuccess
    )
    validateForm(
      isCaseSensitiveRule,
      "TEST",
      validationError
    )
    validateForm(
      isCaseSensitiveRule,
      "",
      validationError
    )
    validateForm(
      isCaseSensitiveRule,
      "test",
      validationSuccess
    )
  }
  
  func testValidateStringNotMatchRule() {
    let isNotCaseSensitiveRule = [Rule.ValidateStringNotMatch(stringToMatch: "test", errorMessage: plainErrorMessage)]
    let isCaseSensitiveRule = [Rule.ValidateStringNotMatch(stringToMatch: "test", errorMessage: plainErrorMessage, isCaseSensitive: true)]
    validateForm(
      isNotCaseSensitiveRule,
      "test",
      validationError
    )
    validateForm(
      isNotCaseSensitiveRule,
      "TEST",
      validationError
    )
    validateForm(
      isNotCaseSensitiveRule,
      "",
      validationSuccess
    )
    validateForm(
      isNotCaseSensitiveRule,
      "testt",
      validationSuccess
    )
    validateForm(
      isCaseSensitiveRule,
      "test",
      validationError
    )
    validateForm(
      isCaseSensitiveRule,
      "Testss",
      validationSuccess
    )
    validateForm(
      isCaseSensitiveRule,
      "TEST",
      validationSuccess
    )
    validateForm(
      isCaseSensitiveRule,
      "",
      validationSuccess
    )
  }
  
  func testValidateDuplicateCharacterNotInConsecutiveOrderRule() {
    let maxTimesOfConsecutiveOrder2Rule = [Rule.ValidateDuplicateCharacterNotInConsecutiveOrder(maxTimesOfConsecutiveOrder: 2, errorMessage: plainErrorMessage)]
    let maxTimesOfConsecutiveOrder4Rule = [Rule.ValidateDuplicateCharacterNotInConsecutiveOrder(maxTimesOfConsecutiveOrder: 4, errorMessage: plainErrorMessage)]
    validateForm(
      maxTimesOfConsecutiveOrder2Rule,
      "1313",
      validationSuccess
    )
    validateForm(
      maxTimesOfConsecutiveOrder2Rule,
      "4356754",
      validationSuccess
    )
    validateForm(
      maxTimesOfConsecutiveOrder2Rule,
      "0191",
      validationSuccess
    )
    validateForm(
      maxTimesOfConsecutiveOrder2Rule,
      "1225",
      validationError
    )
    validateForm(
      maxTimesOfConsecutiveOrder2Rule,
      "2332",
      validationError
    )
    validateForm(
      maxTimesOfConsecutiveOrder2Rule,
      "454545454545454555444455455",
      validationError
    )
    validateForm(
      maxTimesOfConsecutiveOrder2Rule,
      "0024",
      validationError
    )
    validateForm(
      maxTimesOfConsecutiveOrder4Rule,
      "0024",
      validationSuccess
    )
    validateForm(
      maxTimesOfConsecutiveOrder4Rule,
      "0004",
      validationSuccess
    )
    validateForm(
      maxTimesOfConsecutiveOrder4Rule,
      "0000",
      validationError
    )
    validateForm(
      maxTimesOfConsecutiveOrder4Rule,
      "35523456337777",
      validationError
    )
  }
  
  func testValidateNumericNotInConsecutiveSequenceOrderRule() {
    let rules = [Rule.ValidateNumericNotInConsecutiveSequenceOrder(length: 4, errorMessage: plainErrorMessage)]
    validateForm(
      rules,
      "1234",
      validationError
    )
    validateForm(
      rules,
      "4321",
      validationError
    )
    validateForm(
      rules,
      "9876",
      validationError
    )
    validateForm(
      rules,
      "3210",
      validationError
    )
    validateForm(
      rules,
      "0123",
      validationError
    )
    validateForm(
      rules,
      "1235",
      validationSuccess
    )
    validateForm(
      rules,
      "9875",
      validationSuccess
    )
    validateForm(
      rules,
      "0124",
      validationSuccess
    )
    validateForm(
      rules,
      "0923",
      validationSuccess
    )
    validateForm(
      rules,
      "8834834835939534",
      validationSuccess
    )
    validateForm(
      rules,
      "TEST",
      validationSuccess
    )
    validateForm(
      rules,
      "",
      validationSuccess
    )
  }
  
  func testValidateMultipleForms() {
    let forms = [
      ValidatableForm(
        inputs : [
          [
            Rule.ValidateNumericNotInConsecutiveSequenceOrder(
              length: 2,
              errorMessage: "ValidateNumericNotInConsecutiveSequenceOrder"
            ),
            Rule.ValidateNotEmpty(
              errorMessage: "ValidateNotEmpty"
            ),
            Rule.ValidateDuplicateCharacterNotInConsecutiveOrder(
              maxTimesOfConsecutiveOrder: 2,
              errorMessage: "ValidateDuplicateCharacterNotInConsecutiveOrder"
            ),
            Rule.ValidateEmail(
              errorMessage: "ValidateEmail"
            ),
            Rule.ValidateRegex(
              regex: ".*(\\d).*",
              errorMessage: "ValidateRegex"
            )
          ] : "4412"
        ]
      ),
      ValidatableForm(
        inputs : [
          [
            Rule.ValidateEmail(
              errorMessage: "ValidateEmail"
            ),
            Rule.ValidateNotEmpty(
              errorMessage: "ValidateNotEmpty"
            ),
            Rule.ValidateDuplicateCharacterNotInConsecutiveOrder(
              maxTimesOfConsecutiveOrder: 2,
              errorMessage: "ValidateDuplicateCharacterNotInConsecutiveOrder"
            ),
            Rule.ValidatePhoneNumber(
              countryCode: "GR",
              errorMessage: "ValidatePhoneNumber"
            ),
            Rule.ValidateRegex(
              regex: ".*(\\d).*",
              errorMessage: "ValidateRegex"
            )
          ] : "test@test.gr"
        ]
      ),
      ValidatableForm(
        inputs : [
          [
            Rule.ValidateEmail(
              errorMessage: "ValidateEmail"
            ),
            Rule.ValidateStringNotMatch(
              stringToMatch: "6991111111",
              errorMessage: "ValidateStringNotMatch"
            ),
            Rule.ValidateDuplicateCharacterNotInConsecutiveOrder(
              maxTimesOfConsecutiveOrder: 2,
              errorMessage: "ValidateDuplicateCharacterNotInConsecutiveOrder"
            ),
            Rule.ValidatePhoneNumber(
              countryCode: "GR",
              errorMessage: "ValidatePhoneNumber"
            ),
            Rule.ValidateRegex(
              regex: ".*[^a-zA-Z0-9].*",
              errorMessage: "ValidateRegex"
            )
          ] : "6991111111"
        ]
      )
    ]
    
    let result = try? formValidator.validateForms(forms: forms).record().next().get()
    XCTAssertEqual(FormsValidationResult(
      isValid: false,
      messages: [
        "ValidateDuplicateCharacterNotInConsecutiveOrder",
        "ValidateEmail",
        "ValidatePhoneNumber",
        "ValidateRegex",
        "ValidateEmail",
        "ValidateStringNotMatch",
        "ValidateDuplicateCharacterNotInConsecutiveOrder",
        "ValidateRegex"
      ]
    ), result)
  }
  
  func testValidateMaximumAmountRule() {
    let rules = [Rule.ValidateMaximumAmount(max: 5, errorMessage: plainErrorMessage)]
    validateForm(
      rules,
      "6",
      validationError
    )
    validateForm(
      rules,
      "12",
      validationError
    )
    validateForm(
      rules,
      "malformed",
      validationError
    )
    validateForm(
      rules,
      "5",
      validationSuccess
    )
    validateForm(
      rules,
      "2",
      validationSuccess
    )
  }
  
  func testValidateMinimumAmountRule() {
    let rules = [Rule.ValidateMinimumAmount(min: 2, errorMessage: plainErrorMessage)]
    validateForm(
      rules,
      "0",
      validationError
    )
    validateForm(
      rules,
      "1",
      validationError
    )
    validateForm(
      rules,
      "malformed",
      validationError
    )
    validateForm(
      rules,
      "2",
      validationSuccess
    )
    validateForm(
      rules,
      "5",
      validationSuccess
    )
  }
  
  func testValidateNoWhiteSpaces() {
    let rules = [Rule.ValidateNoWhiteSpaces(errorMessage: plainErrorMessage)]
    validateForm(
      rules,
      " ",
      validationError
    )
    validateForm(
      rules,
      " test",
      validationError
    )
    validateForm(
      rules,
      "tes t",
      validationError
    )
    validateForm(
      rules,
      "test ",
      validationError
    )
    validateForm(
      rules,
      "test",
      validationSuccess
    )
    validateForm(
      rules,
      "test1!@#$1",
      validationSuccess
    )
  }
  
  private func validateForm(
    _ rules: [Rule],
    _ value: String,
    _ validationResult: FormValidationResult
  ) {
    let result = try? formValidator.validateForm(form: ValidatableForm(inputs: [rules : value])).record().next().get()
    XCTAssertEqual(validationResult, result)
  }
}

