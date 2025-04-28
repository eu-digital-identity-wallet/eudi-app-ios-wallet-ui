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

public protocol ThemeProtocol: Sendable {
  var themeConfiguration: ThemeConfiguration { get }

  var image: ImageManagerProtocol { get }
  var color: ColorManagerProtocol { get }
  var shape: ShapeManagerProtocol { get }
  var font: TypographyManagerProtocol { get }
  var dimension: DimensionManagerProtocol { get }
}

public final class AppTheme: ThemeProtocol {

  public let themeConfiguration: ThemeConfiguration

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
