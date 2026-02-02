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
import SwiftUI
import logic_resources

public extension ToolBarContent {
  struct Action: Identifiable {
    public let id = UUID()
    public let title: LocalizableStringKey?
    public let accessibilityLocator: LocatorType
    public let image: Image?
    public let hasIndicator: Bool?
    public let disabled: Bool
    public let callback: (() -> Void)?

    public init(
      title: LocalizableStringKey? = nil,
      image: Image? = nil,
      accessibilityLocator: LocatorType,
      hasIndicator: Bool? = nil,
      disabled: Bool = false,
      callback: (() -> Void)? = nil
    ) {
      self.title = title
      self.accessibilityLocator = accessibilityLocator
      self.image = image
      self.hasIndicator = hasIndicator
      self.disabled = disabled
      self.callback = callback
    }
  }
}

public struct ToolBarContent: ToolbarContent {

  private let trailingActions: [Action]?
  private let leadingActions: [Action]?

  public init(
    trailingActions: [Action]? = nil,
    leadingActions: [Action]? = nil
  ) {
    self.trailingActions = trailingActions
    self.leadingActions = leadingActions
  }

  public var body: some ToolbarContent {
    if let leadingActions {
      ToolbarItemGroup(placement: .topBarLeading) {
        ForEach(leadingActions, id: \.id) { action in
          ActionView(
            action: action,
            disabled: action.disabled
          )
          .ignoreChilrenAccessibility(
            locator: action.accessibilityLocator
          )
        }
      }
    }
    if let trailingActions {
      ToolbarItemGroup(placement: .topBarTrailing) {
        ForEach(trailingActions, id: \.id) { action in
          ActionView(
            action: action,
            disabled: action.disabled
          )
          .ignoreChilrenAccessibility(
            locator: action.accessibilityLocator
          )
        }
      }
    }
  }
}

private struct ActionView: View {
  let action: ToolBarContent.Action
  let disabled: Bool

  init(action: ToolBarContent.Action, disabled: Bool) {
    self.action = action
    self.disabled = disabled
  }

  var body: some View {
    Group {
      if let callback = action.callback {
        Button(action: callback) {
          content
        }
        .disabled(disabled)
        .overlay(alignment: .topTrailing) {
          if let hasIndicator = action.hasIndicator, hasIndicator {
            Circle()
              .foregroundStyle(Theme.shared.color.primary)
              .frame(width: 10)
              .offset(x: 2, y: 2)
          }
        }
      } else {
        content
      }
    }
  }

  @ViewBuilder
  private var content: some View {
    if let title = action.title {
      Text(title)
    }
    if let image = action.image {
      image
    }
  }
}

#Preview {
  NavigationStack {
    Text("Hello, World!")
      .toolbar {
        ToolBarContent(
          trailingActions: [
            .init(
              title: .custom("State"),
              accessibilityLocator: ToolbarLocators.chevronLeft,
              disabled: false,
              callback: {}
            ),
            .init(
              title: .custom("Proceed"),
              accessibilityLocator: ToolbarLocators.chevronLeft,
              disabled: false,
              callback: {}
            )
          ],
          leadingActions: [
            .init(
              image: Image(systemName: "plus"),
              accessibilityLocator: ToolbarLocators.chevronLeft,
              disabled: false,
              callback: {}
            )
          ]
        )
      }
  }
}
