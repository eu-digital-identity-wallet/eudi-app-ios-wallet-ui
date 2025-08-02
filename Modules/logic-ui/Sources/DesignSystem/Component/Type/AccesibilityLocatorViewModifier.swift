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

public protocol LocatorType {
  var id: String { get }
  func value() -> String
}

public struct AccesibilityLocatorViewModifier: ViewModifier {
  private let identifier: String
  private let value: String

  public init(by locatorType: LocatorType) {
    identifier = locatorType.id
    value = locatorType.value()
  }

  public init(by locatorType: LocatorType, with identifier: String) {
    self.identifier = locatorType.id + identifier
    value = locatorType.value() + identifier
  }

  public func body(content: Content) -> some View {
    content
      .accessibilityIdentifier(identifier)
      .accessibilityLabel(value)
      .accessibilityAddTraits(.isButton)
  }
}

public extension View {
  func accesibilityLocator(_ locator: LocatorType) -> some View {
    modifier(AccesibilityLocatorViewModifier(by: locator))
  }

  func accesibilityLocator(_ locator: LocatorType, with identifier: String) -> some View {
    modifier(AccesibilityLocatorViewModifier(by: locator, with: identifier))
  }
}
