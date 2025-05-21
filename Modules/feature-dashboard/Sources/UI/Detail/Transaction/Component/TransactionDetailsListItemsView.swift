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
import logic_ui

public struct TransactionDetailsListItemsView: View {
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
          if item.isEnable {
            action?(item)
          }
        }
      )
      if index < listItems.count - 1 {
        ListDividerView()
      }
    }
  }
}

#Preview {
  TransactionDetailsListItemsView(
    listItems: [
      .init(mainText: .custom("Family name"), supportingText: .custom("Doe")),
      .init(mainText: .custom("Given names"), supportingText: .custom("John")),
      .init(mainText: .custom("Date of birth"), supportingText: .custom("21 Oct 1994")),
      .init(mainText: .custom("Age over 18"), supportingText: .custom("21 Oct 1994")),
      .init(mainText: .custom("Date of issue"), supportingText: .custom("21 Oct 1994"))
    ]
  )
  .padding()
}
