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
import logic_business
import logic_resources
import Combine

public enum DashboardPartialState {
  case success(BearerUIModel, [DocumentUIModel])
  case failure(Error)
}

public protocol DashboardInteractorType {
  func fetchDashboard() async -> DashboardPartialState
  func getBleAvailability() async -> ReachabilityController.BleAvailibity
  func openBleSettings()
  func getAppVersion() -> String
}

public final class DashboardInteractor: DashboardInteractorType {

  private lazy var walletController: WalletKitControllerType = WalletKitController.shared
  private lazy var reachabilityController: ReachabilityControllerType = ReachabilityController.shared
  private lazy var configLogic: ConfigLogic = ConfigProvider.shared.getConfigLogic()

  private lazy var cancellables = Set<AnyCancellable>()

  public init() {}

  convenience init(
    walletController: WalletKitControllerType,
    reachabilityController: ReachabilityControllerType,
    configLogic: ConfigLogic
  ) {
    self.init()
    self.walletController = walletController
    self.reachabilityController = reachabilityController
    self.configLogic = configLogic
  }

  public func fetchDashboard() async -> DashboardPartialState {

    let documents: [DocumentUIModel]? = fetchDocuments()
    let bearer: BearerUIModel = fetchBearer()

    guard let documents = documents else {
      return .failure(RuntimeError.unableFetchDocuments)
    }

    return .success(bearer, documents)
  }

  public func getBleAvailability() async -> ReachabilityController.BleAvailibity {
    return await withCheckedContinuation { cont in
      reachabilityController.getBleAvailibity()
        .sink { cont.resume(returning: $0)}
        .store(in: &cancellables)
    }
  }

  public func openBleSettings() {
    reachabilityController.openBleSettings()
  }

  public func getAppVersion() -> String {
    return configLogic.appVersion
  }

  private func fetchBearer() -> BearerUIModel {
    let documents = self.walletController.fetchDocuments()
    return documents.transformToBearerUi()
  }

  private func fetchDocuments() -> [DocumentUIModel]? {
    let documents = self.walletController.fetchDocuments()
    guard !documents.isEmpty else {
      return nil
    }
    return documents.transformToDocumentUi()
  }
}
