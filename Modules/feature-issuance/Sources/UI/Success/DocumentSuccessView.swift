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

public struct DocumentSuccessView<Router: RouterHostType, Interactor: DocumentSuccessInteractorType>: View {

  @ObservedObject var viewModel: DocumentSuccessViewModel<Router, Interactor>

  public init(
    with router: Router,
    and interactor: Interactor,
    config: any UIConfigType,
    documentName: String
  ) {
    self.viewModel = .init(
      router: router,
      interactor: interactor,
      config: config,
      documentName: documentName
    )
  }

  public var body: some View {
    ContentScreen(errorConfig: viewModel.viewState.error) {

      ContentTitle(
        title: viewModel.viewState.title,
        caption: viewModel.viewState.caption,
        titleColor: ThemeManager.shared.color.success,
        topSpacing: .withoutToolbar
      )

      VSpacer.large()

      document

      Spacer()

      footer
    }
    .sheetDialog(isPresented: $viewModel.isCancelModalShowing) {
      VStack(spacing: SPACING_MEDIUM) {

        ContentTitle(
          title: viewModel.viewState.modalTitle,
          caption: viewModel.viewState.modalCaption,
          titleColor: Theme.shared.color.textPrimaryDark
        )

        WrapButtonView(style: .primary, title: .issuanceSuccessModalContinueButton, onAction: viewModel.onShowCancelModal())
        WrapButtonView(style: .secondary, title: .issuanceSuccessModalCancelButton, onAction: viewModel.onPop())
      }
    }
  }

  private var document: some View {
    VStack(spacing: SPACING_MEDIUM) {

      HStack {

        Theme.shared.image.user
          .roundedCorner(Theme.shared.shape.small, corners: .allCorners)

        Theme.shared.image.idStroke
          .roundedCorner(Theme.shared.shape.small, corners: .allCorners)
          .padding(.leading, -40)

        Spacer()
      }

      HStack {

        Text(viewModel.viewState.holderName)
          .typography(Theme.shared.font.bodyLarge)
          .foregroundColor(Theme.shared.color.black)

        Spacer()
      }
    }
    .padding(SPACING_MEDIUM_LARGE)
    .frame(maxWidth: .infinity)
    .background(Theme.shared.color.secondary)
    .roundedCorner(Theme.shared.shape.small, corners: .allCorners)
  }

  private var footer: some View {
    VStack(spacing: SPACING_MEDIUM) {
      HStack {
        Text(viewModel.viewState.footerTitle)
          .typography(ThemeManager.shared.font.titleLarge)
          .foregroundColor(Theme.shared.color.textPrimaryDark)
        Spacer()
      }
      WrapButtonView(
        style: .primary,
        title: .issuanceSuccessAddButton,
        onAction: viewModel.onIssue()
      )
      WrapButtonView(
        style: .secondary,
        title: .issuanceSuccessCancelButton,
        onAction: viewModel.onShowCancelModal()
      )
    }
  }
}
