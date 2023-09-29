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

public struct FloatingTextField<Content: View>: View {
  let title: LocalizedStringKey
  let leftImage: Image?
  var showError: Bool
  let contentType: UITextContentType
  let useSpringAnimation: Bool
  let keyboardType: UIKeyboardType
  let isDisabled: Bool
  let isLoading: Bool
  let formatType: FormatType
  let trailingContent: () -> Content?

  @Binding var text: String
  @Binding var userHasCommitedChange: Bool

  public init(
    title: LocalizedStringKey,
    leftImage: Image? = nil,
    text: Binding<String>,
    showError: Bool,
    contentType: UITextContentType,
    useSpringAnimation: Bool = true,
    keyboardType: UIKeyboardType = .default,
    isDisabled: Bool = false,
    isLoading: Bool = false,
    formatType: FormatType = .none,
    @ViewBuilder trailingContent: @escaping () -> Content? = { EmptyView() },
    userHasCommitedChange: Binding<Bool>
  ) {
    self.title = title
    self.leftImage = leftImage
    self.showError = showError
    self.contentType = contentType
    self.useSpringAnimation = useSpringAnimation
    self.keyboardType = keyboardType
    self.isDisabled = isDisabled
    self.isLoading = isLoading
    self.formatType = formatType
    self.trailingContent = trailingContent
    self._text = text
    self._userHasCommitedChange = userHasCommitedChange
  }

  private var isNotFocused: Bool {
    text.isEmpty && userHasCommitedChange == false
  }

  private var backgroundColor: Color {
    if showError {
      return ThemeManager.shared.color.secondary.opacity(0.12)
    } else if isNotFocused {
      return ThemeManager.shared.color.outlineVariant
    } else {
      return ThemeManager.shared.color.outline
    }
  }

  private var labelColor: Color {
    if showError {
      return ThemeManager.shared.color.primary
    } else if isNotFocused {
      return ThemeManager.shared.color.surface
    } else {
      return ThemeManager.shared.color.secondary
    }
  }

  public var body: some View {
    ZStack {
      HStack {
        if let leftImage = leftImage {
          HSpacer.mediumSmall()
          leftImage
        }
        ZStack(alignment: .leading) {
          Text(title)
            .font(ThemeManager.shared.themeConfiguration.font.bodyMedium)
            .foregroundColor(labelColor)
            .padding(.leading, 15)
            .offset(x: 0, y: isNotFocused ? 0 : -18)
          TextField("", text: $text, onEditingChanged: { changed in
            userHasCommitedChange = changed
          })
          .font(Theme.shared.font.bodyMedium)
          .foregroundColor(Theme.shared.color.surface)
          .autocapitalization(.none)
          .disableAutocorrection(true)
          .padding(.leading, 15)
          .textContentType(contentType)
          .keyboardType(keyboardType)
          .disabled(isDisabled)
          .onChange(of: text) { _ in
            switch formatType {
            case .amount:
              // TODO: Revisit if needed
              text = text
            case .numeric:
              text = text
            case .uppercase:
              text = text.uppercased()
            case .none:
              break
            }
          }
        }
        .padding(.top, isNotFocused ? 0 : 15)
        .frame(maxWidth: .infinity, minHeight: 60, maxHeight: 60)
        .animation(self.useSpringAnimation ? .spring(response: 0.4, dampingFraction: 0.5) : .default, value: userHasCommitedChange)

        trailingContent()

        HSpacer.medium()
      }
      .background(
        Theme.shared.shape.highCornerRadiusShape
          .fill(.gray.opacity(0.2))
      )
    }

  }
}

public extension FloatingTextField {
  enum FormatType {
    case amount
    case numeric
    case uppercase
    case none
  }
}
