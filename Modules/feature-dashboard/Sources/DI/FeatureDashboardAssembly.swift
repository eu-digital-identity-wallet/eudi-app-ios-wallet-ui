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
import Swinject
import logic_business
import logic_core

public final class FeatureDashboardAssembly: Assembly {

  public init() {}

  public func assemble(container: Container) {
    container.register(DashboardInteractor.self) { r in
      DashboardInteractorImpl(
        walletController: r.force(WalletKitController.self),
        filterValidator: r.force(FilterValidator.self),
        reachabilityController: r.force(ReachabilityController.self),
        configLogic: r.force(ConfigLogic.self)
      )
    }
    .inObjectScope(ObjectScope.transient)

    container.register(DocumentSignInteractor.self) { r in
      DocumentSignInteractorImpl(configLogic: r.force(ConfigLogic.self))
    }

    container.register(SideMenuInteractor.self) { r in
      SideMenuInteractorImpl(
        walletController: r.force(WalletKitController.self),
        configLogic: r.force(ConfigLogic.self)
      )
    }
  }
}
