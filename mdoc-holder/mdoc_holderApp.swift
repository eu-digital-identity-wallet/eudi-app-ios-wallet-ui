//
//  mdoc_holderApp.swift
//  mdoc-holder
//
//  Created by ffeli on 21/05/2023.
//

import SwiftUI
import MdocDataTransfer18013

@main
struct mdoc_holderApp: App {

    var body: some Scene {
        WindowGroup {
			MainHolderView().environmentObject(MdocAppData()).environmentObject(MdocGattServer())
        }
    }
}
