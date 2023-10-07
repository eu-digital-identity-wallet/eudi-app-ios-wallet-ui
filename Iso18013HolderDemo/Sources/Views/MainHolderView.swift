//
//  MainHolderView.swift
//  mdoc-holder
//
//  Created by ffeli on 25/06/2023.
//

import SwiftUI
import MdocDataModel18013
import MdocDataTransfer18013
import CodeScanner

struct MainHolderView: View {
	@EnvironmentObject var appData: MdocAppData
	@EnvironmentObject var bleServer: MdocGattServer
	@EnvironmentObject var openId4VpTransfer: OpenId4VpClient
	@State var isPresentingScanner: Bool = false
	@State var isSharing: Bool = false

	var body: some View {
		NavigationStack {
			VStack(alignment: .center, spacing: 0) {
				if !appData.hasData {
					Text("no_documents").italic().font(.footnote)
					Text("start_by_adding_sample_documents").italic().font(.footnote)
					Button {
						_ = appData.loadSampleData(force: true)
					} label: {
						Text("add_sample_documents").padding(12)
					}.padding(.top, 20).tint(Color("AccentColor"))
						.buttonStyle(.borderedProminent)
				}
				if appData.pidLoaded, let m = appData.euPidModel {
					NavigationLink(destination: { DocDataView(index: 0)}) {
						DocButton(title: NSLocalizedString(m.title, comment: ""), subtitle: m.docType)
					}.accessibilityIdentifier("EuPidButton")
				}
				if appData.mdlLoaded, let m = appData.isoMdlModel {
					NavigationLink(destination: { DocDataView(index: 1)}) {
						DocButton(title: NSLocalizedString(m.title, comment: ""), subtitle: m.docType)
					}.accessibilityIdentifier("IsoMdlButton")
				}
				Spacer()
				if appData.mdlLoaded && appData.isoMdlModel != nil {
					NavigationLink(isActive: $isSharing, destination: { ShareView() }) {
						RoundedRectangle(cornerRadius: 6).fill(Color("AccentColor")).frame(maxHeight: 50).overlay() {Text("share").foregroundColor(.white).font(.system(size: 18)) }
					}.accessibilityIdentifier("Share")
				}
				
			}.navigationBarTitle("eudi_wallet_prototype_v1", displayMode: .inline).toolbar {
				ToolbarItemGroup(placement: .navigationBarTrailing) {
					 Button(action: { isPresentingScanner = true }, label: {Image(systemName: "qrcode.viewfinder") })
				 }
			 }.padding()
		}.onAppear(perform: {
			if appData.mdlLoaded || appData.pidLoaded { _ = appData.loadSampleData() }
		}).sheet(isPresented: $isPresentingScanner) {
			CodeScannerView(codeTypes: [.qr], scanMode: .once, showViewfinder: true) { response in
									 if case let .success(result) = response {
										 openId4VpTransfer.qrCodeImageData = result.string.data(using: .utf8)
											isPresentingScanner = false
										 isSharing = true
									 }
							 }
					 }.onOpenURL(perform: { url in
			openId4VpTransfer.qrCodeImageData = url.absoluteString.data(using: .utf8)
				isPresentingScanner = false
			isSharing = true
		 })
    } // end body
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		let appData = MdocAppData().loadSampleData()
		MainHolderView().environmentObject(appData).environmentObject(OpenId4VpClient.shared)
	}
}
