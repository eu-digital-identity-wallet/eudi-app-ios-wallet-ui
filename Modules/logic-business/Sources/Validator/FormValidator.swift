/*
 * Copyright (c) 2025 European Commission
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
import Foundation
import Peppermint
import libPhoneNumber

public protocol FormValidator: Sendable {
  func validateForm(form: ValidatableForm) async -> FormValidationResult
  func validateForms(forms: [ValidatableForm]) async -> FormsValidationResult
}

final class FormValidatorImpl: FormValidator {

  public func validateForm(form: ValidatableForm) async -> FormValidationResult {
    var foundError = false
    for input in form.inputs {
      let rules = input.key
      let value = input.value
      for rule in rules {
        if let result = self.validateRule(rule: rule, value: value) {
          foundError = true
          return result
        }
      }
    }
    if !foundError {
      return FormValidationResult(isValid: true)
    }
  }

  public func validateForms(forms: [ValidatableForm]) async -> FormsValidationResult {
    var errors: [String] = []
    var isValid: Bool = true
    for form in forms {
      for input in form.inputs {
        let rules = input.key
        let value = input.value
        for rule in rules {
          if let result = self.validateRule(rule: rule, value: value) {
            isValid = false
            errors.append(result.message)
          }
        }
      }
    }
    return FormsValidationResult(isValid: isValid, messages: errors)
  }

  private func validateRule(rule: Rule, value: String) -> FormValidationResult? {

    switch rule {
    case .ValidateNotEmpty(let errorMessage):
      return checkValidationResult(isValid: !value.isEmpty, errorMessage: errorMessage)

    case .ValidateEmail(let errorMessage):
      return checkValidationResult(isValid: isEmailValid(email: value), errorMessage: errorMessage)

    case .ValidatePhoneNumber(let countryCode, let errorMessage):
      return checkValidationResult(isValid: isPhoneNumberValid(phone: value, countryCode: countryCode), errorMessage: errorMessage)

    case .ValidateStringMaxLength(let length, let errorMessage):
      return checkValidationResult(isValid: isStringMaxLengthValid(value: value, length: length), errorMessage: errorMessage)

    case .ValidateStringMinLength(let length, let errorMessage):
      return checkValidationResult(isValid: isStringMinLengthValid(value: value, length: length), errorMessage: errorMessage)

    case .ValidateRegex(let regex, let errorMessage):
      return checkValidationResult(isValid: isRegexMatching(value: value, regex: regex), errorMessage: errorMessage)

    case .ValidateStringMatch(let stringToMatch, let errorMessage, let isCaseSensitive):
      return checkValidationResult(isValid: isStringMatching(value: value, stringToMatch: stringToMatch, isCaseSensitive: isCaseSensitive), errorMessage: errorMessage)

    case .ValidateStringNotMatch(let stringToMatch, let errorMessage, let isCaseSensitive):
      return checkValidationResult(isValid: !isStringMatching(value: value, stringToMatch: stringToMatch, isCaseSensitive: isCaseSensitive), errorMessage: errorMessage)

    case .ValidateDuplicateCharacterNotInConsecutiveOrder(let maxTimesOfConsecutiveOrder, let errorMessage):
      return checkValidationResult(isValid: duplicateCharacterNotInConsecutiveOrder(value: value, maxTimesOfConsecutiveOrder: maxTimesOfConsecutiveOrder), errorMessage: errorMessage)

    case .ValidateNumericNotInConsecutiveSequenceOrder(let length, let errorMessage):
      return checkValidationResult(isValid: numericNotInConsecutiveSequenceOrder(value: value, length: length), errorMessage: errorMessage)

    case .ValidateStringRange(minLength: let minLength, maxLength: let maxLength, errorMessage: let errorMessage):
      return checkValidationResult(isValid: isInRange(value: value, minLength: minLength, maxLength: maxLength), errorMessage: errorMessage)

    case .ValidateMinimumAmount(let min, let errorMessage):
      return checkValidationResult(isValid: isAboveOrEqualMinimum(value: value, min: min), errorMessage: errorMessage)

    case .ValidateMaximumAmount(let max, let errorMessage):
      return checkValidationResult(isValid: isBelowOrEqualMaximum(value: value, max: max), errorMessage: errorMessage)

    case .ValidateStringLengths(let lengths, let errorMessage):
      return checkValidationResult(isValid: isLenghtsRangeIncluded(value: value, lenghts: lengths), errorMessage: errorMessage)

    case .ValidateNoWhiteSpaces(errorMessage: let errorMessage):
      return checkValidationResult(isValid: !hasWhiteSpaces(value: value), errorMessage: errorMessage)

    case .ValidateUrl(
      errorMessage: let errorMessage,
      shouldValidateHost: let shouldValidateHost,
      shouldValidateSchema: let shouldValidateSchema,
      shouldValidateQuery: let shouldValidateQuery,
      shouldValidatePath: let shouldValidatePath
    ):
      return checkValidationResult(
        isValid: isUrlValid(
          value: value,
          shouldValidateHost: shouldValidateHost,
          shouldValidateSchema: shouldValidateSchema,
          shouldValidateQuery: shouldValidateQuery,
          shouldValidatePath: shouldValidatePath
        ),
        errorMessage: errorMessage
      )
    }
  }

  private func isUrlValid(
    value: String,
    shouldValidateHost: Bool,
    shouldValidateSchema: Bool,
    shouldValidateQuery: Bool,
    shouldValidatePath: Bool
  ) -> Bool {

    guard
      !value.isEmpty,
      let url = value.toCompatibleUrl(),
      let components = URLComponents(url: url, resolvingAgainstBaseURL: true)
    else {
      return false
    }

    if shouldValidateHost && components.host.isNilOrEmpty() {
      return false
    }

    if shouldValidateSchema && components.scheme.isNilOrEmpty() {
      return false
    }

    if shouldValidateQuery && components.query.isNilOrEmpty() {
      return false
    }

    if shouldValidatePath && components.path.isEmpty == true {
      return false
    }

    return true
  }

  private func hasWhiteSpaces(value: String) -> Bool {
    return value.contains(" ")
  }

  private func isLenghtsRangeIncluded(value: String, lenghts: [Int]) -> Bool {
    return lenghts.contains(where: { $0 == value.count })
  }

  private func checkValidationResult(isValid: Bool, errorMessage: String) -> FormValidationResult? {
    if !isValid {
      return FormValidationResult(isValid: isValid, message: errorMessage)
    }
    return nil
  }

  private func isEmailValid(email: String) -> Bool {
    return EmailPredicate().evaluate(with: email)
  }

  private func isPhoneNumberValid(phone: String, countryCode: String) -> Bool {
    guard let phoneUtil = NBPhoneNumberUtil.sharedInstance() else { return false }
    do {
      let phoneNumber: NBPhoneNumber = try phoneUtil.parse(phone, defaultRegion: countryCode)
      return phoneUtil.isValidNumber(phoneNumber)
    } catch {
      return false
    }
  }

  private func isAboveOrEqualMinimum(value: String, min: Int) -> Bool {
    if let value = value.toInteger() {
      return value >= min
    }
    return false
  }

  private func isBelowOrEqualMaximum(value: String, max: Int) -> Bool {
    if let value = value.toInteger() {
      return value <= max
    }
    return false
  }

  private func isStringMaxLengthValid(value: String, length: Int) -> Bool {
    let predicate = LengthPredicate<String>(max: length)
    return predicate.evaluate(with: value)
  }

  private func isStringMinLengthValid(value: String, length: Int) -> Bool {
    let predicate = LengthPredicate<String>(min: length)
    return predicate.evaluate(with: value)
  }

  private func isRegexMatching(value: String, regex: String) -> Bool {
    let predicate = RegexPredicate(expression: regex)
    return predicate.evaluate(with: value)
  }

  private func isStringMatching(value: String, stringToMatch: String, isCaseSensitive: Bool = false) -> Bool {
    return value.equals(stringToMatch, ignoreCase: !isCaseSensitive)
  }

  private func isInRange(value: String, minLength: Int, maxLength: Int) -> Bool {
    let predicate = LengthPredicate<String>(min: minLength, max: maxLength)
    return predicate.evaluate(with: value)
  }

  private func duplicateCharacterNotInConsecutiveOrder(value: String, maxTimesOfConsecutiveOrder: Int) -> Bool {
    if maxTimesOfConsecutiveOrder < 2 {
      return true
    }
    let regex = "(\\d|\\w)\\1{\(maxTimesOfConsecutiveOrder - 1),}"
    let consecutiveOrderCount = value.match(regex).count
    return consecutiveOrderCount == 0
  }

  private func numericNotInConsecutiveSequenceOrder(value: String, length: Int) -> Bool {
    if value.isEmpty || length < 2 || Int(value) == nil || value.count != length {
      return true
    }
    guard let firstNumber = value[value.startIndex].wholeNumberValue else {
      return true
    }
    guard let secondNumber = value[value.index(value.startIndex, offsetBy: 1)].wholeNumberValue else {
      return true
    }
    let isReversed = firstNumber > secondNumber
    var buffer: String = "\(firstNumber)"
    for i in 1...(length - 1) {
      if isReversed {
        buffer.append("\(firstNumber - i)")
      } else {
        buffer.append("\(firstNumber + i)")
      }
    }
    return !value.contains(buffer)
  }
}

public struct ValidatableForm: Equatable, Sendable {
  let inputs: [[Rule]: String]

  public init(inputs: [[Rule]: String]) {
    self.inputs = inputs
  }
}

public struct FormValidationResult: Equatable, Sendable {
  public let isValid: Bool
  public let message: String

  public init(isValid: Bool, message: String = "") {
    self.isValid = isValid
    self.message = message
  }
}

public struct FormsValidationResult: Equatable {
  public var isValid: Bool
  public var messages: [String]

  public init(isValid: Bool, messages: [String] = []) {
    self.isValid = isValid
    self.messages = messages
  }
}

public protocol FormValidatorInteractor: Sendable {
  func validateForm(form: ValidatableForm) async -> FormValidationResult
  func validateForms(forms: [ValidatableForm]) async -> FormsValidationResult
}

public enum Rule: Hashable, Sendable {
  case ValidateNotEmpty(errorMessage: String)
  case ValidateEmail(errorMessage: String)
  case ValidatePhoneNumber(countryCode: String, errorMessage: String)
  case ValidateStringMaxLength(length: Int, errorMessage: String)
  case ValidateStringMinLength(length: Int, errorMessage: String)
  case ValidateStringRange(minLength: Int, maxLength: Int, errorMessage: String)
  case ValidateRegex(regex: String, errorMessage: String)
  case ValidateStringMatch(stringToMatch: String, errorMessage: String, isCaseSensitive: Bool = false)
  case ValidateStringNotMatch(stringToMatch: String, errorMessage: String, isCaseSensitive: Bool = false)
  case ValidateDuplicateCharacterNotInConsecutiveOrder(maxTimesOfConsecutiveOrder: Int, errorMessage: String)
  case ValidateNumericNotInConsecutiveSequenceOrder(length: Int, errorMessage: String)
  case ValidateMinimumAmount(min: Int, errorMessage: String)
  case ValidateMaximumAmount(max: Int, errorMessage: String)
  case ValidateStringLengths(lengths: [Int], errorMessage: String)
  case ValidateNoWhiteSpaces(errorMessage: String)
  case ValidateUrl(
    errorMessage: String,
    shouldValidateHost: Bool = true,
    shouldValidateSchema: Bool = true,
    shouldValidateQuery: Bool = true,
    shouldValidatePath: Bool = true
  )
}
