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
import logic_resources

public struct WrapText: View {
  private let text: LocalizableStringKey
  private let textConfig: TextConfig

  public init(text: LocalizableStringKey, textConfig: TextConfig) {
    self.text = text
    self.textConfig = textConfig
  }

  public var body: some View {
    Text(text)
      .font(textConfig.font)
      .foregroundColor(textConfig.color)
      .multilineTextAlignment(textConfig.textAlign)
      .lineLimit(textConfig.maxLines)
      .fontWeight(textConfig.fontWeight)
  }
}
