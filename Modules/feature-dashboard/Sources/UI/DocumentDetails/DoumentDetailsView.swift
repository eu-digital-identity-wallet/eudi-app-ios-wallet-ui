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
import logic_resources

public struct DocumentDetailsView<Router: RouterHostType, Interactor: DocumentDetailsInteractorType>: View {

  @ObservedObject var viewModel: DocumentDetailsViewModel<Router, Interactor>

  public init(with router: Router, and interactor: Interactor) {
    self.viewModel = DocumentDetailsViewModel(router: router, interactor: interactor)
  }

  public var body: some View {
    ContentScreen(
      padding: 0,
      canScroll: true
    ) {
      DocumentDetailsHeaderView(
        holdersName: viewModel.viewState.holdersName,
        userIcon: viewModel.viewState.holdersImage
      )
      Spacer()
    }
    .onAppear {
      self.viewModel.fetchDocumentDetails()
    }
  }

}
