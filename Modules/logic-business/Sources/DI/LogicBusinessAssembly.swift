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

public final class LogicBusinessAssembly: Assembly {

  public init() {}

  public func assemble(container: Container) {

    container.register(KeyChainController.self) { _ in
      KeyChainControllerImpl()
    }
    .inObjectScope(ObjectScope.container)

    container.register(PrefsController.self) { _ in
      PrefsControllerImpl()
    }
    .inObjectScope(ObjectScope.container)

    container.register(ConfigLogic.self) { _ in
      ConfigLogicImpl()
    }
    .inObjectScope(ObjectScope.container)

    container.register(FormValidator.self) { _ in
      FormValidatorImpl()
    }
    .inObjectScope(ObjectScope.transient)

    container.register(ReachabilityController.self) { _ in
      ReachabilityControllerImpl()
    }
    .inObjectScope(ObjectScope.transient)
  }
}
