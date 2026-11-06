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

/// The ID Provider extension's decisions on a Digital Credential API request, kept here so that they are tested; the
/// extension has no test target.
public enum DocumentProviderPolicy {

  /// Declines a request while the user has turned off offering documents to apps and websites
  /// (`WalletCoreError.documentOfferingDisabled`), or when it includes a document with a revocation record
  /// (`WalletCoreError.documentBlocked`), as the in-app flows refuse one.
  public static func checkRequest(
    isOffering: Bool,
    requestedDocumentIds: [String],
    blockedDocumentIds: Set<String>
  ) throws {
    guard isOffering else {
      throw WalletCoreError.documentOfferingDisabled
    }
    guard !requestedDocumentIds.contains(where: blockedDocumentIds.contains) else {
      throw WalletCoreError.documentBlocked
    }
  }

  /// True when a requested claim is a picture of the holder (`ConfigUiLogic.userImageClaimKeys`).
  public static func requestsUserImage(claimNames: [String], userImageClaimKeys: Set<String>) -> Bool {
    claimNames.contains(where: userImageClaimKeys.contains)
  }
}
