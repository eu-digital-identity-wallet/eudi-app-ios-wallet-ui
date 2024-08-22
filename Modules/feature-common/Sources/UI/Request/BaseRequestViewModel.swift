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

@Copyable
public struct RequestViewState: ViewState {
  public let isLoading: Bool
  public let error: ContentErrorView.Config?
  public let isContentVisible: Bool
  public let itemsAreAllSelected: Bool
  public let items: [RequestDataUIModel]
  public let title: LocalizableString.Key
  public let trustedRelyingPartyInfo: LocalizableString.Key
  public let relyingParty: String
  public let isTrusted: Bool
  public let allowShare: Bool
}

open class BaseRequestViewModel<Router: RouterHost>: BaseViewModel<Router, RequestViewState> {

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
        relyingParty: LocalizableString.shared.get(with: .unknownVerifier),
        isTrusted: false,
        allowShare: false
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
    setState {
      $0.copy(isLoading: true).copy(error: nil)
    }
  }

  public func onError(with error: Error) {
    setState {
      $0.copy(
        isLoading: false,
        error: .init(
          description: .custom(error.localizedDescription),
          cancelAction: self.router.pop(),
          action: { self.onErrorAction() }
        )
      )
    }
  }

  public func onEmptyDocuments() {
    setState {
      $0
        .copy(isLoading: false, items: [])
        .copy(error: nil)
    }
  }

  public func onReceivedItems(
    with items: [RequestDataUIModel],
    title: LocalizableString.Key,
    relyingParty: String,
    isTrusted: Bool
  ) {
    setState {
      $0
        .copy(
          isLoading: false,
          items: items,
          title: title,
          relyingParty: relyingParty,
          isTrusted: isTrusted,
          allowShare: !items.isEmpty
        )
        .copy(error: nil)
    }
  }

  public func resetState() {
    setState { _ in
        .init(
          isLoading: true,
          error: nil,
          isContentVisible: false,
          itemsAreAllSelected: true,
          items: RequestDataUiModel.mock(),
          title: .requestDataTitle([LocalizableString.shared.get(with: .unknownVerifier)]),
          trustedRelyingPartyInfo: .requestDataVerifiedEntityMessage,
          relyingParty: LocalizableString.shared.get(with: .unknownVerifier),
          isTrusted: false,
          allowShare: false
        )
    }
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
    setState {
      $0.copy(
        isContentVisible: !viewState.isContentVisible,
        items: viewState.items.map {
          if var row = $0.isDataRow {
            row.setVisible(!viewState.isContentVisible)
            return .requestDataRow(row)
          }
          if var row = $0.isDataVerification {
            let items = row.items.map({
              var item = $0
              item.isVisible = !viewState.isContentVisible
              return item
            }
            )
            row.setItems(with: items)
            return .requestDataVerification(row)
          }
          return $0
        }
      )
    }
  }

  func onSelectionChanged(id: String) {
    let items = viewState.items.map {
      if var row = $0.isDataRow, row.id == id {
        row.setSelected(!row.isSelected)
        return RequestDataUIModel.requestDataRow(row)
      }
      return $0
    }

    let allSelected = items.map {
      if $0.isDataRow?.isEnabled == false {
        return true
      }
      return $0.isDataRow?.isSelected ?? true
    }
      .filter { !$0 }
      .isEmpty

    let hasVerificationItems = !items.compactMap { $0.isDataVerification }.isEmpty

    let onlyDataRowItems: [RequestDataUIModel] = items
      .compactMap {
        if $0.isDataSection == nil && $0.isDataRow?.isEnabled == true {
          return $0
        }
        return nil
      }

    let canShare = !onlyDataRowItems.map {
      if let row = $0.isDataRow {
        return row.isSelected
      }
      return false
    }
      .filter { $0 }
      .isEmpty

    setState {
      $0.copy(
        itemsAreAllSelected: allSelected,
        items: items,
        allowShare: canShare || hasVerificationItems
      )
    }
  }

  private func onErrorAction() {
    setState {
      $0
        .copy(isLoading: false)
        .copy(error: nil)
    }
    Task {
      await self.doWork()
    }
  }
}
