/*
 * Copyright (c) 2026 European Commission
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

public struct DocumentSuccessView<Router: RouterHost, RequestItem: Sendable>: View {

  @State private var viewModel: DocumentSuccessViewModel<Router, RequestItem>

  public init(
    with viewModel: DocumentSuccessViewModel<Router, RequestItem>
  ) {
    self._viewModel = State(wrappedValue: viewModel)
  }

  public var body: some View {
    ContentScreenView(
      padding: .zero,
      canScroll: true,
      navigationTitle: viewModel.viewState.navigationTitle
    ) {
      content(
        viewState: viewModel.viewState,
        onDone: viewModel.onDone
      )
    }
  }
}

@MainActor
@ViewBuilder
private func content<RequestItem: Sendable>(
  viewState: DocumentSuccessState<RequestItem>,
  onDone: @escaping () -> Void
) -> some View {
  ScrollView {

    VStack(spacing: .zero) {
      ContentHeaderView(
        config: viewState.contentHeaderConfig,
        accessibilityDescription: DocumentSuccessLocators.documentSuccessDescription
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
  .safeAreaInset(edge: .bottom) {
    doneButton(
      isLoading: viewState.isLoading,
      onDone: onDone
    )
  }
}

@MainActor
@ViewBuilder
private func doneButton(
  isLoading: Bool,
  onDone: @escaping () -> Void
) -> some View {
  WrapButtonView(
    style: .primary,
    title: .doneButton,
    isLoading: isLoading,
    onAction: onDone()
  )
  .combineChilrenAccessibility(
    locator: DocumentSuccessLocators.doneButton
  )
  .padding(.horizontal, SPACING_MEDIUM)
  .padding(.bottom, SPACING_LARGE_MEDIUM)
}

@MainActor
@ViewBuilder
private func documents<RequestItem: Sendable>(
  viewState: DocumentSuccessState<RequestItem>,
  ignoreTrainingContent: Bool = true,
  backgroundColor: Color = Theme.shared.color.successBackground,
  onSelectionChanged: @escaping @Sendable (String) -> Void
) -> some View {
  if !viewState.items.isEmpty {
    VStack(alignment: .leading, spacing: SPACING_MEDIUM) {
      ForEach(viewState.items.indices, id: \.self) { index in
        let section = viewState.items[index]
        WrapExpandableListView(
          header: .init(
            mainContent: .text(.custom(section.title)),
            supportingText: .viewDetails
          ),
          items: section.listItems,
          backgroundColor: backgroundColor,
          hideSensitiveContent: false,
          isLoading: viewState.isLoading,
          onItemClick: { onSelectionChanged($0.groupId) }
        )
        .accessibilityElement()
        .combineChilrenAccessibility(
          locator: BaseRequestLocators.requestedDocument(index.string)
        )
      }
    }
  }
}
