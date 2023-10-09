/*
 * Copyright (c) 2023 European Commission
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import SwiftUI
import logic_resources

struct TypographyGalleryView: View {
  var body: some View {
    Text("displayLarge")
      .applyFont(Theme.shared.font.displayLarge)
    Text("displayMedium")
      .applyFont(Theme.shared.font.displayMedium)
    Text("displaySmall")
      .applyFont(Theme.shared.font.displaySmall)

    Text("headlineLarge")
      .applyFont(ThemeManager.shared.font.headlineLarge)
    Text("headlineMedium")
      .applyFont(Theme.shared.font.headlineMedium)
    Text("headlineSmall")
      .applyFont(Theme.shared.font.headlineSmall)

    Text("titleLarge")
      .applyFont(Theme.shared.font.titleLarge)
    Text("titleMedium")
      .applyFont(Theme.shared.font.titleMedium)
    Text("titleSmall")
      .applyFont(Theme.shared.font.titleSmall)

    Text("bodyLarge")
      .applyFont(Theme.shared.font.bodyLarge)
    Text("bodyMedium")
      .applyFont(Theme.shared.font.bodyMedium)
    Text("bodySmall")
      .applyFont(Theme.shared.font.bodySmall)

    Text("labelLarge")
      .applyFont(Theme.shared.font.labelLarge)
    Text("labelMedium")
      .applyFont(Theme.shared.font.labelMedium)
    Text("labelSmall")
      .applyFont(Theme.shared.font.labelSmall)
  }
}
