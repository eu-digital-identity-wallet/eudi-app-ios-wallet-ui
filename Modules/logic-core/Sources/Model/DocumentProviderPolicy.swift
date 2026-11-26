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
import MdocDataModel18013

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

  /// The ways the extension can answer a request with one document of each requested type the wallet holds, as the DC
  /// API library returns them in `documents`: every combination of one document per type, in their order. An option
  /// that includes a document with a revocation record is not offered. Declines while the user has turned off offering
  /// documents to apps and websites, and when every option includes a blocked document; no documents give no options.
  public static func options(
    for documents: [DocClaimsModel],
    isOffering: Bool,
    blockedDocumentIds: Set<String>
  ) throws -> [[DocClaimsModel]] {
    guard isOffering else {
      throw WalletCoreError.documentOfferingDisabled
    }
    guard !documents.isEmpty else { return [] }
    let docTypes = documents.map(\.docType).reduce(into: [String]()) { docTypes, docType in
      if !docTypes.contains(docType) { docTypes.append(docType) }
    }
    let combinations = docTypes.reduce([[DocClaimsModel]()]) { options, docType in
      let matches = documents.filter { $0.docType == docType }
      return options.flatMap { option in matches.map { option + [$0] } }
    }
    let offered = combinations.filter { option in
      !option.contains { blockedDocumentIds.contains($0.id) }
    }
    guard !offered.isEmpty else {
      throw WalletCoreError.documentBlocked
    }
    return offered
  }

  /// True when a requested claim is a picture of the holder (`ConfigUiLogic.userImageClaimKeys`).
  public static func requestsUserImage(claimNames: [String], userImageClaimKeys: Set<String>) -> Bool {
    claimNames.contains(where: userImageClaimKeys.contains)
  }

  /// True when a claim requested from one of an option's documents is a picture of the holder, so the sheet shows the
  /// notice and Accept asks first while that option is selected.
  public static func requestsUserImage(in option: [DocClaimsModel], userImageClaimKeys: Set<String>) -> Bool {
    requestsUserImage(
      claimNames: option.flatMap { $0.docClaims.map(\.name) },
      userImageClaimKeys: userImageClaimKeys
    )
  }
}
