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

public struct ExpandableCardView: View {
  private let title: String
  private let subtitle: String
  private let listItems: [ListItemData]
  private let backgroundColor: Color
  private let mainTextVerticalPadding: CGFloat?
  private let isLoading: Bool

  public init(
    backgroundColor: Color = Theme.shared.color.surfaceContainer,
    title: String,
    subtitle: String,
    listItems: [ListItemData],
    mainTextVerticalPadding: CGFloat? = nil,
    isLoading: Bool = false
  ) {
    self.title = title
    self.subtitle = subtitle
    self.listItems = listItems
    self.backgroundColor = backgroundColor
    self.mainTextVerticalPadding = mainTextVerticalPadding
    self.isLoading = isLoading
  }

  @State private var isExpanded: Bool = false

  public var body: some View {
    VStack(spacing: .zero) {
      WrapCardView(
        backgroundColor: backgroundColor
      ) {
        VStack(spacing: .zero) {
          WrapListItemView(
            listItem: .init(
              mainText: title,
              mainStyle: .bold,
              supportingText: !isExpanded ? subtitle : nil,
              trailingContent: .icon(isExpanded ? Theme.shared.image.chevronUp : Theme.shared.image.chevronDown)
            ),
            mainTextVerticalPadding: mainTextVerticalPadding
          ) {
            if !isLoading {
              withAnimation {
                isExpanded.toggle()
              }
            }
          }

          if isExpanded {
            WrapListItemsView(
              listItems: listItems,
              mainTextVerticalPadding: mainTextVerticalPadding
            )
          }
        }
      }
      .shimmer(isLoading: isLoading)
    }
  }
}

#Preview {
  ExpandableCardView(
    title: "Digital ID",
    subtitle: "View details",
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
