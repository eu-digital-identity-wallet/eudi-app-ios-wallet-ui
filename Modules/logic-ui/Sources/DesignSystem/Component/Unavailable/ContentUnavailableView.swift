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

public struct ContentUnavailableView: View {

  private let title: LocalizableStringKey
  private let description: LocalizableStringKey

  public init(
    title: LocalizableStringKey,
    description: LocalizableStringKey
  ) {
    self.title = title
    self.description = description
  }

  public var body: some View {
    VStack(spacing: SPACING_SMALL) {
      Text(title)
        .typography(Theme.shared.font.titleLarge)
        .fontWeight(.bold)

      Text(description)
        .typography(Theme.shared.font.bodyLarge)
        .foregroundStyle(Theme.shared.color.onSurface)
        .multilineTextAlignment(.center)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    .padding(.top, SPACING_LARGE_MEDIUM)
    .padding(.horizontal, SPACING_MEDIUM)
  }
}

#Preview {
  ContentUnavailableView(
    title: .noResults,
    description: .noResultsDocumentsDescription
  )
}
