/*
 * Copyright (c) 2023 European Commission
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import SwiftUI
import logic_ui
import feature_common

public struct CrossDeviceLoadingView<Router: RouterHostType, Interactor: CrossDeviceInteractorType>: View {

  @ObservedObject private var viewModel: CrossDeviceLoadingViewModel<Router, Interactor>

  public init(with router: Router, and interactor: Interactor, relyingParty: String) {
    self.viewModel = .init(router: router, interactor: interactor, relyingParty: relyingParty)
  }

  public var body: some View {
    BaseLoadingView(with: viewModel.router, viewModel: viewModel)
  }
}
