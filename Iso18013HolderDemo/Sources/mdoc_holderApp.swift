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
			let wallet = UserWallet(storageType: .sample)
			NavigationStack(path: $path) {
				MainHolderView(appData: wallet.storageService as! DataSampleStorageService, path: $path).environmentObject(wallet)					
			}
		}
	}
}
