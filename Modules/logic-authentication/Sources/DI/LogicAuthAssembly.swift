/*
 * Copyright (c) 2026 European Commission
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
import logic_business
import Swinject

public final class LogicAuthAssembly: Assembly {

  public init() {}

  public func assemble(container: Container) {

    container.register(AuthenticationConfig.self) { _ in
      AuthenticationConfigImpl()
    }
    .inObjectScope(ObjectScope.container)

    container.register(PinStorageProvider.self) { r in
      KeychainPinStorageProvider(keyChainController: r.force(KeyChainController.self))
    }
    .inObjectScope(ObjectScope.graph)

    container.register(PinStorageController.self) { r in
      PinStorageControllerImpl(provider: r.force(PinStorageProvider.self))
    }
    .inObjectScope(ObjectScope.graph)

    container.register(PinThrottleProvider.self) { r in
      KeychainPinThrottleProvider(
        keyChainController: r.force(KeyChainController.self),
        authenticationConfig: r.force(AuthenticationConfig.self)
      )
    }
    .inObjectScope(ObjectScope.graph)

    container.register(PinThrottleController.self) { r in
      PinThrottleControllerImpl(provider: r.force(PinThrottleProvider.self))
    }
    .inObjectScope(ObjectScope.graph)

    container.register(SystemBiometryController.self) { r in
      SystemBiometryControllerImpl(
        keyChainController: r.force(KeyChainController.self)
      )
    }
    .inObjectScope(ObjectScope.transient)
  }
}
