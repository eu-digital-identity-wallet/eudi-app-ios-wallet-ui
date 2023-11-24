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

public struct BaseRequestView<Router: RouterHostType>: View {

  @ObservedObject var viewModel: BaseRequestViewModel<Router>

  public init(with router: Router, viewModel: BaseRequestViewModel<Router>) {
    self.viewModel = viewModel
  }

  public var body: some View {
    ContentScreen(errorConfig: viewModel.viewState.error) {

      if viewModel.viewState.isTrusted {
        ContentTitle(
          titleDecoration: .icon(
            decorated: Text(viewModel.getRelyingParty()),
            icon: Theme.shared.image.checkMarkSealFill,
            text: Text(viewModel.getTitleCaption())
          ),
          decorationColor: Theme.shared.color.success,
          topSpacing: .withoutToolbar,
          onTap: {
            viewModel.onVerifiedEntityModal()
          }
        )
      } else {
        ContentTitle(
          title: viewModel.getTitle(),
          topSpacing: .withoutToolbar
        )
      }

      VSpacer.extraSmall()

      HStack {

        let titleText = Text(viewModel.getCaption())
          .foregroundColor(ThemeManager.shared.color.textSecondaryDark)

        let whyInfoText = Text(viewModel.getDataRequestInfo())
          .foregroundColor(ThemeManager.shared.color.textPrimaryDark)

        Text("\(titleText) \(whyInfoText)")
          .typography(ThemeManager.shared.font.bodyMedium)
          .onTapGesture { viewModel.onShowRequestInfoModal() }

        Spacer()

        visibilityIcon
      }

      VSpacer.small()

      ScrollView {
        VStack(spacing: .zero) {

          ForEach(viewModel.viewState.items.indices, id: \.self) { index in

            let item = viewModel.viewState.items[index]
            let nextItem: RequestDataCell? = (index + 2) < viewModel.viewState.items.count
            ? viewModel.viewState.items[index + 1]
            : nil

            if index > 0 {
              VSpacer.small()
            }

            RequestDataCellView(
              cellModel: item,
              isLoading: viewModel.viewState.isLoading
            ) { id in
              viewModel.onSelectionChanged(id: id)
            }

            if (index + 1) < viewModel.viewState.items.count,
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

      footer
    }
    .sheetDialog(isPresented: $viewModel.isCancelModalShowing) {
      VStack(spacing: SPACING_MEDIUM) {

        ContentTitle(
          title: .cancelShareSheetTitle,
          caption: .cancelShareSheetCaption
        )

        WrapButtonView(style: .primary, title: .cancelShareSheetContinue, onAction: viewModel.onShowCancelModal())
        WrapButtonView(style: .secondary, title: .cancelButton, onAction: viewModel.onPop())
      }
    }
    .sheetDialog(isPresented: $viewModel.isRequestInfoModalShowing) {
      VStack(spacing: SPACING_MEDIUM) {

        ContentTitle(
          title: .requestDataInfoNotice,
          caption: .requestDataSheetCaption
        )

        WrapButtonView(style: .primary, title: .okButton, onAction: viewModel.onShowRequestInfoModal())
      }
    }
    .sheetDialog(isPresented: $viewModel.isVerifiedEntityModalShowing, {
      VStack(spacing: SPACING_MEDIUM) {

        ContentTitle(
          title: viewModel.getTrustedRelyingParty(),
          caption: viewModel.getTrustedRelyingPartyInfo()
        )

        WrapButtonView(style: .primary, title: .okButton, onAction: viewModel.onShowRequestInfoModal())
      }
    })
    .task {
      await viewModel.doWork()
    }
  }

  var visibilityIcon: some View {

    let image = switch viewModel.viewState.isContentVisible {
    case true:
      ThemeManager.shared.image.eye
    case false:
      ThemeManager.shared.image.eyeSlash
    }

    return image
      .foregroundStyle(ThemeManager.shared.color.primary)
      .onTapGesture {
        viewModel.onContentVisibilityChange()
      }
      .disabled(viewModel.viewState.isLoading)
  }

  private var footer: some View {
    VStack(spacing: SPACING_MEDIUM) {
      missingCredentials()
      WrapButtonView(
        style: .primary,
        title: .shareButton,
        isLoading: viewModel.viewState.isLoading,
        isEnabled: !viewModel.viewState.isLoading,
        onAction: viewModel.onShare()
      )
      WrapButtonView(
        style: .secondary,
        title: .cancelButton,
        onAction: viewModel.onShowCancelModal()
      )
    }
    .animation(.easeInOut, value: viewModel.viewState.itemsAreAllSelected)
  }

  @ViewBuilder
  private func missingCredentials() -> some View {
    if !viewModel.viewState.itemsAreAllSelected {
      HStack(spacing: SPACING_MEDIUM) {

        ThemeManager.shared.image.warning
          .resizable()
          .renderingMode(.template)
          .scaledToFit()
          .frame(width: 35)
          .foregroundStyle(ThemeManager.shared.color.warning)

        Text(.incompleteRequestDataSelection)
          .typography(ThemeManager.shared.font.bodyMedium)
          .foregroundStyle(ThemeManager.shared.color.textPrimaryDark)
      }
      .padding()
      .frame(maxWidth: .infinity)
      .overlay(
        RoundedRectangle(cornerRadius: 15)
          .foregroundStyle(ThemeManager.shared.color.warning.opacity(0.12))
      )
    }
  }
}
