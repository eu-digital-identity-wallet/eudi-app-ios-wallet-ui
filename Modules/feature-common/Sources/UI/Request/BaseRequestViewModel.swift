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

public struct RequestViewState: ViewState {
  public let isLoading: Bool
  public let error: ContentError.Config?
  public let isContentVisible: Bool
  public let itemsAreAllSelected: Bool
  public let items: [any RequestDataCell]
}

@MainActor
open class BaseRequestViewModel<Router: RouterHostType>: BaseViewModel<Router, RequestViewState> {

  @Published var isCancelModalShowing: Bool = false
  @Published var isRequestInfoModalShowing: Bool = false

  public init(router: Router) {
    super.init(
      router: router,
      initialState: .init(
        isLoading: true,
        error: nil,
        isContentVisible: false,
        itemsAreAllSelected: true,
        items: RequestDataUiModel.mock()
      )
    )
  }

  open func doWork() async {}

  open func getTitle() -> LocalizableString.Key {
    return .custom("")
  }

  open func getRelyingParty() -> String {
    return ""
  }

  open func getCaption() -> LocalizableString.Key {
    return .custom("")
  }

  open func getDataRequestInfo() -> LocalizableString.Key {
    return .custom("")
  }

  open func getSuccessRoute() -> AppRoute? {
    return nil
  }

  open func onShare() {
    guard let route = getSuccessRoute() else { return }
    router.push(with: route)
  }

  public func onStartLoading() {
    setNewState(
      isLoading: true
    )
  }

  public func onError(with error: Error) {
    setNewState(
      error: .init(
        description: .custom(error.localizedDescription),
        cancelAction: self.router.pop(),
        action: { self.onErrorAction() }
      )
    )
  }

  public func onReceivedItems(with items: [any RequestDataCell]) {
    setNewState(
      items: items
    )
  }

  func onPop() {
    isRequestInfoModalShowing = false
    isCancelModalShowing = false
    router.pop()
  }

  func onShowCancelModal() {
    isCancelModalShowing = !isCancelModalShowing
  }

  func onShowRequestInfoModal() {
    isRequestInfoModalShowing = !isRequestInfoModalShowing
  }

  func onContentVisibilityChange() {
    setNewState(
      isContentVisible: !viewState.isContentVisible,
      items: viewState.items.map {
        guard var row = $0 as? RequestDataRow else {
          return $0
        }
        row.setVisible(!viewState.isContentVisible)
        return row
      }
    )
  }

  func onSelectionChanged(id: String) {

    let items = viewState.items.map {
      guard var row = $0 as? RequestDataRow, row.id == id else {
        return $0
      }
      row.setSelected(!row.isSelected)
      return row
    }

    let allSelected = items.map {
      ($0 as? RequestDataRow)?.isSelected ?? true
    }
      .filter { !$0 }
      .isEmpty

    setNewState(
      itemsAreAllSelected: allSelected,
      items: items
    )
  }

  private func onErrorAction() {
    setNewState()
    Task {
      await self.doWork()
    }
  }

  private func setNewState(
    isLoading: Bool = false,
    error: ContentError.Config? = nil,
    isContentVisible: Bool? = nil,
    itemsAreAllSelected: Bool? = nil,
    items: [any RequestDataCell]? = nil
  ) {
    setState {
      .init(
        isLoading: isLoading,
        error: error,
        isContentVisible: isContentVisible ?? $0.isContentVisible,
        itemsAreAllSelected: itemsAreAllSelected ?? $0.itemsAreAllSelected,
        items: items ?? $0.items
      )
    }
  }
}
