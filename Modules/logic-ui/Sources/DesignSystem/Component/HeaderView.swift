/*
 * Copyright (c) 2023 European Commission
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

public struct HeaderView: View {

  private let showLogo: Bool
  private let title: LocalizedStringKey?
  private let dismissIcon: String
  private let onBack: (() -> Void)?
  private let actions: [Action]?

  public init(
    showLogo: Bool = false,
    title: LocalizedStringKey? = nil,
    dismissIcon: String = "chevron.backward",
    onBack: (() -> Void)? = nil,
    actions: [Action]? = nil
  ) {
    self.showLogo = showLogo
    self.title = title
    self.dismissIcon = dismissIcon
    self.onBack = onBack
    self.actions = actions
  }

  public var body: some View {
    VStack(spacing: .zero) {

      if showLogo {
        HStack {
          Image("eu-logo")
            .resizable()
            .scaledToFit()
            .frame(height: 50)

          Spacer()
        }
        .padding(.vertical)
      }

      HStack {

        if let onBack {
          Button(
            action: {
              onBack()
            },
            label: {
              Image(systemName: dismissIcon)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(Theme.shared.color.textPrimaryDark)
                .frame(height: 20)
                .padding()
            }
          )
          HSpacer.medium()
        }

        if let title {
          Text(title)
            .bold()
            .foregroundColor(Theme.shared.color.textPrimaryDark)
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
    }
  }
}

public extension HeaderView {
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
