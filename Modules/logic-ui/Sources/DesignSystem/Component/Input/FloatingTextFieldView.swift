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

public struct FloatingTextFieldView<Content: View>: View {

  let placeholderScaleFactor = 0.8

  let title: LocalizableString.Key
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
    title: LocalizableString.Key,
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
      return Theme.shared.color.primary.opacity(0.12)
    } else if isNotFocused {
      return Theme.shared.color.dividerDark
    } else {
      return Theme.shared.color.textPrimaryDark
    }
  }

  private var labelColor: Color {
    if showError {
      return Theme.shared.color.primary
    } else if isNotFocused {
      return Theme.shared.color.dividerDark
    } else {
      return Theme.shared.color.primary
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
            .typography(Theme.shared.font.bodyMedium)
            .foregroundColor(
              userHasCommitedChange
              ? labelColor
              : Theme.shared.color.textSecondaryDark
            )
            .padding(2)
            .background(Theme.shared.color.backgroundPaper)
            .padding(.leading, 15)
            .offset(x: 0, y: isNotFocused ? 0 : -(30 + (1-placeholderScaleFactor) * 30))
            .scaleEffect(isNotFocused ? 1 : placeholderScaleFactor, anchor: .topLeading)

          TextField("", text: $text, onEditingChanged: { changed in
            userHasCommitedChange = changed
          })
          .typography(Theme.shared.font.bodyMedium)
          .foregroundColor(Theme.shared.color.textPrimaryDark)
          .autocapitalization(.none)
          .disableAutocorrection(true)
          .padding(.leading, 15)
          .textContentType(contentType)
          .keyboardType(keyboardType)
          .disabled(isDisabled)
          .onChange(of: text) { _ in
            switch formatType {
            case .amount:
              text = formatAmount(with: text)
            case .numeric:
              text = text.toNumeric()
            case .uppercase:
              text = text.uppercased()
            case .none:
              break
            }
          }
        }
        .frame(maxWidth: .infinity, minHeight: 60, maxHeight: 60)
        .animation(self.useSpringAnimation ? .spring(response: 0.4, dampingFraction: 0.5) : .default, value: userHasCommitedChange)

        trailingContent()
          .background(Color.blue)
        HSpacer.medium()
          .background(Color.red)
      }
      .background(
        RoundedRectangle(
          cornerRadius: Theme.shared.shape.small,
          style: .continuous)
        .stroke(
          userHasCommitedChange ?
          Theme.shared.color.primary :
            Theme.shared.color.dividerDark,
          lineWidth: 1.5)
      )
    }

  }
}

public extension FloatingTextFieldView {
  enum FormatType {
    case amount
    case numeric
    case uppercase
    case none
  }
}

private extension FloatingTextFieldView {
  func formatAmount(with text: String) -> String {
    let replacedText = text.replacingOccurrences(of: ",", with: ".")
    let isFirstCharPunctuation = replacedText.first?.isPunctuation ?? false

    if isFirstCharPunctuation {
      return ""
    }

    let dotInstances = replacedText.countInstances(of: ".")

    if dotInstances > 1 {
      return String(replacedText.prefix(replacedText.count - (dotInstances - 1)))
    }

    let splitted = replacedText.split(separator: ".")
    if splitted.count >= 2 {
      var firstPart = splitted[0]
      if firstPart.count > 13 {
        firstPart = firstPart.prefix(13)
      }
      return "\(firstPart).\(splitted[1])".toAmount() ?? replacedText
    } else if replacedText.count > 13 && replacedText.last?.isPunctuation == false {
      return String(replacedText.prefix(13))
    }

    return replacedText
  }
}

#Preview {
  VStack(spacing: 10) {
    FloatingTextFieldView(
      title: .search,
      text: .constant("text"),
      showError: false,
      contentType: .username,
      useSpringAnimation: false,
      userHasCommitedChange: .constant(true)
    )
    FloatingTextFieldView(
      title: .search,
      leftImage: Image(systemName: "calendar"),
      text: .constant("text"),
      showError: true,
      contentType: .password,
      useSpringAnimation: false,
      userHasCommitedChange: .constant(false)
    )
    FloatingTextFieldView(
      title: .search,
      text: .constant("text"),
      showError: true,
      contentType: .password,
      isDisabled: true,
      trailingContent: { Image(systemName: "calendar") },
      userHasCommitedChange: .constant(false)
    )
  }
}
