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
import Foundation

public protocol ThemeProtocol {
  var themeConfiguration: ThemeConfiguration { get set }

  var image: ImageManagerProtocol { get }
  var color: ColorManagerProtocol { get }
  var shape: ShapeManagerProtocol { get }
  var font: TypographyManagerProtocol { get }
  var dimension: DimensionManagerProtocol { get }
}

public class AppTheme: ThemeProtocol {

  public var themeConfiguration: ThemeConfiguration

  public var color: ColorManagerProtocol {
    themeConfiguration.color
  }

  public var image: ImageManagerProtocol {
    themeConfiguration.image
  }
  public var shape: ShapeManagerProtocol {
    themeConfiguration.shape
  }

  public var font: TypographyManagerProtocol {
    themeConfiguration.font
  }

  public var dimension: DimensionManagerProtocol {
    themeConfiguration.dimension
  }

  init(themeConfiguration: ThemeConfiguration = ThemeConfiguration()) {
    self.themeConfiguration = themeConfiguration
  }

}
