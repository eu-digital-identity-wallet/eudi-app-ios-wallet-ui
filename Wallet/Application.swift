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
import SwiftUI
import PartialSheet
import logic_assembly

@main
struct Application: App {

  @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
  @Environment(\.scenePhase) var scenePhase

  @State var blurType: BlurType = .none
  @State var toolbarConfig: UIConfig.ToolBar = .init(Theme.shared.color.surface)

  private let routerHost: RouterHost
  private let configUiLogic: ConfigUiLogic
  private let deepLinkController: DeepLinkController
  private let walletKitController: WalletKitController

  init() {

    // Depedency Injection
    DIGraph.assembleDependenciesGraph()

    self.routerHost = DIGraph.resolver.force(RouterHost.self)
    self.configUiLogic = DIGraph.resolver.force(ConfigUiLogic.self)
    self.deepLinkController = DIGraph.resolver.force(DeepLinkController.self)
    self.walletKitController = DIGraph.resolver.force(WalletKitController.self)
    self.toolbarConfig = routerHost.getToolbarConfig()
  }

  var body: some Scene {
    WindowGroup {
      ZStack {

        Rectangle()
          .fill(toolbarConfig.backgroundColor)
          .frame(maxWidth: .infinity, maxHeight: .infinity)
          .edgesIgnoringSafeArea(.all)
          .animation(
            .easeIn(duration: UINavigationController.hideShowBarDuration),
            value: toolbarConfig.backgroundColor
          )

        routerHost.composeApplication()
          .ignoresSafeArea(edges: .bottom)
          .attachPartialSheetToRoot()

        if blurType != .none {
          BlurView(style: .regular)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea(.all)
        }
      }
      .onOpenURL { url in
        if let deepLink = deepLinkController.hasDeepLink(url: url) {
          Task {
            deepLinkController.handleDeepLinkAction(
              routerHost: routerHost,
              deepLinkExecutable: deepLink,
              remoteSessionCoordinator: deepLink.requiresCoordinator
              ? await walletKitController.startSameDevicePresentation(deepLink: deepLink.link)
              : nil
            )
          }
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
      .onReceive(NotificationCenter.default.publisher(for: .shouldChangeBackgroundColor), perform: { _ in
        self.toolbarConfig = routerHost.getToolbarConfig()
      })
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
