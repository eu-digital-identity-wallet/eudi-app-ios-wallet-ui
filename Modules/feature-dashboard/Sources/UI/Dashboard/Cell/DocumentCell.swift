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

extension DocumentListView {
  struct DocumentCell: View {

    let item: DocumentUIModel
    let action: (DocumentUIModel) -> Void
    let isLoading: Bool

    private let exrtaSpace: CGFloat = 10

    init(
      item: DocumentUIModel,
      isLoading: Bool,
      action: @escaping (DocumentUIModel) -> Void
    ) {
      self.item = item
      self.isLoading = isLoading
      self.action = action
    }

    var body: some View {
      Button(action: {
        action(item)
      }, label: {
        VStack {
          Spacer(minLength: exrtaSpace)
          Theme.shared.image.idStroke
            .foregroundColor(Theme.shared.color.primary)
            .aspectRatio(contentMode: .fit)
            .frame(maxWidth: 48)
          Text(.custom(item.value.title))
            .typography(ThemeManager.shared.font.bodyMedium)
            .foregroundColor(ThemeManager.shared.color.textPrimaryDark)
            .minimumScaleFactor(0.3)
            .lineLimit(1)
          Text(.custom(item.value.status))
            .typography(ThemeManager.shared.font.bodySmall)
            .foregroundColor(Theme.shared.color.success)
          Spacer(minLength: exrtaSpace)
        }
      })
      .frame(maxWidth: .infinity, alignment: .center)
      .padding()
      .background(Theme.shared.color.backgroundDefault)
      .clipShape(.rect(cornerRadius: 16))
      .shimmer(isLoading: isLoading)
    }
  }
}
