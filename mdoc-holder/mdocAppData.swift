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
    @Published var score = 0
    @Published var qrCodeImage: UIImage?

    func genQrCode(isBleServer: Bool) {
        let de = DeviceEngagement(isBleServer: isBleServer)
        qrCodeImage = de.getQrCodeImage()
    }
}
