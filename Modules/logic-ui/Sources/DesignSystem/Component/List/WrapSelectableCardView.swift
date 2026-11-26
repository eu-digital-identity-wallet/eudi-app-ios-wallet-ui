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
/// `allowsMultipleSelection` a checkbox for any number of them. A selected card has an accent border, and a checkbox
/// card that is not selected a separator-coloured one. A disabled card cannot change: a selected one has a grey border,
/// and a checkbox card also greys its checkbox. `accessibilityName` names what the card selects for VoiceOver, after
/// the title, when several cards share one title; `headerLocator` identifies the header for UI automation.
public struct WrapSelectableCardView<Content: View>: View {

  private let title: LocalizableStringKey
  private let isSelected: Bool
  private let allowsMultipleSelection: Bool
  private let isEnabled: Bool
  private let isLoading: Bool
  private let accessibilityName: String?
  private let headerLocator: LocatorType?
  private let onSelected: () -> Void
  private let content: () -> Content

  public init(
    title: LocalizableStringKey,
    isSelected: Bool,
    allowsMultipleSelection: Bool = false,
    isEnabled: Bool = true,
    isLoading: Bool = false,
    accessibilityName: String? = nil,
    headerLocator: LocatorType? = nil,
    onSelected: @escaping () -> Void,
    @ViewBuilder content: @escaping () -> Content
  ) {
    self.title = title
    self.isSelected = isSelected
    self.allowsMultipleSelection = allowsMultipleSelection
    self.isEnabled = isEnabled
    self.isLoading = isLoading
    self.accessibilityName = accessibilityName
    self.headerLocator = headerLocator
    self.onSelected = onSelected
    self.content = content
  }

  public var body: some View {
    WrapCardView(backgroundColor: Theme.shared.color.groupedBackground) {
      VStack(alignment: .leading, spacing: SPACING_MEDIUM) {
        header
          .if(accessibilityName != nil) {
            $0.accessibilityLabel(headerAccessibilityLabel)
          }
          .ifLet(headerLocator) { view, locator in
            view.accessibilityIdentifier(locator.id)
          }

        content()
      }
      .padding(SPACING_MEDIUM)
    }
    .overlay(
      RoundedRectangle(cornerRadius: 18)
        .strokeBorder(borderColor, lineWidth: 1)
    )
  }
}

extension WrapSelectableCardView {

  /// The header row: the title after its control, which selects the card on a tap while the card is enabled.
  var header: WrapListItemView {
    WrapListItemView(
      listItem: .init(
        mainContent: .text(title),
        leadingContent: selectionContent
      ),
      mainTextVerticalPadding: 0,
      minHeight: false,
      isLoading: isLoading,
      action: isEnabled ? onSelected : nil
    )
  }

  /// The header's control: a checkbox when several cards can be selected, otherwise a radio button.
  var selectionContent: LeadingContent {
    allowsMultipleSelection
      ? .checkbox(isSelected: isSelected, isEnabled: isEnabled)
      : .radioButton(isSelected: isSelected)
  }

  /// The card's border: the accent colour when selected (grey when disabled), the separator colour around a checkbox
  /// card that is not selected, none around a radio card that is not.
  var borderColor: Color {
    if isSelected {
      return isEnabled ? Theme.shared.color.accent : Theme.shared.color.tertiaryLabel
    }
    return allowsMultipleSelection ? Theme.shared.color.separator : .clear
  }

  /// The header as VoiceOver reads it: the title, then `accessibilityName` when there is one
  /// ("Share this document, PID (SD-JWT VC)").
  var headerAccessibilityLabel: String {
    [title.toString, accessibilityName].compactMap { $0 }.joined(separator: ", ")
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
      accessibilityName: "PID (SD-JWT VC)",
      onSelected: {},
      content: {
        Text(.custom("PID (SD-JWT VC)"))
      }
    )
  }
  .padding()
}
