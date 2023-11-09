//
//  ContentView.swift
//  mdoc-holder
//
//  Created by ffeli on 21/05/2023.
//

import SwiftUI
import CoreData
import EudiWalletKit
import LocalAuthentication

struct ShareView: View {
	@State var hasCancelled = false
	@Environment(\.dismiss) var dismiss
	var isProximitySharing: Bool { presentationSession.flow.isProximity }
	@ObservedObject var presentationSession: PresentationSession
	@EnvironmentObject var userWallet: EudiWallet
	@Environment(\.openURL) private var openURL
	
	var body: some View {
		VStack(spacing: 16) {
			Text(verbatim: "Status: \(statusDescription)").foregroundStyle(.blue)
			if presentationSession.status == .error, let err = presentationSession.uiError {
				Text(verbatim: err.localizedDescription).foregroundStyle(.red)
			}
			else if presentationSession.status == .qrEngagementReady, let d = presentationSession.deviceEngagement {
				Image(uiImage: UIImage(data: d) ?? UIImage(systemName: "questionmark.square.dashed")!)
					.resizable().scaledToFit().frame(maxWidth: .infinity, alignment: .center).padding(.bottom, 8)
			}
			else if presentationSession.status == .requestReceived {
				if let issuerM = presentationSession.readerCertIssuerMessage {
					Text(verbatim: issuerM).font(.footnote).foregroundStyle(.green)
				}
				ScrollView {
					ForEach(presentationSession.disclosedDocuments.indices, id: \.self) { docIndex in
						let nsItems = presentationSession.disclosedDocuments[docIndex]
						Text(verbatim: NSLocalizedString(nsItems.docType, comment: "")).font(.title2).disabled(nsItems.isEnabled)
						ForEach($presentationSession.disclosedDocuments[docIndex].elements) { $el in
							if el.isEnabled {
								Toggle(NSLocalizedString(el.elementIdentifier, comment: ""), isOn: $el.isSelected).toggleStyle(CheckboxToggleStyle())
							} else {
								Text(el.elementIdentifier).disabled(true).foregroundColor(el.isEnabled ? .black : .gray).multilineTextAlignment(.leading).frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
							}
						}.padding(.bottom, 2)
					}
				}
				HStack(alignment: .bottom, spacing: 40) {
					Button { hasCancelled = true
						Task { try await presentationSession.sendResponse(userAccepted: false, itemsToSend: [:], onCancel: { dismiss() }) }
					} label: {Label("Cancel", systemImage: "x.circle") }.buttonStyle(.bordered)
					Button { Task { try? await sendAsyncResponse()  } } label: {Label("Accept", systemImage: "checkmark.seal")}.buttonStyle(.borderedProminent)
				}
			}
			else if presentationSession.status == .userSelected {
				Spacer()
				if isProximitySharing {
					Image(.tileBluetooth).renderingMode(.template).aspectRatio(contentMode: .fit).frame(width: 80, height: 80).tint(.blue)
				}else{
					Image(systemName: "wifi").resizable().aspectRatio(contentMode: .fit).frame(width: 80, height: 80).tint(.blue)
				}
				Spacer()
			}
			else if presentationSession.status == .disconnected || presentationSession.status == .responseSent  {
				Spacer()
				checkMark
				Spacer()
				Button {
					dismiss()
				} label: {Label("OK", systemImage: "checkmark.seal").frame(width:200, height: 30)}.buttonStyle(.borderedProminent).padding()
			}
		}.padding().padding()
		 .task {
			 if isProximitySharing { try? await presentationSession.startQrEngagement() }
			 try? await presentationSession.receiveRequest()
			}
	} // body
		
	var statusDescription: String { NSLocalizedString(hasCancelled ? "cancelledSent" : presentationSession.status.rawValue, comment: "") }
	
	func sendAsyncResponse() async throws {
		hasCancelled = false
		_ = try await presentationSession.sendResponse(userAccepted: true, itemsToSend: presentationSession.disclosedDocuments.items, onCancel: { dismiss() })
	}
	
	var checkMark: some View { Image(systemName: "checkmark.circle").font(.system(size: 100)).symbolRenderingMode(.monochrome).foregroundStyle(.green).padding(.top, 50) }
	

	 

} // end struct


