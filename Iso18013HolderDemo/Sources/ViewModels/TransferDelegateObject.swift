//
//  TransferDelegateObject.swift
//  Iso18013HolderDemo

import Foundation
import MdocDataTransfer18013

class TransferDelegateObject: ObservableObject, MdocOfflineDelegate {
	@Published var readerCertIsserMessage: String?
	@Published var readerCertValidationMessage: String?
	@Published var hasError: Bool = false
	@Published var errorMessage: String = ""
	@Published var selectedRequestItems: Array<DocElementsViewModel> = []
	public var handleSelected: (Bool, RequestItems?) -> Void = { _,_ in }
	public func didChangeStatus(_ newStatus: MdocDataTransfer18013.TransferStatus) {
	}
	
	func didReceiveRequest(_ request: [String: Any], handleSelected: @escaping (Bool, RequestItems?) -> Void) {
		self.handleSelected = handleSelected
		// show the items as checkboxes
		guard let validRequestItems = request[UserRequestKeys.items_requested.rawValue] as? RequestItems else { return }
		selectedRequestItems = validRequestItems.map { docType,nsItems in DocElementsViewModel(docType: docType, elements: nsItems.map { (k,v) in v.map { ElementViewModel(nameSpace: k, elementIdentifier:$0)} }.flatMap {$0}) }
		if let readerAuthority = request[UserRequestKeys.reader_certificate_issuer.rawValue] as? String {
			let bAuthenticated = request[UserRequestKeys.reader_auth_validated.rawValue] as? Bool ?? false
			readerCertIsserMessage = "Reader Certificate Issuer:\n\(readerAuthority)\n\(bAuthenticated ? "Authenticated" : "NOT authenticated")\n\(request[UserRequestKeys.reader_certificate_validation_message.rawValue] as? String ?? "")"
		}
	}

	public func didFinishedWithError(_ error: Error) {
		hasError = true
		errorMessage = error.localizedDescription
	}
	
	
}
