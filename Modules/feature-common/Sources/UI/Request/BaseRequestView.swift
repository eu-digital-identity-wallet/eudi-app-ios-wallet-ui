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
      errorConfig: viewModel.viewState.error,
      navigationTitle: LocalizableString.shared.get(with: .dataSharingRequest),
      toolbarContent: ToolBarContent(
        trailingActions: [
          Action(
            title: LocalizableString.shared.get(with: .shareButton).capitalizedFirst(),
            disabled: !viewModel.viewState.allowShare
          ) {
            viewModel.onShare()
          }
        ],
        leadingActions: [
          Action(
            title: LocalizableString.shared.get(with: .cancelButton).capitalizedFirst()) {
              viewModel.onShowCancelModal()
            }
        ]
      )
    ) {
      content(
        viewState: viewModel.viewState,
        getScreenRect: getScreenRect(),
        getRelyingParty: viewModel.getRelyingParty(),
        getTitle: viewModel.getTitle(),
        getCaption: viewModel.getCaption(),
        onShowRequestInfoModal: viewModel.onShowRequestInfoModal,
        onVerifiedEntityModal: viewModel.onVerifiedEntityModal,
        onContentVisibilityChange: viewModel.onContentVisibilityChange,
        onShare: viewModel.onShare,
        onShowCancelModal: viewModel.onShowCancelModal,
        onSelectionChanged: { id in
          viewModel.onSelectionChanged(id: id)
        }
      )
    }
    .confirmationDialog(
      title: LocalizableString.shared.get(with: .cancelShareSheetTitle),
      message: LocalizableString.shared.get(with: .cancelShareSheetCaption),
      destructiveText: LocalizableString.shared.get(with: .cancelButton),
      baseText: LocalizableString.shared.get(with: .cancelShareSheetContinue),
      isPresented: $viewModel.isCancelModalShowing,
      destructiveAction: {
        viewModel.onPop()
      },
      baseAction: {
        viewModel.onShowCancelModal()
      }
    )
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
  getRelyingParty: String,
  getTitle: LocalizableString.Key,
  getCaption: LocalizableString.Key,
  onShowRequestInfoModal: @escaping () -> Void,
  onVerifiedEntityModal: @escaping () -> Void,
  onContentVisibilityChange: @escaping () -> Void,
  onShare: @escaping () -> Void,
  onShowCancelModal: @escaping () -> Void,
  onSelectionChanged: @escaping (String) -> Void
) -> some View {
  ScrollView {
    if viewState.isTrusted {
      ContentHeader(
        config: ContentHeaderConfig(
          appIconAndTextData: AppIconAndTextData(
            appIcon: ThemeManager.shared.image.logoEuDigitalIndentityWallet,
            appText: ThemeManager.shared.image.euditext
          ),
          description: LocalizableString.shared.get(with: .dataSharingTitle),
          mainText: LocalizableString.shared.get(with: getTitle).uppercased(),
          relyingPartyData: RelyingPartyData(
            isVerified: viewState.isTrusted,
            name: getRelyingParty,
            description: LocalizableString.shared.get(with: getCaption)
          )
        )
      )
    } else {
      ContentHeader(
        config: ContentHeaderConfig(
          appIconAndTextData: AppIconAndTextData(
            appIcon: ThemeManager.shared.image.logoEuDigitalIndentityWallet,
            appText: ThemeManager.shared.image.euditext
          ),
          description: LocalizableString.shared.get(with: viewState.title)
        )
      )
    }

    if viewState.items.isEmpty {
      noDocumentsFound(getScreenRect: getScreenRect)
    } else {

      VStack(alignment: .leading, spacing: SPACING_MEDIUM) {
        ForEach(viewState.items, id: \.id) { section in
          ExpandableCardView(
            title: section.requestDataSection.title,
            subtitle: LocalizableString.shared.get(with: .viewDetails)
          ) {
            ForEach(section.requestDataRow ?? [], id: \.id) { item in
              switch item.value {
                case .string(let value):
                  WrapListItemView(
                    listItem: ListItemData(
                      mainText: value,
                      overlineText: item.title,
                      isBlur: item.isVisible,
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
                      isBlur: item.isVisible,
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
            ForEach(section.requestDataVerification ?? [], id: \.id) { item in
              switch item.value {
                case .string(let value):
                  WrapListItemView(
                    listItem: ListItemData(
                      mainText: value,
                      overlineText: item.title,
                      isBlur: item.isVisible,
                      trailingContent: .checkbox(
                        false,
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
                      isBlur: item.isVisible,
                      trailingContent: .checkbox(
                        false,
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
          .typography(Theme.shared.font.bodySmall)
          .foregroundColor(Theme.shared.color.onSurface)
          .multilineTextAlignment(.leading)
      }
    }
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
        .typography(Theme.shared.font.bodyMedium)
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
    isContentVisible: true,
    itemsAreAllSelected: true,
    showMissingCrredentials: false,
    items: RequestDataUiModel.mockData(),
    title: LocalizableString.Key.addDocumentTitle,
    trustedRelyingPartyInfo: .requestDataVerifiedEntityMessage,
    relyingParty: "relying party",
    isTrusted: true,
    allowShare: true,
    originator: .featureDashboardModule(.dashboard),
    initialized: true
  )

  ContentScreenView {
    content(
      viewState: viewState,
      getScreenRect: UIScreen.main.bounds,
      getRelyingParty: "",
      getTitle: viewState.title,
      getCaption: .requestDataCaption,
      onShowRequestInfoModal: {},
      onVerifiedEntityModal: {},
      onContentVisibilityChange: {},
      onShare: {},
      onShowCancelModal: {},
      onSelectionChanged: { _ in }
    )
  }
}
