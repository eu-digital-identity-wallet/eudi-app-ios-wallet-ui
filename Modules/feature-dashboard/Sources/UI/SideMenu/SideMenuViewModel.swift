/*
 * Copyright (c) 2025 European Commission
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
import logic_ui
import logic_core
import feature_common

@Copyable
struct SideMenuViewState: ViewState {
  let items: [SideMenuItemUIModel]
}

final class SideMenuViewModel<Router: RouterHost>: ViewModel<Router, SideMenuViewState> {

  init(
    router: Router
  ) {
    super.init(
      router: router,
      initialState: .init(items: [])
    )

    buildMenuItems()
  }

  func settings() {
    router.push(
      with: .featureDashboardModule(
        .settingsMenu
      )
    )
  }

  func updatePin() {
    router.push(
      with: .featureCommonModule(
        .quickPin(
          config: QuickPinUiConfig(
            flow: .update
          )
        )
      )
    )
  }

  func toolbarContent() -> ToolBarContent {
    .init(
      trailingActions: [],
      leadingActions: [
        .init(
          image: Theme.shared.image.chevronLeft,
          accessibilityLocator: ToolbarLocators.chevronLeft
        ) {
          self.router.pop()
        }
      ]
    )
  }

  private func buildMenuItems() {
    setState {
      $0.copy(
        items: [
          .init(
            title: .changeQuickPinOption,
            action: self.updatePin()
          ),
          .init(
            title: .settings,
            showDivider: false,
            action: self.settings()
          )
        ]
      )
    }
  }
}
