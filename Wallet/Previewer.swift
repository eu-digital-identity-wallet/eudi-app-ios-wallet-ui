import Foundation
import feature_login
import feature_common
import feature_startup
import feature_dashboard
import SwiftUI

import logic_navigation
import logic_ui
import logic_resources

#Preview {
  FAQsView(with: PreviewRouter(), and: FAQsInteractor())
}

#Preview {
  SuccessView(
    with: PreviewRouter(),
    and: UIConfig.Success(
      title: .custom("LITERAL PLACEHOLDER"),
      subtitle: .custom("LITERAL PLACEHOLDER"),
      buttons: [
        .init(
          title: .custom("LITERAL PLACEHOLDER"),
          screen: .startup,
          style: .primary,
          navigationType: .pop
        )
      ],
      visualKind: .defaultIcon
    )
  )
}

#Preview {
  StartupView(with: PreviewRouter(), and: StartupInteractor())
}

#Preview {
  DashboardView(with: PreviewRouter(), and: DashboardInteractor())
}
