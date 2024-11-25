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
import SwiftUI

struct Action: Identifiable {
  let id = UUID()
  let title: String?
  let image: Image?
  let disabled: Bool
  let callback: (() -> Void)?

  init(
    title: String? = nil,
    image: Image? = nil,
    disabled: Bool = false,
    callback: (() -> Void)? = nil
  ) {
    self.title = title
    self.image = image
    self.disabled = disabled
    self.callback = callback
  }
}

struct ToolBarContent: ToolbarContent {

  private let trailingActions: [Action]?
  private let leadingActions: [Action]?

  init(
    trailingActions: [Action]? = nil,
    leadingActions: [Action]? = nil
  ) {
    self.trailingActions = trailingActions
    self.leadingActions = leadingActions
  }

  var body: some ToolbarContent {
    if let leadingActions {
      ToolbarItemGroup(placement: .topBarLeading) {
        ForEach(leadingActions, id: \.id) { action in
          ActionView(
            action: action,
            disabled: action.disabled
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
        }
      }
    }
  }
}

private struct ActionView: View {
  let action: Action
  let disabled: Bool

  init(action: Action, disabled: Bool) {
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
            Action(
              title: "State",
              disabled: false,
              callback: {}
            ),
            Action(
              title: "Proceed",
              disabled: false,
              callback: {}
            )
          ],
          leadingActions: [
            Action(
              image: Image(systemName: "plus"),
              disabled: false,
              callback: {}
            )
          ]
        )
      }
  }
}
