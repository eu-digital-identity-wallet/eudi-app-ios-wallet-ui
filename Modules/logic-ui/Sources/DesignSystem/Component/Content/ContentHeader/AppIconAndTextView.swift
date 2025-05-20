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

public struct AppIconAndTextData {
  public let appIcon: Image
  public let appText: Image
  public let appIconSize: CGFloat
  public let appTextSize: CGFloat

  public init(
    appIcon: Image,
    appText: Image,
    appIconSize: CGFloat = 60,
    appTextSize: CGFloat = 60
  ) {
    self.appIcon = appIcon
    self.appText = appText
    self.appIconSize = appIconSize
    self.appTextSize = appTextSize
  }
}

public struct AppIconAndTextView: View {
  private let appIconAndTextData: AppIconAndTextData

  public init(
    appIconAndTextData: AppIconAndTextData
  ) {
    self.appIconAndTextData = appIconAndTextData
  }

  public var body: some View {
    HStack(spacing: SPACING_SMALL) {
      appIconAndTextData.appIcon
        .resizable()
        .scaledToFit()
        .frame(width: appIconAndTextData.appIconSize, height: appIconAndTextData.appIconSize)
      appIconAndTextData.appText
        .resizable()
        .scaledToFit()
        .frame(width: appIconAndTextData.appTextSize, height: appIconAndTextData.appTextSize)
    }
    .frame(maxWidth: .infinity, alignment: .center)
  }
}
