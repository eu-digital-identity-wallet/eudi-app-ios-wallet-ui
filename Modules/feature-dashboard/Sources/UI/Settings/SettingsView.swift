/*
 * Copyright (c) 2025 European Commission
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

struct SettingsView<Router: RouterHost>: View {
  @State private var viewModel: SettingsViewModel<Router>

  init(with viewModel: SettingsViewModel<Router>) {
    self._viewModel = State(wrappedValue: viewModel)
  }

  var body: some View {
    ContentScreenView(
      canScroll: true,
      navigationTitle: .settings,
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
  viewState: SettingsViewState
) -> some View {
  VStack(spacing: SPACING_MEDIUM_SMALL) {
    ForEach(viewState.items) { item in
      if item.isShareLink {
        if let fileUrl = viewState.logsUrl {
          ShareLink(item: fileUrl) {
            TappableCellView(
              title: .retrieveLogs,
              showDivider: item.showDivider,
              useOverlay: false,
              action: {}()
            )
          }
        }
      } else {
        TappableCellView(
          title: item.title,
          showDivider: item.showDivider,
          action: item.action()
        )
      }
    }

    Spacer()

    Text(viewState.appVersion)
      .typography(Theme.shared.font.bodyMedium)
      .frame(maxWidth: .infinity, alignment: .center)
  }
  .padding(.bottom, SPACING_LARGE_MEDIUM)
}

#Preview {
  let viewSate = SettingsViewState(
    items: [
      .init(
        title: .changeQuickPinOption,
        action: {}()
      )
    ],
    appVersion: "",
    logsUrl: URL(string: "https://www.example.com"),
    changelogUrl: URL(string: "https://www.example.com")
  )
  ContentScreenView(
    padding: .zero,
    canScroll: false,
    background: Theme.shared.color.surface
  ) {
    content(
      viewState: viewSate
    )
  }
}
