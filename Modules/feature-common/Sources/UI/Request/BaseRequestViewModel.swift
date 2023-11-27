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

@_exported import logic_ui
@_exported import logic_resources

public struct RequestViewState: ViewState {
  public let isLoading: Bool
  public let error: ContentError.Config?
  public let isContentVisible: Bool
  public let itemsAreAllSelected: Bool
  public let items: [RequestDataCell]
  public let title: LocalizableString.Key
  public let trustedRelyingPartyInfo: LocalizableString.Key
  public let relyingParty: String
  public let isTrusted: Bool
}

@MainActor
open class BaseRequestViewModel<Router: RouterHostType>: BaseViewModel<Router, RequestViewState> {

  @Published var isCancelModalShowing: Bool = false
  @Published var isRequestInfoModalShowing: Bool = false
  @Published var isVerifiedEntityModalShowing: Bool = false

  public init(router: Router) {
    super.init(
      router: router,
      initialState: .init(
        isLoading: true,
        error: nil,
        isContentVisible: false,
        itemsAreAllSelected: true,
        items: RequestDataUiModel.mock(),
        title: .requestDataTitle([LocalizableString.shared.get(with: .unknownVerifier)]),
        trustedRelyingPartyInfo: .requestDataVerifiedEntityMessage,
        relyingParty: "Unknown Verifier",
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

  open func getTitleCaption() -> String {
    return ""
  }

  open func getTrustedRelyingParty() -> LocalizableString.Key {
    return .custom("")
  }

  open func getTrustedRelyingPartyInfo() -> LocalizableString.Key {
    return .custom("")
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

  func onVerifiedEntityModal() {
    isVerifiedEntityModalShowing = !isVerifiedEntityModalShowing
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
    trustedRelyingPartyInfo: LocalizableString.Key? = nil,
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
        trustedRelyingPartyInfo: trustedRelyingPartyInfo ?? $0.trustedRelyingPartyInfo,
        relyingParty: relyingParty ?? $0.relyingParty,
        isTrusted: isTrusted ?? $0.isTrusted
      )
    }
  }
}
