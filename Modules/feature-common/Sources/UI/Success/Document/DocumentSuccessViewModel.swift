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
@_exported import logic_business

@Copyable
public struct DocumentSuccessState<T: Sendable>: ViewState {
  let config: DocumentSuccessUIConfig
  let contentHeaderConfig: ContentHeaderConfig
  let items: [ListItemSection<T>]
  let navigationTitle: LocalizableStringKey
  let isLoading: Bool
}

open class DocumentSuccessViewModel<Router: RouterHost, RequestItem: Sendable>: ViewModel<Router, DocumentSuccessState<RequestItem>> {

  private let openURL: @MainActor (URL) -> Void

  /// `openURL` opens the verifier's redirect once `URL.openInBrowser(using:)` has accepted it as an
  /// `https` link; the default is the system's opener.
  public init(
    router: Router,
    config: any UIConfigType,
    requestItems: [any Routable],
    openURL: @escaping @MainActor (URL) -> Void = URL.openWithSystem
  ) {

    guard let config = config as? DocumentSuccessUIConfig else {
      fatalError("BaseSuccessViewModel:: Invalid configuraton")
    }

    guard let requestItems = requestItems as? [ListItemSection<RequestItem>] else {
      fatalError("BaseSuccessViewModel:: ListItemSection")
    }

    self.openURL = openURL

    super.init(
      router: router,
      initialState: .init(
        config: config,
        contentHeaderConfig: ContentHeaderConfig(
          appIconAndTextData: AppIconAndTextData(
            appIcon: ThemeManager.shared.image.logoEuDigitalIndentityWallet
          ),
          description: config.isIssuingDocument
          ? .issuanceSuccessHeaderDescription
          : .successfullySharedFollowingInformation,
          relyingPartyData: RelyingPartyData(
            logo: config.issuerLogoUrl == nil ? nil : .remoteImage(config.issuerLogoUrl, nil),
            isVerified: config.relyingPartyIsTrusted,
            name: .custom(config.relyingParty ?? "")
          )
        ),
        items: requestItems.removeTrailingContent(),
        navigationTitle: config.isIssuingDocument
        ? .documentAdded
        : .dataShared,
        isLoading: false
      )
    )
  }

  open func doWork() async {}

  /// A verifier's redirect (`.deepLink`) opens only as an `https` link in the browser, never through the
  /// wallet's link handling, and the user returns to `popToScreen` either way.
  open func onDone() {
    switch viewState.config.successNavigation {
    case .pop(let screen, let inclusive):
      router.popTo(with: screen, inclusive: inclusive)
    case .deepLink(let url, let popToScreen):
      url.openInBrowser(using: openURL)
      router.popTo(with: popToScreen)
    case .push(let screen):
      router.push(with: screen)
    case .none:
      break
    }
  }

}
