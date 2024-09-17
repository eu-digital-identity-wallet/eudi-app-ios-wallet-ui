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
import Foundation
import SwiftUI

import logic_resources

public struct ExpandableTextView: View {
  @State private var isExpanded = false
  var title: LocalizableString.Key
  var content: LocalizableString.Key
  let isloading: Bool

  public init(
    isExpanded: Bool = false,
    title: LocalizableString.Key,
    content: LocalizableString.Key,
    isloading: Bool
  ) {
    self.isExpanded = isExpanded
    self.title = title
    self.content = content
    self.isloading = isloading
  }

  @ViewBuilder
  var chevron: some View {
    if isExpanded {
      Theme.shared.image.chevronUp
        .foregroundColor(Theme.shared.color.primary)
    } else {
      Theme.shared.image.chevronDown
        .foregroundColor(Theme.shared.color.primary)
    }
  }

  public var body: some View {
    VStack(spacing: SPACING_MEDIUM_SMALL) {
      Group {
        HStack {
          Text(title)
            .typography(Theme.shared.font.titleSmall)
            .foregroundColor(Theme.shared.color.textPrimaryDark)
          Spacer()
          chevron
        }
        .padding(isExpanded ? [.horizontal, .top] : [.all])

        if isExpanded {
          HStack {
            Text(content)
              .typography(Theme.shared.font.bodyMedium)
              .foregroundColor(Theme.shared.color.textSecondaryDark)
            Spacer()
          }
          .padding([.horizontal, .bottom])
        }
      }
    }
    .padding()
    .background(Theme.shared.color.backgroundDefault)
    .cornerRadius(10)
    .onTapGesture {
      withAnimation {
        isExpanded.toggle()
      }
    }
    .shimmer(isLoading: isloading)
  }
}

#Preview {
  VStack {
    ExpandableTextView(
      title: LocalizableString.Key.addDocumentTitle,
      content: LocalizableString.Key.addDoc,
      isloading: false
    )

    ExpandableTextView(
      title: LocalizableString.Key.addDocumentTitle,
      content: LocalizableString.Key.addDoc,
      isloading: true
    )
  }
}
