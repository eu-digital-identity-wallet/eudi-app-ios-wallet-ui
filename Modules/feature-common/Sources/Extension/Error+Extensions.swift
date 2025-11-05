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
import logic_authentication
import logic_core

public extension Error {

  var errorMessage: String {
    switch self {
    case let walletError as WalletCoreError:
      return walletError.errorDescription ?? LocalizableStringKey.genericErrorTitle.toString

    case let storageError as StorageError:
      return storageError.errorDescription ?? LocalizableStringKey.genericErrorTitle.toString

    case let authError as AuthenticationError:
      return authError.errorDescription ?? LocalizableStringKey.genericErrorTitle.toString

    case let runtimeError as RuntimeError:
      return runtimeError.errorDescription ?? LocalizableStringKey.genericErrorTitle.toString

    case let biometryError as SystemBiometryError:
      return biometryError.errorDescription ?? LocalizableStringKey.genericErrorTitle.toString

    default:
      return localizedDescription.isEmpty ? LocalizableStringKey.genericErrorTitle.toString : localizedDescription
    }
  }
}
