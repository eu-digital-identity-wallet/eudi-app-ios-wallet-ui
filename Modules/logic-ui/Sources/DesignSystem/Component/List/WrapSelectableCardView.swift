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

/// A card with a radio-style selectable header followed by arbitrary content.
/// Used to present mutually exclusive options (e.g. credential combinations) where the user
/// picks exactly one. The selected card is highlighted with an accent border.
public struct WrapSelectableCardView<Content: View>: View {

  private let title: LocalizableStringKey
  private let isSelected: Bool
  private let onSelected: () -> Void
  private let content: () -> Content

  public init(
    title: LocalizableStringKey,
    isSelected: Bool,
    onSelected: @escaping () -> Void,
    @ViewBuilder content: @escaping () -> Content
  ) {
    self.title = title
    self.isSelected = isSelected
    self.onSelected = onSelected
    self.content = content
  }

  public var body: some View {
    WrapCardView(backgroundColor: Theme.shared.color.groupedBackground) {
      VStack(alignment: .leading, spacing: SPACING_MEDIUM) {
        Button(action: onSelected) {
          HStack(spacing: SPACING_MEDIUM_SMALL) {
            (isSelected ? Theme.shared.image.radioButtonSelected : Theme.shared.image.radioButtonUnselected)
              .foregroundColor(
                isSelected
                  ? Theme.shared.color.accent
                  : Theme.shared.color.secondaryLabel
              )
            Text(title)
              .typography(Theme.shared.font.titleSmall)
              .foregroundColor(Theme.shared.color.primaryLabel)
            Spacer()
          }
          .contentShape(Rectangle())
        }
        .buttonStyle(.plain)

        content()
      }
      .padding(SPACING_MEDIUM)
    }
    .overlay(
      RoundedRectangle(cornerRadius: 18)
        .strokeBorder(
          isSelected ? Theme.shared.color.accent : .clear,
          lineWidth: 1
        )
    )
  }
}

#Preview {
  VStack(spacing: SPACING_MEDIUM) {
    WrapSelectableCardView(
      title: .custom("Option 1 of 2"),
      isSelected: true,
      onSelected: {},
      content: {
        Text(.custom("mDL (MSO mDoc)"))
      }
    )
    WrapSelectableCardView(
      title: .custom("Option 2 of 2"),
      isSelected: false,
      onSelected: {},
      content: {
        Text(.custom("PID (MSO mDoc)"))
      }
    )
  }
  .padding()
}
