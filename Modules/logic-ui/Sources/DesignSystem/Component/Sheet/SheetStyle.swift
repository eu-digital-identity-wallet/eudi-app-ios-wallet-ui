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
import PartialSheet
import SwiftUI
import logic_resources

public struct SheetStyle {

  public static var iphoneSheetStyle: PSIphoneStyle {
    return PSIphoneStyle(
      background: .solid(Theme.shared.color.background),
      handleBarStyle: .none,
      cover: .enabled(Theme.shared.color.onBackground.opacity(0.5)),
      cornerRadius: 20
    )
  }

  public static var IpadMacSheetStyle: PSIpadMacStyle {
    return PSIpadMacStyle(
      backgroundColor: Theme.shared.color.background,
      closeButtonStyle: .icon(
        image: Theme.shared.image.xmark,
        color: Theme.shared.color.primary
      )
    )
  }
}
