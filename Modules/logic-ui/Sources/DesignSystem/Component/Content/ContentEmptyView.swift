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

public struct ContentEmptyView: View {

  private let title: LocalizableString.Key
  private let image: Image
  private let iconColor: Color
  private let textColor: Color
  private let onClick: (() -> Void)?

  public init(
    title: LocalizableString.Key,
    image: Image = Theme.shared.image.exclamationmarkCircle,
    iconColor: Color = Theme.shared.color.background,
    textColor: Color = Theme.shared.color.onSurface,
    onClick: (() -> Void)? = nil
  ) {
    self.title = title
    self.image = image
    self.iconColor = iconColor
    self.textColor = textColor
    self.onClick = onClick
  }

  public var body: some View {
    VStack(alignment: .center, spacing: SPACING_MEDIUM) {

      image
        .resizable()
        .scaledToFit()
        .foregroundColor(iconColor)
        .frame(height: 50)

      Text(title)
        .multilineTextAlignment(.center)
        .foregroundColor(textColor)
    }
    .onTapGesture {
      onClick?()
    }
  }
}

#Preview {
  Group {
    ContentEmptyView(
      title: LocalizableString.Key.tryAgain,
      image: Theme.shared.image.checkmarkCircleFill
    )
    .lightModePreview()

    ContentEmptyView(
      title: LocalizableString.Key.tryAgain,
      image: Theme.shared.image.checkmarkCircleFill
    )
    .darkModePreview()
  }
}
