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
import Swinject
import logic_business

public final class LogicStorageAssembly: Assembly {

  public init() {}

  public func assemble(container: Container) {

    container.register(StorageConfig.self) { _ in
      StorageConfigImpl()
    }
    .inObjectScope(ObjectScope.container)

    container.register(SwiftDataService.self) { r in
      SwiftDataServiceImpl(storageConfig: r.force(StorageConfig.self))
    }
    .inObjectScope(ObjectScope.container)

    container.register((any BookmarkStorageController).self) { r in
      BookmarkStorageControllerImpl(swiftDataService: r.force(SwiftDataService.self))
    }
    .inObjectScope(ObjectScope.transient)

    container.register((any TransactionLogStorageController).self) { r in
      TransactionLogStorageControllerImpl(swiftDataService: r.force(SwiftDataService.self))
    }
    .inObjectScope(ObjectScope.transient)

    container.register((any RevokedDocumentStorageController).self) { r in
      RevokedDocumentStorageControllerImpl(swiftDataService: r.force(SwiftDataService.self))
    }
    .inObjectScope(ObjectScope.transient)
  }
}
