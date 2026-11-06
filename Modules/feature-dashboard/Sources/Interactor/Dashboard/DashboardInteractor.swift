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
import logic_core

public protocol DashboardInteractor: Sendable {
  /// Loads the wallet's documents. Start-up loads none, so this is the first load after login.
  func loadDocuments() async
  /// Brings the Digital Credential API registrations in line with the loaded documents.
  func reconcileRegistrations() async
  /// Starts the revocation and re-issuance workers, which run only once the wallet is open.
  func startWorkers() async
}

final actor DashboardInteractorImpl: DashboardInteractor {

  private let walletKitController: WalletKitController
  private let walletWorkScheduler: WalletWorkScheduler

  init(
    walletKitController: WalletKitController,
    walletWorkScheduler: WalletWorkScheduler
  ) {
    self.walletKitController = walletKitController
    self.walletWorkScheduler = walletWorkScheduler
  }

  /// A load error is ignored: the tabs show the documents that did load.
  func loadDocuments() async {
    try? await walletKitController.loadDocuments()
  }

  func reconcileRegistrations() async {
    await walletKitController.reconcileRegistrations()
  }

  func startWorkers() async {
    await walletWorkScheduler.schedule()
  }
}
