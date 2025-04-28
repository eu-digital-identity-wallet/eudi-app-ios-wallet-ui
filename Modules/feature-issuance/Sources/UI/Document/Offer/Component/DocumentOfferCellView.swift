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
import logic_ui

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
      WrapListItemView(
        listItem: cellModel.listItem
      )
      .disabled(isLoading)
      .shimmer(isLoading: isLoading)
    }
  }
}

#Preview {
  DocumentOfferCellView(
    cellModel: DocumentOfferUIModel.UIOffer(
      listItem: .init(mainText: .custom("Name")),
      documentName: "Name"
    ),
    isLoading: false
  )
}
