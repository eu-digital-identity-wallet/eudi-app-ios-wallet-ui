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
import logic_ui

extension BaseRequestView {
  struct RequestDataCellView: View {

    typealias Cell = RequestDataCell
    typealias TapListener = ((String) -> Void)?

    let cellModel: Cell
    let isLoading: Bool
    let onTap: TapListener

    init(cellModel: Cell, isLoading: Bool, onTap: TapListener = nil) {
      self.cellModel = cellModel
      self.isLoading = isLoading
      self.onTap = onTap
    }

    var body: some View {
      switch cellModel {
      case .requestDataRow(let row):
        WrapCheckBoxView(
          isSelected: row.isSelected,
          isVisible: row.isVisible,
          isEnabled: true,
          isLoading: isLoading,
          id: row.id,
          title: row.title,
          value: row.value,
          onTap: self.onTap
        )
        .padding(.bottom)
      case .requestDataSection(let section):
        HStack(spacing: .zero) {

          HStack(spacing: SPACING_SMALL) {

            ThemeManager.shared.image.id
              .resizable()
              .scaledToFit()
              .frame(width: 45)

            Text(section.title)
              .typography(ThemeManager.shared.font.titleMedium)
              .colorScheme(.light)
              .foregroundStyle(ThemeManager.shared.color.textPrimaryDark)

          }
          .padding([.horizontal, .vertical], SPACING_SMALL)
          .background(ThemeManager.shared.color.secondary)
          .roundedCorner(Theme.shared.shape.small, corners: .allCorners)

          Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: 50)
        .padding(.bottom)
        .disabled(isLoading)
        .shimmer(isLoading: isLoading)
      case .requestDataVerification(let verification):
        ContentExpandable(title: .custom(verification.title)) {

          VStack(spacing: SPACING_LARGE) {

            ForEach(verification.items, id: \.id) {
              WrapCheckBoxView(
                isSelected: $0.isSelected,
                isVisible: $0.isVisible,
                isEnabled: false,
                isLoading: isLoading,
                id: $0.id,
                title: $0.title,
                value: $0.value
              )
            }
          }
        }
        .padding(.bottom)
        .shimmer(isLoading: isLoading)
      }
    }
  }
}
