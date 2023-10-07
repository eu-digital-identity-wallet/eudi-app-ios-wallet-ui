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
import LocalAuthentication

struct ShareView: View {
	@EnvironmentObject var mdocAppData: MdocAppData
	@State var isBleServer: Bool = true
	@State var hasCancelled = false
	@EnvironmentObject var bleServerTransfer: MdocGattServer
	@EnvironmentObject var openId4VpTransfer: OpenId4VpClient
	@StateObject var transferDelegate: DefaultTransferDelegate = .init()
	@Environment(\.presentationMode) var presentationMode
	var transferManager: MdocTransferManager { isProximitySharing ? bleServerTransfer : openId4VpTransfer }
	var isProximitySharing: Bool { openId4VpTransfer.qrCodeImageData == nil }

	var body: some View {
		VStack(spacing: 16) {
			Text(verbatim: "Status: \(statusDescription)").foregroundStyle(.blue)
			
			if transferDelegate.status == .qrEngagementReady, let d = bleServerTransfer.qrCodeImageData {
				Image(uiImage: UIImage(data: d) ?? UIImage(systemName: "questionmark.square.dashed")!)
					.resizable().scaledToFit().frame(maxWidth: .infinity, alignment: .center).padding(.bottom, 8)
			}
			if transferDelegate.status == .requestReceived {
				if let issuerM = transferDelegate.readerCertIsserMessage {
					Text(verbatim: issuerM).font(.footnote).foregroundStyle(.green)
				}
				ScrollView {
					ForEach(transferDelegate.selectedRequestItems.indices, id: \.self) { docIndex in
						let nsItems = transferDelegate.selectedRequestItems[docIndex]
						Text(verbatim: NSLocalizedString(nsItems.docType, comment: "")).font(.title2).disabled(nsItems.isEnabled)
						ForEach($transferDelegate.selectedRequestItems[docIndex].elements) { $el in
							if el.isEnabled {
								Toggle(NSLocalizedString(el.elementIdentifier, comment: ""), isOn: $el.isSelected).toggleStyle(CheckboxToggleStyle())
							} else {
								Text(el.elementIdentifier).disabled(true).foregroundColor(el.isEnabled ? .black : .gray).multilineTextAlignment(.leading).frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
							}
						}.padding(.bottom, 2)
					}
				}
				Text(transferDelegate.errorMessage).foregroundStyle(.red).padding(.bottom, 20)
				HStack(alignment: .bottom, spacing: 40) {
					Button { hasCancelled = true; transferDelegate.handleSelected(false, nil) } label: {Label("Cancel", systemImage: "x.circle") }.buttonStyle(.bordered)
					Button { beginDataTransfer() } label: {Label("Accept", systemImage: "checkmark.seal")}.buttonStyle(.borderedProminent)
				}
			}
			if transferDelegate.status == .userSelected {
				Spacer()
				Image(.tileBluetooth).renderingMode(.template).aspectRatio(contentMode: .fit).frame(width: 80, height: 80).tint(.blue)
				Spacer()
			}
			if transferDelegate.status == .disconnected || transferDelegate.status == .responseSent  {
				Spacer()
				checkMark
				Spacer()
				Button { self.presentationMode.wrappedValue.dismiss() } label: {Label("OK", systemImage: "checkmark.seal").frame(width:200, height: 30)}.buttonStyle(.borderedProminent).padding()
			}
		}.padding().padding()
			.onAppear(perform: initializeAndPerformDeviceEngagement)
			.onDisappear(perform: { transferManager.stop() })
	} // body
	
	var statusDescription: String { NSLocalizedString(hasCancelled ? "cancelledSent" : transferDelegate.status.rawValue, comment: "") }
	
	func doTransfer() {
		hasCancelled = false;
		transferDelegate.handleSelected(true,  transferDelegate.selectedRequestItems.docSelectedDictionary)
	}
	
	var checkMark: some View { Image(systemName: "checkmark.circle").font(.system(size: 100)).symbolRenderingMode(.monochrome).foregroundStyle(.green).padding(.top, 50) }
	
	func beginDataTransfer(isFallBack: Bool = false) {
		let context = LAContext()
			 var error: NSError?
		let policy: LAPolicy =  .deviceOwnerAuthentication
			 if context.canEvaluatePolicy(policy, error: &error) {
					 context.evaluatePolicy(policy, localizedReason: NSLocalizedString("authenticate_to_share_data", comment: "")) {
							 success, authenticationError in

							 DispatchQueue.main.async {
									 if success {
										 mdocAppData.hasGivenLA = true
											 doTransfer()
									 } else if !isFallBack, let error = error as? LAError, error.code == .userFallback {
										 beginDataTransfer(isFallBack: true)
									 }
								 else {
									 transferManager.stop()
										 self.presentationMode.wrappedValue.dismiss()
									 }
							 }
					 }
			 } else {
				 doTransfer()
			 }
	}
	
	func initializeAndPerformDeviceEngagement() {
		transferManager.initialize(parameters: [
			InitializeKeys.document_signup_response_data.rawValue: [mdocAppData.isoMdlModel?.response, mdocAppData.euPidModel?.response].compactMap {$0},
			InitializeKeys.device_private_key.rawValue: (mdocAppData.isoMdlModel?.devicePrivateKey ?? mdocAppData.euPidModel?.devicePrivateKey)!,
			InitializeKeys.trusted_certificates.rawValue: [Data(name: "scytales_root_ca", ext: "der")!],
			InitializeKeys.require_user_accept.rawValue: true
		]
		)
		transferManager.delegate = transferDelegate
		transferManager.performDeviceEngagement()
	}
	
}


struct ShareView_Previews: PreviewProvider {
	static var previews: some View {
		let appData = MdocAppData().loadSampleData()
		let server = MdocGattServer()
		ShareView()
			.environmentObject(appData).environmentObject(server)
	}
}
