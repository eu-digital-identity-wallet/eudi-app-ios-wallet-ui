//  mdocAppData.swift
//  mdoc-holder
//

import Foundation
import SwiftUI
import SwiftCBOR
import MdocDataModel18013
import MdocDataTransfer18013

class MdocAppData: ObservableObject {
	@Published var euPidModel: EuPidModel?
	@Published var isoMdlModel: IsoMdlModel?
	@AppStorage("pidLoaded") var pidLoaded: Bool = false
	@AppStorage("mdlLoaded") var mdlLoaded: Bool = false
	@AppStorage("DebugDisplay") var debugDisplay: Bool = false
	var hasGivenLA = false

	func getDoc(i: Int) -> MdocDecodable? { i == 0 ? euPidModel : isoMdlModel}
	func removeDoc(i: Int) {
		if i == 0 { euPidModel = nil; pidLoaded = false }
		else { isoMdlModel = nil; mdlLoaded = false }
	}
	var hasData: Bool { pidLoaded && getDoc(i: 0) != nil || mdlLoaded && getDoc(i: 1) != nil }
	
	func loadSampleData(force: Bool = false) -> MdocAppData {
		debugDisplay = true
		let sampleData = Data(name: "sample_data")!
		let sr = sampleData.decodeJSON(type: SignUpResponse.self)!
		guard let dr = sr.deviceResponse, let dpk = sr.devicePrivateKey else { return self}
		if force || pidLoaded { euPidModel = EuPidModel(response: dr, devicePrivateKey: dpk) }
		pidLoaded = euPidModel != nil
		if force || mdlLoaded { isoMdlModel = IsoMdlModel(response: dr, devicePrivateKey: dpk) }
		mdlLoaded = isoMdlModel != nil
		return self
	}
}
