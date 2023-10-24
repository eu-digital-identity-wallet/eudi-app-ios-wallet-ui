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
import logic_resources
import logic_business
import PartialSheet

@main
struct Application: App {

  @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
  @Environment(\.scenePhase) var scenePhase

  @State var isScreenCapping: Bool = false
  @State var blurType: BlurType = .none
  @State var shouldAddBottomPadding: Bool = false
  @State var backgroundColor: Color = Theme.shared.color.primary

  private let routerHost: RouterHostType
  private let configUiLogic: ConfigUiLogic
  private let securityController: SecurityControllerType

  init() {
    self.routerHost = RouterHost()
    self.configUiLogic = ConfigUiProvider.shared.getConfigUiLogic()
    self.securityController = SecurityController()
    self.backgroundColor = routerHost.getBackgroundColor()
  }

  var body: some Scene {
    WindowGroup {
      ZStack {

        Rectangle()
          .fill(backgroundColor)
          .frame(maxWidth: .infinity, maxHeight: .infinity)
          .edgesIgnoringSafeArea(.all)
          .animation(
            .easeIn(duration: UINavigationController.hideShowBarDuration),
            value: backgroundColor
          )

        routerHost.composeApplication()
          .if(self.shouldAddBottomPadding == false) {
            $0.ignoresSafeArea(edges: .bottom)
          }
          .attachPartialSheetToRoot()

        if isScreenCapping {
          warningScreenCap()
        }

        if blurType != .none {
          BlurView(style: .regular)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea(.all)
        }
      }
      .onChange(of: scenePhase) { phase in
        switch phase {
        case .background:
          self.blurType = .background
        case .inactive:
          self.blurType = .inactive
        case .active:
          self.blurType = .none
        default: break
        }
      }
      .onReceive(NotificationCenter.default.publisher(for: UIScreen.capturedDidChangeNotification)) { _ in
        guard self.securityController.isScreenCaptureDisabled() else {
          return
        }
        self.isScreenCapping.toggle()
      }
      .onReceive(NotificationCenter.default.publisher(for: .shouldChangeBackgroundColor), perform: { _ in
        self.backgroundColor = routerHost.getBackgroundColor()
      })
      .task {
        await checkForHomeIndicator()
      }
    }
  }

  private func warningScreenCap() -> some View {
    ZStack(alignment: .center) {
      VStack(alignment: .center, spacing: SPACING_EXTRA_LARGE) {
        ThemeManager.shared.image.logo
        Text(.screenCaptureSecurityWarning)
          .typography(ThemeManager.shared.font.bodyMedium)
          .foregroundColor(ThemeManager.shared.color.textPrimaryDark)
          .multilineTextAlignment(.center)
      }
    }
    .padding()
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(ThemeManager.shared.color.backgroundPaper)
    .edgesIgnoringSafeArea(.all)
  }

  private func checkForHomeIndicator() async {
    try? await Task.sleep(nanoseconds: 1_000_000_000)
    if UIDevice.current.uiHomeIndicator == .unavailable {
      self.shouldAddBottomPadding = true
    }
  }
}

extension Application {
  enum BlurType {
    case inactive
    case background
    case none
  }
}
