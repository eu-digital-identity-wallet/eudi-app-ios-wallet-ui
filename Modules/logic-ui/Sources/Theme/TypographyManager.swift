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

public protocol TypographyManagerProtocol {
  var Title: Font { get }
  var SubTitle: Font { get }
  var SubTitle2: Font { get }
  var Text: Font { get }
  var Text2: Font { get }
  var Text3: Font { get }
  var Text4: Font { get }
  var Text5: Font { get }
  var Body: Font { get }
  var Body2: Font { get }

}

class TypographyManager: TypographyManagerProtocol {

  // 32pt
  var Title: Font = .custom(.medium, relativeTo: .largeTitle)
  // 24pt
  var SubTitle: Font = .custom(.medium, relativeTo: .title)

  var SubTitle2: Font = .custom(.medium, relativeTo: .title2)
  // 20pt
  var Text: Font = .custom(.medium, relativeTo: .headline)

  var Text2: Font = .custom(.medium, relativeTo: .headline)
  // 16pt
  var Text3: Font = .custom(.regular, relativeTo: .callout)
  // 12pt
  var Text4: Font = .custom(.regular, relativeTo: .caption)

  var Text5: Font  = .custom(.regular, relativeTo: .caption)
  // 14 pt
  var Body: Font = .custom(.regular, relativeTo: .body)

  var Body2: Font = .custom(.regular, relativeTo: .body)

  init() {
    Font.registerFonts()
  }

}
