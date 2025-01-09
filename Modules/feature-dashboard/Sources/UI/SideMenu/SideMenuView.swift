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
    content(viewState: viewModel.viewState)
      .navigationTitle("My EU Wallet")
  }
}

@MainActor
@ViewBuilder
private func content(viewState: SideMenuViewState) -> some View {
  ScrollView {
    VStack(spacing: SPACING_SMALL) {
      ForEach(viewState.items) { item in
        TappableCellView(
          title: item.title,
          subtitle: item.subTitle,
          action: item.action
        )
      }
    }
    .padding(.top)
  }
}

#Preview {
  let viewSate = SideMenuViewState(
    items: [
      .init(
        title: "Change PIN",
        action: {
        }
      )
    ]
  )
  ContentScreenView(
    padding: .zero,
    canScroll: false,
    background: Theme.shared.color.surface
  ) {
    content(viewState: viewSate)
  }
}
