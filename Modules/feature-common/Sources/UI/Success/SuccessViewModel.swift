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
import logic_ui
import logic_business

@MainActor
final class SuccessViewModel<Router: RouterHostType>: BaseViewModel<Router> {

  @Published var config: UIConfig.Success

  init(config: any UIConfigType, router: Router) {
    guard let config = config as? UIConfig.Success else {
      fatalError("SuccessViewModel:: Invalid configuraton")
    }
    self.config = config
    super.init(router: router)
  }

  func onButtonClicked(with button: UIConfig.Success.Button) {
    switch button.navigationType {
    case .pop:
      router.popTo(with: button.screen)
    case .deepLink:
      if let _ = button.deepLink {
        //cacheDeepLinkURL(url: link)
        router.popTo(with: button.screen)
      }
    }
  }
}
