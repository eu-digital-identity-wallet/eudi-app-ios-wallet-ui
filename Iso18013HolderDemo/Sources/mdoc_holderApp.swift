//
//  mdoc_holderApp.swift
//  mdoc-holder
//
//  Created by ffeli on 21/05/2023.
//

import SwiftUI
import EudiWalletKit

@main
struct mdoc_holderApp: App {
	@State private var path = NavigationPath()
	
	var body: some Scene {
		WindowGroup {
			let wallet = EudiWallet()
			NavigationStack(path: $path) {
				MainHolderView(appData: wallet.documentsViewModel, path: $path).environmentObject(wallet)
			}
		}
	}
}
