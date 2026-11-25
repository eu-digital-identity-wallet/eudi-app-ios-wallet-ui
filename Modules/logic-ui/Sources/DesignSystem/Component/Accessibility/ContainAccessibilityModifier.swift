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
import SwiftUI

/// Makes a view an accessibility container whose children VoiceOver reaches one by one, identified by the locator
/// so that UI automation still finds the whole group. The locator's trait is not applied: VoiceOver never focuses a
/// container, so a trait on it would not be read.
private struct ContainAccessibilityModifier: ViewModifier {
  let locator: LocatorType

  func body(content: Content) -> some View {
    content
      .accessibilityElement(children: .contain)
      .accessibilityIdentifier(locator.id)
  }
}

public extension View {
  /// Groups this view's accessibility elements under the locator's identifier, each child still reachable on its
  /// own, for a card whose rows the user reads or acts on. `combineChilrenAccessibility(locator:)` reads the view as
  /// one element instead.
  func containChildrenAccessibility(locator: LocatorType) -> some View {
    modifier(ContainAccessibilityModifier(locator: locator))
  }
}
