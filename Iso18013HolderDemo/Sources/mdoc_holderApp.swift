//
//  mdoc_holderApp.swift
//  mdoc-holder
//
//  Created by ffeli on 21/05/2023.
//

import SwiftUI
import MdocDataTransfer18013
import Logging

@main
struct mdoc_holderApp: App {
	let logger: Logger
	init() {
		logger = Logger(label: "logger")
	}
    var body: some Scene {
        WindowGroup {
					MainHolderView().environmentObject(MdocAppData()).environmentObject(MdocGattServer()).environmentObject(OpenId4VpClient.shared)
        }
    }
}
