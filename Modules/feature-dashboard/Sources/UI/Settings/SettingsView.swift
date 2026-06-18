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
import logic_business

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
      SettingsViewContainer(
        viewState: viewModel.viewState
      )
    }
    .task {
      await viewModel.initialize()
    }
    .alert(item: $viewModel.biometryError) { error in
      Alert(
        title: Text(.genericErrorTitle),
        message: Text(error.errorDescription.orEmpty),
        primaryButton: .default(Text(.biometryOpenSettings)) {
          viewModel.onBiometrySettings()
        },
        secondaryButton: .cancel {}
      )
    }
  }
}

private struct SettingsViewContainer: View {

  let viewState: SettingsViewState

  var body: some View {
    content()
  }

  @MainActor
  @ViewBuilder
  private func content() -> some View {
    VStack(spacing: SPACING_MEDIUM_SMALL) {
      ForEach(viewState.items) { item in
        if item.isShareLink {
          if let fileUrl = viewState.logsUrl {
            ShareLink(item: fileUrl) {
              TappableCellView(
                title: .retrieveLogs,
                icon: item.icon,
                showDivider: item.showDivider,
                useOverlay: false,
                action: {}
              )
            }
          }
        } else if item.isToggle {
          if let toggleBinding = item.toggleBinding {
            TappableCellView(
              title: item.title,
              icon: item.icon,
              showDivider: item.showDivider,
              isToggle: true,
              isOn: toggleBinding,
              useOverlay: false,
              action: item.action
            )
          }
        } else {
          TappableCellView(
            title: item.title,
            icon: item.icon,
            showDivider: item.showDivider,
            action: item.action
          )
        }
      }

      Spacer()

      if let version = viewState.appVersion {
        Text(version)
          .typography(Theme.shared.font.bodyMedium)
          .foregroundStyle(Theme.shared.color.primaryLabel)
          .frame(maxWidth: .infinity, alignment: .center)
      }
    }
    .padding(.bottom, SPACING_LARGE_MEDIUM)
  }
}

#Preview {
  let viewState = SettingsViewState(
    items: [
      .init(
        title: .loginWithBiometrics,
        isToggle: true,
        action: {}
      ),
      .init(
        title: .changeQuickPinOption,
        action: {}
      )
    ],
    isBiometryEnabled: true,
    appVersion: "",
    logsUrl: URL(string: "https://www.example.com"),
    changelogUrl: URL(string: "https://www.example.com")
  )
  ContentScreenView(
    canScroll: true,
    navigationTitle: .settings
  ) {
    SettingsViewContainer(viewState: viewState)
  }
}
