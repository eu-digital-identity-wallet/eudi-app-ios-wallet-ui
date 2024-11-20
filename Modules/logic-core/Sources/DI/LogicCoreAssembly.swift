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

public final class LogicCoreAssembly: Assembly {

  public init() {}

  public func assemble(container: Container) {
    container.register(WalletKitConfig.self) { r in
      WalletKitConfigImpl(configLogic: r.force(ConfigLogic.self))
    }
    .inObjectScope(ObjectScope.container)

    container.register(WalletKitController.self) { r in
      WalletKitControllerImpl(
        configLogic: r.force(WalletKitConfig.self),
        keyChainController: r.force(KeyChainController.self),
        sessionCoordinatorHolder: r.force(SessionCoordinatorHolder.self)
      )
    }
    .inObjectScope(ObjectScope.container)

    container.register(ProximitySessionCoordinator.self) { _, session in
      ProximitySessionCoordinatorImpl(session: session)
    }
    .inObjectScope(ObjectScope.transient)

    container.register(RemoteSessionCoordinator.self) { _, session in
      RemoteSessionCoordinatorImpl(session: session)
    }
    .inObjectScope(ObjectScope.transient)

    container.register(SessionCoordinatorHolder.self) { _ in
      SessionCoordinatorHolderImpl()
    }
    .inObjectScope(ObjectScope.transient)
  }
}
