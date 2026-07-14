/*
 * Copyright (c) 2026 European Commission
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
import Observation

@Copyable
public struct RequestViewState: ViewState {
  public let isLoading: Bool
  public let error: ContentErrorView.Config?
  public let errorTitle: LocalizableStringKey?
  public let showMissingCredentials: Bool
  public let items: [RequestDataUiModel]
  public let combinations: [[RequestDataUiModel]]
  public let selectedCombinationIndex: Int
  public let trustedRelyingPartyInfo: LocalizableStringKey
  public let relyingParty: LocalizableStringKey
  public let isTrusted: Bool
  public let allowShare: Bool
  public let originator: AppRoute
  public let initialized: Bool
  public let contentHeaderConfig: ContentHeaderConfig
}

@Observable
open class BaseRequestViewModel<Router: RouterHost>: ViewModel<Router, RequestViewState> {

  var isRequestInfoModalShowing: Bool = false
  var isVerifiedEntityModalShowing: Bool = false
  var isVerifierNotTrustedSheetShowing: Bool = false
  var itemsChanged: Bool = false

  public init(router: Router, originator: AppRoute) {
    super.init(
      router: router,
      initialState: .init(
        isLoading: true,
        error: nil,
        errorTitle: nil,
        showMissingCredentials: true,
        items: RequestDataUiModel.mockData(),
        combinations: [],
        selectedCombinationIndex: 0,
        trustedRelyingPartyInfo: .requestDataVerifiedEntityMessage,
        relyingParty: .unknownVerifier,
        isTrusted: false,
        allowShare: false,
        originator: originator,
        initialized: false,
        contentHeaderConfig: .init(
          appIconAndTextData: AppIconAndTextData(
            appIcon: ThemeManager.shared.image.logoEuDigitalIndentityWallet
          ),
          description: .dataSharingTitle
        )
      )
    )
  }

  open func doWork() async {}

  open func getTitle() -> LocalizableStringKey {
    return .custom("")
  }

  open func getRelyingParty() -> LocalizableStringKey {
    return .custom("")
  }

  open func getRelyingPartyIsTrusted() -> Bool {
    return false
  }

  open func getCaption() -> LocalizableStringKey {
    return .custom("")
  }

  open func getDataRequestInfo() -> LocalizableStringKey {
    return .custom("")
  }

  open func getSuccessRoute() -> AppRoute? {
    return nil
  }

  open func getTitleCaption() -> LocalizableStringKey {
    return .custom("")
  }

  open func getTrustedRelyingParty() -> LocalizableStringKey {
    return .custom("")
  }

  open func getTrustedRelyingPartyInfo() -> LocalizableStringKey {
    return .custom("")
  }

  open func onShare() {
    guard let route = getSuccessRoute() else { return }
    router.push(with: route)
  }

  open func getPopRoute() -> AppRoute? {
    return nil
  }

  public func getOriginator() -> AppRoute {
    return viewState.originator
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
          description: .custom(error.errorMessage),
          cancelAction: self.router.pop(),
          action: { self.onErrorAction() }
        )
      )
    }
  }

  public func onEmptyDocuments(error: String) {
    setState {
      $0.copy(
        isLoading: false,
        errorTitle: .custom(error),
        items: [],
        initialized: true
      ).copy(error: nil)
    }
  }

  public func onReceivedItems(
    with items: [RequestDataUiModel],
    title: LocalizableStringKey,
    relyingParty: LocalizableStringKey,
    isTrusted: Bool
  ) {
    onReceivedCombinations(
      with: [items],
      title: title,
      relyingParty: relyingParty,
      isTrusted: isTrusted
    )
  }

  public func onReceivedCombinations(
    with combinations: [[RequestDataUiModel]],
    title: LocalizableStringKey,
    relyingParty: LocalizableStringKey,
    isTrusted: Bool
  ) {
    let selectedItems = combinations.first ?? []
    setState {
      $0.copy(
        isLoading: false,
        items: selectedItems,
        combinations: combinations,
        selectedCombinationIndex: 0,
        relyingParty: relyingParty,
        isTrusted: isTrusted,
        allowShare: canShare(with: selectedItems),
        initialized: true
      )
      .copy(error: nil)
    }
  }

  func onCombinationSelected(index: Int) {
    guard viewState.combinations.indices.contains(index) else { return }
    let selectedItems = viewState.combinations[index]
    setState {
      $0.copy(
        showMissingCredentials: false,
        items: selectedItems,
        selectedCombinationIndex: index,
        allowShare: canShare(with: selectedItems)
      )
    }
  }

  public func resetState() {
    setState { previous in
      .init(
        isLoading: true,
        error: nil,
        errorTitle: nil,
        showMissingCredentials: true,
        items: RequestDataUiModel.mockData(),
        combinations: [],
        selectedCombinationIndex: 0,
        trustedRelyingPartyInfo: .requestDataVerifiedEntityMessage,
        relyingParty: .unknownVerifier,
        isTrusted: false,
        allowShare: false,
        originator: previous.originator,
        initialized: false,
        contentHeaderConfig: initialHeaderConfig()
      )
    }
  }

  func toolbarContent() -> ToolBarContent {
    .init(
      leadingActions: [
        .init(
          image: Theme.shared.image.chevronLeft,
          accessibilityLocator: ToolbarLocators.chevronLeft
        ) {
          self.onPop()
        }
      ]
    )
  }

  func onPop() {
    isRequestInfoModalShowing = false
    if let route = getPopRoute() {
      router.popTo(with: route)
    } else {
      router.pop()
    }
  }

  func onShowRequestInfoModal() {
    isRequestInfoModalShowing = !isRequestInfoModalShowing
  }

  func onVerifiedEntityModal() {
    isVerifiedEntityModalShowing = !isVerifiedEntityModalShowing
  }

  open func stopPresentation() async {}
  public func onVerifierNotTrusted() {
    setState {
      $0.copy(isLoading: false, initialized: true).copy(error: nil)
    }
    isVerifierNotTrustedSheetShowing = true
    Task { await stopPresentation() }
  }

  func onVerifierNotTrustedClose() {
    isVerifierNotTrustedSheetShowing = false
    onPop()
  }

  func onSelectionChanged(id: String) async {
    await onCombinationItemClick(combinationIndex: viewState.selectedCombinationIndex, id: id)
  }

  /// Handles a row tap (expand/collapse or checkbox toggle) within a specific combination.
  /// Edits that combination's data and, when it is the selected one, keeps `items` in sync.
  func onCombinationItemClick(combinationIndex: Int, id: String) async {
    guard viewState.combinations.indices.contains(combinationIndex) else { return }

    if viewState.combinations[combinationIndex].hasSelectableClaims() && viewState.showMissingCredentials {
      itemsChanged = true
      setState {
        $0.copy(
          showMissingCredentials: false
        )
      }
    } else {
      let updatedItems = viewState.combinations[combinationIndex].map { item in
        var updatedItem = item
        updatedItem.toggleSelection(id: id)
        return updatedItem
      }

      var combinations = viewState.combinations
      combinations[combinationIndex] = updatedItems

      let isSelectedCombination = combinationIndex == viewState.selectedCombinationIndex

      setState {
        $0.copy(
          showMissingCredentials: false,
          items: isSelectedCombination ? updatedItems : $0.items,
          combinations: combinations,
          allowShare: isSelectedCombination ? canShare(with: updatedItems) : $0.allowShare
        )
      }
    }
  }

  private func initialHeaderConfig() -> ContentHeaderConfig {
    .init(
      appIconAndTextData: AppIconAndTextData(
        appIcon: ThemeManager.shared.image.logoEuDigitalIndentityWallet
      ),
      description: .dataSharingTitle
    )
  }

  private func canShare(with items: [RequestDataUiModel]) -> Bool {
    items.canShare()
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
