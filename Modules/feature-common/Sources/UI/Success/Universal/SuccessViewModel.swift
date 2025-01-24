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
import logic_ui
import logic_business

struct SuccessState: ViewState {
  let config: UIConfig.Success
}

final class SuccessViewModel<Router: RouterHost>: ViewModel<Router, SuccessState> {

  private let deepLinkController: DeepLinkController

  init(
    config: any UIConfigType,
    router: Router,
    deepLinkController: DeepLinkController
  ) {
    guard let config = config as? UIConfig.Success else {
      fatalError("SuccessViewModel:: Invalid configuraton")
    }
    self.deepLinkController = deepLinkController
    super.init(router: router, initialState: .init(config: config))
  }

  func onButtonClicked(with button: UIConfig.Success.Button) {
    switch button.navigationType {
    case .pop(let screen, let inclusive):
      router.popTo(with: screen, inclusive: inclusive)
    case .deepLink(let url, let popToScreen):
      deepLinkController.cacheDeepLinkURL(url: url)
      router.popTo(with: popToScreen)
    case .push(let screen):
      router.push(with: screen)
    }
  }
}
