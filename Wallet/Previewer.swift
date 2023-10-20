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
  DashboardView(with: PreviewRouter(), and: DashboardInteractor())
    .environmentObject(BackgroundColorManager())

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
