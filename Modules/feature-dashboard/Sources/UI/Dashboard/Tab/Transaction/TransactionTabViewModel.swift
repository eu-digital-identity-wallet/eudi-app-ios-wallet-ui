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
import logic_ui
import logic_resources

@Copyable
struct TransactionTabState: ViewState {}

final class TransactionTabViewModel<Router: RouterHost>: ViewModel<Router, TransactionTabState> {

  private let interactor: TransactionTabInteractor
  private let onUpdateToolbar: (ToolBarContent, LocalizableStringKey) -> Void

  init(
    router: Router,
    interactor: TransactionTabInteractor,
    onUpdateToolbar: @escaping (ToolBarContent, LocalizableStringKey) -> Void
  ) {
    self.interactor = interactor
    self.onUpdateToolbar = onUpdateToolbar
    super.init(
      router: router,
      initialState: .init()
    )
  }

  func onCreate() {
    onUpdateToolbar(
      .init(
        trailingActions: nil,
        leadingActions: [
          Action(image: Theme.shared.image.menuIcon) {
            self.onMyWallet()
          }
        ]
      ),
      .transactions
    )
  }

  private func onMyWallet() {
    router.push(
      with: .featureDashboardModule(
        .sideMenu
      )
    )
  }
}
