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

import SwiftUI
import EudiWalletKit

@main
struct WalletUiApp: App {
	@State private var path = NavigationPath()
	 var wallet: EudiWallet = EudiWallet.standard
	
	// initialize wallet app
	init() {
		UserDefaults.standard.set(true, forKey: "DebugDisplay")
		wallet.trustedReaderCertificates = [Data(name: "scytales_root_ca", ext: "der")!]
		wallet.verifierApiUri = ProcessInfo.processInfo.environment["VERIFIER_API"] ?? "https://eudi.netcompany-intrasoft.com"
		wallet.openID4VciIssuerUrl = ProcessInfo.processInfo.environment["VCI_ISSUER_URL"] ?? "https://eudi.netcompany-intrasoft.com/pid-issuer" // "https://preprod.issuer.eudiw.dev/oidc"
		wallet.openID4VciClientId = ProcessInfo.processInfo.environment["VCI_CLIENT_ID"] ?? "wallet-dev"
	}
	
	var body: some Scene {
		WindowGroup {
			NavigationStack(path: $path) {
				MainHolderView(storage: wallet.storage, path: $path).environmentObject(wallet)
			}
		}
	}
}
