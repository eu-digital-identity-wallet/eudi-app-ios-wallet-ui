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
@testable import logic_business
@testable import logic_test

final class TestFormValidator: EudiTest {
  
  private let plainErrorMessage = "generic_error_description"
  
  private var formValidator : FormValidator!
  
  private var validationError : FormValidationResult!
  private var validationSuccess : FormValidationResult!
  
  override func setUp() {
    formValidator = FormValidatorImpl()
    validationError = FormValidationResult(isValid: false, message: plainErrorMessage)
    validationSuccess = FormValidationResult(isValid: true)
  }
  
  func testValidateNotEmptyRule_WhenValueIsEmptyOrFilled_ThenOnlyTheEmptyOneFails() async {
    // Given
    let rules = [Rule.ValidateNotEmpty(errorMessage: plainErrorMessage)]

    // Then
    await validateForm(
      rules,
      "",
      validationError
    )
    await validateForm(
      rules,
      "test",
      validationSuccess
    )
  }
  
  func testValidateEmailRule_WhenAddressIsCompleteOrCutOff_ThenOnlyTheCompleteOneSucceeds() async {
    // Given
    let rules = [Rule.ValidateEmail(errorMessage: plainErrorMessage)]

    // Then
    await validateForm(
      rules,
      "test@test.com",
      validationSuccess
    )
    await validateForm(
      rules,
      "test@",
      validationError
    )
  }
  
  func testValidatePhoneNumberRule_WhenNumbersAreCheckedPerCountry_ThenOnlyMatchingNumbersSucceed() async {
    // Given
    let greekPhoneRule = [Rule.ValidatePhoneNumber(countryCode: "GR", errorMessage: plainErrorMessage)]
    let usPhoneRule = [Rule.ValidatePhoneNumber(countryCode: "US", errorMessage: plainErrorMessage)]

    // Then
    await validateForm(
      greekPhoneRule,
      "1111111111",
      validationError
    )
    await validateForm(
      greekPhoneRule,
      "15223433333",
      validationError
    )
    await validateForm(
      greekPhoneRule,
      "6941111111",
      validationSuccess
    )
    await validateForm(
      usPhoneRule,
      "6941111111",
      validationError
    )
    await validateForm(
      usPhoneRule,
      "6102458772",
      validationSuccess
    )
  }
  
  func testValidateStringMaxLengthRule_WhenValueExceedsOrFitsTheMaximum_ThenOnlyTheLongOnesFail() async {
    // Given
    let rules = [Rule.ValidateStringMaxLength(length: 10, errorMessage: plainErrorMessage)]

    // Then
    await validateForm(
      rules,
      "aaaaaaaaaaa",
      validationError
    )
    await validateForm(
      rules,
      "aaaaaaaaaaaaaaa",
      validationError
    )
    await validateForm(
      rules,
      "aaaaaaaaa",
      validationSuccess
    )
  }
  
  func testValidateStringMinLengthRule_WhenValueIsBelowOrReachesTheMinimum_ThenOnlyTheShortOnesFail() async {
    // Given
    let rules = [Rule.ValidateStringMinLength(length: 5, errorMessage: plainErrorMessage)]

    // Then
    await validateForm(
      rules,
      "aaaa",
      validationError
    )
    await validateForm(
      rules,
      "a",
      validationError
    )
    await validateForm(
      rules,
      "aaaaa",
      validationSuccess
    )
  }
  
  func testValidateRegexRule_WhenValuesAreMatchedAgainstEachPattern_ThenOnlyMatchingValuesSucceed() async {
    // Given
    let atLeastOneCapitalLetterRule = [Rule.ValidateRegex(regex: ".*[A-Z].*", errorMessage: plainErrorMessage)]
    let atLeastOneDigitRule = [Rule.ValidateRegex(regex: ".*(\\d).*", errorMessage: plainErrorMessage)]
    let atLeastOneSpecialCharRule = [Rule.ValidateRegex(regex: ".*[^a-zA-Z0-9].*", errorMessage: plainErrorMessage)]
    let onlyLettersNumbersSpaceAndDashesRule = [Rule.ValidateRegex(regex: "^[a-zA-Z0-9-\\s]+$", errorMessage: plainErrorMessage)]
    
    // Then
    await validateForm(
      atLeastOneCapitalLetterRule,
      "test",
      validationError
    )
    await validateForm(
      atLeastOneCapitalLetterRule,
      "Test",
      validationSuccess
    )
    await validateForm(
      atLeastOneDigitRule,
      "test",
      validationError
    )
    await validateForm(
      atLeastOneDigitRule,
      "test1",
      validationSuccess
    )
    await validateForm(
      atLeastOneSpecialCharRule,
      "test",
      validationError
    )
    await validateForm(
      atLeastOneSpecialCharRule,
      "test1@",
      validationSuccess
    )
    
    await validateForm(
      onlyLettersNumbersSpaceAndDashesRule,
      "NL86INGB7482085033",
      validationSuccess
    )
    
    await validateForm(
      onlyLettersNumbersSpaceAndDashesRule,
      "CY82947517727631922532755722",
      validationSuccess
    )
    
    await validateForm(
      onlyLettersNumbersSpaceAndDashesRule,
      "GB57BARC20040114216837",
      validationSuccess
    )
    
    await validateForm(
      onlyLettersNumbersSpaceAndDashesRule,
      "123456789",
      validationSuccess
    )
    
    await validateForm(
      onlyLettersNumbersSpaceAndDashesRule,
      "327821737812367126712",
      validationSuccess
    )
    
    await validateForm(
      onlyLettersNumbersSpaceAndDashesRule,
      "3278 2173781 23671 26712",
      validationSuccess
    )
    
    await validateForm(
      onlyLettersNumbersSpaceAndDashesRule,
      "3278-2173781-23671-26712",
      validationSuccess
    )
    
    await validateForm(
      onlyLettersNumbersSpaceAndDashesRule,
      "3278-2173781 23671-26712",
      validationSuccess
    )
    
    await validateForm(
      onlyLettersNumbersSpaceAndDashesRule,
      "3278-2173781&23671-26712",
      validationError
    )
    
    await validateForm(
      onlyLettersNumbersSpaceAndDashesRule,
      "3278-21£73781£23671-26712",
      validationError
    )
  }
  
  func testValidateStringRangeRule_WhenValueIsInsideOrOutsideTheRange_ThenOnlyTheOutsideOneFails() async {
    // Given
    let rules = [Rule.ValidateStringRange(minLength: 0, maxLength: 10, errorMessage: plainErrorMessage)]

    // Then
    await validateForm(
      rules,
      "aaaaaaaaaaa",
      validationError
    )
    await validateForm(
      rules,
      "aaaaaaaaaa",
      validationSuccess
    )
    await validateForm(
      rules,
      "",
      validationSuccess
    )
  }
  
  func testValidateStringMatchRule_WhenValueEqualsOrDiffersFromTheString_ThenOnlyTheEqualOneSucceeds() async {
    // Given
    let isNotCaseSensitiveRule = [Rule.ValidateStringMatch(stringToMatch: "test", errorMessage: plainErrorMessage)]
    let isCaseSensitiveRule = [Rule.ValidateStringMatch(stringToMatch: "test", errorMessage: plainErrorMessage, isCaseSensitive: true)]

    // Then
    await validateForm(
      isNotCaseSensitiveRule,
      "testt",
      validationError
    )
    await validateForm(
      isNotCaseSensitiveRule,
      "t!@#$",
      validationError
    )
    await validateForm(
      isNotCaseSensitiveRule,
      "",
      validationError
    )
    await validateForm(
      isNotCaseSensitiveRule,
      "TEST",
      validationSuccess
    )
    await validateForm(
      isCaseSensitiveRule,
      "TEST",
      validationError
    )
    await validateForm(
      isCaseSensitiveRule,
      "",
      validationError
    )
    await validateForm(
      isCaseSensitiveRule,
      "test",
      validationSuccess
    )
  }
  
  func testValidateStringNotMatchRule_WhenValueEqualsOrDiffersFromTheString_ThenOnlyTheEqualOneFails() async {
    // Given
    let isNotCaseSensitiveRule = [Rule.ValidateStringNotMatch(stringToMatch: "test", errorMessage: plainErrorMessage)]
    let isCaseSensitiveRule = [Rule.ValidateStringNotMatch(stringToMatch: "test", errorMessage: plainErrorMessage, isCaseSensitive: true)]

    // Then
    await validateForm(
      isNotCaseSensitiveRule,
      "test",
      validationError
    )
    await validateForm(
      isNotCaseSensitiveRule,
      "TEST",
      validationError
    )
    await validateForm(
      isNotCaseSensitiveRule,
      "",
      validationSuccess
    )
    await validateForm(
      isNotCaseSensitiveRule,
      "testt",
      validationSuccess
    )
    await validateForm(
      isCaseSensitiveRule,
      "test",
      validationError
    )
    await validateForm(
      isCaseSensitiveRule,
      "Testss",
      validationSuccess
    )
    await validateForm(
      isCaseSensitiveRule,
      "TEST",
      validationSuccess
    )
    await validateForm(
      isCaseSensitiveRule,
      "",
      validationSuccess
    )
  }
  
  func testValidateDuplicateCharacterNotInConsecutiveOrderRule_WhenACharacterRepeatsTheMaximumTimesInARow_ThenOnlyThoseValuesFail() async {
    // Given
    let maxTimesOfConsecutiveOrder2Rule = [Rule.ValidateDuplicateCharacterNotInConsecutiveOrder(maxTimesOfConsecutiveOrder: 2, errorMessage: plainErrorMessage)]
    let maxTimesOfConsecutiveOrder4Rule = [Rule.ValidateDuplicateCharacterNotInConsecutiveOrder(maxTimesOfConsecutiveOrder: 4, errorMessage: plainErrorMessage)]

    // Then
    await validateForm(
      maxTimesOfConsecutiveOrder2Rule,
      "1313",
      validationSuccess
    )
    await validateForm(
      maxTimesOfConsecutiveOrder2Rule,
      "4356754",
      validationSuccess
    )
    await validateForm(
      maxTimesOfConsecutiveOrder2Rule,
      "0191",
      validationSuccess
    )
    await validateForm(
      maxTimesOfConsecutiveOrder2Rule,
      "1225",
      validationError
    )
    await validateForm(
      maxTimesOfConsecutiveOrder2Rule,
      "2332",
      validationError
    )
    await validateForm(
      maxTimesOfConsecutiveOrder2Rule,
      "454545454545454555444455455",
      validationError
    )
    await validateForm(
      maxTimesOfConsecutiveOrder2Rule,
      "0024",
      validationError
    )
    await validateForm(
      maxTimesOfConsecutiveOrder4Rule,
      "0024",
      validationSuccess
    )
    await validateForm(
      maxTimesOfConsecutiveOrder4Rule,
      "0004",
      validationSuccess
    )
    await validateForm(
      maxTimesOfConsecutiveOrder4Rule,
      "0000",
      validationError
    )
    await validateForm(
      maxTimesOfConsecutiveOrder4Rule,
      "35523456337777",
      validationError
    )
  }
  
  func testValidateNumericNotInConsecutiveSequenceOrderRule_WhenDigitsFormARunOfFour_ThenOnlyThoseValuesFail() async {
    // Given
    let rules = [Rule.ValidateNumericNotInConsecutiveSequenceOrder(length: 4, errorMessage: plainErrorMessage)]

    // Then
    await validateForm(
      rules,
      "1234",
      validationError
    )
    await validateForm(
      rules,
      "4321",
      validationError
    )
    await validateForm(
      rules,
      "9876",
      validationError
    )
    await validateForm(
      rules,
      "3210",
      validationError
    )
    await validateForm(
      rules,
      "0123",
      validationError
    )
    await validateForm(
      rules,
      "1235",
      validationSuccess
    )
    await validateForm(
      rules,
      "9875",
      validationSuccess
    )
    await validateForm(
      rules,
      "0124",
      validationSuccess
    )
    await validateForm(
      rules,
      "0923",
      validationSuccess
    )
    await validateForm(
      rules,
      "8834834835939534",
      validationSuccess
    )
    await validateForm(
      rules,
      "TEST",
      validationSuccess
    )
    await validateForm(
      rules,
      "",
      validationSuccess
    )
  }
  
  func testValidateForms_WhenSeveralFormsAreValidated_ThenAllFailingMessagesAreCollected() async {
    // Given
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
    
    // When
    let result = await formValidator.validateForms(forms: forms)

    // Then
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
  
  func testValidateMaximumAmountRule_WhenAmountExceedsOrFitsTheMaximum_ThenLargeOrNonNumericValuesFail() async {
    // Given
    let rules = [Rule.ValidateMaximumAmount(max: 5, errorMessage: plainErrorMessage)]

    // Then
    await validateForm(
      rules,
      "6",
      validationError
    )
    await validateForm(
      rules,
      "12",
      validationError
    )
    await validateForm(
      rules,
      "malformed",
      validationError
    )
    await validateForm(
      rules,
      "5",
      validationSuccess
    )
    await validateForm(
      rules,
      "2",
      validationSuccess
    )
  }
  
  func testValidateMinimumAmountRule_WhenAmountIsBelowOrReachesTheMinimum_ThenSmallOrNonNumericValuesFail() async {
    // Given
    let rules = [Rule.ValidateMinimumAmount(min: 2, errorMessage: plainErrorMessage)]

    // Then
    await validateForm(
      rules,
      "0",
      validationError
    )
    await validateForm(
      rules,
      "1",
      validationError
    )
    await validateForm(
      rules,
      "malformed",
      validationError
    )
    await validateForm(
      rules,
      "2",
      validationSuccess
    )
    await validateForm(
      rules,
      "5",
      validationSuccess
    )
  }
  
  func testValidateNoWhiteSpaces_WhenValueHoldsOrLacksWhiteSpace_ThenOnlyTheOnesWithWhiteSpaceFail() async {
    // Given
    let rules = [Rule.ValidateNoWhiteSpaces(errorMessage: plainErrorMessage)]

    // Then
    await validateForm(
      rules,
      " ",
      validationError
    )
    await validateForm(
      rules,
      " test",
      validationError
    )
    await validateForm(
      rules,
      "tes t",
      validationError
    )
    await validateForm(
      rules,
      "test ",
      validationError
    )
    await validateForm(
      rules,
      "test",
      validationSuccess
    )
    await validateForm(
      rules,
      "test1!@#$1",
      validationSuccess
    )
  }
  
  func testValidateUrl_WhenValuesAreCheckedAsUrls_ThenOnlyUrlsWithASchemeHostAndQuerySucceed() async {
    // Given
    let rules = [Rule.ValidateUrl(errorMessage: plainErrorMessage, shouldValidatePath: false)]
    
    // Then
    await validateForm(
      rules,
      "",
      validationError
    )
    await validateForm(
      rules,
      "invalid_url",
      validationError
    )
    await validateForm(
      rules,
      "123456789",
      validationError
    )
    await validateForm(
      rules,
      "http://example.com",
      validationError
    )
    await validateForm(
      rules,
      "https://notarealproject.com/otherpath",
      validationError
    )
    await validateForm(
      rules,
      "https://notarealproject.com/bad_query_param?",
      validationError
    )
    await validateForm(
      rules,
      "ftp://projectsite.com",
      validationError
    )
    await validateForm(
      rules,
      "mocked-scheme://mocked-host?mocked-query-param=some-value",
      validationSuccess
    )
    await validateForm(
      rules,
      "mocked.scheme://mocked.host?mocked.query.param=some.value",
      validationSuccess
    )
    await validateForm(
      rules,
      "eudi-openid4vp%3A%2F%2Fdev.verifier-backend.eudiw.dev%3Fclient_id%3Ddev.verifier-backend.eudiw.dev%26request_uri%3Dhttps%3A%2F%2Fdev.verifier-backend.eudiw.dev%2Fwallet%2Frequest.jwt%2F1234",
      validationSuccess
    )
    await validateForm(
      rules,
      "openid-credential-offer://credential_offer?credential_offer=%7B%22credential_issuer%22:%20%22https://dev.issuer.eudiw.dev%22%2C%20%22credential_configuration_ids%22:%20%5B%22eu.europa.ec.eudi.pid_mdoc%22%5D%2C%20%22grants%22:%20%7B%22urn:ietf:params:oauth:grant-type:pre-authorized_code%22:%20%7B%22pre-authorized_code%22:%20%22some_code%22%2C%20%22tx_code%22:%20%7B%22length%22:%205%2C%20%22input_mode%22:%20%22numeric%22%2C%20%22description%22:%20%22Please%20provide%20the%20one-time%20code.%22%7D%7D%7D%7D",
      validationSuccess
    )
    await validateForm(
      rules,
      "eudi-openid4vp://dev.verifier-backend.eudiw.dev?client_id=dev.verifier-backend.eudiw.dev&request_uri=https://dev.verifier-backend.eudiw.dev/wallet/request.jwt/1234",
      validationSuccess
    )
    await validateForm(
      rules,
      "openid-credential-offer://credential_offer?credential_offer={\"credential_issuer\": \"https://dev.issuer.eudiw.dev\", \"credential_configuration_ids\": [\"eu.europa.ec.eudi.pid_mdoc\"], \"grants\": {\"urn:ietf:params:oauth:grant-type:pre-authorized_code\": {\"pre-authorized_code\": \"some_code\", \"tx_code\": {\"length\": 5, \"input_mode\": \"numeric\", \"description\": \"Please provide the one-time code.\"}}}}",
      validationSuccess
    )
    await validateForm(
      [Rule.ValidateUrl(errorMessage: plainErrorMessage, shouldValidateHost: true, shouldValidatePath: false)],
      "openid-credential-offer://?credential_offer=%7B%22credential_issuer%22:%20%22https://dev.issuer.eudiw.dev%22%2C%20%22credential_configuration_ids%22:%20%5B%22eu.europa.ec.eudi.pid_mdoc%22%5D%2C%20%22grants%22:%20%7B%22urn:ietf:params:oauth:grant-type:pre-authorized_code%22:%20%7B%22pre-authorized_code%22:%20%22some_code%22%2C%20%22tx_code%22:%20%7B%22length%22:%205%2C%20%22input_mode%22:%20%22numeric%22%2C%20%22description%22:%20%22Please%20provide%20the%20one-time%20code.%22%7D%7D%7D%7D",
      validationError
    )
    await validateForm(
      [Rule.ValidateUrl(errorMessage: plainErrorMessage, shouldValidatePath: true)],
      "openid-credential-offer://credential_offer/path1/path2?credential_offer=%7B%22credential_issuer%22:%20%22https://dev.issuer.eudiw.dev%22%2C%20%22credential_configuration_ids%22:%20%5B%22eu.europa.ec.eudi.pid_mdoc%22%5D%2C%20%22grants%22:%20%7B%22urn:ietf:params:oauth:grant-type:pre-authorized_code%22:%20%7B%22pre-authorized_code%22:%20%22some_code%22%2C%20%22tx_code%22:%20%7B%22length%22:%205%2C%20%22input_mode%22:%20%22numeric%22%2C%20%22description%22:%20%22Please%20provide%20the%20one-time%20code.%22%7D%7D%7D%7D",
      validationSuccess
    )
  }
  
  func testValidateStringLengthsRule_WhenLengthIsListedOrNot_ThenOnlyListedLengthsSucceed() async {
    // Given
    let rules = [Rule.ValidateStringLengths(lengths: [4, 6, 8], errorMessage: plainErrorMessage)]

    // Then
    await validateForm(rules, "ab", validationError)
    await validateForm(rules, "abc", validationError)
    await validateForm(rules, "abcd", validationSuccess)
    await validateForm(rules, "abcde", validationError)
    await validateForm(rules, "abcdef", validationSuccess)
    await validateForm(rules, "abcdefgh", validationSuccess)
    await validateForm(rules, "abcdefghi", validationError)
    await validateForm(rules, "", validationError)
  }

  /// A length below 2 short-circuits to success regardless of the input.
  func testValidateNumericNotInConsecutiveSequenceOrder_WhenLengthIsLessThanTwo_ThenAlwaysSuccess() async {
    // Given
    let rules = [Rule.ValidateNumericNotInConsecutiveSequenceOrder(length: 1, errorMessage: plainErrorMessage)]

    // Then
    await validateForm(rules, "1", validationSuccess)
    await validateForm(rules, "9", validationSuccess)
    await validateForm(rules, "", validationSuccess)
  }

  /// A `maxTimesOfConsecutiveOrder` below 2 returns true unconditionally (line 238), so even strings like "1111" pass the rule.
  func testValidateDuplicateCharacter_WhenMaxConsecutiveOrderIsLessThanTwo_ThenAlwaysSuccess() async {
    // Given
    let rules1 = [Rule.ValidateDuplicateCharacterNotInConsecutiveOrder(maxTimesOfConsecutiveOrder: 1, errorMessage: plainErrorMessage)]
    let rules0 = [Rule.ValidateDuplicateCharacterNotInConsecutiveOrder(maxTimesOfConsecutiveOrder: 0, errorMessage: plainErrorMessage)]

    // Then
    await validateForm(rules1, "1111", validationSuccess)
    await validateForm(rules1, "aaaa", validationSuccess)
    await validateForm(rules0, "0000", validationSuccess)
  }

  /// `shouldValidatePath: true` with a URL that has an empty path component (e.g. `https://example.com`) hits the
  /// empty-path failure branch (line 159).
  func testValidateUrl_WhenPathIsEmptyAndShouldValidatePath_ThenFailsValidation() async {
    // Given
    let rules = [Rule.ValidateUrl(
      errorMessage: plainErrorMessage,
      shouldValidateHost: false,
      shouldValidateSchema: false,
      shouldValidateQuery: false,
      shouldValidatePath: true
    )]

    // Then
    await validateForm(rules, "https://example.com", validationError)
  }

  private func validateForm(
    _ rules: [Rule],
    _ value: String,
    _ validationResult: FormValidationResult
  ) async {
    let result = await formValidator.validateForm(form: ValidatableForm(inputs: [rules : value]))
    XCTAssertEqual(validationResult, result)
  }
}

