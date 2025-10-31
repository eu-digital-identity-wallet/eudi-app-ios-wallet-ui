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
import Foundation
import logic_resources

public enum WalletCoreError: LocalizedError, Equatable {
  case unableFetchDocuments
  case unableFetchDocument
  case missingPid
  case unableToIssueAndStore
  case missingMetadata
  case transactionCodeFormat([String])
  case unableToPresentAndShare
  case unableToFetchTransactionLog

  public var errorDescription: String? {
    return switch self {
    case .unableFetchDocuments:
      LocalizableStringKey.errorUnableFetchDocuments.toString
    case .unableFetchDocument:
      LocalizableStringKey.errorUnableFetchDocument.toString
    case .missingPid:
      LocalizableStringKey.missingPid.toString
    case .unableToIssueAndStore:
      LocalizableStringKey.unableToIssueAndStore.toString
    case .missingMetadata:
      LocalizableStringKey.missingMetadata.toString
    case .transactionCodeFormat(let args):
      LocalizableStringKey.transactionCodeFormatError(args).toString
    case .unableToPresentAndShare:
      LocalizableStringKey.unableToPresentAndShare.toString
    case .unableToFetchTransactionLog:
      LocalizableStringKey.errorFetchTransactionLog.toString
    }
  }
}
