//
//  MainHolderView.swift
//  mdoc-holder
//
//  Created by ffeli on 25/06/2023.
//

import SwiftUI
import MdocDataModel18013

struct MainHolderView: View {
	@EnvironmentObject var appData: MdocAppData
    var body: some View {
		NavigationStack {
			VStack(alignment: .center, spacing: 0) {
				Text("eudi_wallet_prototype_v1").font(.title2)
				Divider().padding(.horizontal, -8).padding(.vertical, 12)
				if !appData.hasData {
					Text("no_documents").italic().font(.footnote)
					Text("start_by_adding_sample_documents").italic().font(.footnote)
					Button {
						_ = appData.loadSampleData()
					} label: {
						Text("add_sample_documents").padding(12)
					}.padding(.top, 20).tint(Color("AccentColor"))
						.buttonStyle(.borderedProminent)
				}
				if appData.pidLoaded && appData.euPidModel != nil {
					NavigationLink(destination: { DocDataView(index: 0)}) {
						DocButton(title: String(localized:EuPidModel.title), subtitle: EuPidModel.namespace)
					}
				}
				if appData.mdlLoaded && appData.isoMdlModel != nil {
					NavigationLink(destination: { DocDataView(index: 1)}) {
						DocButton(title: String(localized:IsoMdlModel.title), subtitle: IsoMdlModel.namespace)
					}
				}
				Spacer()
				if appData.hasData {
					NavigationLink(destination: { ShareView() }) {
						RoundedRectangle(cornerRadius: 6).fill(Color("AccentColor")).frame(maxHeight: 50).overlay() {Text("share").foregroundColor(.white).font(.system(size: 18)) }
					}
				}
				
			}.padding()
		}
    }
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		let appData = MdocAppData().loadSampleData()
		MainHolderView().environmentObject(appData)
	}
}
