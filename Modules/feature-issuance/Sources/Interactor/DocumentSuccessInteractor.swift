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
import logic_resources

public protocol DocumentSuccessInteractor: ThreadSafeInteractor {
  func getHoldersName(for documentIdentifier: String) -> String?
  func getDocumentSuccessCaption(for documentIdentifier: String) -> LocalizableString.Key?
}

final class DocumentSuccessInteractorImpl: DocumentSuccessInteractor {

  private let walletController: WalletKitController

  init(walletController: WalletKitController ) {
    self.walletController = walletController
  }

  public func getHoldersName(for documentIdentifier: String) -> String? {
    guard
      let bearerName = walletController.fetchDocument(with: documentIdentifier)?.getBearersName()
    else {
      return nil
    }
    return  "\(bearerName.first) \(bearerName.last)"
  }

  public func getDocumentSuccessCaption(for documentIdentifier: String) -> LocalizableString.Key? {
    guard
      let type = walletController.fetchDocument(with: documentIdentifier)?.docType
    else {
      return nil
    }
    return .issuanceSuccessCaption([DocumentTypeIdentifier(rawValue: type).localizedTitle])
  }

}
