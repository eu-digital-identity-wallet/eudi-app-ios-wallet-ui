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

public struct PinTextFieldView: View {

  // MARK: - Properties
  private let maxDigits: Int
  private let isSecureEntry: Bool
  private let shouldUseFullScreen: Bool
  private let hasError: Bool

  @State private var stateForDigit: [FieldState]
  @State private var currentIndex: Int = 0
  @State private var isInEditMode = false
  @State private var toggleLine = false

  // MARK: - Observables
  @Binding private var numericText: String
  @Binding private var canFocus: Bool

  @FocusState private var focused: Bool

  let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()

  private var activeIndex: Int {
    return currentIndex - 1
  }

  private var computeDotsSize: (width: CGFloat, height: CGFloat) {
    guard shouldUseFullScreen else {
      return (
        width: 45.0 / UIScreen.main.zoomFactor,
        height: 55.0 / UIScreen.main.zoomFactor
      )
    }
    let size = (getScreenRect().width - CGFloat((maxDigits + 1) * 10)) / CGFloat(maxDigits)
    return (width: size, height: (size + 10))
  }

  public init(
    numericText: Binding<String>,
    maxDigits: Int,
    isSecureEntry: Bool,
    canFocus: Binding<Bool> = .constant(true),
    shouldUseFullScreen: Bool = false,
    hasError: Bool = false
  ) {
    self._numericText = numericText
    self._canFocus = canFocus
    self.maxDigits = maxDigits
    self.isSecureEntry = isSecureEntry
    self.shouldUseFullScreen = shouldUseFullScreen
    self.hasError = hasError

    self.stateForDigit = Array(repeating: FieldState.inactive, count: maxDigits)
  }

  public var body: some View {
    VStack(spacing: 15) {
      ZStack {
        pinDots
        backgroundField
      }
    }
  }

  private var pinDots: some View {
    HStack(spacing: shouldUseFullScreen ? 0.0 : 10) {
      ForEach(0..<maxDigits, id: \.self) { index in
        createMainComponent(input: getEachDigit(at: index), index: index)
          .frame(width: computeDotsSize.width, height: computeDotsSize.height, alignment: .center)
          .background(
            RoundedRectangle(cornerRadius: 5.0)
              .stroke(
                hasError ?
                Theme.shared.color.error :
                  stateForDigit[index].color
              )
          )
        if shouldUseFullScreen && index < (maxDigits - 1) {
          Spacer()
        }
      }
      if !shouldUseFullScreen {
        Spacer()
      }
    }
  }

  @ViewBuilder
  private func createMainComponent(input: String, index: Int) -> some View {

    let size = computeDotsSize.width / 4
    let canShowLine = index == currentIndex && focused

    if input.isEmpty && canShowLine {
      showLine()
    } else if isSecureEntry {
      let image: Image = input.isEmpty
      ? Image(systemName: "")
      : Theme.shared.image.circle
      image
        .resizable()
        .frame(width: size, height: size, alignment: .center)
        .foregroundColor(
          hasError
          ? Theme.shared.color.error
          : Theme.shared.color.onSurface
        )
    } else {
      Text(input)
        .typography(Theme.shared.font.bodyLarge)
    }
  }

  @ViewBuilder
  private func showLine() -> some View {

    let height = computeDotsSize.height / 3

    HStack {
      Divider()
        .frame(width: 1, height: height)
        .background(Theme.shared.color.onSurface)
    }
    .opacity(toggleLine ? 1 : 0)
    .onReceive(timer) { _ in
      toggleLine.toggle()
    }
  }

  private var backgroundField: some View {
    return TextField(
      "",
      text: $numericText,
      onEditingChanged: { isEditing in
        self.isInEditMode = isEditing
        if isEditing, self.stateForDigit[safe: numericText.count] != nil {
          self.stateForDigit[numericText.count] = .active
        }
      },
      onCommit: {
        submitPin()
        stateForDigit = Array(repeating: FieldState.inactive, count: maxDigits)
      }
    )
    .onChange(of: numericText) { _, newValue in
      self.numericText = newValue
      self.currentIndex = newValue.count > maxDigits ? maxDigits : newValue.count
      self.submitPin()

      for index in (0..<maxDigits) {
        self.stateForDigit[index] = numericText.count == index  ? .active : .inactive
      }
    }
    .accentColor(.clear)
    .foregroundColor(.clear)
    .keyboardType(.numberPad)
    .textContentType(.oneTimeCode)
    .frame(width: self.isInEditMode ? 0 : nil, height: nil)
    .focused($focused)
    .if(canFocus) { view in
      view
        .onAppearDelayed {
          self.focused = true
        }
    }
  }

  private func submitPin() {

    guard !numericText.isEmpty else {
      return
    }

    if numericText.count > maxDigits {
      numericText = String(numericText.prefix(maxDigits))
      submitPin()
    }
  }

  private func getEachDigit(at index: Int) -> String {
    guard index < numericText.digits.count else { return "" }
    return self.numericText.digits[index].numberString
  }
}

private extension String {

  var digits: [Int] {
    var result = [Int]()
    for char in self {
      if let number = Int(String(char)) {
        result.append(number)
      }
    }
    return result
  }
}

private extension Int {

  var numberString: String {
    guard self < 10 else { return "0" }
    return String(self)
  }
}

extension PinTextFieldView {
  enum FieldState {
    case inactive
    case active

    var color: Color {
      return switch self {
      case .inactive:
        Theme.shared.color.outlineVariant
      case .active:
        Theme.shared.color.primary
      }
    }
  }
}

struct PinTextFieldViewPreview: View {
  @State private var numerText = ""

  var body: some View {
    VStack(alignment: .center) {
      PinTextFieldView(
        numericText: $numerText,
        maxDigits: 6,
        isSecureEntry: false
      )

      PinTextFieldView(
        numericText: $numerText,
        maxDigits: 6,
        isSecureEntry: true
      )

      PinTextFieldView(
        numericText: $numerText,
        maxDigits: 6,
        isSecureEntry: false,
        hasError: true
      )
    }
    .padding()
  }
}

#Preview {
  Group {
    PinTextFieldViewPreview().lightModePreview()
    PinTextFieldViewPreview().darkModePreview()
  }
}
