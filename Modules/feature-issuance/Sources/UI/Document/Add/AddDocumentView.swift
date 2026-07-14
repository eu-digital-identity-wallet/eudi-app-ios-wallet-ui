/*
 * Copyright (c) 2026 European Commission
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
import feature_common
import logic_resources
import logic_core

struct AddDocumentView<Router: RouterHost>: View {

  @State private var viewModel: AddDocumentViewModel<Router>

  init(with viewModel: AddDocumentViewModel<Router>) {
    self._viewModel = State(wrappedValue: viewModel)
  }

  var body: some View {
    ContentScreenView(
      padding: .zero,
      canScroll: true,
      errorConfig: viewModel.viewState.error,
      navigationTitle: .chooseFromList,
      isLoading: viewModel.viewState.isLoading,
      toolbarContent: viewModel.toolbarContent()
    ) {
      AddDocumentViewContainer(
        viewState: viewModel.viewState
      ) { issuerId, configIds, identifier in
        viewModel.onClick(
          issuerId: issuerId,
          configIds: configIds,
          docTypeIdentifier: identifier
        )
      }
    }
    .sheetDialog(isPresented: $viewModel.isIssuerNotTrustedSheetShowing) {
      TrustBlockedSheetContent(
        title: .issuanceBlockedTitle,
        message: .issuanceBlockedMessage,
        onClose: { viewModel.isIssuerNotTrustedSheetShowing = false }
      )
    }
    .task {
      await self.viewModel.initialize()
    }
  }
}

private struct AddDocumentViewContainer: View {

  let viewState: AddDocumentViewState
  let action: (String, [String], DocumentTypeIdentifier) -> Void

  var body: some View {
    if viewState.addDocumentCellModels.isEmpty {
      noDocumentsFound()
    } else {
      content()
    }
  }

  @MainActor
  @ViewBuilder
  private func content() -> some View {
    ScrollView {
      LazyVStack(spacing: SPACING_MEDIUM_SMALL) {

        Text(.chooseFromListTitle)
          .typography(Theme.shared.font.bodyLarge)
          .foregroundStyle(Theme.shared.color.primaryLabel)
          .accessibilityLocator(AddDocumentLocators.subtitle)

        ForEach(viewState.addDocumentCellModels.elements, id: \.key) { pair in

          let issuer = pair.key
          let models = pair.value

          Section(
            header: WrapTextView(
              text: .custom(issuer),
              textConfig: TextConfig(
                font: Theme.shared.font.bodySmall.font,
                color: Theme.shared.color.primaryLabel,
                textAlign: .leading,
                fontWeight: .semibold
              )
            )
            .frame(maxWidth: .infinity, alignment: .leading)
            .shimmer(isLoading: viewState.isLoading)
            .padding(.top, SPACING_MEDIUM_SMALL)
          ) {
            ForEach(models, id: \.id) { cell in
              WrapCardView {
                WrapListItemView(
                  listItem: cell.listItem,
                  locator: AddDocumentLocators.attestation(
                    "\(cell.issuerId)_\(cell.docTypeIdentifier)"
                  ),
                  isLoading: cell.isLoading,
                  action: { action(cell.issuerId, cell.configIds, cell.docTypeIdentifier) }
                )
              }
            }
          }
        }
      }
      .padding(.horizontal, Theme.shared.dimension.padding)
      .padding(.bottom)
    }
    .disabled(viewState.addDocumentCellModels.allSatisfy { $0.value.isEmpty })
  }

  @MainActor
  @ViewBuilder
  private func noDocumentsFound() -> some View {
    VStack(spacing: .zero) {
      Text(.chooseFromListTitle)
        .typography(Theme.shared.font.bodyLarge)
        .foregroundStyle(Theme.shared.color.primaryLabel)

      Spacer()
      ContentEmptyView(
        title: .issuanceAddDocumentNoOptions
      )
      Spacer()
    }
    .padding(.horizontal, Theme.shared.dimension.padding)
  }
}

#Preview {
  let viewState = AddDocumentViewState(
    addDocumentCellModels: AddDocumentUIModel.mocks,
    error: nil,
    config: IssuanceFlowUiConfig(flow: .noDocument)
  )

  AddDocumentViewContainer(
    viewState: viewState
  ) { _, _, _ in }
}
