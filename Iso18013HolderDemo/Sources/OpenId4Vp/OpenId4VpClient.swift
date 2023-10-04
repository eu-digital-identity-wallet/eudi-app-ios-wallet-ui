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

Iso18013HolderDemo
Created on 04/10/2023 
*/

import Foundation
import SwiftCBOR
import MdocDataModel18013
import MdocSecurity18013
import MdocDataTransfer18013

class OpenId4VpClient: ObservableObject, MdocTransferManager {
	var status: MdocDataTransfer18013.TransferStatus = .initializing
	var deviceEngagement: MdocDataModel18013.DeviceEngagement?
	var requireUserAccept: Bool = true
	var sessionEncryption: MdocSecurity18013.SessionEncryption?
	var deviceRequest: MdocDataModel18013.DeviceRequest?
	var deviceResponseToSend: MdocDataModel18013.DeviceResponse?
	var validRequestItems: MdocDataTransfer18013.RequestItems?
	var errorRequestItems: MdocDataTransfer18013.RequestItems?
	var delegate: MdocDataTransfer18013.MdocOfflineDelegate?
	var docs: [MdocDataModel18013.DeviceResponse]!
	var devicePrivateKey: MdocDataModel18013.CoseKeyPrivate!
	var iaca: [SecCertificate]!
	var error: Error?
	var readerName: String?
	
	init() {
		
	}
	
	func performDeviceEngagement() {
	}
	
	func stop() {
	}
	
}
