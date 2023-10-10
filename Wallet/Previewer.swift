import Foundation
import feature_login
import SwiftUI

import logic_navigation
import logic_ui

class PreviewInteractor: FAQsInteractorType {
  func fetchFAQs() async throws -> [FAQUIModel] {
    try await Task.sleep(nanoseconds: 2 * 1_000_000_000)
    return FAQUIModel.mocks()
  }
}

class PreviewRouter: RouterHostType {
  func push(with route: AppRoute) {}
  func popTo(with route: AppRoute, inclusive: Bool, animated: Bool) {}
  func pop(animated: Bool) {}
  func composeApplication() -> AnyView {
    FAQsView(with: self, and: PreviewInteractor())
      .eraseToAnyView()
  }
  func getCurrentScreen() -> AppRoute? { nil }
}

#Preview {
  FAQsView(with: PreviewRouter(), and: PreviewInteractor())
}
