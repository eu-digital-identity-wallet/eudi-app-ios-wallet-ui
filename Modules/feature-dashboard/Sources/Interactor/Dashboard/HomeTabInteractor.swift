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
import logic_core
import logic_business

public protocol HomeTabInteractor: Sendable {
  func fetchUsername() -> String
  func getWalletKitController() -> WalletKitController
  func getBleAvailability() async -> Reachability.BleAvailibity
  @MainActor func openBleSettings()
}

final class HomeTabInteractorImpl: HomeTabInteractor {

  private let walletKitController: WalletKitController
  private let reachabilityController: ReachabilityController

  private let sendableAnyCancellable: SendableAnyCancellable = .init()

  init(
    walletKitController: WalletKitController,
    reachabilityController: ReachabilityController
  ) {
    self.walletKitController = walletKitController
    self.reachabilityController = reachabilityController
  }

  deinit {
    sendableAnyCancellable.cancel()
  }

  func fetchUsername() -> String {
    let name = walletKitController.fetchMainPidDocument()?.getBearersName()?.first
    return name.orEmpty
  }

  func getWalletKitController() -> WalletKitController {
    walletKitController
  }

  func getBleAvailability() async -> Reachability.BleAvailibity {
    return await withCheckedContinuation { cont in
      reachabilityController.getBleAvailibity()
        .sink { cont.resume(returning: $0)}
        .store(in: &sendableAnyCancellable.cancellables)
    }
  }

  func openBleSettings() {
    reachabilityController.openBleSettings()
  }
}
