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
  public let items: [RequestDataCell]
  public let title: LocalizableString.Key
  public let caption: LocalizableString.Key
  public let dataRequestInfo: LocalizableString.Key
  public let relyingParty: String
  public let isTrusted: Bool
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
        items: RequestDataUiModel.mock(),
        title: .requestDataTitle(["EUDI Conference"]),
        caption: .requestDataCaption,
        dataRequestInfo: .requestDataInfoNotice,
        relyingParty: "EUDI Conference",
        isTrusted: false
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

  open func getPopRoute() -> AppRoute? {
    return nil
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

  public func onReceivedItems(
    with items: [RequestDataCell],
    title: LocalizableString.Key,
    relyingParty: String,
    isTrusted: Bool
  ) {
    setNewState(
      items: items,
      title: title,
      relyingParty: relyingParty,
      isTrusted: isTrusted
    )
  }

  func onPop() {
    isRequestInfoModalShowing = false
    isCancelModalShowing = false
    if let route = getPopRoute() {
      router.popTo(with: route)
    } else {
      router.pop()
    }
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
        if var row = $0.isDataRow {
          row.setVisible(!viewState.isContentVisible)
          return .requestDataRow(row)
        }
        return $0
      }
    )
  }

  func onSelectionChanged(id: String) {
    let items = viewState.items.map {
      if var row = $0.isDataRow, row.id == id {
        row.setSelected(!row.isSelected)
        return RequestDataCell.requestDataRow(row)
      }
      return $0
    }

    let allSelected = items.map { $0.isDataRow?.isSelected ?? true }
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
    items: [RequestDataCell]? = nil,
    title: LocalizableString.Key? = nil,
    caption: LocalizableString.Key? = nil,
    dataRequestInfo: LocalizableString.Key? = nil,
    relyingParty: String? = nil,
    isTrusted: Bool? = nil
  ) {
    setState {
      .init(
        isLoading: isLoading,
        error: error,
        isContentVisible: isContentVisible ?? $0.isContentVisible,
        itemsAreAllSelected: itemsAreAllSelected ?? $0.itemsAreAllSelected,
        items: items ?? $0.items,
        title: title ?? $0.title,
        caption: caption ?? $0.caption,
        dataRequestInfo: dataRequestInfo ?? $0.dataRequestInfo,
        relyingParty: relyingParty ?? $0.relyingParty,
        isTrusted: isTrusted ?? $0.isTrusted
      )
    }
  }
}
