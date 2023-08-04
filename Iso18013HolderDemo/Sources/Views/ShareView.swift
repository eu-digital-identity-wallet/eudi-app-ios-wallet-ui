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
	@EnvironmentObject var bleServerTransfer: MdocGattServer

    var body: some View {
        VStack(spacing: 16) {
			if let d = bleServerTransfer.qrCodeImageData {
				Image(uiImage: UIImage(data: d) ?? UIImage(systemName: "questionmark.square.dashed")!)
					.resizable().scaledToFit().frame(maxWidth: .infinity, alignment: .center).padding(.bottom, 16)
			}
			Text(bleServerTransfer.statusDescription)
			Text(bleServerTransfer.errorMessage)
            //Toggle("Is BLE server", isOn: $isBleServer)
            Spacer()
        }.padding().padding()
			.onAppear(perform: genQrCode)
			.onDisappear(perform: { bleServerTransfer.stop() })
			.alert(isPresented: $bleServerTransfer.hasRequestPresented) {
				Alert(title: Text("Request"), message: Text(verbatim: bleServerTransfer.requestItemsMessage), primaryButton: .default(Text("OK")) { bleServerTransfer.handleAccept(true) }, secondaryButton: .destructive(Text("Cancel")) { bleServerTransfer.handleAccept(false) })
			}
    } // body
    
	func genQrCode() {
		bleServerTransfer.initialize(parameters: [
			InitializeKeys.document_data.rawValue: [Data(name: "sample_data")!],
			InitializeKeys.trusted_certificates.rawValue: [Data(name: "scytales_root_ca", ext: "der")!],
			InitializeKeys.require_user_accept.rawValue: true
			]
		)
		bleServerTransfer.delegate = bleServerTransfer
		bleServerTransfer.performDeviceEngagement()
	}
 
}


struct ShareView_Previews: PreviewProvider {
    static var previews: some View {
		let appData = MdocAppData().loadSampleData()
		ShareView()
			.environmentObject(appData).environmentObject(MdocGattServer())
    }
}
