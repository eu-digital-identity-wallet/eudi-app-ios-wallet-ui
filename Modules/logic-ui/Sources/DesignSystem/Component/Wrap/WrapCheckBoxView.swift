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
import SwiftUI
import logic_resources

public struct CheckboxData {
  public let isChecked: Bool
  public let enabled: Bool
  public let onCheckedChange: ((Bool) -> Void)?
}

public struct WrapCheckboxView: View {
  private let checkboxData: CheckboxData
  private let size: CGFloat

  public init(
    checkboxData: CheckboxData,
    size: CGFloat = 24
  ) {
    self.checkboxData = checkboxData
    self.size = size
  }
  public var body: some View {
    Button {
      if checkboxData.enabled {
        checkboxData.onCheckedChange?(!checkboxData.isChecked)
      }
    } label: {
      checkmarkSquare
        .resizable()
        .frame(width: size, height: size)
        .foregroundColor(checkboxData.enabled ? Theme.shared.color.primary : Theme.shared.color.secondary)
    }
    .disabled(!checkboxData.enabled)
  }

  private var checkmarkSquare: Image {
    checkboxData.isChecked ? Theme.shared.image.checkmarkSquareFill : Theme.shared.image.square
  }
}

struct WrapCheckbox_Previews: PreviewProvider {
  @State static var isChecked: Bool = true

  static var previews: some View {
    WrapCheckboxView(
      checkboxData: CheckboxData(
        isChecked: isChecked,
        enabled: true,
        onCheckedChange: { newValue in
          isChecked = newValue
        }
      )
    )
    .padding()
    .previewLayout(.sizeThatFits)
  }
}
