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
@_exported import logic_business

@Copyable
public struct BaseSuccessState: ViewState {
  let config: PresentationSuccessUIConfig
  let issuerData: IssuerDataUIModel
  let items: [RequestDataUI]
  let isLoading: Bool
}

open class BaseSuccessViewModel<Router: RouterHost>: ViewModel<Router, BaseSuccessState> {

  private let deepLinkController: DeepLinkController

  public init(
    router: Router,
    config: any UIConfigType,
    deepLinkController: DeepLinkController,
    requestItems: [any Routable]
  ) {

    guard let config = config as? PresentationSuccessUIConfig else {
      fatalError("ExternalLoginViewModel:: Invalid configuraton")
    }

    guard let requestItems = requestItems as? [RequestDataUI] else {
      fatalError("ExternalLoginViewModel:: Invalid configuraton")
    }

    self.deepLinkController = deepLinkController

    super.init(
      router: router,
      initialState: .init(
        config: config,
        issuerData: .init(
          icon: Image(systemName: ""),
          title: config.relyingParty,
          isVerified: true
        ),
        items: requestItems,
        isLoading: false
      )
    )
  }

  open func doWork() async {}

  open func onDone() {
    switch viewState.config.successNavigation {
    case .pop(let screen, let inclusive):
      router.popTo(with: screen, inclusive: inclusive)
    case .deepLink(let url, let popToScreen):
      deepLinkController.cacheDeepLinkURL(url: url)
      router.popTo(with: popToScreen)
    case .push(let screen):
      router.push(with: screen)
    }
  }

  func toolbarContent() -> ToolBarContent {
    .init(
      trailingActions: [
        Action(
          title: LocalizableString.shared.get(with: .doneButton).capitalizedFirst()
        ) {
          self.onDone()
        }
      ]
    )
  }
}
