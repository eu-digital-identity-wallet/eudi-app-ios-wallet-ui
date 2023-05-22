//
//  mdoc_holderApp.swift
//  mdoc-holder
//
//  Created by ffeli on 21/05/2023.
//

import SwiftUI

@main
struct mdoc_holderApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(MdocAppData())
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
