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
import SwiftUI

final class SuccessViewModel<Router: RouterHostType>: BaseViewModel<Router> {

  let config: SuccessUiConfig

  init(config: SuccessUiConfig, router: Router) {
    self.config = config
    super.init(router: router)
  }

  func onBack() {
    if let route = config.routeToPop {
      router.popTo(with: route, inclusive: false, animated: true)
    } else {
      router.pop()
    }
  }
}
