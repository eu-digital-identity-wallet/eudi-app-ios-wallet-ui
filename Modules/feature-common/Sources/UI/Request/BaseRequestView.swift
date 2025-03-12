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

public struct BaseRequestView<Router: RouterHost>: View {

  @ObservedObject var viewModel: BaseRequestViewModel<Router>

  public init(with router: Router, viewModel: BaseRequestViewModel<Router>) {
    self.viewModel = viewModel
  }

  public var body: some View {
    ContentScreenView(
      padding: .zero,
      canScroll: true,
      errorConfig: viewModel.viewState.error,
      navigationTitle: .dataSharingRequest,
      toolbarContent: viewModel.toolbarContent()
    ) {
      content(
        viewState: viewModel.viewState,
        getScreenRect: getScreenRect(),
        onShare: viewModel.onShare,
        onSelectionChanged: { id in
          Task {
            await viewModel.onSelectionChanged(id: id)
          }
        }
      )
    }
    .confirmationDialog(
      title: .requestDataInfoNotice,
      message: .requestDataSheetCaption,
      baseText: .okButton,
      isPresented: $viewModel.isRequestInfoModalShowing,
      baseAction: viewModel.onShowRequestInfoModal()
    )
    .confirmationDialog(
      title: viewModel.getTrustedRelyingParty(),
      message: viewModel.getTrustedRelyingPartyInfo(),
      baseText: .okButton,
      isPresented: $viewModel.isVerifiedEntityModalShowing,
      baseAction: viewModel.onVerifiedEntityModal()
    )
    .task {
      if !viewModel.viewState.initialized {
        await viewModel.doWork()
      }
    }
    .alertView(
      isPresented: $viewModel.itemsChanged,
      title: .custom(""),
      message: .incompleteRequestDataSelection
    )
  }
}

@MainActor
@ViewBuilder
private func content(
  viewState: RequestViewState,
  getScreenRect: CGRect,
  onShare: @escaping () -> Void,
  onSelectionChanged: @escaping @Sendable (String) -> Void
) -> some View {
  ScrollView {
    VStack(spacing: .zero) {
      ContentHeader(
        config: viewState.contentHeaderConfig
      )

      if viewState.items.isEmpty {
        noDocumentsFound(getScreenRect: getScreenRect)
      } else {
        VStack(alignment: .leading, spacing: SPACING_MEDIUM) {

          ForEach(viewState.items, id: \.id) { section in
            WrapExpandableListView(
              header: .init(
                mainText: .custom(section.section.title),
                supportingText: .viewDetails
              ),
              items: section.section.listItems,
              hideSensitiveContent: false,
              onItemClick: { onSelectionChanged($0.groupId) }
            )
          }

          Text(.shareDataReview)
            .typography(Theme.shared.font.bodyMedium)
            .foregroundColor(Theme.shared.color.onSurface)
            .multilineTextAlignment(.leading)

          VSpacer.medium()
        }
        .padding(.top, Theme.shared.dimension.padding)
        .shimmer(isLoading: viewState.isLoading)
      }
    }
    .padding(Theme.shared.dimension.padding)
  }
}

@MainActor
@ViewBuilder
private func noDocumentsFound(getScreenRect: CGRect) -> some View {
  VStack(alignment: .center) {

    Spacer()

    VStack(alignment: .center, spacing: SPACING_MEDIUM) {

      let imageSize = getScreenRect.width / 4

      Theme.shared.image.exclamationmarkCircle
        .renderingMode(.template)
        .resizable()
        .foregroundStyle(Theme.shared.color.secondaryFixed)
        .frame(width: imageSize, height: imageSize)

      Text(.requestDataNoDocument)
        .typography(Theme.shared.font.bodyLarge)
        .foregroundColor(Theme.shared.color.secondaryFixed)
        .multilineTextAlignment(.center)
    }

    Spacer()
  }
}

#Preview {
  let viewState = RequestViewState(
    isLoading: false,
    error: nil,
    showMissingCredentials: false,
    items: RequestDataUiModel.mockData(),
    trustedRelyingPartyInfo: .requestDataVerifiedEntityMessage,
    relyingParty: .custom("relying party"),
    isTrusted: true,
    allowShare: true,
    originator: .featureDashboardModule(.dashboard),
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
      viewState: viewState,
      getScreenRect: UIScreen.main.bounds,
      onShare: {},
      onSelectionChanged: { _ in }
    )
  }
}
