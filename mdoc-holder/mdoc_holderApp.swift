//
//  mdoc_holderApp.swift
//  mdoc-holder
//
//  Created by ffeli on 21/05/2023.
//

import SwiftUI

@main
struct mdoc_holderApp: App {

    var body: some Scene {
        WindowGroup {
			MainHolderView().environmentObject(MdocAppData().loadSampleData())
        }
    }
}
