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
import logic_core
import logic_business
import logic_resources
import Combine

public enum DashboardPartialState {
  case success(BearerUIModel, [DocumentUIModel])
  case failure(Error)
}

public protocol DashboardInteractor {
  func fetchDashboard() async -> DashboardPartialState
  func getBleAvailability() async -> Reachability.BleAvailibity
  func openBleSettings()
  func getAppVersion() -> String
}

final class DashboardInteractorImpl: DashboardInteractor {

  private let walletController: WalletKitController
  private let reachabilityController: ReachabilityController
  private let configLogic: ConfigLogic

  private lazy var cancellables = Set<AnyCancellable>()

  init(
    walletController: WalletKitController,
    reachabilityController: ReachabilityController,
    configLogic: ConfigLogic
  ) {
    self.walletController = walletController
    self.reachabilityController = reachabilityController
    self.configLogic = configLogic
  }

  public func fetchDashboard() async -> DashboardPartialState {

    let documents: [DocumentUIModel]? = fetchDocuments()
    let bearer: BearerUIModel = fetchBearer()

    guard let documents = documents else {
      return .failure(WalletCoreError.unableFetchDocuments)
    }

    return .success(bearer, documents)
  }

  public func getBleAvailability() async -> Reachability.BleAvailibity {
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
    return BearerUIModel.transformToBearerUi(
      walletKitController: self.walletController
    )
  }

  private func fetchDocuments() -> [DocumentUIModel]? {
    let documents = self.walletController.fetchDocuments()
    guard !documents.isEmpty else {
      return nil
    }
    return documents.transformToDocumentUi()
  }
}
