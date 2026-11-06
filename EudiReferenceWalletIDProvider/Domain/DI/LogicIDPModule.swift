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
import Swinject
import DcApi18013AnnexC
import logic_assembly

final class LogicIDPModule: Assembly {

  init() {}

  func assemble(container: Container) {
    container.register(DcApiHandler.self) { r in
      let serviceName = LogicIDPModule.getDocumentStorageServiceName()
      let accessGroup = LogicIDPModule.getKeychainAccessGroup()
      let transactionLogger = r.resolve(TransactionLogger.self)
      return DcApiHandler(
        serviceName: serviceName,
        accessGroup: accessGroup,
        transactionLogger: transactionLogger
      )
    }
    .inObjectScope(ObjectScope.container)

    container.register(RequestAuthorizationInteractor.self) { r in
      RequestAuthorizationInteractorImpl(
        dcApiHandler: r.force(DcApiHandler.self),
        configUiLogic: r.force(ConfigUiLogic.self),
        prefsController: r.force(PrefsController.self)
      )
    }
  }
}

extension LogicIDPModule {
  static func getKeychainAccessGroup() -> String {
    return Bundle.getKeychainAccessGroup()
  }

  static func getDocumentStorageServiceName() -> String {
    return Bundle.getDocumentStorageServiceName()
  }
}

final class DocumentProviderDIContainer {
  static let shared = DocumentProviderDIContainer()

  private init() {
    DIGraph.assembleDependenciesGraph(withExtras: [LogicIDPModule()])
  }
}
