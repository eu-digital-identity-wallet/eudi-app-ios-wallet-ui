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

struct DocumentSuccessView<Router: RouterHost>: View {

  @ObservedObject var viewModel: DocumentSuccessViewModel<Router>

  init(with viewModel: DocumentSuccessViewModel<Router>) {
    self.viewModel = viewModel
  }

  var body: some View {
    ContentScreenView(
      allowBackGesture: false,
      navigationTitle: LocalizableString.shared.get(
        with: .documentAdded
      ),
      toolbarContent: .init(
        trailingActions: [
          Action(
            title: LocalizableString.shared.get(
              with: .issuanceSuccessNextButton
            ).capitalizedFirst()
          ) {
            viewModel.onIssue()
          }
        ])
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

    ContentHeader(
      config: ContentHeaderConfig(
        appIconAndTextData: AppIconAndTextData(
          appIcon: ThemeManager.shared.image.logoEuDigitalIndentityWallet,
          appText: ThemeManager.shared.image.euditext
        )
      )
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

    PlainWithLogoView(
      icon: viewState.issuerData.icon,
      title: viewState.issuerData.title,
      isVerified: viewState.issuerData.isVerified
    )

    VSpacer.largeMedium()

    document(
      holderName: viewState.holderName,
      viewState: viewState
    )

    Spacer()
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
        title: document.documentName,
        subtitle: LocalizableString.shared.get(with: .viewDocumentDetails),
        isLoading: viewState.isLoading,
        content: {
          WrapListItemsView(
            listItems: document.documentFields.map({ field in
              switch field.value {
              case .string(let value):
                  .init(
                    mainText: value,
                    overlineText: field.title
                  )
              case .image(let image):
                  .init(
                    mainText: field.title,
                    leadingIcon: image
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
    issuerData: IssuerDataUIModel.mock(),
    isLoading: false,
    error: nil
  )

  ContentScreenView {
    content(viewState: viewState)
  }
}
