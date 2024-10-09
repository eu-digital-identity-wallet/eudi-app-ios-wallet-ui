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

public protocol RouterHost {
  @MainActor func push(with route: AppRoute)
  @MainActor func popTo(with route: AppRoute, inclusive: Bool, animated: Bool)
  @MainActor func pop(animated: Bool)
  @MainActor func pop()
  @MainActor func popTo(with route: AppRoute, inclusive: Bool)
  @MainActor func popTo(with route: AppRoute)
  @MainActor func composeApplication() -> AnyView
  @MainActor func getCurrentScreen() -> AppRoute?
  @MainActor func getToolbarConfig() -> UIConfig.ToolBar
  @MainActor func userIsLoggedInWithDocuments() -> Bool
  @MainActor func userIsLoggedInWithNoDocuments() -> Bool
  @MainActor func isScreenForeground(with route: AppRoute) -> Bool
  @MainActor func isScreenOnBackStack(with route: AppRoute) -> Bool
}

public final class PreviewRouter: RouterHost {

  public init() {}

  public func push(with route: AppRoute) {}

  public func popTo(with route: AppRoute, inclusive: Bool, animated: Bool) {}

  public func popTo(with route: AppRoute, inclusive: Bool) {}

  public func popTo(with route: AppRoute) {}

  public func pop(animated: Bool) {}

  public func pop() {}

  public func composeApplication() -> AnyView { EmptyView().eraseToAnyView() }

  public func getCurrentScreen() -> AppRoute? { .none }

  public func getToolbarConfig() -> UIConfig.ToolBar { .init(.clear) }

  public func userIsLoggedInWithDocuments() -> Bool {
    false
  }

  public func userIsLoggedInWithNoDocuments() -> Bool {
    true
  }

  public func isScreenForeground(with route: AppRoute) -> Bool {
    false
  }

  public func isScreenOnBackStack(with route: AppRoute) -> Bool {
    true
  }
}
