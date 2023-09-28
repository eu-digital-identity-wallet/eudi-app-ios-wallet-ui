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

public typealias Theme = ThemeManager

public class ThemeManager {

  public static var shared: ThemeProtocol = AppTheme()

  private init() {}

  class func config(themeConfiguration: ThemeConfiguration) {
    self.shared.themeConfiguration = themeConfiguration
  }
}

public struct ThemeConfiguration {
  public static let `default` = ThemeConfiguration()

  var color: ColorManagerProtocol
  var image: ImageManagerProtocol
  var shape: ShapeManagerProtocol
  var font: TypographyManagerProtocol
  var dimension: DimensionManagerProtocol

  init(color: ColorManagerProtocol? = nil,
       image: ImageManagerProtocol? = nil,
       shape: ShapeManagerProtocol? = nil,
       font: TypographyManagerProtocol? = nil,
       dimension: DimensionManagerProtocol? = nil) {
    self.color = color ?? ColorManager(bundle: .assetsBundle)
    self.image = image ?? ImageManager(bundle: .assetsBundle)
    self.shape = shape ?? ShapeManager()
    self.font = font ?? TypographyManager()
    self.dimension = dimension ?? DimensionManager()
  }
}
