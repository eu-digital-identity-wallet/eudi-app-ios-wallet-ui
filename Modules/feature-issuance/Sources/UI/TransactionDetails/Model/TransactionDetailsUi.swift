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
import Copyable
import logic_ui

public typealias TransactionListItemSection = ListItemSection<TransactionClaimItem>
private typealias TransactionExpandableListItem = ExpandableListItem<TransactionClaimItem>

@Copyable
public struct TransactionDetailsUIModel: Equatable, Identifiable, Routable {
  public let id: String
  public let transactionId: String
  public let transactionName: String
  public let transactionIdentifier: String
  public let transactionDetailsDataSharedList: [TransactionListItemSection]
  public let transactionDetailsDataSigned: [TransactionListItemSection]

  public var log: String {
    "id: \(id), transactionId: \(transactionId), transactionName: \(transactionName)"
  }
}

public extension TransactionDetailsUIModel {
  static func mockData() -> TransactionDetailsUIModel {
    TransactionDetailsUIModel(
      id: UUID().uuidString,
      transactionId: "transaction Id",
      transactionName: "transaction Name",
      transactionIdentifier: "transaction Identifier",
      transactionDetailsDataSharedList: [
        .init(
          id: UUID().uuidString,
          title: "Digital ID",
          listItems: [
            .single(
              .init(
                collapsed: ListItemData(
                  mainText: .custom("Joe"),
                  overlineText: .custom("Family Name")
                ),
                domainModel: nil
              )
            ),
            .single(
              .init(
                collapsed: ListItemData(
                  mainText: .custom("yes"),
                  overlineText: .custom("Age over 18")
                ),
                domainModel: nil
              )
            )
          ]
        ),
        .init(
          id: UUID().uuidString,
          title: "Driving License",
          listItems: [
            .single(
              .init(
                collapsed: ListItemData(
                  mainText: .custom("Joe"),
                  overlineText: .custom("Family Name")
                ),
                domainModel: nil
              )
            ),
            .single(
              .init(
                collapsed: ListItemData(
                  mainText: .custom("yes"),
                  overlineText: .custom("Age over 18")
                ),
                domainModel: nil
              )
            )
          ]
        )
      ],
      transactionDetailsDataSigned: [
        .init(
          id: UUID().uuidString,
          title: "Driving License",
          listItems: [
            .single(
              .init(
                collapsed: ListItemData(
                  mainText: .custom("Joe"),
                  overlineText: .custom("Family Name")
                ),
                domainModel: nil
              )
            ),
            .single(
              .init(
                collapsed: ListItemData(
                  mainText: .custom("yes"),
                  overlineText: .custom("Age over 18")
                ),
                domainModel: nil
              )
            )
          ]
        )
      ]
    )
  }
}
