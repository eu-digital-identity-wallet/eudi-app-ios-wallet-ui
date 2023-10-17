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

import logic_ui
import logic_resources

struct AuthRequestViewState: ViewState {
  let error: ContentError.Config?
  let title: LocalizableString.Key
  let caption: LocalizableString.Key
  let dataRequestInfo: LocalizableString.Key
  let isContentVisible: Bool

}

@MainActor
final class AuthenticationRequestViewModel<Router: RouterHostType, Interactor: AuthenticationInteractorType>: BaseViewModel<Router, AuthRequestViewState> {

  private let interactor: Interactor

  @Published var isCancelModalShowing: Bool = false

  init(router: Router, interactor: Interactor) {
    self.interactor = interactor
    super.init(
      router: router,
      initialState: .init(
        error: nil,
        title: .requestDataTitle(["EUDI Conference"]),
        caption: .requestDataCaption,
        dataRequestInfo: .requestDataInfoNotice,
        isContentVisible: false
      )
    )
  }

  func onPop() {
    router.pop()
  }

  func onShowCancelModal() {
    isCancelModalShowing = !isCancelModalShowing
  }

  func onShare() {

  }

  func onContentVisibilityChange() {
    setNewState(isContentVisible: !viewState.isContentVisible)
    print(viewState.isContentVisible)
  }

  private func setNewState(
    error: ContentError.Config? = nil,
    isContentVisible: Bool? = nil
  ) {
    setState {
      .init(
        error: error,
        title: $0.title,
        caption: $0.caption,
        dataRequestInfo: $0.dataRequestInfo,
        isContentVisible: isContentVisible ?? $0.isContentVisible
      )
    }
  }
}
