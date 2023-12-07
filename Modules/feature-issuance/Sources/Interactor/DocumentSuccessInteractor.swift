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

import logic_business

public protocol DocumentSuccessInteractorType {
  func getHoldersName(for documentIdentifier: String) -> String
  func getDocumentName(for documentIdentifier: String) -> String
}

public final class DocumentSuccessInteractor: DocumentSuccessInteractorType {

  private lazy var walletKitController: WalletKitControllerType = WalletKitController.shared

  public init() {}

  public func getHoldersName(for documentIdentifier: String) -> String {
    walletKitController.fetchDocument(with: documentIdentifier)?.getBearersName() ?? "No Name"
  }

  public func getDocumentName(for documentIdentifier: String) -> String {
    DocumentIdentifier(rawValue: documentIdentifier).localizedTitle
  }
}
