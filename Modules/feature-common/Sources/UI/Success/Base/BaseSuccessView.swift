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

public struct BaseSuccessView<Router: RouterHost>: View {

  @ObservedObject private var viewModel: BaseSuccessViewModel<Router>

  public init(
    with viewModel: BaseSuccessViewModel<Router>
  ) {
    self.viewModel = viewModel
  }

  public var body: some View {
    ContentScreenView(
      padding: .zero,
      canScroll: true,
      navigationTitle: .dataShared,
      toolbarContent: viewModel.toolbarContent()
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
  viewState: BaseSuccessState
) -> some View {
  ScrollView {

    VStack(spacing: .zero) {
      ContentHeader(
        config: ContentHeaderConfig(
          appIconAndTextData: AppIconAndTextData(
            appIcon: ThemeManager.shared.image.logoEuDigitalIndentityWallet,
            appText: ThemeManager.shared.image.euditext
          ),
          description: .successfullySharedFollowingInformation,
          relyingPartyData: viewState.relyingParty
        )
      )

      VSpacer.large()

      documents(
        viewState: viewState,
        onSelectionChanged: { _ in }
      )

      VSpacer.large()
    }
    .padding(.horizontal, Theme.shared.dimension.padding)
  }
}

@MainActor
@ViewBuilder
private func documents(
  viewState: BaseSuccessState,
  ignoreTrainingContent: Bool = true,
  backgroundColor: Color = Theme.shared.color.tertiary,
  onSelectionChanged: @escaping @Sendable (String) -> Void
) -> some View {
  if !viewState.items.isEmpty {
    VStack(alignment: .leading, spacing: SPACING_MEDIUM) {
      ForEach(viewState.items, id: \.id) { section in
        ExpandableCardView(
          backgroundColor: backgroundColor,
          title: .custom(section.title),
          subtitle: .viewDetails
        ) {
          WrapListItemsView(
            listItems: section.listItems
          )
        }
        .shimmer(isLoading: viewState.isLoading)
      }
    }
  }
}
