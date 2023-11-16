/*
 * Copyright (c) 2023 European Commission
 *
 * Licensed under the EUPL, Version 1.2 or - as soon they will be approved by the European
 * Commission - subsequent versions of the EUPL (the "Licence"); You may not use this work
 * except in compliance with the Licence.
 *
 * You may obtain a copy of the Licence at:
 * https://joinup.ec.europa.eu/software/page/eupl
 *
 * Unless required by applicable law or agreed to in writing, software distributed under
 * the Licence is distributed on an "AS IS" basis, WITHOUT WARRANTIES OR CONDITIONS OF
 * ANY KIND, either express or implied. See the Licence for the specific language
 * governing permissions and limitations under the Licence.
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
				guard path.count == 0, isPresentingScanner else { return }
				if case let .success(result) = response {
					isPresentingScanner = false
					flow = .openid4vp(qrCode: result.string.data(using: .utf8)!)
					print(path.count)
					path.removeLast(path.count)
					path.append(RouteDestination.shareView(flow: flow))
				}
			}
		}.onOpenURL(perform: { customUrl in
			guard path.count == 0, let sc = customUrl.scheme else { return }
			let url = customUrl.absoluteString.replacingOccurrences(of: sc, with: "https")
			flow = .openid4vp(qrCode: url.data(using: .utf8)!)
			path.removeLast(path.count)
			path.append(RouteDestination.shareView(flow: flow))
		})
		.alert(isPresented: $hasError, error: uiError) { Button("OK") {} }
	} // end body

}


