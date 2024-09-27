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
import logic_ui
import logic_core

extension DocumentOfferView {
  struct DocumentOfferCellView: View {

    typealias Cell = DocumentOfferUIModel.UIOffer

    let cellModel: Cell
    let isLoading: Bool

    init(cellModel: Cell, isLoading: Bool) {
      self.cellModel = cellModel
      self.isLoading = isLoading
    }

    var body: some View {
      HStack {
        HStack(spacing: .zero) {

          HStack(spacing: SPACING_SMALL) {

            Theme.shared.image.id
              .resizable()
              .scaledToFit()
              .frame(width: 45)

            Text(cellModel.title)
              .typography(Theme.shared.font.titleMedium)
              .foregroundStyle(Theme.shared.color.black)

          }
          .padding([.horizontal, .vertical], SPACING_SMALL)
          .background(Theme.shared.color.secondary)
          .roundedCorner(Theme.shared.shape.small, corners: .allCorners)

          Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: 50)
        .padding(.bottom)
        .disabled(isLoading)
        .shimmer(isLoading: isLoading)
      }
    }
  }
}

#Preview {
  DocumentOfferView<PreviewRouter>.DocumentOfferCellView(
    cellModel: DocumentOfferUIModel.UIOffer(
      documentName: "Name",
      documentType: DocumentTypeIdentifier.PID
    ),
    isLoading: false
  )
}
