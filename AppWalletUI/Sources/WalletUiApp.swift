/*
Copyright (c) 2023 European Commission

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

		http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

import SwiftUI
import EudiWalletKit

@main
struct WalletUiApp: App {
	@State private var path = NavigationPath()
	var wallet: EudiWallet
	
	// initialize wallet app
	init() {
		wallet = EudiWallet.standard
		wallet.userAuthenticationRequired = true
		wallet.trustedReaderCertificates = [Data(name: "scytales_root_ca", ext: "der")!]
		wallet.openId4VpVerifierApiUri = ProcessInfo.processInfo.environment["VERIFIER_API"] ?? "http://localhost:8080"
		wallet.loadDocuments()
	}
	
	var body: some Scene {
		WindowGroup {
			NavigationStack(path: $path) {
				MainHolderView(storage: wallet.storage, path: $path).environmentObject(wallet)
			}
		}
	}
}
