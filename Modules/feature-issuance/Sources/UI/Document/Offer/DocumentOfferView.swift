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

struct DocumentOfferView<Router: RouterHost>: View {

  @StateObject private var viewModel: DocumentOfferViewModel<Router>

  init(with viewModel: DocumentOfferViewModel<Router>) {
    self._viewModel = StateObject(wrappedValue: viewModel)
  }

  var body: some View {
    ContentScreenView(
      errorConfig: viewModel.viewState.error,
      navigationTitle: .addDocumentRequest,
      toolbarContent: viewModel.toolbarContent(),
      notificationAction: .init(
        name: NSNotification.CredentialOffer,
        callback: {
          guard let payload = $0 else { return }
          viewModel.handleNotification(with: payload)
        }
      )
    ) {
      content(
        viewState: viewModel.viewState
      )
    }
    .task {
      await viewModel.initialize()
    }
  }
}

@MainActor
@ViewBuilder
private func content(
  viewState: DocumentOfferViewState
) -> some View {
  if viewState.documentOfferUiModel.uiOffers.isEmpty {
    noDocumentsFound(viewState: viewState)
  } else {
    scrollableContent(viewState: viewState)
  }
}

@MainActor
@ViewBuilder
private func scrollableContent(
  viewState: DocumentOfferViewState
) -> some View {
  ScrollView {
    VStack(spacing: .zero) {

      ContentHeaderView(
        config: viewState.contentHeaderConfig
      )

      VStack(alignment: .leading, spacing: SPACING_MEDIUM) {

        ForEach(viewState.documentOfferUiModel.uiOffers) { cell in
          WrapCardView {
            DocumentOfferCellView(
              cellModel: cell,
              isLoading: viewState.isLoading
            )
          }
        }

        Text(.shareDataReview)
          .typography(Theme.shared.font.bodyMedium)
          .foregroundColor(Theme.shared.color.onSurface)
          .multilineTextAlignment(.leading)
          .shimmer(isLoading: viewState.isLoading)

        VSpacer.medium()
      }
    }
  }
}

@MainActor
@ViewBuilder
private func noDocumentsFound(
  viewState: DocumentOfferViewState
) -> some View {
  VStack(spacing: .zero) {
    ContentHeaderView(
      config: viewState.contentHeaderConfig
    )
    Spacer()
    ContentEmptyView(
      title: .requestCredentialOfferNoDocument
    )
    Spacer()
  }
}

#Preview {
  let viewState = DocumentOfferViewState(
    isLoading: false,
    documentOfferUiModel: DocumentOfferUIModel.mock(),
    error: nil,
    config: UIConfig.Generic(
      arguments: ["uri": "uri"],
      navigationSuccessType: .push(.featureDashboardModule(.dashboard)),
      navigationCancelType: .pop
    ),
    offerUri: "offer uri",
    allowIssue: true,
    initialized: true,
    contentHeaderConfig: .init(
      appIconAndTextData: AppIconAndTextData(
        appIcon: ThemeManager.shared.image.logoEuDigitalIndentityWallet,
        appText: ThemeManager.shared.image.euditext
      )
    )
  )

  ContentScreenView {
    content(
      viewState: viewState
    )
  }
}

#Preview("No document") {
  let viewState = DocumentOfferViewState(
    isLoading: false,
    documentOfferUiModel: .init(
      issuerName: LocalizableStringKey.unknownIssuer.toString,
      issuerLogo: nil,
      txCode: nil,
      uiOffers: [],
      docOffers: []
    ),
    error: nil,
    config: UIConfig.Generic(
      arguments: ["uri": "uri"],
      navigationSuccessType: .push(.featureDashboardModule(.dashboard)),
      navigationCancelType: .pop
    ),
    offerUri: "offer uri",
    allowIssue: true,
    initialized: true,
    contentHeaderConfig: .init(
      appIconAndTextData: AppIconAndTextData(
        appIcon: ThemeManager.shared.image.logoEuDigitalIndentityWallet,
        appText: ThemeManager.shared.image.euditext
      )
    )
  )

  ContentScreenView {
    content(
      viewState: viewState
    )
  }
}
