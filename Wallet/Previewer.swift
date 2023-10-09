import Foundation
import feature_login
import SwiftUI

import logic_navigation
import logic_ui

class PreviewInteractor: FAQsInteractorType {
  func fetchFAQs() async throws -> [FAQUIModel] {
    try await Task.sleep(nanoseconds: 5 * 1_000_000_000)
    return FAQUIModel.mocks()
  }
}

class PreviewRouter: RouterHostType {
  func push(with route: logic_ui.AppRoute) {}
  func popTo(with route: logic_ui.AppRoute, inclusive: Bool, animated: Bool) {}
  func pop() {}
  func composeApplication() -> AnyView {
    FAQsView(with: self, and: PreviewInteractor())
      .eraseToAnyView()
  }
  func getCurrentScreen() -> logic_ui.AppRoute? { nil }
}

#Preview {
  FAQsView(with: PreviewRouter(), and: PreviewInteractor())
}
