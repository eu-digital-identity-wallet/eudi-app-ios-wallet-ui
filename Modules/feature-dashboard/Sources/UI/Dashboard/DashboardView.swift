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
import logic_business
import feature_common
import logic_core

struct DashboardView<Router: RouterHost>: View {

  @Environment(\.scenePhase) private var scenePhase

  @ObservedObject private var viewModel: DashboardViewModel<Router>

  public init(with viewModel: DashboardViewModel<Router>) {
    self.viewModel = viewModel
  }

  var body: some View {
    ContentScreenView(
      padding: .zero,
      canScroll: false,
      navigationTitle: viewModel.viewState.navigationTitle,
      toolbarContent: viewModel.viewState.toolBarContent
    ) {
      content(
        tabView: { tab in
          return switch tab {
          case .documents:
            viewModel.viewState.documentTab
              .eraseToAnyView()
          case .home:
            viewModel.viewState.homeTab
              .eraseToAnyView()
          case .transactions:
            viewModel.viewState.transactionTab
              .eraseToAnyView()
          }
        },
        selectedTab: $viewModel.selectedTab
      )
    }
    .sheetDialog(isPresented: $viewModel.isRevokedModalShowing) {
      SheetContentView {
        VStack(spacing: SPACING_MEDIUM) {

          ContentTitleView(
            title: .revokedModalTitle,
            caption: .revokedModalDescription
          )

          revokedNotificationList(
            state: viewModel.viewState,
            onDocumentDetails: {
              viewModel.onDocumentDetails(documentId: $0)
            }
          )
        }
      }
    }
    .onChange(of: scenePhase) { phase in
      viewModel.setPhase(with: phase)
    }
    .onDisappear {
      viewModel.onPause()
    }
    .task {
      await viewModel.onCreate()
    }
    .onReceive(NotificationCenter.default.publisher(for: NSNotification.RevocationDashboard)) { data in
      guard let payload = data.userInfo else { return }
      viewModel.handleRevocationNotification(for: payload)
    }
  }
}

@MainActor
@ViewBuilder
private func content(
  tabView: @escaping (SelectedTab) -> AnyView,
  selectedTab: Binding<SelectedTab>
) -> some View {
  TabView(selection: selectedTab) {

    tabView(.home)
      .tabItem {
        Label(
          LocalizableStringKey.home.toString,
          systemImage: "house.fill"
        )
      }
      .tag(SelectedTab.home)

    tabView(.documents)
      .tabItem {
        Label(
          .documents,
          systemImage: "doc.fill"
        )
      }
      .tag(SelectedTab.documents)

    tabView(.transactions)
    .tabItem {
      Label(
        .transactions,
        systemImage: "arrow.left.arrow.right"
      )
    }
    .tag(SelectedTab.transactions)
  }
}

@MainActor
@ViewBuilder
private func revokedNotificationList<Router: RouterHost>(
  state: DashboardState<Router>,
  onDocumentDetails: @escaping (String) -> Void
) -> some View {
  VStack(spacing: SPACING_SMALL) {
    ForEach(state.revokedDocuments.sorted(by: >), id: \.key) { key, value in

      HStack {
        Text(.custom(key))
          .typography(Theme.shared.font.bodyLarge)
          .foregroundColor(Theme.shared.color.onSurface)

        Spacer()

        Theme.shared.image.chevronRight
          .renderingMode(.template)
          .foregroundStyle(Theme.shared.color.primary)
      }
      .padding()
      .background(Theme.shared.color.surfaceContainer)
      .clipShape(.rect(cornerRadius: 8))
      .onTapGesture {
        onDocumentDetails(value)
      }
    }
  }
  .padding(.vertical)
}

#Preview {
  ContentScreenView(
    padding: .zero,
    canScroll: false,
    background: Theme.shared.color.surface
  ) {
    content(
      tabView: {_ in EmptyView().eraseToAnyView()},
      selectedTab: .constant(.home)
    )
  }
}
