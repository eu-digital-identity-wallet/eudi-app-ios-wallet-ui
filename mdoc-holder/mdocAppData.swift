//
//  mdocAppData.swift
//  mdoc-holder
//
//  Created by ffeli on 23/05/2023.
//

import Foundation
import SwiftUI
import MdocDataModel18013

class MdocAppData: ObservableObject {
    @Published var qrCodeImage: UIImage?
	var euPidModel: EuPidModel!
	var isoMdlModel: IsoMdlModel!

    func genQrCode(isBleServer: Bool) {
        let de = DeviceEngagement(isBleServer: isBleServer, crv: .p256)
        qrCodeImage = de.getQrCodeImage()
    }
	func getDoc(i: Int) -> MdocDecodable { i == 0 ? euPidModel : isoMdlModel}
	
	func loadSampleData() -> MdocAppData {
		let sampleData = Data(name: "sample_data")!
		let sr = sampleData.decodeJSON(type: SignUpResponse.self)!
		let dr = sr.deviceResponse
		euPidModel = EuPidModel(response: dr)
		isoMdlModel = IsoMdlModel(response: dr)
		return self
	}
}
