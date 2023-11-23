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
import Foundation
import feature_login
import feature_common
import feature_startup
import feature_dashboard
import feature_issuance
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

#Preview("DocumentDetails View") {
  DocumentDetailsView(
    with: PreviewRouter(),
    and: DocumentDetailsInteractor(),
    config: IssuanceDetailUiConfig(flow: .extraDocument(""))
  )
}

#Preview("AddDocument View") {
  AddDocumentView(
    with: PreviewRouter(),
    and: AddDocumentInteractor(),
    config: IssuanceFlowUiConfig(flow: .extraDocument)
  )
}
