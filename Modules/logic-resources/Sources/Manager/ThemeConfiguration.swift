/*
 * Copyright (c) 2025 European Commission
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
import Foundation

public struct ThemeConfiguration: Sendable {

  public static let `default` = ThemeConfiguration()

  let color: ColorManagerProtocol
  let image: ImageManagerProtocol
  let shape: ShapeManagerProtocol
  let font: TypographyManagerProtocol
  let dimension: DimensionManagerProtocol

  init(
    color: ColorManagerProtocol? = nil,
    image: ImageManagerProtocol? = nil,
    shape: ShapeManagerProtocol? = nil,
    font: TypographyManagerProtocol? = nil,
    dimension: DimensionManagerProtocol? = nil
  ) {
    self.color = color ?? ColorManager(bundle: .assetsBundle)
    self.image = image ?? ImageManager(bundle: .assetsBundle)
    self.shape = shape ?? ShapeManager()
    self.font = font ?? TypographyManager()
    self.dimension = dimension ?? DimensionManager()
  }
}
