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
import feature_common

struct DashboardView<Router: RouterHost>: View {

  @Environment(\.scenePhase) private var scenePhase

  @State private var viewModel: DashboardViewModel<Router>

  public init(with viewModel: DashboardViewModel<Router>) {
    self._viewModel = State(wrappedValue: viewModel)
  }

  var body: some View {
    ContentScreenView(
      padding: .zero,
      canScroll: false,
      navigationTitle: viewModel.viewState.navigationTitle,
      toolbarContent: viewModel.viewState.toolBarContent,
      notificationActions: [
        .init(
          name: NSNotification.RevocationDashboard,
          callback: {
            guard let payload = $0 else { return }
            viewModel.handleRevocationNotification(for: payload)
          }
        )
      ]
    ) {
      DashboardViewContainer(
        selectedTab: $viewModel.selectedTab,
        isRevokedModalShowing: $viewModel.isRevokedModalShowing,
        tabView: { tab in
          switch tab {
          case .documents:
            viewModel.viewState.documentTab.eraseToAnyView()
          case .home:
            viewModel.viewState.homeTab.eraseToAnyView()
          case .history:
            viewModel.viewState.historyTab.eraseToAnyView()
          }
        },
        revokedDocuments: viewModel.viewState.revokedDocuments,
        onDocumentDetails: { viewModel.onDocumentDetails(documentId: $0) }
      )
    }
    .onChange(of: scenePhase) {
      viewModel.setPhase(with: scenePhase)
    }
    .onDisappear {
      viewModel.onPause()
    }
    .task {
      await viewModel.onCreate()
    }
  }
}

private struct DashboardViewContainer: View {

  @Binding var selectedTab: SelectedTab
  @Binding var isRevokedModalShowing: Bool
  let tabView: (SelectedTab) -> AnyView
  let revokedDocuments: [String: String]
  let onDocumentDetails: (String) -> Void

  var body: some View {
    content()
      .sheetDialog(isPresented: $isRevokedModalShowing) {
        VStack(spacing: .zero) {

          ContentTitleView(
            title: .revokedModalTitle,
            caption: .revokedModalDescription
          )

          revokedNotificationList()
        }
      }
  }

  @MainActor
  @ViewBuilder
  private func content() -> some View {
    TabView(selection: $selectedTab) {

      tabView(.home)
        .tabItem {
          Label(
            LocalizableStringKey.home.toString,
            systemImage: "house.fill"
          )
          .accessibilityLocator(
            TabViewLocators.home,
            label: LocalizableStringKey.home.toString
          )
        }
        .tag(SelectedTab.home)

      tabView(.documents)
        .tabItem {
          Label(
            .documents,
            systemImage: "doc.fill"
          )
          .accessibilityLocator(
            TabViewLocators.documents,
            label: LocalizableStringKey.documents.toString
          )
        }
        .tag(SelectedTab.documents)

      tabView(.history)
        .tabItem {
          Label(
            .historyTitle,
            systemImage: "clock.fill"
          )
          .accessibilityLocator(
            TabViewLocators.history,
            label: LocalizableStringKey.historyTitle.toString
          )
        }
        .tag(SelectedTab.history)
    }
    .tint(Theme.shared.color.accent)
  }

  @MainActor
  @ViewBuilder
  private func revokedNotificationList() -> some View {
    VStack(spacing: SPACING_SMALL) {
      ForEach(revokedDocuments.sorted(by: >), id: \.key) { key, value in

        HStack {
          Text(.custom(key))
            .typography(Theme.shared.font.bodyLarge)
            .foregroundColor(Theme.shared.color.primaryLabel)

          Spacer()

          Theme.shared.image.chevronRight
            .renderingMode(.template)
            .foregroundStyle(Theme.shared.color.accent)
        }
        .padding()
        .background(Theme.shared.color.groupedBackground)
        .clipShape(.rect(cornerRadius: 8))
        .onTapGesture {
          onDocumentDetails(value)
        }
      }
    }
    .padding(.vertical)
  }
}

#Preview {
  ContentScreenView(
    padding: .zero,
    canScroll: false,
    background: Theme.shared.color.background
  ) {
    DashboardViewContainer(
      selectedTab: .constant(.home),
      isRevokedModalShowing: .constant(false),
      tabView: { _ in EmptyView().eraseToAnyView() },
      revokedDocuments: [:],
      onDocumentDetails: { _ in }
    )
  }
}
