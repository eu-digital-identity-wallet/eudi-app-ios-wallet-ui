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

struct StartupView<Router: RouterHost>: View {

  @StateObject private var viewModel: StartupViewModel<Router>

  init(with viewModel: StartupViewModel<Router>) {
    self._viewModel = StateObject(wrappedValue: viewModel)
  }

  var body: some View {
    ContentScreenView(
      padding: .zero,
      canScroll: false,
      background: Theme.shared.color.surface
    ) {
      content(
        viewState: viewModel.viewState,
        screenWidth: getScreenRect().width
      )
    }
    .task {
      await viewModel.initialize()
    }
  }
}

@MainActor
@ViewBuilder
private func content(
  viewState: StartupState,
  screenWidth: CGFloat
) -> some View {
  ZStack {
    Theme.shared.image.logo
      .resizable()
      .aspectRatio(contentMode: .fit)
      .frame(width: screenWidth / 2.5)
  }
  .frame(maxWidth: .infinity, maxHeight: .infinity)
  .ignoresSafeArea(.all)
}

#Preview {
  let viewState = StartupState(
    splashDuration: 10,
    setupError: nil
  )

  ContentScreenView(
    padding: .zero,
    canScroll: false,
    background: Theme.shared.color.primary
  ) {
    content(viewState: viewState, screenWidth: 1080)
  }
}
