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
import feature_common
import logic_core

struct DocumentSuccessView<Router: RouterHost>: View {

  @ObservedObject var viewModel: DocumentSuccessViewModel<Router>

  init(with viewModel: DocumentSuccessViewModel<Router>) {
    self.viewModel = viewModel
  }

  var body: some View {
    ContentScreenView {
      content(viewState: viewModel.viewState) {
        viewModel.onIssue()
      }
    }
    .task {
      await viewModel.initialize()
    }
  }
}

@MainActor
@ViewBuilder
private func content(
  viewState: DocumentSuccessState,
  onIssue: @escaping () -> Void
) -> some View {
  ContentTitleView(
    title: viewState.title,
    caption: viewState.caption,
    titleColor: Theme.shared.color.success,
    topSpacing: .withoutToolbar
  )

  VSpacer.large()

  document(holderName: viewState.holderName)

  Spacer()

  footer {
    onIssue()
  }
}

@MainActor
@ViewBuilder
private func footer(action: @escaping () -> Void) -> some View {
  WrapButtonView(
    style: .primary,
    title: .issuanceSuccessNextButton,
    onAction: action()
  )
}

@MainActor
@ViewBuilder
private func document(holderName: String?) -> some View {
  VStack(spacing: SPACING_MEDIUM) {

    HStack {

      Theme.shared.image.user
        .roundedCorner(Theme.shared.shape.small, corners: .allCorners)

      Theme.shared.image.idStroke
        .roundedCorner(Theme.shared.shape.small, corners: .allCorners)
        .padding(.leading, -40)

      Spacer()
    }

    HStack {
      if let holderName {
        Text(holderName)
          .typography(Theme.shared.font.bodyLarge)
          .foregroundColor(Theme.shared.color.black)
      }

      Spacer()
    }
  }
  .padding(SPACING_MEDIUM_LARGE)
  .frame(maxWidth: .infinity)
  .background(Theme.shared.color.secondary)
  .roundedCorner(Theme.shared.shape.small, corners: .allCorners)
}

#Preview {
  let viewState = DocumentSuccessState(
    title: .success,
    caption: .issuanceSuccessCaption(
      ["DocumentTitle"]
    ),
    holderName: "Name",
    config: IssuanceFlowUiConfig(flow: .noDocument),
    documentIdentifier: "id"
  )

  ContentScreenView {
    content(viewState: viewState) {}
  }
}
