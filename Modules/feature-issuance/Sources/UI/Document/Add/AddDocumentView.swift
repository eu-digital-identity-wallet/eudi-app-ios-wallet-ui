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
import feature_common
import logic_resources

public struct AddDocumentView<Router: RouterHost>: View {

  @ObservedObject var viewModel: AddDocumentViewModel<Router>

  var contentSize: CGFloat = 0.0

  public init(
    with router: Router,
    and interactor: AddDocumentInteractor,
    deeplinkController: DeepLinkController,
    config: any UIConfigType
  ) {
    self.viewModel = AddDocumentViewModel(
      router: router,
      interactor: interactor,
      deepLinkController: deeplinkController,
      config: config
    )
    self.contentSize = getScreenRect().width / 2.0
  }

  public var body: some View {
    ContentScreenView(
      padding: .zero,
      canScroll: true,
      errorConfig: viewModel.viewState.error
    ) {

      if viewModel.viewState.isFlowCancellable {
        ContentHeaderView(dismissIcon: Theme.shared.image.xmark) {
          viewModel.pop()
        }
        .padding([.top, .horizontal], Theme.shared.dimension.padding)
      }

      content()

      scanFooter
    }
    .task {
      await self.viewModel.initialize()
    }
  }

  @ViewBuilder
  private func content() -> some View {
    ScrollView {
      VStack(spacing: .zero) {

        ContentTitleView(
          title: .addDocumentTitle,
          caption: .addDocumentSubtitle,
          titleColor: Theme.shared.color.textPrimaryDark,
          topSpacing: viewModel.viewState.isFlowCancellable ? .withToolbar : .withoutToolbar
        )

        VSpacer.large()

        ForEach(viewModel.viewState.addDocumentCellModels) { cell in
          AddNewDocumentCellView(
            isEnabled: cell.isEnabled,
            icon: cell.image,
            title: cell.documentName,
            isLoading: cell.isLoading,
            action: {
              viewModel.onClick(for: cell.type)
            }
          )
          .padding(.bottom, Theme.shared.shape.small)
        }
      }
      .padding(.horizontal, Theme.shared.dimension.padding)
    }
  }

  private var scanFooter: some View {
    VStack(spacing: SPACING_MEDIUM) {

      Spacer()

      Text(.or)
        .typography(Theme.shared.font.bodyMedium)
        .foregroundColor(Theme.shared.color.textSecondaryDark )
        .shimmer(isLoading: viewModel.viewState.isLoading)

      Button(
        action: { self.viewModel.onScanClick() },
        label: {

          HStack {

            Spacer()

            VStack(alignment: .center) {

              Theme.shared.image.qrScan
                .resizable()
                .renderingMode(.template)
                .scaledToFit()
                .foregroundStyle(Theme.shared.color.primary)
                .frame(height: contentSize / 6)

              Text(.issuanceScanQr)
                .typography(Theme.shared.font.titleSmall)
                .foregroundColor(Theme.shared.color.textPrimaryDark )
            }
            .padding(.vertical)

            Spacer()
          }

        }
      )
      .background(Theme.shared.color.backgroundDefault)
      .roundedCorner(SPACING_MEDIUM_SMALL, corners: .allCorners)
      .padding(.horizontal)
      .disabled(viewModel.viewState.isLoading)
      .shimmer(isLoading: viewModel.viewState.isLoading)

      Spacer()
    }
    .frame(maxWidth: .infinity, maxHeight: contentSize)
    .background(Theme.shared.color.backgroundDefault.opacity(0.8))
    .roundedCorner(SPACING_MEDIUM, corners: [.topLeft, .topRight])
  }
}
