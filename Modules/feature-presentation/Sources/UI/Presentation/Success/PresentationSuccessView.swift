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
import logic_business
import logic_ui
import feature_common

struct PresentationSuccessView<Router: RouterHost>: View {

  @ObservedObject private var viewModel: PresentationSuccessViewModel<Router>

  init(
    with viewModel: PresentationSuccessViewModel<Router>
  ) {
    self.viewModel = viewModel
  }

  var body: some View {
    ContentScreenView(
      allowBackGesture: false,
      navigationTitle: LocalizableString.shared.get(
        with: .dataShared
      ),
      toolbarContent: .init(
        trailingActions: [
          Action(
            title: LocalizableString.shared.get(
              with: .doneButton
            ).capitalizedFirst()
          ) {
            viewModel.onDone()
          }
        ])
    ) {
      content(
        viewState: viewModel.viewState
      )
    }
  }
}

@MainActor
@ViewBuilder
private func content(
  viewState: PresentationSuccessState
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

    HStack {
      Text(LocalizableString.shared.get(
        with: .successfullySharedFollowingInformation
      ))
      .typography(Theme.shared.font.bodyMedium)
      .multilineTextAlignment(.center)
      .foregroundColor(Theme.shared.color.onSurfaceVariant)
      .frame(maxWidth: .infinity, alignment: .center)
    }

    VSpacer.large()

    VStack(alignment: .center, spacing: SPACING_SMALL) {
      Text(viewState.issuerData.title)
        .typography(Theme.shared.font.bodyMedium)
        .if(viewState.issuerData.isVerified) {
          $0.leftImage(image: Theme.shared.image.relyingPartyVerified)
        }
        .foregroundStyle(Theme.shared.color.onSurfaceVariant)
        .frame(maxWidth: .infinity, alignment: .center)
    }

    VSpacer.large()

    documents(
      viewState: viewState
    )

    Spacer()
  }
}

@MainActor
@ViewBuilder
private func documents(viewState: PresentationSuccessState) -> some View {
  if !viewState.items.isEmpty {
    VStack(alignment: .leading, spacing: SPACING_MEDIUM) {
      ForEach(viewState.items, id: \.id) { section in
        ExpandableCardView(
          backgroundColor: Theme.shared.color.tertiary,
          title: section.requestDataSection.title,
          subtitle: LocalizableString.shared.get(with: .viewDetails)
        ) {
          ForEach(section.requestDataRow ?? [], id: \.id) { item in
            if item.isSelected {
              switch item.value {
              case .string(let value):
                WrapListItemView(
                  listItem: ListItemData(
                    mainText: value,
                    overlineText: item.title
                  )
                )
              case .image(let image):
                WrapListItemView(
                  listItem: ListItemData(
                    mainText: item.title,
                    leadingIcon: (nil, image)
                  )
                )
              }
              Divider()
                .padding(.horizontal, SPACING_MEDIUM)
                .background(Theme.shared.color.onSurfaceVariant.opacity(0.2))
            }
          }

          ForEach(section.requestDataVerification ?? [], id: \.id) { item in
            if item.isSelected {
              switch item.value {
              case .string(let value):
                WrapListItemView(
                  listItem: ListItemData(
                    mainText: value,
                    overlineText: item.title
                  )
                )
              case .image(let image):
                WrapListItemView(
                  listItem: ListItemData(
                    mainText: item.title,
                    leadingIcon: (nil, image)
                  )
                )
              }
              Divider()
                .padding(.horizontal, SPACING_MEDIUM)
                .background(Theme.shared.color.onSurfaceVariant.opacity(0.2))
            }
          }
        }
      }
    }
  }
}
