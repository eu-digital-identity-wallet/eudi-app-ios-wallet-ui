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
import logic_resources
import logic_business
import feature_common
import logic_core

struct SignDocumentView<Router: RouterHost>: View {

  @ObservedObject private var viewModel: SignDocumentViewModel<Router>

  public init(with viewModel: SignDocumentViewModel<Router>) {
    self.viewModel = viewModel
  }

  var body: some View {
    ContentScreenView(
      padding: .zero
    ) {
      ContentHeaderView(dismissIcon: Theme.shared.image.xmark) {
        viewModel.pop()
      }
      .padding([.top, .horizontal], Theme.shared.dimension.padding)

      content(viewState: viewModel.viewState) {
        viewModel.launchRQESSdk()
      }

      Spacer()
    }
  }
}

@MainActor
@ViewBuilder
private func content(
  viewState: SignDocumentState,
  action: @escaping () -> Void
) -> some View {
  VStack(spacing: .zero) {
    ContentTitleView(
      title: .signDocument,
      caption: .signDocumentSubtitle,
      titleColor: Theme.shared.color.textPrimaryDark
    )

    VSpacer.large()

    AddNewDocumentCellView(
      isEnabled: viewState.selectDocumentCard.isEnabled,
      icon: viewState.selectDocumentCard.image,
      title: viewState.selectDocumentCard.documentName,
      isLoading: false,
      action: {
        action()
      }
    )
  }
  .padding(.horizontal, Theme.shared.dimension.padding)
}
