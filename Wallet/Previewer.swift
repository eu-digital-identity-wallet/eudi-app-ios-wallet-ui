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
import Foundation
import feature_login
import feature_common
import feature_startup
import feature_dashboard
import SwiftUI

import logic_navigation
import logic_ui
import logic_resources
import logic_business

#Preview {
  FAQsView(with: PreviewRouter(), and: FAQsInteractor())
}

#Preview {
  SuccessView(
    with: PreviewRouter(),
    and: successConfig()
  )
}

#Preview {
  StartupView(with: PreviewRouter(), and: StartupInteractor())
}

#Preview {
  DashboardView(with: PreviewRouter(), and: DashboardInteractor(), also: DeepLinkController())

}

#Preview {
  BiometryView(
    with: PreviewRouter(),
    interactor: BiometryInteractor(),
    config: UIConfig.Biometry(
      title: .genericErrorTitle,
      caption: .genericErrorDesc,
      quickPinOnlyCaption: .genericErrorDesc,
      navigationSuccessConfig: .init(
        screen: .success(config: successConfig()), navigationType: .push
      ),
      navigationBackConfig: .init(screen: .startup, navigationType: .pop),
      isPreAuthorization: false,
      shouldInitializeBiometricOnCreate: false
    )
  )
}

#Preview {
  FloatingActionButton(title: .custom("FAB"), icon: Theme.shared.image.xmark) {

  }
}

private func successConfig() -> UIConfig.Success {
  return UIConfig.Success(
    title: .custom("LITERAL PLACEHOLDER"),
    subtitle: .custom("LITERAL PLACEHOLDER"),
    buttons: [
      .init(
        title: .custom("LITERAL PLACEHOLDER"),
        screen: .startup,
        style: .primary, navigationType: .pop
      )
    ],
    visualKind: .defaultIcon
  )
}

#Preview("Welcome View") {
  WelcomeView(with: PreviewRouter(), and: WelcomeInteractor())
}
