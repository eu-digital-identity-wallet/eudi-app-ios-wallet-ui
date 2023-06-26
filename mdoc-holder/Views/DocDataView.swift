//
//  DocDataView.swift
//  mdoc-holder
//
//  Created by ffeli on 26/06/2023.
//

import SwiftUI
import MdocDataModel18013

struct DocDataView: View {
	@EnvironmentObject var appData: MdocAppData
	let index: Int
	
    var body: some View {
		ScrollView {
			VStack(alignment: .leading) {
				let doc: MdocDecodable = appData.getDoc(i: index)
				Text(verbatim: String(localized:type(of: doc).title)).font(.title).frame(maxWidth: .infinity, alignment: .center)
				Divider()
				ForEach(doc.displayStrings, id: \.name) { nv in
					VStack(alignment: .leading) {
						Text(String(localized:String.LocalizationValue(nv.name))).fontWeight(.semibold).font(.footnote)
						Text(nv.value).font(.footnote)
						Divider()
					}.padding(.horizontal).padding(.bottom, 0)
				}
			}
		}
    }
}

struct DocDataView_Previews: PreviewProvider {
	static var previews: some View {
		let appData = MdocAppData().loadSampleData()
		DocDataView(index: 0).environmentObject(appData)
	}
}
