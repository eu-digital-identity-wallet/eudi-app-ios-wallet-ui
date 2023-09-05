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
import IdentifiedCollections

struct ShareView: View {
	@EnvironmentObject var mdocAppData: MdocAppData
	@State var isBleServer: Bool = true
	@EnvironmentObject var bleServerTransfer: MdocGattServer
	@StateObject var transferDelegate = TransferDelegateObject()
	
	var body: some View {
		VStack(spacing: 16) {
			Text(verbatim: "Status: \(bleServerTransfer.status)").foregroundStyle(.blue)
			
			if bleServerTransfer.status == .qrEngagementReady, let d = bleServerTransfer.qrCodeImageData {
				Image(uiImage: UIImage(data: d) ?? UIImage(systemName: "questionmark.square.dashed")!)
					.resizable().scaledToFit().frame(maxWidth: .infinity, alignment: .center).padding(.bottom, 8)
			}
			if bleServerTransfer.status == .requestReceived {
				if let issuerM = transferDelegate.readerCertIsserMessage {
					Text(verbatim: issuerM).font(.footnote).foregroundStyle(.green)
				}
				ScrollView {
					ForEach(transferDelegate.selectedRequestItems.indices, id: \.self) { docIndex in
						var nsItems = transferDelegate.selectedRequestItems[docIndex]
						Text(verbatim: NSLocalizedString(nsItems.docType, comment: "")).font(.title2)
						ForEach($transferDelegate.selectedRequestItems[docIndex].elements) { $el in
							Toggle(el.elementIdentifier, isOn: $el.isSelected).toggleStyle(CheckboxToggleStyle())
						} .padding(.bottom, 2)
					}
				}
				Text(transferDelegate.errorMessage).foregroundStyle(.red).padding(.bottom, 20)
				HStack(alignment: .bottom, spacing: 40) {
					Button { transferDelegate.handleSelected(false, nil) } label: {Label("Cancel", systemImage: "x.circle") }.buttonStyle(.bordered)
					Button { transferDelegate.handleSelected(true,  transferDelegate.selectedRequestItems.docSelectedDictionary) } label: {Label("Accept", systemImage: "checkmark.seal")}.buttonStyle(.borderedProminent)
				}
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
		let server = MdocGattServer(status: .requestReceived)
		ShareView()
			.environmentObject(appData).environmentObject(server)
	}
}
