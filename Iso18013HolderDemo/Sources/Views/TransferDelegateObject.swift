//
//  TransferDelegateObject.swift
//  Iso18013HolderDemo

import Foundation
import MdocDataTransfer18013

class TransferDelegateObject: ObservableObject, MdocOfflineDelegate {
	
	@Published var requestItemsMessage: String = ""
	@Published var readerCertValidationMessage: String?
	@Published var hasError: Bool = false
	@Published var errorMessage: String = ""
	@Published var status: TransferStatus = .disconnected
	public var handleAccept: (Bool) -> Void = { _ in }
	
	public func didChangeStatus(_ newStatus: MdocDataTransfer18013.TransferStatus) {
		status = newStatus
	}
	
	public func didReceiveRequest(_ request: [String:Any], handleAccept: @escaping (Bool) -> Void) {
		self.handleAccept = handleAccept
		guard let requestItems = request[UserRequestKeys.items_requested.rawValue] as? [String:[String]] else {
			handleAccept(false); return
		}
		requestItemsMessage = ""
		if let readerAuthority = request[UserRequestKeys.reader_certificate_issuer.rawValue] as? String {
			let bAuthenticated = request[UserRequestKeys.reader_auth_validated.rawValue] as? Bool ?? false
			requestItemsMessage += "Reader Certificate Issuer:\n\(readerAuthority)\n \(bAuthenticated ? "Authenticated" : "NOT authenticated")\n\n"
			readerCertValidationMessage = request[UserRequestKeys.reader_certificate_validation_message.rawValue] as? String
		}
		for (k,v) in requestItems {
			requestItemsMessage += "DocType: \(k)\n \(v.map { NSLocalizedString($0, comment: "") }.sorted().joined(separator: "\n"))"
		}
	}
	
	public func didFinishedWithError(_ error: Error) {
		hasError = true
		errorMessage = error.localizedDescription
	}
	
	
}
