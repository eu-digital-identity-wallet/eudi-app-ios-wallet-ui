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
import logic_resources

public struct ContentHeaderView: View {

  private let title: LocalizableString.Key?
  private let dismissIcon: Image
  private let foregroundColor: Color
  private let actions: [Action]?
  private let onBack: (() -> Void)?

  public init(
    title: LocalizableString.Key? = nil,
    dismissIcon: Image = Theme.shared.image.arrowLeft,
    foregroundColor: Color = Theme.shared.color.primary,
    actions: [Action]? = nil,
    onBack: (() -> Void)? = nil
  ) {
    self.title = title
    self.dismissIcon = dismissIcon
    self.foregroundColor = foregroundColor
    self.actions = actions
    self.onBack = onBack
  }

  public var body: some View {

    HStack {

      if let onBack {
        Button(
          action: {
            onBack()
          },
          label: {
            self.dismissIcon
              .foregroundColor(foregroundColor)
          }
        )
        HSpacer.medium()
      }

      if let title {
        Text(title)
          .typography(Theme.shared.font.headlineSmall)
          .foregroundColor(foregroundColor)
      }

      Spacer()

      if let actions {
        HStack(spacing: SPACING_MEDIUM_SMALL) {
          ForEach(actions, id: \.id) { action in
            Button(
              action: {
                action.callback()
              },
              label: {
                action.image
                  .foregroundColor(foregroundColor)
              }
            )
          }
        }
      }
    }
    .frame(height: SPACING_EXTRA_LARGE)
  }
}

public extension ContentHeaderView {
  struct Action: Identifiable {

    public let id: String
    public let image: Image
    public let callback: () -> Void

    public init(
      systemImage: String,
      callback: @autoclosure @escaping () -> Void
    ) {
      self.id = UUID().uuidString
      self.image = Image(systemName: systemImage)
      self.callback = callback
    }

    public init(
      image: Image,
      callback: @autoclosure @escaping () -> Void
    ) {
      self.id = UUID().uuidString
      self.image = image
      self.callback = callback
    }
  }
}

#Preview {
  Group {
    ContentHeaderView(
      title: LocalizableString.Key.loginTitle,
      actions: [
        ContentHeaderView.Action(
          image: Image(systemName: "person"),
          callback: {}()
        )
      ],
      onBack: {}
    )
    .lightModePreview()

    ContentHeaderView(
      title: LocalizableString.Key.loginTitle,
      actions: [
        ContentHeaderView.Action(
          image: Image(systemName: "person"),
          callback: {}()
        )
      ],
      onBack: {}
    )
    .darkModePreview()
  }
}
