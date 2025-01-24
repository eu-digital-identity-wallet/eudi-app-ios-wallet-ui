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
import feature_common
import logic_core

struct DocumentIssuanceSuccessView<Router: RouterHost>: View {

  @ObservedObject var viewModel: DocumentSuccessViewModel<Router>

  init(with viewModel: DocumentSuccessViewModel<Router>) {
    self.viewModel = viewModel
  }

  var body: some View {
    ContentScreenView(
      padding: .zero,
      navigationTitle: LocalizableString.shared.get(
        with: .documentAdded
      ),
      toolbarContent: viewModel.toolbarContent()
    ) {
      content(
        viewState: viewModel.viewState
      )
    }
    .viewDidLoadAsync {
      await viewModel.initialize()
    }
  }
}

@MainActor
@ViewBuilder
private func content(
  viewState: DocumentSuccessState
) -> some View {
  ScrollView {

    VStack(spacing: .zero) {
      ContentHeader(
        config: viewState.contentHeaderConfig
      )

      if let caption = viewState.caption {
        HStack {
          Text(caption)
            .typography(Theme.shared.font.bodyMedium)
            .multilineTextAlignment(.center)
            .foregroundColor(Theme.shared.color.onSurfaceVariant)
            .frame(maxWidth: .infinity, alignment: .center)
        }
      }

      VSpacer.medium()

      if let document = viewState.documents.first,
         let issuer = document.issuer {
        PlainWithLogoView(
          icon: .remoteImage(
            issuer.logoUrl,
            Theme.shared.image.logo
          ),
          title: issuer.name
        )

        VSpacer.largeMedium()
      }

      document(
        holderName: viewState.holderName,
        viewState: viewState
      )

      Spacer()
    }
    .padding(.horizontal, Theme.shared.dimension.padding)
  }
}

@MainActor
@ViewBuilder
private func footer(action: @escaping () -> Void) -> some View {
  WrapButtonView(
    style: .primary,
    title: .issuanceSuccessNextButton,
    onAction: action()
  )
}

@MainActor
@ViewBuilder
private func document(
  holderName: String?,
  viewState: DocumentSuccessState
) -> some View {
  VStack(spacing: SPACING_MEDIUM) {

    ForEach(viewState.documents) { document in
      ExpandableCardView(
        backgroundColor: Theme.shared.color.tertiary,
        title: .custom(document.documentName),
        subtitle: .viewDocumentDetails,
        isLoading: viewState.isLoading,
        content: {
          WrapListItemsView(
            listItems: document.documentFields.map({ field in
              switch field.value {
              case .string(let value):
                  .init(
                    mainText: .custom(value),
                    overlineText: .custom(field.title)
                  )
              case .image(let image):
                  .init(
                    mainText: .custom(field.title),
                    leadingIcon: (nil, image)
                  )
              }
            })
          )
        }
      )
    }
  }
  .frame(maxWidth: .infinity)
}

#Preview {
  let viewState = DocumentSuccessState(
    title: .success,
    caption: .issuanceSuccessCaption(
      ["DocumentTitle"]
    ),
    holderName: "Name",
    config: IssuanceFlowUiConfig(flow: .noDocument),
    documentIdentifiers: ["id"],
    documents: [DocumentDetailsUIModel.mock()],
    isLoading: false,
    contentHeaderConfig: .init(
      appIconAndTextData: AppIconAndTextData(
        appIcon: ThemeManager.shared.image.logoEuDigitalIndentityWallet,
        appText: ThemeManager.shared.image.euditext
      )
    ),
    error: nil
  )

  ContentScreenView {
    content(viewState: viewState)
  }
}
