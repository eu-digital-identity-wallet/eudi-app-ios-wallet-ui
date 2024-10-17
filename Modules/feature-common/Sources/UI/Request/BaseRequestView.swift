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
    ContentScreenView(errorConfig: viewModel.viewState.error) {
      content(
        viewState: viewModel.viewState,
        getScreenRect: getScreenRect(),
        getRelyingParty: viewModel.getRelyingParty(),
        getTitleCaption: viewModel.getTitleCaption(),
        getTitle: viewModel.getTitle(),
        getCaption: viewModel.getCaption(),
        getDataRequestInfo: viewModel.getDataRequestInfo(),
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
    .sheetDialog(isPresented: $viewModel.isCancelModalShowing) {
      SheetContentView {
        VStack(spacing: SPACING_MEDIUM) {

          ContentTitleView(
            title: .cancelShareSheetTitle,
            caption: .cancelShareSheetCaption
          )

          WrapButtonView(style: .primary, title: .cancelShareSheetContinue, onAction: viewModel.onShowCancelModal())
          WrapButtonView(style: .secondary, title: .cancelButton, onAction: viewModel.onPop())
        }
      }
    }
    .sheetDialog(isPresented: $viewModel.isRequestInfoModalShowing) {
      SheetContentView {
        VStack(spacing: SPACING_MEDIUM) {

          ContentTitleView(
            title: .requestDataInfoNotice,
            caption: .requestDataSheetCaption
          )

          WrapButtonView(style: .primary, title: .okButton, onAction: viewModel.onShowRequestInfoModal())
        }
      }
    }
    .sheetDialog(isPresented: $viewModel.isVerifiedEntityModalShowing) {
      SheetContentView {
        VStack(spacing: SPACING_MEDIUM) {

          ContentTitleView(
            title: viewModel.getTrustedRelyingParty(),
            caption: viewModel.getTrustedRelyingPartyInfo()
          )

          WrapButtonView(style: .primary, title: .okButton, onAction: viewModel.onVerifiedEntityModal())
        }
      }
    }
    .task {
      if !viewModel.viewState.initialized {
        await viewModel.doWork()
      }
    }
  }
}

@MainActor
@ViewBuilder
private func content(
  viewState: RequestViewState,
  getScreenRect: CGRect,
  getRelyingParty: String,
  getTitleCaption: String,
  getTitle: LocalizableString.Key,
  getCaption: LocalizableString.Key,
  getDataRequestInfo: LocalizableString.Key,
  onShowRequestInfoModal: @escaping () -> Void,
  onVerifiedEntityModal: @escaping () -> Void,
  onContentVisibilityChange: @escaping () -> Void,
  onShare: @escaping () -> Void,
  onShowCancelModal: @escaping () -> Void,
  onSelectionChanged: @escaping (String) -> Void
) -> some View {
  if viewState.isTrusted {
    ContentTitleView(
      titleDecoration: .icon(
        decorated: getRelyingParty,
        icon: Theme.shared.image.checkMarkSealFill,
        text: getTitleCaption
      ),
      decorationColor: Theme.shared.color.success,
      topSpacing: .withoutToolbar,
      onTap: {
        onVerifiedEntityModal()
      }
    )
  } else {
    ContentTitleView(
      title: getTitle,
      topSpacing: .withoutToolbar
    )
  }

  VSpacer.extraSmall()

  HStack {

    let titleText = Text(getCaption)
      .foregroundColor(Theme.shared.color.textSecondaryDark)

    let whyInfoText = Text(getDataRequestInfo)
      .foregroundColor(Theme.shared.color.textPrimaryDark)

    Text("\(titleText) \(whyInfoText)")
      .typography(Theme.shared.font.bodyMedium)
      .onTapGesture { onShowRequestInfoModal() }

    Spacer()

    visibilityIcon(viewState: viewState) {
      onContentVisibilityChange()
    }
  }

  VSpacer.small()

  if viewState.items.isEmpty {
    noDocumentsFound(getScreenRect: getScreenRect)
  } else {
    ScrollView {
      VStack(spacing: .zero) {

        ForEach(viewState.items.indices, id: \.self) { index in

          let item = viewState.items[index]
          let nextItem: RequestDataUIModel? = (index + 2) < viewState.items.count
          ? viewState.items[index + 1]
          : nil

          if index > 0 {
            VSpacer.small()
          }

          RequestDataCellView(
            cellModel: item,
            isLoading: viewState.isLoading
          ) { id in
            onSelectionChanged(id)
          }

          if (index + 1) < viewState.items.count,
             item.isDataSection == nil,
             item.isDataVerification == nil,
             nextItem?.isDataRow != nil {
            Divider()
          }

          VSpacer.small()
        }
      }
      .padding(.top)
    }
    .bottomFade()

    Spacer()

    footer(viewState: viewState) {
      onShare()
    } onShowCancelModal: {
      onShowCancelModal()
    }
  }
}

@MainActor
@ViewBuilder
private func visibilityIcon(
  viewState: RequestViewState,
  onContentVisibilityChange: @escaping () -> Void
) -> some View {

  let image = switch viewState.isContentVisible {
  case true:
    Theme.shared.image.eyeSlash
  case false:
    Theme.shared.image.eye
  }

  image
    .foregroundStyle(Theme.shared.color.primary)
    .onTapGesture {
      onContentVisibilityChange()
    }
    .disabled(viewState.isLoading)
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
        .foregroundStyle(Theme.shared.color.textSecondaryDark)
        .frame(width: imageSize, height: imageSize)

      Text(.requestDataNoDocument)
        .typography(Theme.shared.font.bodyMedium)
        .foregroundColor(Theme.shared.color.textSecondaryDark)
        .multilineTextAlignment(.center)
    }

    Spacer()
  }
}

@MainActor
@ViewBuilder
private func footer(
  viewState: RequestViewState,
  onShare: @escaping () -> Void,
  onShowCancelModal: @escaping () -> Void
) -> some View {
  VStack(spacing: SPACING_MEDIUM) {
    missingCredentials(itemsAreAllSelected: viewState.itemsAreAllSelected)
    WrapButtonView(
      style: .primary,
      title: .shareButton,
      isLoading: viewState.isLoading,
      isEnabled: viewState.allowShare && !viewState.isLoading,
      onAction: onShare()
    )
    WrapButtonView(
      style: .secondary,
      title: .cancelButton,
      onAction: onShowCancelModal()
    )
  }
  .animation(.easeInOut, value: viewState.itemsAreAllSelected)
}

@MainActor
@ViewBuilder
private func missingCredentials(itemsAreAllSelected: Bool) -> some View {
  if !itemsAreAllSelected {
    HStack(spacing: SPACING_MEDIUM) {

      Theme.shared.image.warning
        .resizable()
        .renderingMode(.template)
        .scaledToFit()
        .frame(width: 35)
        .foregroundStyle(Theme.shared.color.warning)

      Text(.incompleteRequestDataSelection)
        .typography(Theme.shared.font.bodyMedium)
        .foregroundStyle(Theme.shared.color.textPrimaryDark)
    }
    .padding()
    .frame(maxWidth: .infinity)
    .overlay(
      RoundedRectangle(cornerRadius: 15)
        .foregroundStyle(Theme.shared.color.warning.opacity(0.12))
    )
  }
}

#Preview {
  let viewState = RequestViewState(
    isLoading: false,
    error: nil,
    isContentVisible: true,
    itemsAreAllSelected: true,
    items: RequestDataUiModel.mock(),
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
      getTitleCaption: "",
      getTitle: viewState.title,
      getCaption: .requestDataCaption,
      getDataRequestInfo: .requestDataVerifiedEntityMessage,
      onShowRequestInfoModal: {},
      onVerifiedEntityModal: {},
      onContentVisibilityChange: {},
      onShare: {},
      onShowCancelModal: {},
      onSelectionChanged: { _ in }
    )
  }
}
