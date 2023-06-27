//  mdocAppData.swift
//  mdoc-holder
//

import Foundation
import SwiftUI
import MdocDataModel18013

class MdocAppData: ObservableObject {
    @Published var qrCodeImage: UIImage?
	@Published var euPidModel: EuPidModel?
	@Published var isoMdlModel: IsoMdlModel?
	@AppStorage("pidLoaded") var pidLoaded: Bool = false
	@AppStorage("mdlLoaded") var mdlLoaded: Bool = false

    func genQrCode(isBleServer: Bool) {
        let de = DeviceEngagement(isBleServer: isBleServer, crv: .p256)
        qrCodeImage = de.getQrCodeImage()
    }
	func getDoc(i: Int) -> MdocDecodable? { i == 0 ? euPidModel : isoMdlModel}
	func removeDoc(i: Int) {
		if i == 0 { euPidModel = nil; pidLoaded = false }
		else { isoMdlModel = nil; mdlLoaded = false }
	}
	var hasData: Bool { pidLoaded && getDoc(i: 0) != nil || mdlLoaded && getDoc(i: 1) != nil }
	
	func loadSampleData(force: Bool = false) -> MdocAppData {
		let sampleData = Data(name: "sample_data")!
		let sr = sampleData.decodeJSON(type: SignUpResponse.self)!
		let dr = sr.deviceResponse
		if force || pidLoaded { euPidModel = EuPidModel(response: dr) }
		pidLoaded = euPidModel != nil
		if force || mdlLoaded { isoMdlModel = IsoMdlModel(response: dr) }
		mdlLoaded = isoMdlModel != nil
		return self
	}
}
