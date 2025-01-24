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

struct SideMenuView<Router: RouterHost>: View {

  @ObservedObject private var viewModel: SideMenuViewModel<Router>

  init(with viewModel: SideMenuViewModel<Router>) {
    self.viewModel = viewModel
  }

  var body: some View {
    ContentScreenView(
      padding: .zero,
      canScroll: true,
      navigationTitle: LocalizableString.shared.get(with: .myEuWallet),
      toolbarContent: toolbarContent()
    ) {
      content(
        viewState: viewModel.viewState
      )
    }
  }

  func toolbarContent() -> ToolBarContent {
    .init(
      trailingActions: [],
      leadingActions: [
        Action(image: Theme.shared.image.chevronLeft) {
          viewModel.onPop()
        }
      ]
    )
  }
}

@MainActor
@ViewBuilder
func shareLogs(with fileUrl: URL) -> some View {
  ShareLink(item: fileUrl) {
    TappableCellView(
      title: .retrieveLogs,
      showDivider: false,
      useOverlay: false,
      action: {}
    )
  }
}

@MainActor
@ViewBuilder
private func content(viewState: SideMenuViewState) -> some View {
  VStack(spacing: SPACING_SMALL) {
    ForEach(viewState.items) { item in
      TappableCellView(
        title: item.title,
        showDivider: true,
        action: item.action
      )
    }

    if let logsUrl = viewState.logsUrl {
      shareLogs(with: logsUrl)
    }

    Spacer()

    Text(viewState.appVersion)
      .typography(Theme.shared.font.bodyMedium)
      .frame(maxWidth: .infinity, alignment: .center)

  }
  .padding(.top)
}

#Preview {
  let viewSate = SideMenuViewState(
    items: [
      .init(
        title: .changeQuickPinOption,
        action: {
        }
      )
    ],
    appVersion: "",
    logsUrl: URL(string: "https://www.example.com")
  )
  ContentScreenView(
    padding: .zero,
    canScroll: false,
    background: Theme.shared.color.surface
  ) {
    content(viewState: viewSate)
  }
}
