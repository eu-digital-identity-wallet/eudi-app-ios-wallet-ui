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
import logic_api

public enum FAQsPartialState {
  case success([FAQUIModel])
  case failure(Error)
}

public protocol FAQsInteractor {
  func fetchFAQs() async -> FAQsPartialState
}

final class FAQsInteractorImpl: FAQsInteractor {

  public func fetchFAQs() async -> FAQsPartialState {
    do {
      try await Task.sleep(nanoseconds: 2 * 1_000_000_000)
      return .success(FAQUIModel.mocks())
    } catch {
      return .failure(error)
    }
  }
}
