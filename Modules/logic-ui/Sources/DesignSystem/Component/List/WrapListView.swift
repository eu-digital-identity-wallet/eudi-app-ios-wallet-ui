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

public struct WrapListView<Item: Identifiable, Content: View>: View {
  public let sections: [(header: String?, items: [Item])]
  public let rowContent: (Item) -> Content

  public var body: some View {
    List {
      ForEach(0..<sections.count, id: \.self) { index in
        let section = sections[index]
        if let header = section.header {
          Section(
            header:
              Text(header)
              .typography(Theme.shared.font.labelMedium)
              .foregroundStyle(Theme.shared.color.onSurfaceVariant)
          ) {
            ForEach(section.items) { item in
              rowContent(item)
            }
          }
          .listRowBackground(Theme.shared.color.surfaceContainer)
        } else {
          ForEach(section.items) { item in
            rowContent(item)
          }
        }
      }
    }
    .listStyle(InsetGroupedListStyle())
  }
}

#Preview {
  NavigationView {
    TransactionHistoryView()
  }
}

private struct TransactionHistoryView: View {
  struct Transaction: Identifiable {
    let id = UUID()
    let status: String
    let title: String
    let subtitle: String
    let statusColor: Color
  }

  let todayTransactions: [Transaction] = [
    Transaction(status: "Completed", title: "TravelBook", subtitle: "5 minutes ago", statusColor: .green),
    Transaction(status: "Completed", title: "AirBNB", subtitle: "11:05 AM", statusColor: .green),
    Transaction(status: "Failed", title: "Natural Bank VISA", subtitle: "11:07 AM", statusColor: .red)
  ]

  var body: some View {
    WrapListView(
      sections: [
        (header: "Today", items: todayTransactions),
        (header: "This Week", items: todayTransactions)
      ],
      rowContent: { transaction in
        WrapListItemView(
          mainText: transaction.status,
          overlineText: transaction.title,
          overlineTextColor: transaction.statusColor,
          supportingText: transaction.subtitle,
          trailingIcon: Image(systemName: "chevron.right")
        )
      }
    )
    .navigationTitle("Transaction History")
  }
}
