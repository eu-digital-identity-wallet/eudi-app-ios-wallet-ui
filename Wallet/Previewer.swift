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

#Preview {
  FAQsView(with: PreviewRouter(), and: PreviewInteractor())
}
