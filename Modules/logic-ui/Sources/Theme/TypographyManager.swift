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
  var title: Font { get }
  var subTitle: Font { get }
  var subTitle2: Font { get }
  var text: Font { get }
  var text2: Font { get }
  var text3: Font { get }
  var text4: Font { get }
  var text5: Font { get }
  var body: Font { get }
  var body2: Font { get }

}

class TypographyManager: TypographyManagerProtocol {

  // 32pt
  var title: Font = .custom(.medium, relativeTo: .largeTitle)
  // 24pt
  var subTitle: Font = .custom(.medium, relativeTo: .title)

  var subTitle2: Font = .custom(.medium, relativeTo: .title2)
  // 20pt
  var text: Font = .custom(.medium, relativeTo: .headline)

  var text2: Font = .custom(.medium, relativeTo: .headline)
  // 16pt
  var text3: Font = .custom(.regular, relativeTo: .callout)
  // 12pt
  var text4: Font = .custom(.regular, relativeTo: .caption)

  var text5: Font  = .custom(.regular, relativeTo: .caption)
  // 14 pt
  var body: Font = .custom(.regular, relativeTo: .body)

  var body2: Font = .custom(.regular, relativeTo: .body)

  init() {
    Font.registerFonts()
  }

}
