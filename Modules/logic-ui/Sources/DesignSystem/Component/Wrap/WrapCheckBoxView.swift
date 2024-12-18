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
import logic_business

public struct WrapCheckBoxView: View {

  enum Value {
    case string(String)
    case image(Image)
  }

  public typealias TapListener = ((String) -> Void)?

  let isSelected: Bool
  let isVisible: Bool
  let isEnabled: Bool
  let isLoading: Bool
  let id: String
  let title: String
  let value: Value
  let onTap: TapListener

  var checkBoxColor: Color {
    if self.isEnabled {
      Theme.shared.color.primary
    } else {
      Theme.shared.color.textDisabledDark
    }
  }

  var titleTextColor: Color {
    if self.isEnabled {
      Theme.shared.color.textPrimaryDark
    } else {
      Theme.shared.color.textDisabledDark
    }
  }

  public init(
    isSelected: Bool,
    isVisible: Bool,
    isEnabled: Bool,
    isLoading: Bool,
    id: String,
    title: String,
    value: Any,
    onTap: TapListener = nil
  ) {
    self.isSelected = isSelected
    self.isVisible = isVisible
    self.isEnabled = isEnabled
    self.isLoading = isLoading
    self.id = id
    self.title = title
    switch value {
    case let value as Image:
      self.value = .image(value)
    case let value as String:
      self.value = .string(value)
    default:
      self.value = .string("")
    }
    self.onTap = onTap
  }

  @ViewBuilder
  private var contentValue: some View {
    switch value {
    case .string(let value):
      Text(value)
        .typography(Theme.shared.font.titleMedium)
        .foregroundStyle(Theme.shared.color.textPrimaryDark)
    case .image(let image):
      image
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(maxHeight: 50)
    }
  }

  public var body: some View {

    HStack(spacing: SPACING_SMALL) {

      let image: Image = self.isSelected
      ? Theme.shared.image.checkmarkSquareFill
      : Theme.shared.image.square

      image
        .resizable()
        .scaledToFit()
        .frame(height: 25)
        .foregroundStyle(self.checkBoxColor)

      if !self.isVisible {
        Text(self.title)
          .typography(Theme.shared.font.titleMedium)
          .foregroundStyle(self.titleTextColor)
      } else {
        VStack(alignment: .leading, spacing: SPACING_EXTRA_SMALL) {

          Text(self.title)
            .typography(Theme.shared.font.bodyMedium)
            .foregroundStyle(Theme.shared.color.textSecondaryDark)

          contentValue
        }
      }

      Spacer()
    }
    .frame(maxWidth: .infinity)
    .if(self.onTap != nil && self.isEnabled && !self.isLoading) {
      $0.onTapGesture {
        self.onTap?(self.id)
      }
    }
    .disabled(!self.isEnabled || self.isLoading)
    .shimmer(isLoading: self.isLoading)
    .animation(.easeInOut, value: self.isVisible)
  }
}

struct WrapCheckBoxViewPreview: View {
  var body: some View {
    VStack {
      WrapCheckBoxView(
        isSelected: false,
        isVisible: true,
        isEnabled: true,
        isLoading: false,
        id: "1",
        title: "Title",
        value: "title"
      )

      WrapCheckBoxView(
        isSelected: true,
        isVisible: true,
        isEnabled: true,
        isLoading: false,
        id: "1",
        title: "Title",
        value: "title"
      )

      WrapCheckBoxView(
        isSelected: true,
        isVisible: false,
        isEnabled: true,
        isLoading: false,
        id: "1",
        title: "Title",
        value: "title"
      )

      WrapCheckBoxView(
        isSelected: true,
        isVisible: false,
        isEnabled: true,
        isLoading: true,
        id: "1",
        title: "Title",
        value: "title"
      )

      WrapCheckBoxView(
        isSelected: false,
        isVisible: true,
        isEnabled: false,
        isLoading: false,
        id: "1",
        title: "Title",
        value: "title"
      )
    }
    .padding()
  }
}

#Preview {
  Group {
    WrapCheckBoxViewPreview().lightModePreview()
    WrapCheckBoxViewPreview().darkModePreview()
  }
}
