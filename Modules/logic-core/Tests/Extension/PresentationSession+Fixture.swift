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
@testable import logic_test
@testable import logic_core

extension PresentationSession {
  fileprivate struct StubPresentationService: PresentationService, ProximityTransferService {
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

    func sendResponse(userAccepted: Bool, itemsToSend: EudiWalletKit.RequestItems, deviceNameSpacesToSend: MdocDataTransfer18013.RequestDeviceNameSpaces?, authenticationContext: ThreadSafeAuthContext, onSuccess: (@Sendable (URL?) -> Void)?) async throws {
      try onSend?(userAccepted)
    }

    private let onStop: (@Sendable (Bool) -> Void)?
    private let onSend: (@Sendable (Bool) throws -> Void)?
    let isReaderDisconnected: Bool

    init(
      transactionLog: TransactionEntry,
      flow: EudiWalletKit.FlowType,
      onStop: (@Sendable (Bool) -> Void)?,
      onSend: (@Sendable (Bool) throws -> Void)? = nil,
      isReaderDisconnected: Bool
    ) {
      self.transactionLog = transactionLog
      self.flow = flow
      self.onStop = onStop
      self.onSend = onSend
      self.isReaderDisconnected = isReaderDisconnected
    }

    func stop() {
      onStop?(Thread.isMainThread)
    }
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
  static let fixture = stoppableFixture(onStop: nil)

  /// A presentation session over a stub service that reports a stop of its transfer, and whether it ran on
  /// the main thread, and whose reader has disconnected when `isReaderDisconnected` is true.
  static func stoppableFixture(
    onStop: (@Sendable (Bool) -> Void)?,
    isReaderDisconnected: Bool = false
  ) -> PresentationSession {
    PresentationSession(
      presentationService: StubPresentationService(
        transactionLog: fixtureTransactionLog,
        flow: .other,
        onStop: onStop,
        isReaderDisconnected: isReaderDisconnected
      ),
      storageManager: .init(storageService: fixtureStorageService),
      docIdToPresentInfo: [:],
      documentKeyIndexes: [:],
      userAuthenticationRequired: false,
      localAuthenticationContext: ThreadSafeAuthContext()
    )
  }

  /// A presentation session over a stub service that reports each answer it is asked to send (true for a response,
  /// false for a decline) to `onSend`, which may throw to make the send fail.
  static func answeringFixture(onSend: @escaping @Sendable (Bool) throws -> Void) -> PresentationSession {
    PresentationSession(
      presentationService: StubPresentationService(
        transactionLog: fixtureTransactionLog,
        flow: .other,
        onStop: nil,
        onSend: onSend,
        isReaderDisconnected: false
      ),
      storageManager: .init(storageService: fixtureStorageService),
      docIdToPresentInfo: [:],
      documentKeyIndexes: [:],
      userAuthenticationRequired: false,
      localAuthenticationContext: ThreadSafeAuthContext()
    )
  }
}
