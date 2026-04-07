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
import logic_ui
import feature_common

struct RequestAuthorizationView: View {

  @State private var viewModel: RequestAuthorizationViewModel

  init(with viewModel: RequestAuthorizationViewModel) {
    self._viewModel = State(wrappedValue: viewModel)
  }

  var body: some View {
    NavigationStack {
      VStack(alignment: .center) {
        if !viewModel.viewState.items.isEmpty {
          contentView(viewState: viewModel.viewState)
        } else {
          noDocumentsFound()
        }
      }
      .navigationDestination(isPresented: $viewModel.showBiometryView) {
        ProviderBiometryView(
          with: .init(
            config: viewModel.createBiometryConfig(),
            onDismiss: { viewModel.showBiometryView = false }
          )
        )
      }
      .shimmer(isLoading: viewModel.viewState.isLoading)
      .frame(maxWidth: .infinity)
      .padding()
      .task {
        await viewModel.loadRequest()
      }
    }
  }

  @ViewBuilder
  private func contentView(
    viewState: RequestAuthorizationViewState
  ) -> some View {
    ScrollView {
      VStack(spacing: .zero) {
        ContentHeaderView(
          config: viewState.contentHeaderConfig
        )

        VStack(alignment: .leading, spacing: SPACING_MEDIUM) {

          ForEach(viewState.items.indices, id: \.self) { index in
            let section = viewState.items[index]
            WrapExpandableListView(
              header: .init(
                mainContent: .text(.custom(section.section.title)),
                supportingText: .viewDetails
              ),
              items: section.section.listItems,
              hideSensitiveContent: false,
              isLoading: viewState.isLoading,
              onItemClick: { viewModel.onSelectionChanged(id: $0.groupId) }
            )
            .accessibilityElement()
            .combineChilrenAccessibility(
              locator: BaseRequestLocators.requestedDocument(index.string)
            )
          }

          Text(.shareDataReview)
            .typography(Theme.shared.font.bodyMedium)
            .foregroundColor(Theme.shared.color.onSurface)
            .multilineTextAlignment(.leading)
        }
        .shimmer(isLoading: viewState.isLoading)
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
        config: viewModel.viewState.contentHeaderConfig
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
      isLoading: viewModel.viewState.isLoading,
      onAction: {
        viewModel.showBiometryView = true
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
