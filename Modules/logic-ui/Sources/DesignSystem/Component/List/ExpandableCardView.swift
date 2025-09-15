/*
 * Copyright (c) 2025 European Commission
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

public struct ExpandableCardView<Content: View>: View {
  private let header: ListItemData
  private let backgroundColor: Color
  private let mainTextVerticalPadding: CGFloat?
  private let isLoading: Bool
  private let content: () -> Content

  public init(
    backgroundColor: Color = Theme.shared.color.surfaceContainer,
    header: ListItemData,
    mainTextVerticalPadding: CGFloat? = nil,
    isLoading: Bool = false,
    @ViewBuilder content: @escaping () -> Content
  ) {
    self.header = header
    self.backgroundColor = backgroundColor
    self.mainTextVerticalPadding = mainTextVerticalPadding
    self.isLoading = isLoading
    self.content = content
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
              mainContent: header.mainContent,
              mainStyle: .bold,
              supportingText: header.supportingText,
              trailingContent: .icon(
                isExpanded ? Theme.shared.image.chevronUp : Theme.shared.image.chevronDown
              )
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
            content()
          }
        }
      }
      .shimmer(isLoading: isLoading)
    }
  }
}
