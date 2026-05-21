/*
 * Copyright (c) 2026 European Commission
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

public struct TappableCellView: View {
  public let title: LocalizableStringKey
  public let icon: Image?
  public let showDivider: Bool
  public let useOverlay: Bool
  public let action: () -> Void
  public let isToggle: Bool

  @Binding var isOn: Bool

  public init(
    title: LocalizableStringKey,
    icon: Image? = nil,
    showDivider: Bool,
    isToggle: Bool = false,
    isOn: Binding<Bool> = .constant(false),
    useOverlay: Bool = true,
    action: @escaping () -> Void = {}
  ) {
    self.title = title
    self.icon = icon
    self.useOverlay = useOverlay
    self.action = action
    self.showDivider = showDivider
    self.isToggle = isToggle
    self._isOn = isOn
  }

  public var body: some View {
    VStack(spacing: SPACING_MEDIUM_SMALL) {
      HStack(alignment: .center, spacing: SPACING_MEDIUM) {
        if let icon {
          icon
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 24, height: 24)
            .foregroundStyle(Theme.shared.color.primary)
        }

        Text(title)
          .typography(Theme.shared.font.bodyLarge)
          .foregroundColor(Theme.shared.color.onSurface)
          .lineLimit(1)
          .minimumScaleFactor(0.8)
          .frame(maxWidth: .infinity, alignment: .leading)

        if isToggle {
          Toggle(
            "",
            isOn: Binding(
              get: { isOn },
              set: { newValue in
                isOn = newValue
                action()
              }
            )
          )
          .labelsHidden()
        } else {
          Theme.shared.image.chevronRight
            .foregroundColor(Theme.shared.color.onSurface)
        }
      }
      if showDivider {
        Divider()
      }
    }
    .if(useOverlay && !isToggle) {
      $0.contentShape(Rectangle())
    }
    .if(useOverlay && !isToggle) {
      $0.onTapGesture {
        action()
      }
    }
  }
}

#Preview {
  TappableCellView(
    title: .addDocumentTitle,
    showDivider: true,
    useOverlay: true,
    action: {}
  )
  .padding()
}
