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

public struct WrapListItemsView: View {
  private let listItems: [ListItemData]
  private let action: ((ListItemData) -> Void)?
  private let mainTextVerticalPadding: CGFloat?

  public init(
    listItems: [ListItemData],
    mainTextVerticalPadding: CGFloat? = nil,
    action: ((ListItemData) -> Void)? = nil
  ) {
    self.listItems = listItems
    self.mainTextVerticalPadding = mainTextVerticalPadding
    self.action = action
  }

  public var body: some View {
    ForEach(Array(listItems.enumerated()), id: \.element.id) { index, item in
      WrapListItemView(
        listItem: item,
        mainTextVerticalPadding: mainTextVerticalPadding,
        action: {
          action?(item)
        }
      )
      if index < listItems.count - 1 {
        Divider()
          .padding(.horizontal, SPACING_MEDIUM)
          .background(Theme.shared.color.onSurfaceVariant.opacity(0.2))
      }
    }
  }
}

#Preview {
  WrapListItemsView(
    listItems: [
      .init(mainText: "Family name", supportingText: "Doe"),
      .init(mainText: "Given names", supportingText: "John"),
      .init(mainText: "Date of birth", supportingText: "21 Oct 1994"),
      .init(mainText: "Age over 18", supportingText: "Yes"),
      .init(mainText: "Date of issue", supportingText: "21 Oct 2023"),
      .init(mainText: "Date of expiry", supportingText: "21 Oct 2040"),
      .init(mainText: "Issuing authority", supportingText: "GR"),
      .init(mainText: "Issuing country", supportingText: "GR")
    ]
  )
  .padding()
}
