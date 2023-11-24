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

public struct ContentHeader: View {

  private let title: LocalizableString.Key?
  private let dismissIcon: Image
  private let foregroundColor: Color
  private let onBack: (() -> Void)?
  private let actions: [Action]?

  public init(
    title: LocalizableString.Key? = nil,
    dismissIcon: Image = Theme.shared.image.arrowLeft,
    foregroundColor: Color = Theme.shared.color.primary,
    onBack: (() -> Void)? = nil,
    actions: [Action]? = nil
  ) {
    self.title = title
    self.dismissIcon = dismissIcon
    self.foregroundColor = foregroundColor
    self.onBack = onBack
    self.actions = actions
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
                Image(systemName: action.systemImage)
                  .resizable()
                  .scaledToFit()
                  .frame(height: 25)
              }
            )
          }
        }
      }
    }
    .frame(height: SPACING_EXTRA_LARGE)
  }
}

public extension ContentHeader {
  struct Action: Identifiable {

    public var id: String {
      return systemImage
    }

    public let systemImage: String
    public let callback: () -> Void

    public init(systemImage: String, callback: @autoclosure @escaping () -> Void) {
      self.systemImage = systemImage
      self.callback = callback
    }
  }
}
