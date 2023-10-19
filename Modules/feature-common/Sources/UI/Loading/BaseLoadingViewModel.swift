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
@_exported import logic_ui
@_exported import logic_resources

public struct BaseLoadingState: ViewState {
  let error: ContentError.Config?
}

open class BaseLoadingViewModel<Router: RouterHostType>: BaseViewModel<Router, BaseLoadingState> {

  public init(router: Router) {
    super.init(router: router, initialState: .init(error: nil))
  }

  open func getTitle() -> LocalizableString.Key {
    return .custom("")
  }

  open func getCaption() -> LocalizableString.Key {
    return .custom("")
  }

  open func getOnSuccessRoute() -> AppRoute? {
    return nil
  }

  open func getOnPopRoute() -> AppRoute? {
    return nil
  }

  open func doWork() async {}

  public func onNavigate(type: UIConfig.NavigationConfig.NavigationType) {
    switch type {
    case .pop:
      if let route = getOnPopRoute() {
        router.popTo(with: route)
      }
    case .push:
      if let route = getOnSuccessRoute() {
        router.push(with: route)
      }
    }
  }

  public func onError(with error: Error) {
    setState { _ in
        .init(
          error: .init(
            description: .custom(error.localizedDescription),
            cancelAction: self.onNavigate(type: .pop),
            action: { self.onErrorAction() }
          )
        )
    }
  }

  private func onErrorAction() {
    setState { _ in
        .init(error: nil)
    }
    Task {
      await self.doWork()
    }
  }
}
