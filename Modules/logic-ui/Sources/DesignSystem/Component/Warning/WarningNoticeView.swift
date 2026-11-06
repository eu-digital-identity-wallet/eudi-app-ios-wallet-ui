/*
 * Copyright (c) 2026 European Commission
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

/// A warning the user reads without acknowledging it, such as the biometric-data notice on a request for the
/// portrait.
public struct WarningNoticeView: View {
  private let message: LocalizableStringKey

  private var iconSize: Double { 20 }

  public init(message: LocalizableStringKey) {
    self.message = message
  }

  public var body: some View {
    HStack(alignment: .center, spacing: SPACING_SMALL) {
      Theme.shared.image.exclamationmarkTriangleFill
        .renderingMode(.template)
        .resizable()
        .scaledToFit()
        .frame(width: iconSize, height: iconSize)
        .foregroundColor(Theme.shared.color.warning)

      Text(message)
        .typography(Theme.shared.font.bodyMedium)
        .foregroundColor(Theme.shared.color.primaryLabel)
        .multilineTextAlignment(.leading)
        .fixedSize(horizontal: false, vertical: true)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    .padding(SPACING_MEDIUM)
    .frame(maxWidth: .infinity, alignment: .leading)
    .background(Theme.shared.color.groupedElevatedBackground)
    .clipShape(RoundedRectangle(cornerRadius: SPACING_SMALL))
  }
}

#Preview {
  WarningNoticeView(message: .requestUserImageNotice)
    .padding()
}
