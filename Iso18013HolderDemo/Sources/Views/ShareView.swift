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
	@StateObject var transferDelegate = TransferDelegateObject()

    var body: some View {
        VStack(spacing: 16) {
			Text(verbatim: "Status: \(transferDelegate.status)").foregroundStyle(.blue)

			if transferDelegate.status == .qrEngagementReady, let d = bleServerTransfer.qrCodeImageData {
				Image(uiImage: UIImage(data: d) ?? UIImage(systemName: "questionmark.square.dashed")!)
					.resizable().scaledToFit().frame(maxWidth: .infinity, alignment: .center).padding(.bottom, 8)
			}
			if transferDelegate.status == .requestReceived {
				ScrollView {
					Text(transferDelegate.requestItemsMessage).font(.footnote).padding(.bottom, 20)
					if let valM = transferDelegate.readerCertValidationMessage {
						Text(verbatim: valM).foregroundStyle(.blue)
					}
				}
			Spacer()
			Text(transferDelegate.errorMessage).foregroundStyle(.red).padding(.bottom, 20)
				Button { transferDelegate.handleAccept(true) } label: {Label("Accept (send data)", systemImage: "checkmark.seal").font(.title2)}.buttonStyle(.borderedProminent).padding(.bottom, 30)
					
				Button { transferDelegate.handleAccept(false) } label: {Label("Reject (dont send)", systemImage: "x.circle").font(.title2) }.buttonStyle(.bordered)

			}
        }.padding().padding()
			.onAppear(perform: genQrCode)
			.onDisappear(perform: { bleServerTransfer.stop() })
    } // body
    
	func genQrCode() {
		bleServerTransfer.initialize(parameters: [
			InitializeKeys.document_data.rawValue: [Data(name: "sample_data")!],
			InitializeKeys.trusted_certificates.rawValue: [Data(name: "scytales_root_ca", ext: "der")!],
			InitializeKeys.require_user_accept.rawValue: true
			]
		)
		bleServerTransfer.delegate = transferDelegate
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
