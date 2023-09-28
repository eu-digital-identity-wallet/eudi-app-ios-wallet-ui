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

public struct WrapButtonView: View {

  private let title: LocalizedStringKey
  private let onAction: () -> Void
  private let textColor: Color
  private let backgroundColor: Color
  private let systemIcon: String?
  private let gravity: Gravity
  private let cornerRadius: CGFloat
  private let isEnabled: Bool

  @Binding
  private var isLoading: Bool

  public init(
    title: LocalizedStringKey,
    textColor: Color = .white,
    backgroundColor: Color = Theme.shared.color.background,
    systemIcon: String? = nil,
    gravity: Gravity = .center,
    isLoading: Binding<Bool> = Binding.constant(false),
    isEnabled: Bool = true,
    cornerRadius: CGFloat = .zero,
    onAction: @autoclosure @escaping () -> Void
  ) {
    self.title = title
    self.textColor = textColor
    self.backgroundColor = backgroundColor
    self.systemIcon = systemIcon
    self.gravity = gravity
    self._isLoading = isLoading
    self.isEnabled = isEnabled
    self.cornerRadius = cornerRadius
    self.onAction = onAction
  }

  public var body: some View {
    Button(
      action: { onAction() },
      label: {
        HStack {

          if gravity == .center || gravity == .end {
            Spacer()
          }

          if let systemIcon {

            Image(systemName: systemIcon)
              .resizable()
              .scaledToFit()
              .frame(width: 25)
              .foregroundColor(textColor)

            HSpacer.small()
          }

          Text(title)
            .foregroundColor(textColor)

          if gravity == .center || gravity == .start {
            Spacer()
          }

          if isLoading {
            LoaderView(
              showLoader: $isLoading,
              width: 20,
              height: 20
            )
            HSpacer.small()
          }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(backgroundColor)
        .cornerRadius(cornerRadius)
      }
    )
    .disabled(isLoading || !isEnabled)
  }
}

public extension WrapButtonView {
  enum Gravity {
    case center, start, end
  }
}
