//
//  MainHolderView.swift
//  mdoc-holder
//
//  Created by ffeli on 25/06/2023.
//

import SwiftUI
import EudiWalletKit
import CodeScanner

struct MainHolderView: View {
	@ObservedObject var appData: DataSampleStorageService 
	@State var isPresentingScanner: Bool = false
	@State var flow: FlowType = .ble
	@EnvironmentObject var userWallet: UserWallet
	@Binding var path: NavigationPath
	
	var body: some View {
			VStack(alignment: .center, spacing: 0) {
				if !appData.hasData {
					Text("no_documents").italic().font(.footnote)
					Text("start_by_adding_sample_documents").italic().font(.footnote)
					Button {
						appData.loadSampleData(force: true)
					} label: {
						Text("add_sample_documents").padding(12)
					}.padding(.top, 20).tint(Color("AccentColor"))
						.buttonStyle(.borderedProminent)
				}
				if appData.pidLoaded, let m = appData.euPidModel {
					NavigationLink(value: RouteDestination.docView(index: 0)) {
						DocButton(title: NSLocalizedString(m.title, comment: ""), subtitle: m.docType)
					}.accessibilityIdentifier("EuPidButton")
				}
				if appData.mdlLoaded, let m = appData.isoMdlModel {
					NavigationLink(value: RouteDestination.docView(index: 1)) {
						DocButton(title: NSLocalizedString(m.title, comment: ""), subtitle: m.docType)
					}.accessibilityIdentifier("IsoMdlButton")
				}
				if appData.conferenceLoaded, let m = appData.conferenceModel {
					NavigationLink(value: RouteDestination.docView(index: 2)) {
						DocButton(title: NSLocalizedString(m.title, comment: ""), subtitle: m.docType)
					}.accessibilityIdentifier("ConferenceButton")
				}
				Spacer()
				if appData.mdlLoaded && appData.isoMdlModel != nil {					
					Button(action: { flow = .ble; path.append(RouteDestination.shareView(flow: flow)) }, label: {
						RoundedRectangle(cornerRadius: 6).fill(Color("AccentColor")).frame(maxHeight: 50).overlay() {Text("share").foregroundColor(.white).font(.system(size: 18)) }
					}).accessibilityIdentifier("Share")
				}
			}.navigationDestination(for: RouteDestination.self) { destination in
				switch destination {
					  case .docView(let index):
						  DocDataView(index: index, appData: appData)
					  case .shareView(let flow):
						  let session = PresentationSession(presentationService: userWallet.beginPresentation(flow: flow))
						  ShareView(presentationSession: session)
					  }
				  }.navigationBarTitle("eudi_wallet_prototype_v1", displayMode: .inline).toolbar {
				ToolbarItemGroup(placement: .navigationBarTrailing) {
					Button(action: { isPresentingScanner = true }, label: {Image(systemName: "qrcode.viewfinder") })
				}
			}.padding()
		.onAppear {
			if appData.mdlLoaded || appData.pidLoaded { appData.loadSampleData() }
		}.sheet(isPresented: $isPresentingScanner) {
			CodeScannerView(codeTypes: [.qr], scanMode: .once, showViewfinder: true) { response in
				if case let .success(result) = response {
					flow = .openid4vp(qrCode: result.string.data(using: .utf8)!)
					path.append(RouteDestination.shareView(flow: flow))
					isPresentingScanner = false
				}
			}
		}.onOpenURL(perform: { customUrl in
			guard let sc = customUrl.scheme else { return }
			let url = customUrl.absoluteString.replacingOccurrences(of: sc, with: "https")
			flow = .openid4vp(qrCode: url.data(using: .utf8)!)
			path.append(RouteDestination.shareView(flow: flow))
			isPresentingScanner = false
		})
	} // end body
}

/*
 struct ContentView_Previews: PreviewProvider {
 static var previews: some View {
 let appData = MdocAppData().loadSampleData()
 MainHolderView().environmentObject(appData)
 }
 }
 */
