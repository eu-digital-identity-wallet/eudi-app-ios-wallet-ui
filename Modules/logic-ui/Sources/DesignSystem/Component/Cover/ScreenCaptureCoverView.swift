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

/// What the wallet shows instead of its screens: the wallet's mark alone in the app switcher, as the start-up screen
/// (`StartupView`) shows it, and the mark with a title and a message while the screen is recorded, mirrored or shared.
struct ScreenCaptureCoverView: View {

  let isMessageShown: Bool

  var body: some View {
    VStack(spacing: SPACING_LARGE) {
      Theme.shared.image.logo
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(width: getScreenRect().width / 2.5)
        .accessibilityHidden(true)

      if isMessageShown {
        VStack(spacing: SPACING_SMALL) {
          Text(.screenCaptureCoverTitle)
            .typography(Theme.shared.font.displaySmall)
            .foregroundStyle(Theme.shared.color.primaryLabel)
          Text(.screenCaptureCoverMessage)
            .typography(Theme.shared.font.bodyLarge)
            .foregroundStyle(Theme.shared.color.secondaryLabel)
        }
        .multilineTextAlignment(.center)
        .accessibilityElement(children: .combine)
      }
    }
    .padding(.horizontal, Theme.shared.dimension.padding)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Theme.shared.color.background)
    .ignoresSafeArea()
    .fastenDynamicType()
  }
}

#Preview("Recording or sharing") {
  ScreenCaptureCoverView(isMessageShown: true)
}

#Preview("App switcher") {
  ScreenCaptureCoverView(isMessageShown: false)
}
