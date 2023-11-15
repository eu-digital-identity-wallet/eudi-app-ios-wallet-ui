/*
Copyright (c) 2023 European Commission

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

		http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

import SwiftUI
import EudiWalletKit
import WalletStorage
import CodeScanner

struct MainHolderView: View {
	@ObservedObject var storage: StorageManager
	@State var isPresentingScanner: Bool = false
	@State var flow: FlowType = .ble
	@State var hasError: Bool = false
	@State var uiError: StorageError? = nil
	@EnvironmentObject var userWallet: EudiWallet
	@Binding var path: NavigationPath
	
	var body: some View {
			VStack(alignment: .center, spacing: 0) {
				if !storage.hasWellKnownData {
					Text("no_documents").italic().font(.footnote)
					Text("start_by_adding_sample_documents").italic().font(.footnote)
					Button {
						do { try userWallet.loadSampleData() }
						catch { hasError = true; uiError = error as? StorageError; print(error.localizedDescription) }
					} label: {
						Text("add_sample_documents").padding(12)
					}.padding(.top, 20).tint(Color("AccentColor"))
						.buttonStyle(.borderedProminent)
				}
				if let pidModel = storage.pidModel {
					NavigationLink(value: RouteDestination.docView(docType: pidModel.docType)) {
						DocButton(title: NSLocalizedString(pidModel.title, comment: ""), subtitle: pidModel.docType)
					}.accessibilityIdentifier("EuPidButton")
				}
				if let mdlModel = storage.mdlModel {
					NavigationLink(value: RouteDestination.docView(docType: mdlModel.docType)) {
						DocButton(title: NSLocalizedString(mdlModel.title, comment: ""), subtitle: mdlModel.docType)
					}.accessibilityIdentifier("IsoMdlButton")
				}
				Spacer()
				if storage.hasData {
					Button(action: { flow = .ble; path.append(RouteDestination.shareView(flow: flow)) }, label: {
						RoundedRectangle(cornerRadius: 6).fill(Color("AccentColor")).frame(maxHeight: 50).overlay() {Text("share").foregroundColor(.white).font(.system(size: 18)) }
					}).accessibilityIdentifier("Share")
				}
			}.navigationDestination(for: RouteDestination.self) { destination in
				switch destination {
					  case .docView(let docType):
					DocDataView(docType: docType, storage: storage)
					  case .shareView(let flow):
					let session = userWallet.beginPresentation(flow: flow) 
						  ShareView(presentationSession: session)
					  }
				  }.navigationBarTitle("eudi_wallet_prototype_v1", displayMode: .inline).toolbar {
				ToolbarItemGroup(placement: .navigationBarTrailing) {
					Button(action: { isPresentingScanner = true }, label: {Image(systemName: "qrcode.viewfinder") })
				}
			}.padding()
			.sheet(isPresented: $isPresentingScanner) {
			CodeScannerView(codeTypes: [.qr], scanMode: .once, showViewfinder: true) { response in
				guard isPresentingScanner else { return }
				if case let .success(result) = response {
					isPresentingScanner = false
					flow = .openid4vp(qrCode: result.string.data(using: .utf8)!)
					path.append(RouteDestination.shareView(flow: flow))
				}
			}
		}.onOpenURL(perform: { customUrl in
			guard let sc = customUrl.scheme else { return }
			let url = customUrl.absoluteString.replacingOccurrences(of: sc, with: "https")
			flow = .openid4vp(qrCode: url.data(using: .utf8)!)
			path.append(RouteDestination.shareView(flow: flow))
			isPresentingScanner = false
		})
		.alert(isPresented: $hasError, error: uiError) { Button("OK") {} }
	} // end body

}


