//
//  ContentView.swift
//  mdoc-holder
//
//  Created by ffeli on 21/05/2023.
//

import SwiftUI
import CoreData
import MdocDataModel18013
import MdocDataTransfer18013

struct ShareView: View {
    @EnvironmentObject var mdocAppData: MdocAppData
    @State var isBleServer: Bool = true
	@State var qrCodeImage: UIImage?
	@ObservedObject var bleServerTransfer: MdocGattServer

    var body: some View {
        VStack(spacing: 16) {
            Text("QR to BLE Device Engagement").minimumScaleFactor(0.5).lineLimit(1)
            Image(uiImage: qrCodeImage ?? UIImage(systemName: "questionmark.square.dashed")!)
				.resizable().scaledToFit().frame(maxWidth: .infinity, alignment: .center).padding(.bottom, 16)
			Text(bleServerTransfer.statusDescription)
			Text(bleServerTransfer.errorMessage)
            //Toggle("Is BLE server", isOn: $isBleServer)
            Spacer()
        }.padding().padding()
			.onAppear(perform: genQrCode)
			.onDisappear(perform: { bleServerTransfer.stop() })
			.alert(isPresented: $bleServerTransfer.hasRequestPresented) {
				Alert(title: Text(bleServerTransfer.requestItemsMessage), primaryButton: .default(Text("OK")) { bleServerTransfer.handleAccept(true) }, secondaryButton: .destructive(Text("Cancel")) { bleServerTransfer.handleAccept(false) })
			}
    } // body
    
	func genQrCode() {
		bleServerTransfer.requireUserAccept = true
		bleServerTransfer.delegate = bleServerTransfer
		qrCodeImage = bleServerTransfer.performDeviceEngagement()
	}
 
}


struct ShareView_Previews: PreviewProvider {
    static var previews: some View {
		let appData = MdocAppData().loadSampleData()
		ShareView(bleServerTransfer: MdocGattServer(docs: [], iaca: Data())).environmentObject(appData)
    }
}
