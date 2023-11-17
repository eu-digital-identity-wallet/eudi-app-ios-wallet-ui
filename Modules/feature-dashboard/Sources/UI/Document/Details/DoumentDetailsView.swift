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

public struct DocumentDetailsView<Router: RouterHostType, Interactor: DocumentDetailsInteractorType>: View {

  @ObservedObject var viewModel: DocumentDetailsViewModel<Router, Interactor>

  public init(
    with router: Router,
    and interactor: Interactor,
    documentId: String
  ) {
    self.viewModel = DocumentDetailsViewModel(
      router: router,
      interactor: interactor,
      documentId: documentId
    )
  }

  @ViewBuilder
  func content() -> some View {
    ScrollView {
      VStack(spacing: .zero) {

        VSpacer.medium()

        ForEach(viewModel.viewState.document.documentFields) { documentFieldContent in
          KeyValueView(
            title: .custom(documentFieldContent.title),
            subTitle: .custom(documentFieldContent.value),
            isLoading: viewModel.viewState.isLoading
          )

          VSpacer.medium()
        }
      }
      .padding(.horizontal, Theme.shared.dimension.padding)
    }
  }

  public var body: some View {
    ContentScreen(
      padding: .zero,
      canScroll: true,
      errorConfig: viewModel.viewState.error
    ) {

      DocumentDetailsHeaderView(
        documentName: viewModel.viewState.document.documentName,
        holdersName: viewModel.viewState.document.holdersName,
        userIcon: viewModel.viewState.document.holdersImage,
        isLoading: viewModel.viewState.isLoading
      ) {
        viewModel.pop()
      }

      content()
    }
    .task {
      await self.viewModel.fetchDocumentDetails()
    }
  }
}
