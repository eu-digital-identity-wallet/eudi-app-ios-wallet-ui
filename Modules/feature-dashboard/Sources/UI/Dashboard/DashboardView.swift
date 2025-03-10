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
    .task {
      await viewModel.handleDeepLink()
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
      //.tag(SelectedTab.transactions)
  }
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
