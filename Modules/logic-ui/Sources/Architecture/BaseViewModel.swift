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

open class BaseViewModel<Router: RouterHostType>: ObservableObject {

  // Loader
  @Published public var showLoader: Bool = false

  // Error
  @Published public var showError: Bool = false
  @Published private(set) public var error: String = ""

  public let router: Router

  public init(router: Router) {
    self.router = router
  }

  public func toggleError() {
    self.showError.toggle()
  }

  public func toggleLoader() {
    self.showLoader.toggle()
  }

  public func setError(_ error: String) {
    self.error = error
    self.toggleError()
  }
}
