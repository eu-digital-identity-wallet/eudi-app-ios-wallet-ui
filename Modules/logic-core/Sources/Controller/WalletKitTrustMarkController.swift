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
import Foundation
import logic_business

public protocol WalletKitTrustMarkController: Sendable {
  func getTrustMark() async throws -> TrustMarkDomain
}

final actor WalletKitTrustMarkControllerImpl: WalletKitTrustMarkController {

  private let walletKitController: WalletKitController

  init(walletKitController: WalletKitController) {
    self.walletKitController = walletKitController
  }

  public func getTrustMark() async throws -> TrustMarkDomain {
    guard let manager = walletKitController.wallet.trustMarkManager else {
      throw WalletCoreError.unableToFetchTrustMark
    }
    let trustMark = try await manager.getTrustMark()
    return TrustMarkDomain(
      resourceUrl: trustMark.information.trustMarkResourceURL,
      imageName: trustMark.resource.image.name,
      imageUrl: trustMark.resource.image.url,
      localisedText: trustMark.resource.text.getLocalizedText(
        userLanguageCode: Locale.current.systemLanguageCode
      ),
      certifiedWalletsUrl: trustMark.information.listOfCertifiedWalletsURL,
      walletSolutionUrl: trustMark.information.walletSolutionInfoPageURL
    )
  }
}
