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

struct DashboardView<Router: RouterHost>: View {

  @ObservedObject private var viewModel: DashboardViewModel<Router>
  @Environment(\.scenePhase) var scenePhase

  public init(with viewModel: DashboardViewModel<Router>) {
    self.viewModel = viewModel
  }

  var body: some View {
    ContentScreenView(
      padding: .zero,
      canScroll: false,
      background: Theme.shared.color.secondary
    ) {
      content(
        viewState: viewModel.viewState,
        onMore: viewModel.onMore,
        onDocumentDetails: { id in
          viewModel.onDocumentDetails(documentId: id)
        },
        onDeleteDeferredDocument: { doc in
          viewModel.onDeleteDeferredDocument(with: doc)
        },
        onAdd: viewModel.onAdd,
        onShare: viewModel.onShare
      )
    }
    .sheetDialog(isPresented: $viewModel.isMoreModalShowing) {
      SheetContentView {
        VStack(spacing: .zero) {

          ContentTitleView(
            title: .moreOptions
          )

          VSpacer.medium()

          ForEach(viewModel.viewState.moreOptions, id: \.id) { option in

            switch option {
            case .changeQuickPin:
              WrapButtonView(
                title: .changeQuickPinOption,
                backgroundColor: .clear,
                icon: Theme.shared.image.pencil,
                gravity: .start,
                onAction: viewModel.onUpdatePin()
              )
            case .scanQrCode:
              WrapButtonView(
                title: .scanQrCode,
                backgroundColor: .clear,
                icon: Theme.shared.image.qrScan,
                gravity: .start,
                onAction: viewModel.onShowScanner()
              )
            case .signDocument:
              WrapButtonView(
                title: .signDocument,
                backgroundColor: .clear,
                icon: Theme.shared.image.signDocument,
                gravity: .start,
                onAction: viewModel.openSignDocument()
              )
            case .retrieveLogs(let url):
              shareLogs(with: url)
            }

          }

          HStack {
            Spacer()
            Text(viewModel.viewState.appVersion)
              .typography(Theme.shared.font.bodyMedium)
              .foregroundColor(Theme.shared.color.textSecondaryDark)
            Spacer()
          }
        }
      }
    }
    .sheetDialog(isPresented: $viewModel.isBleModalShowing) {
      SheetContentView {
        VStack(spacing: SPACING_MEDIUM) {

          ContentTitleView(
            title: .bleDisabledModalTitle,
            caption: .bleDisabledModalCaption
          )

          WrapButtonView(style: .primary, title: .bleDisabledModalButton, onAction: viewModel.onBleSettings())
          WrapButtonView(style: .secondary, title: .cancelButton, onAction: viewModel.toggleBleModal())
        }
      }
    }
    .sheetDialog(isPresented: $viewModel.isDeleteDeferredModalShowing) {
      SheetContentView {
        VStack(spacing: SPACING_MEDIUM) {

          ContentTitleView(
            title: .issuanceDetailsDeletionTitle([viewModel.viewState.pendingDocumentTitle]),
            caption: .issuanceDetailsDeletionCaption([viewModel.viewState.pendingDocumentTitle])
          )

          WrapButtonView(
            style: .primary,
            title: .yes,
            onAction: viewModel.deleteDeferredDocument()
          )
          WrapButtonView(
            style: .secondary,
            title: .no,
            onAction: viewModel.toggleDeleteDeferredModal()
          )
        }
      }
    }
    .sheetDialog(isPresented: $viewModel.isSuccededDocumentsModalShowing) {
      SheetContentView {
        VStack(spacing: SPACING_MEDIUM) {

          ContentTitleView(
            title: .deferredDocumentsIssuedModalTitle,
            caption: .defferedDocumentsIssuedModalCaption
          )

          deferredSuccessList()
        }
      }
    }
    .task {
      await viewModel.fetch()
    }
    .onChange(of: scenePhase) { phase in
      self.viewModel.setPhase(with: phase)
    }
    .onDisappear {
      self.viewModel.onPause()
    }
  }

  @ViewBuilder
  func deferredSuccessList() -> some View {
    VStack(spacing: SPACING_SMALL) {
      ForEach(viewModel.viewState.succededIssuedDocuments) { item in

        HStack {
          Text(.custom(item.value.title))
            .typography(Theme.shared.font.bodyMedium)
            .foregroundColor(Theme.shared.color.textPrimaryDark)

          Spacer()

          Theme.shared.image.chevronRight
            .renderingMode(.template)
            .foregroundStyle(Theme.shared.color.primary)
        }
        .padding()
        .background(Theme.shared.color.backgroundDefault)
        .clipShape(.rect(cornerRadius: 8))
        .onTapGesture {
          viewModel.onDocumentDetails(documentId: item.value.id)
        }

      }
    }
    .padding(.vertical)
  }

  @ViewBuilder
  func shareLogs(with fileUrl: URL) -> some View {
    ShareLink(item: fileUrl) {
      HStack {

        Theme.shared.image.share
          .resizable()
          .scaledToFit()
          .frame(width: 25, height: 25)
          .foregroundColor(Theme.shared.color.primary)

        HSpacer.medium()

        Text(.retrieveLogs)
          .typography(Theme.shared.font.labelLarge)
          .foregroundColor(Theme.shared.color.textPrimaryDark)

        Spacer()
      }
      .padding()
    }
  }
}

@MainActor
@ViewBuilder
private func content(
  viewState: DashboardState,
  onMore: @escaping () -> Void,
  onDocumentDetails: @escaping (String) -> Void,
  onDeleteDeferredDocument: @escaping (DocumentUIModel) -> Void,
  onAdd: @escaping () -> Void,
  onShare: @escaping () -> Void
) -> some View {
  BearerHeaderView(
    item: viewState.bearer,
    isLoading: viewState.isLoading,
    isMoreOptionsEnabled: viewState.allowUserInteraction,
    onMoreClicked: onMore()
  )

  VStack(spacing: .zero) {

    DocumentListView(
      items: viewState.documents,
      isLoading: viewState.isLoading
    ) { document in
      switch document.value.state {
      case .issued:
        onDocumentDetails(document.value.id)
      case .pending, .failed:
        onDeleteDeferredDocument(document)
      }
    }
    .bottomFade()

    if viewState.allowUserInteraction {

      FloatingActionButtonBarView(
        isLoading: viewState.isLoading,
        addAction: onAdd(),
        shareAction: onShare()
      )

      VSpacer.small()

    }
  }
  .background(Theme.shared.color.backgroundPaper)
}

#Preview {
  let viewState = DashboardState(
    isLoading: false,
    documents: DocumentUIModel.mocks(),
    bearer: BearerUIModel.mock(),
    phase: .active,
    pendingBleModalAction: false,
    appVersion: "App version",
    allowUserInteraction: true,
    pendingDeletionDocument: nil,
    succededIssuedDocuments: [],
    failedDocuments: [],
    moreOptions: [.changeQuickPin, .scanQrCode]
  )

  ContentScreenView(
    padding: .zero,
    canScroll: false,
    background: Theme.shared.color.secondary
  ) {
    content(
      viewState: viewState,
      onMore: {},
      onDocumentDetails: { _ in },
      onDeleteDeferredDocument: { _ in },
      onAdd: {},
      onShare: {}
    )
  }
}
