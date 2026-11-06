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

public extension PrefsController {

  /// Records the current factory-reset generation as seen by a reader that keeps its own `defaults`, such as the ID
  /// Provider extension, and returns true when that reader had not seen it: once after each reset. The seen value
  /// lives in the reader's own `defaults`, not in `Prefs.Key`, because the shared preferences are what the reset clears.
  func recordWalletResetSeen(in defaults: UserDefaults) -> Bool {
    let generation = getInt(forKey: .walletResetGeneration)
    guard defaults.integer(forKey: WalletResetConstants.seenGenerationKey) != generation else { return false }
    defaults.set(generation, forKey: WalletResetConstants.seenGenerationKey)
    return true
  }
}

private enum WalletResetConstants {
  static let seenGenerationKey = "seenWalletResetGeneration"
}
