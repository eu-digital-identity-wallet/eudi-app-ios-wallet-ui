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
      navigationTitle: LocalizableString.shared.get(with: .dataSharingRequest),
      toolbarContent: viewModel.toolbarContent()
    ) {
      content(
        viewState: viewModel.viewState,
        getScreenRect: getScreenRect(),
        onShowRequestInfoModal: viewModel.onShowRequestInfoModal,
        onVerifiedEntityModal: viewModel.onVerifiedEntityModal,
        onShare: viewModel.onShare,
        onSelectionChanged: { id in
          viewModel.onSelectionChanged(id: id)
        }
      )
    }
    .confirmationDialog(
      title: LocalizableString.shared.get(with: .requestDataInfoNotice),
      message: LocalizableString.shared.get(with: .requestDataSheetCaption),
      baseText: LocalizableString.shared.get(with: .okButton).capitalized,
      isPresented: $viewModel.isRequestInfoModalShowing,
      baseAction: {
        viewModel.onShowRequestInfoModal()
      }
    )
    .confirmationDialog(
      title: LocalizableString.shared.get(with: viewModel.getTrustedRelyingParty()),
      message: LocalizableString.shared.get(with: viewModel.getTrustedRelyingPartyInfo()),
      baseText: LocalizableString.shared.get(with: .okButton).capitalized,
      isPresented: $viewModel.isVerifiedEntityModalShowing,
      baseAction: {
        viewModel.onVerifiedEntityModal()
      }
    )
    .task {
      if !viewModel.viewState.initialized {
        await viewModel.doWork()
      }
    }
    .alertView(
      isPresented: $viewModel.itmesChanged,
      title: "",
      message: LocalizableString.shared.get(with: .incompleteRequestDataSelection)
    )
  }
}

@MainActor
@ViewBuilder
private func content(
  viewState: RequestViewState,
  getScreenRect: CGRect,
  onShowRequestInfoModal: @escaping () -> Void,
  onVerifiedEntityModal: @escaping () -> Void,
  onShare: @escaping () -> Void,
  onSelectionChanged: @escaping (String) -> Void
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
            ExpandableCardView(
              title: section.requestDataSection.title,
              subtitle: LocalizableString.shared.get(with: .viewDetails)
            ) {
              ForEach(section.requestDataRow, id: \.id) { item in
                switch item.value {
                case .string(let value):
                  WrapListItemView(
                    listItem: ListItemData(
                      mainText: value,
                      overlineText: item.title,
                      trailingContent: .checkbox(
                        item.isEnabled,
                        item.isSelected
                      ) { _ in
                        onSelectionChanged(item.id)
                      }
                    )
                  )
                case .image(let image):
                  WrapListItemView(
                    listItem: ListItemData(
                      mainText: item.title,
                      leadingIcon: (nil, image),
                      trailingContent: .checkbox(
                        item.isEnabled,
                        item.isSelected
                      ) { _ in
                        onSelectionChanged(item.id)
                      }
                    )
                  )
                }
                Divider()
                  .padding(.horizontal, SPACING_MEDIUM)
                  .background(Theme.shared.color.onSurfaceVariant.opacity(0.2))
              }
            }
            .shimmer(isLoading: viewState.isLoading)
          }

          Text(.shareDataReview)
            .typography(Theme.shared.font.bodyMedium)
            .foregroundColor(Theme.shared.color.onSurface)
            .multilineTextAlignment(.leading)
          VSpacer.medium()
        }
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
    showMissingCrredentials: false,
    items: RequestDataUiModel.mockData(),
    title: LocalizableString.Key.requestDataVerifiedEntity,
    trustedRelyingPartyInfo: .requestDataVerifiedEntityMessage,
    relyingParty: "relying party",
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
      onShowRequestInfoModal: {},
      onVerifiedEntityModal: {},
      onShare: {},
      onSelectionChanged: { _ in }
    )
  }
}
