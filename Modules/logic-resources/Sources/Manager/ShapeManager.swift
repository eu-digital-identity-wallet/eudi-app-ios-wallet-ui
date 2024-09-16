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

public protocol ShapeManagerProtocol {
  var none: CGFloat { get }
  var extraSmall: CGFloat { get }
  var small: CGFloat { get }
  var medium: CGFloat { get }
  var large: CGFloat { get }
  var extraLarge: CGFloat { get }
  var xxLarge: CGFloat { get }
  var xxxLarge: CGFloat { get }
  var xxxxLarge: CGFloat { get }
  var full: CGFloat { get }

  var capsuleShape: AnyShape { get }
  var lowCornerRadius: AnyShape { get }
  var highCornerRadiusShape: AnyShape { get }
}

final class ShapeManager: ShapeManagerProtocol {

  public var none: CGFloat = 0
  public var extraSmall: CGFloat = 8
  public var small: CGFloat = 16
  public var medium: CGFloat = 18
  public var large: CGFloat = 20
  public var extraLarge: CGFloat = 24
  public var xxLarge: CGFloat = 32
  public var xxxLarge: CGFloat = 48
  public var xxxxLarge: CGFloat = 56
  public var full: CGFloat = .infinity

  public var lowCornerRadius: AnyShape {
    .init(
      RoundedRectangle(cornerSize: .init(width: small, height: small))
        .inset(by: -4)
    )
  }

  public var highCornerRadiusShape: AnyShape {
    .init(
      RoundedRectangle(cornerSize: .init(width: large, height: large))
        .inset(by: -4)
    )
  }

  public var capsuleShape: AnyShape {
    .init(
      Capsule()
        .inset(by: -4)
    )
  }
}
