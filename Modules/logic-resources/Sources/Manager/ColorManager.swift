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

public protocol ColorManagerProtocol {
  var base: BaseColor { get }
  var palette: PaletteColor { get }
  var material: MaterialColor { get }
}

class ColorManager: ColorManagerProtocol {

  // MARK: - Properties
  var base: BaseColor
  var palette: PaletteColor
  var material: MaterialColor

  // MARK: - Lifecycle

  init(bundle: Bundle) {
    palette = PaletteColor(bundle: bundle)
    material = MaterialColor(bundle: bundle)
    base = BaseColor(bundle: bundle)
  }

}
