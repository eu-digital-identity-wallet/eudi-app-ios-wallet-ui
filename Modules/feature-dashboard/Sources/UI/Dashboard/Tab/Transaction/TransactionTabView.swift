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

struct TransactionTabView<Router: RouterHost>: View {

  @ObservedObject private var viewModel: TransactionTabViewModel<Router>

  public init(with viewModel: TransactionTabViewModel<Router>) {
    self.viewModel = viewModel
  }

  var body: some View {
    content()
      .onAppear {
        viewModel.onCreate()
      }
  }
}

@MainActor
@ViewBuilder
private func content() -> some View {
  VStack {
    Text("Under construction")
  }
}

#Preview {
  content()
}
