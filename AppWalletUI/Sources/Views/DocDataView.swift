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
import UIKit
import EudiWalletKit
import MdocDataModel18013

struct DocDataView: View {
	@Environment(\.dismiss) var dismiss
	@EnvironmentObject var userWallet: EudiWallet
    @ObservedObject var storage: StorageManager
	@State private var isPresentingConfirm: Bool = false
	let docType: String

	init(docType: String, storage: StorageManager) {
		self.docType = docType
		self.storage = storage
	}
	
	var title:String {
		guard let doc = storage.getDocumentModel(docType: docType) else { return "" }
		return NSLocalizedString(doc.title, comment: "")
	}
	
	var body: some View {
		if let doc = storage.getDocumentModel(docType: docType) {
			docView(doc)
		} else {
			EmptyView()
		}
	}
	@ViewBuilder
	func docView(_ doc: MdocDecodable) -> some View {
		ScrollView {
			VStack(alignment: .leading) {
				Text(verbatim: title).font(.title).frame(maxWidth: .infinity, alignment: .center)
				Divider()
				if doc.docType == IsoMdlModel.isoDocType, let mdlDoc = doc as? IsoMdlModel {
					if let pb = mdlDoc.portrait, let uiImage = UIImage(data: Data(pb)) {
						Image(uiImage: uiImage).resizable().aspectRatio(contentMode: .fit).frame(height: 200).frame(maxWidth: .infinity, alignment: .center)
					}
					if let ps = mdlDoc.signatureUsualMark, let uiImage = UIImage(data: Data(ps)) {
						Image(uiImage: uiImage).resizable().aspectRatio(contentMode: .fit).frame(height: 50).frame(maxWidth: .infinity, alignment: .center).offset(x: 0, y: -5)
						Divider()
					}
				}
				ForEach(doc.displayStrings, id: \.name) { nv in
					if nv.value == "ByteString" && imageFields.contains(nv.name) {
						EmptyView()
					} else {
						VStack(alignment: .leading) {
							Text(String(localized:String.LocalizationValue(nv.name))).fontWeight(.semibold).font(.footnote)
							Text(nv.value).font(.footnote)
							Divider()
						}.padding(.horizontal).padding(.bottom, 0)
					}
				}
			}
		}.toolbar {
			ToolbarItem {
				Button(action: { isPresentingConfirm = true }) {
					Image(systemName: "trash")
				}
			}
		}.confirmationDialog("Confirmation", isPresented: $isPresentingConfirm) { Button("Remove \(title) ?", role: .destructive) {
			dismiss(); storage.deleteDocument(docType: doc.docType) } }
	} // end body
	
	var imageFields = [IsoMdlModel.CodingKeys.portrait.rawValue, IsoMdlModel.CodingKeys.signatureUsualMark.rawValue]
	
}

