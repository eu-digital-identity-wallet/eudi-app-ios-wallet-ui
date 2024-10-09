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
import Foundation

public let SPACING_NONE: CGFloat = 0
public let SPACING_EXTRA_SMALL: CGFloat = 4
public let SPACING_SMALL: CGFloat = 8
public let SPACING_MEDIUM_SMALL: CGFloat = 12
public let SPACING_MEDIUM: CGFloat = 16
public let SPACING_MEDIUM_LARGE: CGFloat = 20
public let SPACING_LARGE_MEDIUM: CGFloat = 24
public let SPACING_LARGE: CGFloat = 32
public let SPACING_EXTRA_LARGE: CGFloat = 48

@MainActor
public struct VSpacer {

  public static func custom(size: CGFloat) -> some View {
    return Spacer().frame(height: size)
  }

  public static func extraSmall() -> some View {
    return Spacer().frame(height: SPACING_EXTRA_SMALL)
  }

  public static func small() -> some View {
    return Spacer().frame(height: SPACING_SMALL)
  }

  public static func mediumSmall() -> some View {
    return Spacer().frame(height: SPACING_MEDIUM_SMALL)
  }

  public static func medium() -> some View {
    return Spacer().frame(height: SPACING_MEDIUM)
  }

  public static func mediumLarge() -> some View {
    return Spacer().frame(height: SPACING_MEDIUM_LARGE)
  }

  public static func largeMedium() -> some View {
    return Spacer().frame(height: SPACING_LARGE_MEDIUM)
  }

  public static func large() -> some View {
    return Spacer().frame(height: SPACING_LARGE)
  }

  public static func extraLarge() -> some View {
    return Spacer().frame(height: SPACING_EXTRA_LARGE)
  }
}

@MainActor
public struct HSpacer {

  public static func custom(size: CGFloat) -> some View {
    return Spacer().frame(width: size)
  }

  public static func extraSmall() -> some View {
    return Spacer().frame(width: SPACING_EXTRA_SMALL)
  }

  public static func small() -> some View {
    return Spacer().frame(width: SPACING_SMALL)
  }

  public static func mediumSmall() -> some View {
    return Spacer().frame(width: SPACING_MEDIUM_SMALL)
  }

  public static func medium() -> some View {
    return Spacer().frame(width: SPACING_MEDIUM)
  }

  public static func mediumLarge() -> some View {
    return Spacer().frame(width: SPACING_MEDIUM_LARGE)
  }

  public static func largeMedium() -> some View {
    return Spacer().frame(width: SPACING_LARGE_MEDIUM)
  }

  public static func large() -> some View {
    return Spacer().frame(width: SPACING_LARGE)
  }

  public static func extraLarge() -> some View {
    return Spacer().frame(width: SPACING_EXTRA_LARGE)
  }
}
