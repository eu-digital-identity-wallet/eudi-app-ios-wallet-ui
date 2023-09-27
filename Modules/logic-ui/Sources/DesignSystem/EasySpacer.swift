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
