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
import Foundation
import SwiftUI
import logic_resources

public struct ChoosableRow: View {
  let text: String
  let isSelected: Bool
  let onTap: () -> Void

  init(text: String, isSelected: Bool, onTap: @escaping () -> Void) {
    self.text = text
    self.isSelected = isSelected
    self.onTap = onTap
  }

  public var body: some View {
    HStack {
      Text(text)
        .typography(Theme.shared.font.bodyLarge)
        .frame(maxWidth: .infinity, alignment: .leading)
      if isSelected {
        ThemeManager.shared.image.checkmark
          .foregroundColor(.blue)
      }
    }
    .contentShape(Rectangle())
    .onTapGesture(perform: onTap)
  }
}
