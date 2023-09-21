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
import logic_ui
import logic_navigation
import feature_onboarding

@main
struct Application: App {
  
  @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
  
  private let routerHost: RouterHostType
  private let configUiLogic: ConfigUiLogic
  
  init() {
    self.routerHost = RouterHost()
    self.configUiLogic = ConfigUiProvider.shared.getConfigUiLogic()
  }
  
  var body: some Scene {
    WindowGroup {
      routerHost.composeApplication()
    }
  }
}
