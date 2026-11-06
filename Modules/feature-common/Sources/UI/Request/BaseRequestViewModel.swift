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
import logic_core
import Observation

@Copyable
public struct RequestViewState: ViewState {
  public let isLoading: Bool
  public let error: ContentErrorView.Config?
  public let errorTitle: LocalizableStringKey?
  public let showMissingCredentials: Bool
  public let items: [RequestDataUiModel]
  public let combinations: [RequestCombinationUiModel]
  public let selectedCombinationIndex: Int
  public let relyingParty: LocalizableStringKey
  public let isTrusted: Bool
  public let allowShare: Bool
  public let originator: AppRoute
  public let initialized: Bool
  public let relyingPartyRegistration: RelyingPartyRegistrationData?
  public let registrationWarning: RegistrationWarning?
  public let isTrustBlocked: Bool
}

@Observable
open class BaseRequestViewModel<Router: RouterHost>: ViewModel<Router, RequestViewState> {

  var isTrustBlockedAlertShowing: Bool = false
  var itemsChanged: Bool = false
  var isRiskAcknowledged: Bool = false
  var isUserImageConfirmationShowing: Bool = false

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
        relyingParty: .unknownVerifier,
        isTrusted: false,
        allowShare: false,
        originator: originator,
        initialized: false,
        relyingPartyRegistration: nil,
        registrationWarning: nil,
        isTrustBlocked: false
      )
    )
  }

  open func doWork() async {}

  /// Called when the screen shows again after another screen covered it, for example when the user backs out of
  /// biometry; a subclass resumes what it paused.
  open func onReappear() async {}

  open func getRelyingParty() -> LocalizableStringKey {
    return .custom("")
  }

  open func getRelyingPartyIsTrusted() -> Bool {
    return viewState.isTrusted
  }

  open func getSuccessRoute() -> AppRoute? {
    return nil
  }

  open func onShare() {
    guard let route = getSuccessRoute() else { return }
    router.push(with: route)
  }

  /// Whether Share may send the response now: the request has loaded, the selection can be shared, and a
  /// registration warning, if there is one, was acknowledged. The view enables Share with it, and
  /// `onShareClick()` and `onUserImageShareConfirmed()` check it again before sharing.
  var canShare: Bool {
    viewState.initialized
    && !viewState.isLoading
    && viewState.allowShare
    && (viewState.registrationWarning == nil || isRiskAcknowledged)
  }

  /// Shares, or first asks for confirmation when Share would disclose a picture of the holder, as on Android.
  func onShareClick() {
    guard canShare else { return }
    guard viewState.items.sharesUserImage() else {
      onShare()
      return
    }
    isUserImageConfirmationShowing = true
  }

  /// Shares once the user has confirmed sending the picture of the holder.
  func onUserImageShareConfirmed() {
    isUserImageConfirmationShowing = false
    guard canShare else { return }
    onShare()
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
      with: [.init(documents: items)],
      title: title,
      relyingParty: relyingParty,
      isTrusted: isTrusted
    )
  }

  public func onReceivedCombinations(
    with combinations: [RequestCombinationUiModel],
    title: LocalizableStringKey,
    relyingParty: LocalizableStringKey,
    isTrusted: Bool
  ) {
    let selectedItems = combinations.first?.documents ?? []
    setState {
      $0.copy(
        isLoading: false,
        items: selectedItems,
        combinations: combinations,
        selectedCombinationIndex: 0,
        relyingParty: relyingParty,
        isTrusted: isTrusted,
        allowShare: hasSharableSelection(selectedItems),
        initialized: true
      )
      .copy(error: nil)
    }
  }

  func onCombinationSelected(index: Int) {
    guard viewState.combinations.indices.contains(index) else { return }
    let selectedItems = viewState.combinations[index].documents
    setState {
      $0.copy(
        showMissingCredentials: false,
        items: selectedItems,
        selectedCombinationIndex: index,
        allowShare: hasSharableSelection(selectedItems)
      )
    }
  }

  /// Shows the registration and its warning. `isRelyingPartyTrusted` is false for a relying party that
  /// did not authenticate, which then gets the access-certificate warning
  /// (`RegistrationWarning.accessCertificateNotTrusted`) that keeps Share disabled. Both flows pass the
  /// request's own verdict, as Android does; with the configured client identifier schemes wallet-kit
  /// refuses an OpenID4VP verifier that did not authenticate before its request reaches this screen.
  public func onReceivedRegistration(_ registration: RelyingPartyRegistration, isRelyingPartyTrusted: Bool) {
    isRiskAcknowledged = false
    let resolvedName = registration.name.map { LocalizableStringKey.custom($0) }
    setState {
      $0
        .copy(relyingParty: resolvedName ?? $0.relyingParty)
        .copy(isTrusted: registration.isFullyVerified)
        .copy(relyingPartyRegistration: registration.toRegistrationData(fallbackName: .unknownVerifier))
        .copy(registrationWarning: registration.toWarning(isRelyingPartyTrusted: isRelyingPartyTrusted))
    }
  }

  func toolbarContent() -> ToolBarContent {
    .init(
      leadingActions: [
        .init(
          image: Theme.shared.image.chevronLeft,
          accessibilityLocator: ToolbarLocators.chevronLeft
        ) {
          Task { await self.declineRequest() }
          self.onPop()
        }
      ]
    )
  }

  public func onPop() {
    if let route = getPopRoute() {
      router.popTo(with: route)
    } else {
      router.pop()
    }
  }

  open func stopPresentation() async {}
  /// Called when the user leaves the request with Back: a remote request sends the decline, and a proximity
  /// request stops its Bluetooth session. Does nothing by default.
  open func declineRequest() async {}
  public func onTrustBlocked() {
    setState {
      $0.copy(
        isLoading: false,
        showMissingCredentials: false,
        items: [],
        combinations: [],
        allowShare: false,
        initialized: true,
        isTrustBlocked: true
      ).copy(error: nil)
    }
    isTrustBlockedAlertShowing = true
    Task { await stopPresentation() }
  }

  func onTrustBlockedClose() {
    isTrustBlockedAlertShowing = false
    onPop()
  }

  func onSelectionChanged(id: String) async {
    await onCombinationItemClick(combinationIndex: viewState.selectedCombinationIndex, id: id)
  }

  func onCombinationItemClick(combinationIndex: Int, id: String) async {
    guard viewState.combinations.indices.contains(combinationIndex) else { return }

    if viewState.combinations[combinationIndex].documents.hasSelectableClaims() && viewState.showMissingCredentials {
      itemsChanged = true
      setState {
        $0.copy(
          showMissingCredentials: false
        )
      }
    } else {
      let updatedItems = viewState.combinations[combinationIndex].documents.map { item in
        var updatedItem = item
        updatedItem.toggleSelection(id: id)
        return updatedItem
      }

      var combinations = viewState.combinations
      combinations[combinationIndex] = combinations[combinationIndex].copy(documents: updatedItems)

      let isSelectedCombination = combinationIndex == viewState.selectedCombinationIndex

      setState {
        $0.copy(
          showMissingCredentials: false,
          items: isSelectedCombination ? updatedItems : $0.items,
          combinations: combinations,
          allowShare: isSelectedCombination ? hasSharableSelection(updatedItems) : $0.allowShare
        )
      }
    }
  }

  private func hasSharableSelection(_ items: [RequestDataUiModel]) -> Bool {
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
