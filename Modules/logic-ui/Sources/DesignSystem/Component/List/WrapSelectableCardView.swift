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

/// A card the user selects by its header: a radio button for one choice among the cards (the default), or with
/// `allowsMultipleSelection` a tick box for any number of them. A disabled card shows its state but cannot change.
public struct WrapSelectableCardView<Content: View>: View {

  private let title: LocalizableStringKey
  private let isSelected: Bool
  private let allowsMultipleSelection: Bool
  private let isEnabled: Bool
  private let onSelected: () -> Void
  private let content: () -> Content

  public init(
    title: LocalizableStringKey,
    isSelected: Bool,
    allowsMultipleSelection: Bool = false,
    isEnabled: Bool = true,
    onSelected: @escaping () -> Void,
    @ViewBuilder content: @escaping () -> Content
  ) {
    self.title = title
    self.isSelected = isSelected
    self.allowsMultipleSelection = allowsMultipleSelection
    self.isEnabled = isEnabled
    self.onSelected = onSelected
    self.content = content
  }

  public var body: some View {
    WrapCardView(backgroundColor: Theme.shared.color.groupedBackground) {
      VStack(alignment: .leading, spacing: SPACING_MEDIUM) {
        WrapListItemView(
          listItem: .init(
            mainContent: .text(title),
            leadingContent: selectionContent
          ),
          mainTextVerticalPadding: 0,
          minHeight: false,
          action: isEnabled ? onSelected : nil
        )

        content()
      }
      .padding(SPACING_MEDIUM)
    }
    .overlay(
      RoundedRectangle(cornerRadius: 18)
        .strokeBorder(
          isSelected ? (isEnabled ? Theme.shared.color.accent : Theme.shared.color.tertiaryLabel) : .clear,
          lineWidth: 1
        )
    )
  }
}

extension WrapSelectableCardView {
  /// The header's control: a tick box when several cards can be selected, otherwise a radio button.
  var selectionContent: LeadingContent {
    allowsMultipleSelection
      ? .checkbox(isSelected: isSelected, isEnabled: isEnabled)
      : .radioButton(isSelected: isSelected)
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
    WrapSelectableCardView(
      title: .custom("Share this document"),
      isSelected: true,
      allowsMultipleSelection: true,
      onSelected: {},
      content: {
        Text(.custom("PID (SD-JWT VC)"))
      }
    )
  }
  .padding()
}
