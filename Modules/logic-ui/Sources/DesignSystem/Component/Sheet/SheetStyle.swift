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
import PartialSheet
import SwiftUI
import logic_resources

public struct SheetStyle {

  public static var iphoneSheetStyle: PSIphoneStyle {
    return PSIphoneStyle(
      background: .solid(ThemeManager.shared.color.backgroundPaper),
      handleBarStyle: .none,
      cover: .enabled(Color.black.opacity(0.5)),
      cornerRadius: 20
    )
  }

  public static var IpadMacSheetStyle: PSIpadMacStyle {
    return PSIpadMacStyle(
      backgroundColor: ThemeManager.shared.color.backgroundPaper,
      closeButtonStyle: .icon(
        image: ThemeManager.shared.image.xmark,
        color: ThemeManager.shared.color.primary
      )
    )
  }
}
