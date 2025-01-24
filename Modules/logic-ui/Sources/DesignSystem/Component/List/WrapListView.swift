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

public struct WrapListView<Item: Identifiable, Content: View, ListStyleType: ListStyle>: View {
  private let sections: [(header: String?, items: [Item])]
  private let rowContent: (Item) -> Content
  private let style: ListStyleType
  private let hideRowSeperators: Bool
  private let listRowBackground: Color
  private let sectionHeaderColor: Color

  public init(
    sections: [(header: String?, items: [Item])],
    style: ListStyleType = .plain,
    hideRowSeperators: Bool = false,
    listRowBackground: Color = Theme.shared.color.surfaceContainer,
    sectionHeaderColor: Color = Theme.shared.color.onSurfaceVariant,
    @ViewBuilder rowContent: @escaping (Item) -> Content
  ) {
    self.sections = sections
    self.style = style
    self.hideRowSeperators = hideRowSeperators
    self.listRowBackground = listRowBackground
    self.sectionHeaderColor = sectionHeaderColor
    self.rowContent = rowContent
  }

  public var body: some View {
    List {
      ForEach(0..<sections.count, id: \.self) { index in
        let section = sections[index]
        if let header = section.header {
          Section(
            header:
              Text(header)
              .typography(Theme.shared.font.labelMedium)
              .foregroundStyle(sectionHeaderColor)
          ) {
            ForEach(section.items) { item in
              rowContent(item)
                .if(hideRowSeperators) {
                  $0.listRowSeparator(.hidden)
                }
            }
          }
          .listRowBackground(listRowBackground)
        } else {
          ForEach(section.items) { item in
            rowContent(item)
              .if(hideRowSeperators) {
                $0.listRowSeparator(.hidden)
              }
          }
          .listRowBackground(listRowBackground)
        }
      }
    }
    .listStyle(style)
  }
}

#Preview {
  NavigationView {
    TransactionHistoryView()
  }
}

#Preview("Cards") {
  NavigationView {
    DashboardDocumentsView()
  }
}

private struct TransactionHistoryView: View {
  let todayTransactions: [ListItemData] = [
    .init(
      mainText: .transactions,
      overlineText: .expired,
      supportingText: .expiryDate,
      overlineTextColor: .green,
      trailingContent: .icon(Image(systemName: "chevron.right"))
    ),
    .init(
      mainText: .transactions,
      overlineText: .expired,
      supportingText: .expiryDate,
      overlineTextColor: .green,
      trailingContent: .icon(Image(systemName: "chevron.right"))
    ),
    .init(
      mainText: .transactions,
      overlineText: .expired,
      supportingText: .expiryDate,
      overlineTextColor: .red,
      trailingContent: .icon(Image(systemName: "chevron.right"))
    )
  ]

  var body: some View {
    WrapListView(
      sections: [
        (header: "Today", items: todayTransactions),
        (header: "This Week", items: todayTransactions)
      ],
      style: .insetGrouped,
      rowContent: { transaction in
        WrapListItemView(
          listItem: transaction
        )
      }
    )
    .navigationTitle("Transaction History")
  }
}

private struct DashboardDocumentsView: View {
  let todayTransactions: [ListItemData] = [
    .init(
      mainText: .custom("TravelBook"),
      overlineText: .custom("5 minutes ago"),
      supportingText: .custom("Completed"),
      overlineTextColor: .green,
      trailingContent: .icon(Image(systemName: "chevron.right"))
    ),
    .init(
      mainText: .custom("AirBNB"),
      overlineText: .custom("11:05 AM"),
      supportingText: .custom("Completed"),
      overlineTextColor: .green,
      trailingContent: .icon(Image(systemName: "chevron.right"))
    ),
    .init(
      mainText: .custom("Natural Bank VISA"),
      overlineText: .custom("11:05 AM"),
      supportingText: .custom("Failed"),
      overlineTextColor: .red,
      trailingContent: .icon(Image(systemName: "chevron.right"))
    )
  ]

  var body: some View {
    WrapListView(
      sections: [
        (header: "GOVERNMENT", items: todayTransactions)
      ],
      style: .plain,
      hideRowSeperators: true,
      listRowBackground: .clear,
      rowContent: { transaction in
        WrapCardView {
          WrapListItemView(
            listItem: transaction
          )
        }
      }
    )
    .navigationTitle("Transaction History")
  }
}
