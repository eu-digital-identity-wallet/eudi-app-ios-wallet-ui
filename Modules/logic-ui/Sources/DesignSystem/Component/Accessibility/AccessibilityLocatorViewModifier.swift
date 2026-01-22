/*
 * Copyright (c) 2025 European Commission
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
import SwiftUI

public protocol LocatorType: Sendable {
  var id: String { get }
  var trait: AccessibilityTraits? { get }
}

struct AccessibilityLocatorViewModifier: ViewModifier {
  private let identifier: String
  private let trait: AccessibilityTraits?
  private let label: String?

  init(
    by locatorType: LocatorType,
    label: String? = nil
  ) {
    self.identifier = locatorType.id
    self.label = label
    self.trait = locatorType.trait
  }

  init(
    by locatorType: LocatorType? = nil,
    with identifier: String,
    label: String? = nil
  ) {
    if let locatorType {
      self.identifier = locatorType.id + identifier
    } else {
      self.identifier = identifier
    }
    self.trait = locatorType?.trait
    self.label = label
  }

  func body(content: Content) -> some View {
    content
      .accessibilityIdentifier(identifier)
      .ifLet(label) { view, label in
        view.accessibilityLabel(label)
      }
      .ifLet(trait) { view, trait in
        view.accessibilityAddTraits(trait)
      }
  }
}

public extension View {
  func accessibilityLocator(
    _ locator: LocatorType,
    label: String? = nil
  ) -> some View {
    modifier(
      AccessibilityLocatorViewModifier(
        by: locator,
        label: label
      )
    )
  }

  func accessibilityLocator(
    _ locator: LocatorType? = nil,
    with identifier: String,
    label: String? = nil
  ) -> some View {
    modifier(
      AccessibilityLocatorViewModifier(
        by: locator,
        with: identifier,
        label: label
      )
    )
  }
}

public enum Locators: String, LocatorType {
  case pinTextField

  public var id: String {
    switch self {
    case .pinTextField:
      return "pin_text_field"
    }
  }

  public var trait: AccessibilityTraits? {
    nil
  }
}
