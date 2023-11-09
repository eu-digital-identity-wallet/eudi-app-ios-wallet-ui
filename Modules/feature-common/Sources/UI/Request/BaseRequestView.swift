/*
 * Copyright (c) 2023 European Commission
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
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

      ContentTitle(
        title: viewModel.getTitle()
      )

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

            if index > 0 {
              VSpacer.small()
            }

            RequestDataCellView(
              cellModel: item,
              isLoading: viewModel.viewState.isLoading
            ) { id in
              viewModel.onSelectionChanged(id: id)
            }

            if (index + 1) < viewModel.viewState.items.count, (item as? RequestDataSection) == nil {
              Divider()
            }

            VSpacer.small()
          }
        }
        .padding(.top)
      }

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

  var footer: some View {
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
  func missingCredentials() -> some View {
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
