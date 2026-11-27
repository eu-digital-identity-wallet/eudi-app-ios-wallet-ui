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

public struct WrapListItemsView: View {
  @Environment(\.accessibilityReduceMotion) private var reduceMotion

  private let listItems: [ListItemData]
  private let action: ((ListItemData) -> Void)?
  private let mainTextVerticalPadding: CGFloat?
  private let isLoading: Bool
  private let highlightedItemIds: Set<String>

  /// - Parameter highlightedItemIds: rows drawn over a light success background, e.g. to point out a row that just
  ///   changed. Only the background is animated: it fades in quickly and out slowly, or just changes with Reduce
  ///   Motion.
  public init(
    listItems: [ListItemData],
    mainTextVerticalPadding: CGFloat? = nil,
    isLoading: Bool = false,
    highlightedItemIds: Set<String> = [],
    action: ((ListItemData) -> Void)? = nil
  ) {
    self.listItems = listItems
    self.mainTextVerticalPadding = mainTextVerticalPadding
    self.isLoading = isLoading
    self.highlightedItemIds = highlightedItemIds
    self.action = action
  }

  public var body: some View {
    ForEach(Array(listItems.enumerated()), id: \.element.id) { index, item in
      WrapListItemView(
        listItem: item,
        mainTextVerticalPadding: mainTextVerticalPadding,
        isLoading: isLoading,
        action: {
          if item.isEnable {
            action?(item)
          }
        }
      )
      .background {
        let isHighlighted = highlightedItemIds.contains(item.id)
        Theme.shared.color.success
          .opacity(isHighlighted ? 0.2 : 0)
          .animation(highlightAnimation(isHighlighted: isHighlighted), value: isHighlighted)
      }
      if index < listItems.count - 1 {
        ListDividerView()
      }
    }
  }

  private func highlightAnimation(isHighlighted: Bool) -> Animation? {
    guard !reduceMotion else { return nil }
    return isHighlighted ? .easeOut(duration: 0.25) : .easeInOut(duration: 0.7)
  }
}

#Preview {
  WrapListItemsView(
    listItems: [
      .init(mainContent: .text(.custom("Family name")), supportingText: .custom("Doe")),
      .init(mainContent: .text(.custom("Given names")), supportingText: .custom("John")),
      .init(mainContent: .text(.custom("Date of birth")), supportingText: .custom("21 Oct 1994")),
      .init(mainContent: .text(.custom("Age over 18")), supportingText: .custom("21 Oct 1994")),
      .init(mainContent: .text(.custom("Date of issue")), supportingText: .custom("21 Oct 1994"))
    ]
  )
  .padding()
}
