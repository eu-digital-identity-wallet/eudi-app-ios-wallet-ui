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
			ToolbarItemGroup(placement: .navigationBarTrailing) {
				Button(action: { isPresentingConfirm = true }) {
					Image(systemName: "trash")
				}
			}
		}.confirmationDialog("Confirmation", isPresented: $isPresentingConfirm) { Button("Remove \(title) ?", role: .destructive) {
			dismiss(); Task { try await storage.deleteDocument(docType: doc.docType) } } }
	} // end body
	
	var imageFields = [IsoMdlModel.CodingKeys.portrait.rawValue, IsoMdlModel.CodingKeys.signatureUsualMark.rawValue]
	
}

