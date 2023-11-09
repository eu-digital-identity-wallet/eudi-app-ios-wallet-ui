//
//  mdoc_holderApp.swift
//  mdoc-holder
//
//  Created by ffeli on 21/05/2023.
//

import SwiftUI
import EudiWalletKit

@main
struct WalletUiApp: App {
	@State private var path = NavigationPath()
	var wallet: EudiWallet
	init() {
		wallet = EudiWallet.standard
		wallet.trustedReaderCertificates = [Data(name: "scytales_root_ca", ext: "der")!]
	}
	
	var body: some Scene {
		WindowGroup {
			NavigationStack(path: $path) {
				MainHolderView(appData: wallet.documentsViewModel, path: $path).environmentObject(wallet)
			}
		}
	}
}
