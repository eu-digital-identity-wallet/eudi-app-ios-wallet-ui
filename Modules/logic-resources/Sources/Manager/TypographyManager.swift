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

public protocol TypographyManagerProtocol {

  var displayLarge: Font { get }
  var displayMedium: Font { get }
  var displaySmall: Font { get }

  var headlineLarge: Font { get }
  var headlineMedium: Font { get }
  var headlineSmall: Font { get }

  var titleLarge: Font { get }
  var titleMedium: Font { get }
  var titleSmall: Font { get }

  var bodyLarge: Font { get }
  var bodyMedium: Font { get }
  var bodySmall: Font { get }

  var labelLarge: Font { get }
  var labelMedium: Font { get }
  var labelSmall: Font { get }

}

class TypographyManager: TypographyManagerProtocol {

  var displayLarge: Font = .custom(.medium, relativeTo: .headline)
  var displayMedium: Font = .custom(.medium, relativeTo: .headline)
  var displaySmall: Font = .custom(.regular, relativeTo: .callout)

  var headlineLarge: Font = .custom(.medium, relativeTo: .title)
  var headlineMedium: Font = .custom(.medium, relativeTo: .title2)
  var headlineSmall: Font = .custom(.medium, relativeTo: .largeTitle)

  var titleLarge: Font = .custom(.medium, relativeTo: .largeTitle)
  var titleMedium: Font = .custom(.medium, relativeTo: .largeTitle)
  var titleSmall: Font = .custom(.medium, relativeTo: .largeTitle)

  var labelLarge: Font = .custom(.regular, relativeTo: .caption)
  var labelMedium: Font = .custom(.regular, relativeTo: .caption)
  var labelSmall: Font  = .custom(.regular, relativeTo: .caption)

  var bodyLarge: Font = .custom(.regular, relativeTo: .body)
  var bodyMedium: Font = .custom(.regular, relativeTo: .body)
  var bodySmall: Font = .custom(.medium, relativeTo: .body)

  init() {
    Font.registerFonts()
  }

}
