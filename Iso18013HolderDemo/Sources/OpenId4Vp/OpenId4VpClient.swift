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
import SiopOpenID4VP
import JOSESwift
import Logging

class OpenId4VpClient: ObservableObject, MdocTransferManager {
	var status: MdocDataTransfer18013.TransferStatus = .initializing
	var deviceEngagement: MdocDataModel18013.DeviceEngagement?
	var requireUserAccept: Bool = false
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
	var logger = Logger(label: "OpenId4VpClient")
	var presentationDefinition: PresentationDefinition?
	var resolvedRequestData: ResolvedRequestData?
	
	var siopOpenId4Vp: SiopOpenID4VP!
	public var qrCodeImageData: Data?
	
	init() {
		guard let wallet = Self.walletConf else { status = .error; error = Self.makeError(code: .invalidInputDocument, str: "INVALID_WALLET_CONFIGURATION"); return }
		siopOpenId4Vp = SiopOpenID4VP(walletConfiguration: wallet)
	}
	
	static var shared: OpenId4VpClient = OpenId4VpClient()
	
	func performDeviceEngagement() {
		guard let qrCodeImageData, let openid4VPlink = String(data: qrCodeImageData, encoding: .utf8) else { return }
		Task {
			try await resolveRequestUri(openid4VPlink)
		}
	}
	
	@MainActor
	func setStatus(newStatus: MdocDataTransfer18013.TransferStatus) {
		status = newStatus
		delegate?.didChangeStatus(newStatus)
		print("New status \(status)")
	}
	
	fileprivate func SendVpToken(_ vpTokenStr: String, _ pd: PresentationDefinition, _ resolved: ResolvedRequestData) async throws {
		let consent: ClientConsent = .vpToken(vpToken: vpTokenStr, presentationSubmission: .init(id: pd.id, definitionID: pd.id, descriptorMap: [])	)
		// Generate a direct post authorisation response
		let response = try AuthorizationResponse(resolvedRequest: resolved, consent: consent, walletOpenId4VPConfig: Self.walletConf!)
		let result: DispatchOutcome = try await siopOpenId4Vp.dispatch(response: response)
		if case let .accepted(url) = result {
			logger.info("Dispatch accepted, return url: \(url?.absoluteString ?? "")")
			await setStatus(newStatus: .responseSent)
		} else if case let .rejected(reason) = result {
			logger.info("Dispatch rejected, reason: \(reason)")
			await setStatus(newStatus: .error); error = Self.makeError(code: .unexpected_error, str: reason)
		}
	}
	
	public func userSelected(_ b: Bool, _ items: RequestItems?) {
		Task {
			await setStatus(newStatus: .userSelected)
			if !b { error = Self.makeError(code: .userRejected); return }
			guard let items, items.count > 0, let pd = presentationDefinition, let resolved = resolvedRequestData else { error = Self.makeError(code: .userRejected); return }
			logger.info("Openid4vp request items: \(items)")
			let deviceResponse = try getDeviceResponseToSend(nil, selectedItems: items, eReaderKey: nil, devicePrivateKey: devicePrivateKey)
			// Obtain consent
			let vpTokenStr = Data(deviceResponse.toCBOR().encode()).base64URLEncodedString()
			try await SendVpToken(vpTokenStr, pd, resolved)
		}
	}
	
	func resolveRequestUri(_ openid4VPlink: String) async throws {
		guard status != .error, let openid4VPURI = URL(string: openid4VPlink) else { return }
		await setStatus(newStatus: .connected)
		do {
			switch try await siopOpenId4Vp.authorize(url: openid4VPURI)  {
			case .notSecured(data: _):
				await setStatus(newStatus: .error); error = Self.makeError(code: .invalidUrl, str: "Not secure request received.")
			case let .jwt(request: resolvedRequestData):
				self.resolvedRequestData = resolvedRequestData
				switch resolvedRequestData {
				case let .vpToken(vp):
					self.presentationDefinition = vp.presentationDefinition
					let items = parsePresentationDefinition(vp.presentationDefinition)
					guard let items else { await setStatus(newStatus: .error); error = Self.makeError(code: .unexpected_error); return }
					await setStatus(newStatus: .requestReceived)
					if requireUserAccept == false /*|| _isDebugAssertConfiguration() */ {
						userSelected(true, nil)
					}
					else {
						// todo: validate items
						let params: [String: Any] = [UserRequestKeys.valid_items_requested.rawValue: items, UserRequestKeys.error_items_requested.rawValue: [:]]
						await MainActor.run {	delegate?.didReceiveRequest(params, handleSelected: self.userSelected) }
					}
				default: await setStatus(newStatus: .error); error = Self.makeError(code: .invalidUrl, str: "SiopAuthentication request received, not supported yet.")
				}
			} }
		catch { await setStatus(newStatus: .error); self.error = error }
	}
	
	func stop() {
	}
	
	func parsePresentationDefinition(_ presentationDefinition: PresentationDefinition) -> RequestItems? {
		guard let fieldConstraints = presentationDefinition.inputDescriptors.first?.constraints.fields else { return nil }
		guard let docType = fieldConstraints.first(where: {$0.paths.first == "$.mdoc.doctype" })?.filter?["const"] as? String else { return nil }
		guard let namespace = fieldConstraints.first(where: {$0.paths.first == "$.mdoc.namespace" })?.filter?["const"] as? String else { return nil }
		let requestedFields = fieldConstraints.filter { $0.intentToRetain != nil }.compactMap { $0.paths.first?.replacingOccurrences(of: "$.mdoc.", with: "") }
		return [docType:[namespace:requestedFields]]
	}
	
	static var walletConf: WalletOpenId4VPConfiguration? = {
		let VERIFIER_API = ProcessInfo.processInfo.environment["VERIFIER_API"] ?? "http://localhost:8080"
		let verifierMetaData = PreregisteredClient(clientId: "Verifier", jarSigningAlg: JWSAlgorithm(.RS256), jwkSetSource: WebKeySource.fetchByReference(url: URL(string: "\(VERIFIER_API)/wallet/public-keys.json")!))
		guard let rsaPrivateKey = try? KeyController.generateRSAPrivateKey(), let privateKey = try? KeyController.generateECDHPrivateKey(),
			  let rsaPublicKey = try? KeyController.generateRSAPublicKey(from: rsaPrivateKey) else { return nil }
		guard let rsaJWK = try? RSAPublicKey(publicKey: rsaPublicKey, additionalParameters: ["use": "sig", "kid": UUID().uuidString, "alg": "RS256"]) else { return nil }
		guard let keySet = try? WebKeySet(jwk: rsaJWK) else { return nil }
		var res = WalletOpenId4VPConfiguration(subjectSyntaxTypesSupported: [], preferredSubjectSyntaxType: .jwkThumbprint, decentralizedIdentifier: try! DecentralizedIdentifier(rawValue: "did:example:123"), idTokenTTL: 10 * 60, presentationDefinitionUriSupported: true, signingKey: privateKey, signingKeySet: keySet, supportedClientIdSchemes: [.preregistered(clients: [verifierMetaData.clientId: verifierMetaData])], vpFormatsSupported: [])
		return res
	}()
	
	
}
