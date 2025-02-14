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

public struct SplashBackgroundView: View {

  let isAnimating: Bool

  public init(isAnimating: Bool = false) {
    self.isAnimating = isAnimating
  }

  public var body: some View {
    ZStack {
      Rectangle()
        .fill(Theme.shared.color.surface)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()

      Theme.shared.image.logo
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(width: getScreenRect().width / 2.5)
        .opacity(isAnimating ? 1.0 : 0)
    }
    .ignoresSafeArea(.all)
  }
}

#Preview {
  Group {
    SplashBackgroundView(isAnimating: true)
  }
}

#Preview("Dark Mode") {
  Group {
    SplashBackgroundView(isAnimating: true)
  }
}
