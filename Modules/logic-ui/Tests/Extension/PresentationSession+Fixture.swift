/*
 * Copyright (c) 2026 European Commission
 *
 * Licensed under the EUPL, Version 1.2 or - as soon they will be approved by the European
 * Commission - subsequent versions of the EUPL (the "Licence"); You may not use this work
 * except in compliance with the Licence.
 *
 * You may obtain a copy of the Licence at:
 * https://joinup.ec.europa.eu/software/page/eupl
 *
 * Unless required by applicable law or agreed to in writing, software distributed under
 * the Licence is distributed on an "AS IS" basis, WITHOUT WARRANTIES OR CONDITIONS OF
 * ANY KIND, either express or implied. See the Licence for the specific language
 * governing permissions and limitations under the Licence.
 */
import XCTest
import logic_business
@testable import logic_ui
@testable import logic_test
@testable import logic_core

extension PresentationSession {
  fileprivate struct StubPresentationService: PresentationService {
    var zkpDocumentIds: [WalletStorage.Document.ID]?

    var wrpVerifierPolicy: WrpRegistrationPolicy?

    var wrpVerifierWarnings: [String: [PresentationPolicyViolation]]?

    func waitForDisconnect() async throws {}

    var transactionLog: TransactionEntry
    var transactionLogger: (any TransactionLogger)?

    func startQrEngagement(secureAreaName: String?, keyOptions: MdocDataModel18013.KeyOptions) async throws -> String {
      ""
    }

    func receiveRequest() async throws -> [MdocDataTransfer18013.UserRequestInfo] {
      [.init(docDataFormats: [DocumentTypeIdentifier.mDocPid.rawValue: .cbor], itemsRequested: RequestItems())]
    }

    var flow: EudiWalletKit.FlowType

    func sendResponse(userAccepted: Bool, itemsToSend: EudiWalletKit.RequestItems, deviceNameSpacesToSend: MdocDataTransfer18013.RequestDeviceNameSpaces?, authenticationContext: ThreadSafeAuthContext, onSuccess: (@Sendable (URL?) -> Void)?) async throws {}
  }

  private static let fixtureTransactionLog: TransactionEntry = .presentation(
    .init(
      transactionIdentifier: "transactionId0",
      time: Date(timeIntervalSince1970: 0),
      transactionResult: .completed,
      listOfClaimsRequested: [],
      listOfClaimsPresented: []
    )
  )

  private static let fixtureStorageService: DataStorageService = KeyChainStorageService(
    serviceName: "",
    accessGroup: ""
  )

  /// A presentation session over a stub service, for building session coordinators in tests.
  static let fixture =
    PresentationSession(
      presentationService: StubPresentationService(
        zkpDocumentIds: nil,
        transactionLog: fixtureTransactionLog,
        flow: .other
      ),
      storageManager: .init(storageService: fixtureStorageService),
      docIdToPresentInfo: [:],
      documentKeyIndexes: [:],
      userAuthenticationRequired: false,
      localAuthenticationContext: ThreadSafeAuthContext()
    )
}
