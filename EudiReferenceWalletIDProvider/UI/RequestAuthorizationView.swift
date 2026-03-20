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
import IdentityDocumentServices
import IdentityDocumentServicesUI
import MdocDataModel18013
import WalletStorage
import DcApi18013AnnexC
import feature_common
import logic_ui

struct RequestAuthorizationView<Router: RouterHost>: View {

  @State private var viewModel: RequestAuthorizationViewModel<Router>

  init(with viewModel: RequestAuthorizationViewModel<Router>) {
    self._viewModel = State(wrappedValue: viewModel)
  }

  var body: some View {
    VStack(alignment: .center) {
      if viewModel.viewState.errorMessage != nil {
        noDocumentsFound()
      } else if let requestSet = viewModel.viewState.documents,
                let websiteName = viewModel.viewState.websiteName {
        contentView(requestSet: requestSet, websiteName: websiteName)
      } else {
        noDocumentsFound()
      }
    }
    .frame(maxWidth: .infinity)
    .padding()
    .task {
      await viewModel.loadRequest()
    }
  }

  @ViewBuilder
  private func contentView(
    requestSet: [AuthorizationUIDocument],
    websiteName: String
  ) -> some View {
    ScrollView {
      VStack(spacing: .zero) {
        ContentHeaderView(
          config: viewModel.viewState.contentHeaderConfig,
          accessibilityDescription: BaseRequestLocators.description
        )

        VStack(alignment: .leading, spacing: SPACING_MEDIUM) {

          ForEach(requestSet, id: \.self) { request in
            WrapCardView {
              WrapListItemView(
                listItem: .init(
                  mainContent: .text(.custom(request.documentName))
                )
              )
            }
          }

          Text(.shareDataReview)
            .typography(Theme.shared.font.bodyMedium)
            .foregroundColor(Theme.shared.color.onSurface)
            .multilineTextAlignment(.leading)
        }
        .shimmer(isLoading: viewModel.viewState.isLoading)
      }
    }
    .safeAreaInset(edge: .bottom) {
      actionButtons()
    }
  }

  @ViewBuilder
  private func noDocumentsFound() -> some View {
    VStack(spacing: .zero) {
      ContentHeaderView(
        config: viewModel.viewState.contentHeaderConfig,
        accessibilityDescription: BaseRequestLocators.description
      )
      VStack(spacing: .zero) {
        Spacer()
        if let errorMessage = viewModel.viewState.errorMessage {
          ContentEmptyView(
            title: .custom(errorMessage)
          )
        } else {
          ContentEmptyView(
            title: .requestDataNoDocument
          )
        }
        Spacer()
      }
      .padding(.horizontal, Theme.shared.dimension.padding)
    }
  }

  @ViewBuilder
  private func actionButtons() -> some View {
    VStack(alignment: .center, spacing: SPACING_SMALL) {
      if viewModel.viewState.errorMessage == nil {
        acceptButton()
      }

      cancelButton()
    }
    .frame(maxWidth: .infinity)
  }

  @ViewBuilder
  private func acceptButton() -> some View {
    WrapButtonView(
      style: .primary,
      title: .documentProviderExtensionAcceptButton,
      onAction: {
        viewModel.acceptVerification()
      }()
    )
  }

  @ViewBuilder
  private func cancelButton() -> some View {
    WrapButtonView(
      style: .error,
      title: .documentProviderExtensionRejectButton,
      onAction: {
        viewModel.cancelRequest()
      }()
    )
  }
}
