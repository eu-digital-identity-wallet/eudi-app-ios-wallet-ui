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
import logic_business
import logic_core

@MainActor
public final class DashboardRouter {

  @ViewBuilder
  public static func resolve(module: FeatureDashboardRouteModule, host: some RouterHost) -> some View {
    switch module {
    case .dashboard:
      DashboardView(
        with: .init(
          router: host,
          dashboardInteractor: DIGraph.shared.resolver.force(
            DashboardInteractor.self
          ),
          homeTabInteractor: DIGraph.shared.resolver.force(
            HomeTabInteractor.self
          ),
          documentTabInteractor: DIGraph.shared.resolver.force(
            DocumentTabInteractor.self
          ),
          transactionTabInteractor: DIGraph.shared.resolver.force(
            TransactionTabInteractor.self
          ),
          deepLinkController: DIGraph.shared.resolver.force(
            DeepLinkController.self
          )
        )
      )
    case .signDocument:
      SignDocumentView(
        with: .init(
          router: host,
          interactor: DIGraph.shared.resolver.force(
            DocumentSignInteractor.self
          )
        )
      )
    case .sideMenu:
      SideMenuView(
        with: .init(
          router: host
        )
      )
    case .settingsMenu:
      SettingsView(
        with: .init(
          router: host,
          interactor: DIGraph.shared.resolver.force(
            SettingsInteractor.self
          ),
          walletKit: DIGraph.shared.resolver.force(
            WalletKitController.self
          )
        )
      )
    case .issuanceOption:
      IssuanceOptionView(
        with: .init(
          router: host
        )
      )
    case .documentDetails(id: let id):
      DocumentDetailsView(
        with: .init(
          router: host,
          interactor: DIGraph.shared.resolver.force(
            DocumentDetailsInteractor.self
          ),
          documentId: id
        )
      )
    case .transactionDetails(id: let id):
      TransactionDetailsView(
        with: .init(
          router: host,
          interactor: DIGraph.shared.resolver.force(
            TransactionDetailsInteractor.self
          ),
          transactionId: id
        )
      )
    }
  }
}
