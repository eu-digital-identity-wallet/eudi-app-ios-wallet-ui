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
				Text("Eudi Wallet Prototype").font(.title2)
				NavigationLink(destination: { DocDataView(index: 0)}) {
					DocButton(title: String(localized:EuPidModel.title), subtitle: EuPidModel.namespace)
				}
				NavigationLink(destination: { DocDataView(index: 1)}) {
					DocButton(title: String(localized:IsoMdlModel.title), subtitle: IsoMdlModel.namespace)
				}
				Spacer()
				Button(action:{}) { Text("Share").font(.headline) }
				
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
