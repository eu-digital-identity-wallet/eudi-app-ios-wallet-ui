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

public struct ActionCard: View {
  public let icon: Image
  public let title: String
  public let action: () -> Void

  public init(
    icon: Image,
    title: String,
    action: @escaping () -> Void
  ) {
    self.icon = icon
    self.title = title
    self.action = action
  }

  public var body: some View {
    Button(action: action) {
      VStack(spacing: SPACING_MEDIUM_SMALL) {
        icon
          .resizable()
          .scaledToFit()
          .frame(width: 64, height: 64)
          .foregroundColor(Color.blue)

        Text(title)
          .typography(Theme.shared.font.labelLarge)
          .foregroundColor(.blue)
      }
      .frame(maxWidth: .infinity, minHeight: 180)
      .padding(.vertical, 16)
      .background(Theme.shared.color.surfaceContainer)
      .cornerRadius(16)
    }
  }
}

#Preview {
  VStack(spacing: 20) {
    ActionCard(
      icon: Image(systemName: "doc.text"),
      title: "Choose from list",
      action: {
        print("Choose from list tapped")
      }
    )

    ActionCard(
      icon: Image(systemName: "qrcode"),
      title: "Scan a QR",
      action: {
        print("Scan a QR tapped")
      }
    )
  }
  .padding()
  .frame(maxWidth: .infinity, maxHeight: .infinity)
  .background(Color.white)
}
