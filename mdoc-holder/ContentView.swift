//
//  ContentView.swift
//  mdoc-holder
//
//  Created by ffeli on 21/05/2023.
//

import SwiftUI
import CoreData
import MdocDataModel18013

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var mdocAppData: MdocAppData
    @State var isBleServer: Bool = true
    
    var body: some View {
        VStack(spacing: 16) {
            Text("QR to BLE Device Engagement").minimumScaleFactor(0.5).lineLimit(1)
            Image(uiImage: mdocAppData.qrCodeImage ?? UIImage(systemName: "questionmark.square.dashed")!)
                .resizable().scaledToFit().frame(maxWidth: .infinity, alignment: .center)
            Toggle("Is BLE server", isOn: $isBleServer)
            Spacer()
        }.padding().padding().onAppear(perform: genQrCode).onChange(of: isBleServer, perform: {b in mdocAppData.genQrCode(isBleServer: b) })
    } // body
    
    func genQrCode() { mdocAppData.genQrCode(isBleServer: isBleServer) }
 
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(MdocAppData())
    }
}
