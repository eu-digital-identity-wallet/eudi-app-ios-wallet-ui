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

public final class LogicCoreAssembly: Assembly {

  public init() {}

  public func assemble(container: Container) {
    container.register(WalletKitConfig.self) { _ in
      WalletKitConfigImpl()
    }
    .inObjectScope(ObjectScope.graph)

    container.register(WalletKitController.self) { r in
      WalletKitControllerImpl(configLogic: r.force(WalletKitConfig.self))
    }
    .inObjectScope(ObjectScope.graph)

    container.register(PresentationSessionCoordinator.self, name: RegistrationName.proximity.rawValue) { _, session in
      ProximityPresentationSessionCoordinator(session: session)
    }
    .inObjectScope(ObjectScope.transient)

    container.register(PresentationSessionCoordinator.self, name: RegistrationName.remote.rawValue) { _, session in
      RemoteSessionCoordinator(session: session)
    }
    .inObjectScope(ObjectScope.transient)
  }
}
