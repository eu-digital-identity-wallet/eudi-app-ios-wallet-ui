import Foundation
import feature_login
import feature_common
import feature_startup
import feature_dashboard
import SwiftUI

import logic_navigation
import logic_ui

#Preview {
  FAQsView(with: PreviewRouter(), and: FAQsInteractor())
}

#Preview {
  SuccessView(
    with: PreviewRouter(),
    and: UIConfig.Success(
      title: "title",
      subtitle: "SubTitle",
      buttons: [
        .init(
          title: "Button title",
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
