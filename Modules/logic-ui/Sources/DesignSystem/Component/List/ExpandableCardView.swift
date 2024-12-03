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
  private let details: [DetailItem]
  private let backgroundColor: Color

  public init(
    backgroundColor: Color = Theme.shared.color.surfaceContainer,
    title: String,
    subtitle: String,
    details: [DetailItem]
  ) {
    self.title = title
    self.subtitle = subtitle
    self.details = details
    self.backgroundColor = backgroundColor
  }

  @State private var isExpanded: Bool = false

  public var body: some View {
    VStack(spacing: .zero) {
      WrapCardView(
        backgroundColor: backgroundColor
      ) {
        VStack(spacing: .zero) {
          WrapListItemView(
            mainText: title,
            supportingText: subtitle,
            trailingIcon: isExpanded ? Theme.shared.image.chevronUp : Theme.shared.image.chevronDown
          ) {
            withAnimation {
              isExpanded.toggle()
            }
          }

          if isExpanded {
            ForEach(Array(details.enumerated()), id: \.element.id) { index, detail in
              WrapListItemView(
                mainText: detail.title,
                overlineText: detail.value
              )
              if index < details.count - 1 {
                Divider()
                  .padding(.horizontal, SPACING_MEDIUM)
                  .background(Theme.shared.color.onSurfaceVariant.opacity(0.2))
              }
            }
          }
        }
      }
    }
  }
}

public struct DetailItem: Identifiable {
  public let id = UUID()
  public let title: String
  public let value: String
}

#Preview {
  ExpandableCardView(
    title: "Digital ID",
    subtitle: "View details",
    details: [
      DetailItem(title: "Family name", value: "Doe"),
      DetailItem(title: "Given names", value: "John"),
      DetailItem(title: "Date of birth", value: "21 Oct 1994"),
      DetailItem(title: "Age over 18", value: "Yes"),
      DetailItem(title: "Date of issue", value: "21 Oct 2023"),
      DetailItem(title: "Date of expiry", value: "21 Oct 2040"),
      DetailItem(title: "Issuing authority", value: "GR"),
      DetailItem(title: "Issuing country", value: "GR")
    ]
  )
  .padding()
}
