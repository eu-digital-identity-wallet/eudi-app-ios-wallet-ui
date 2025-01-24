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

public struct AddNewDocumentCellView: View {

  let isEnabled: Bool
  let icon: Image?
  let title: LocalizableString.Key
  let action: () -> Void
  let isLoading: Bool

  public init(
    isEnabled: Bool,
    icon: Image? = nil,
    title: LocalizableString.Key,
    isLoading: Bool,
    action: @autoclosure @escaping () -> Void
  ) {
    self.isEnabled = isEnabled
    self.icon = icon
    self.title = title
    self.isLoading = isLoading
    self.action = action
  }

  @ViewBuilder
  var iconStyle: some View {
    if !isEnabled {
      icon?
        .renderingMode(.template)
        .resizable()
        .aspectRatio(contentMode: .fit)
    } else {
      icon?
        .resizable()
        .aspectRatio(contentMode: .fit)
    }
  }

  public var body: some View {
    HStack {
      Button(
        action: !isLoading ? action : {},
        label: {
          iconStyle
            .foregroundColor(isEnabled ? Theme.shared.color.primary : Theme.shared.color.onSurface)
            .frame(maxWidth: 32)
          Text(title)
            .typography(Theme.shared.font.bodyLarge)
            .foregroundColor(isEnabled ? Theme.shared.color.onSurface : Theme.shared.color.onSurface)
          Spacer()
          Theme.shared.image.plus
            .font(.body.bold())
            .foregroundColor(isEnabled ? Theme.shared.color.primary : Theme.shared.color.onSurface)
        }
      )
      .disabled(!isEnabled)
      .padding(SPACING_MEDIUM_LARGE)
      .background(Theme.shared.color.background)
      .tint(isEnabled ? nil : Theme.shared.color.onSurface)
      .clipShape(.rect(cornerRadius: Theme.shared.shape.small))
      .shimmer(isLoading: isLoading)
    }
  }
}

#Preview {
  AddNewDocumentCellView(
    isEnabled: true,
    icon: Image(systemName: "person.text.rectangle"),
    title: LocalizableString.Key.addDocumentTitle,
    isLoading: false,
    action: {}()
  )
}
