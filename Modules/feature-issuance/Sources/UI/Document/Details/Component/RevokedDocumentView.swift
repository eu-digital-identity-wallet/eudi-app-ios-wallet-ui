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
import logic_ui
import feature_common
import logic_resources

struct RevokedDocumentView: View {
  private let message: LocalizableStringKey
  private let backgroundColor: Color

  init(
    message: LocalizableStringKey,
    backgroundColor: Color = Theme.shared.color.errorContainer
  ) {
    self.message = message
    self.backgroundColor = backgroundColor
  }

  var body: some View {
    VStack(alignment: .leading, spacing: SPACING_SMALL) {
      Text(message)
        .font(Theme.shared.font.bodyMedium.font)
        .foregroundColor(Theme.shared.color.error)
        .multilineTextAlignment(.leading)
    }
    .padding(Theme.shared.dimension.padding)
    .frame(maxWidth: .infinity)
    .background(backgroundColor)
    .cornerRadius(12)
  }
}

#Preview {
  RevokedDocumentView(
    message: .documentDetailsRevokedDocumentMessage
  )
}
