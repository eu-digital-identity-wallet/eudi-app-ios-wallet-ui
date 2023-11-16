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

@MainActor
final class SuccessViewModel<Router: RouterHostType>: BaseViewModel<Router, SuccessState> {

  init(config: any UIConfigType, router: Router) {
    guard let config = config as? UIConfig.Success else {
      fatalError("SuccessViewModel:: Invalid configuraton")
    }
    super.init(router: router, initialState: .init(config: config))
  }

  func onButtonClicked(with button: UIConfig.Success.Button) {
    switch button.navigationType {
    case .pop:
      router.popTo(with: button.screen)
    case .deepLink:
      if button.deepLink != nil {
        //cacheDeepLinkURL(url: link)
        router.popTo(with: button.screen)
      }
    }
  }
}
