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
import feature_common

public struct PresentationRequestView<Router: RouterHost>: View {

  @ObservedObject private var viewModel: PresentationRequestViewModel<Router>

  public init(with router: Router, and interactor: PresentationInteractor) {
    self.viewModel = .init(router: router, interactor: interactor)
  }

  public var body: some View {
    BaseRequestView(
      with: viewModel.router,
      viewModel: viewModel
    )
    .onReceive(NotificationCenter.default.publisher(for: NSNotification.PresentationVC)) { data in
      guard let payload = data.userInfo else {
        return
      }
      viewModel.handleDeepLinkNotification(with: payload)
    }
  }
}
