//
//  DocDataView.swift
//  mdoc-holder
//
//  Created by ffeli on 26/06/2023.
//

import SwiftUI
import UIKit
import MdocDataModel18013

struct DocDataView: View {
	@EnvironmentObject var appData: MdocAppData
	@Environment(\.dismiss) var dismiss
	@State private var isPresentingConfirm: Bool = false
	var title:String {
		guard let doc = appData.getDoc(i: index) else { return "" }
		return NSLocalizedString(type(of:doc).title, comment: "")
	}
	let index: Int
	
	var body: some View {
		if let doc = appData.getDoc(i: index) {
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
				if type(of: doc).docType == IsoMdlModel.docType, let mdlDoc = doc as? IsoMdlModel {
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
		}.confirmationDialog("Confirmation", isPresented: $isPresentingConfirm) { Button("Remove \(title) ?", role: .destructive) { dismiss(); appData.removeDoc(i: index) } }
	} // end body
	
	var imageFields = [IsoMdlModel.CodingKeys.portrait.rawValue, IsoMdlModel.CodingKeys.signatureUsualMark.rawValue]
	
}

struct DocDataView_Previews: PreviewProvider {
	static var previews: some View {
		let appData = MdocAppData().loadSampleData()
		DocDataView(index: 1).environmentObject(appData)
	}
}
