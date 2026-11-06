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
import os
import EudiWalletKit
import logic_api
import logic_storage
@testable import logic_business
@testable import logic_core
@testable import logic_test

final class TestWalletKitControllerOffer: EudiTest {

  private let issuer = "https://issuer.example"
  private let offerAddress = URL(string: "https://issuer.example/offers/1")!

  override func setUp() {
    super.setUp()
    RecordingURLProtocol.reset()
  }

  func testResolveOfferUrlDocTypes_WhenTheFetchedOfferNamesAnotherIssuer_ThenRefusesItWithoutContactingThatIssuer() async {
    RecordingURLProtocol.serve(offer(issuer: "https://attacker.example"), at: offerAddress)

    let error = await resolutionError(offerUri: byReference(offerAddress.absoluteString), controller: makeController())

    XCTAssertEqual(error as? WalletCoreError, .issuerNotConfigured)
    XCTAssertEqual(RecordingURLProtocol.requested, [offerAddress])
  }

  func testResolveOfferUrlDocTypes_WhenTheFetchedOfferNamesAConfiguredIssuer_ThenWalletKitGetsItWithoutFetchingItAgain() async {
    RecordingURLProtocol.serve(offer(issuer: issuer), at: offerAddress)

    let error = await resolutionError(offerUri: byReference(offerAddress.absoluteString), controller: makeController())

    XCTAssertNotEqual(error as? WalletCoreError, .issuerNotConfigured)
    let requested = RecordingURLProtocol.requested
    XCTAssertEqual(requested.filter { $0 == offerAddress }.count, 1)
    XCTAssertGreaterThan(requested.count, 1, "WalletKit goes on to the issuer's metadata")
    XCTAssertEqual(Set(requested.compactMap(\.host)), ["issuer.example"])
  }

  func testResolveOfferUrlDocTypes_WhenTheOfferAddressIsNotOnAConfiguredIssuersOrigin_ThenNothingIsFetched() async {
    let error = await resolutionError(
      offerUri: byReference("https://attacker.example/offers/1"),
      controller: makeController()
    )

    XCTAssertEqual(error as? WalletCoreError, .issuerNotConfigured)
    XCTAssertTrue(RecordingURLProtocol.requested.isEmpty)
  }

  func testResolveOfferUrlDocTypes_WhenTheOfferCannotBeFetched_ThenFailsAsWalletKitDoes() async {
    let error = await resolutionError(offerUri: byReference(offerAddress.absoluteString), controller: makeController())

    XCTAssertEqual((error as? WalletError)?.code, .offerResolutionFailed)
    XCTAssertEqual(RecordingURLProtocol.requested, [offerAddress])
  }

  func testIssueDocumentsByOfferUrl_WhenTheOfferWasResolved_ThenItIsNotFetchedAgain() async {
    RecordingURLProtocol.serve(offer(issuer: issuer), at: offerAddress)
    let controller = makeController()
    let offerUri = byReference(offerAddress.absoluteString)
    _ = await resolutionError(offerUri: offerUri, controller: controller)

    _ = try? await controller.issueDocumentsByOfferUrl(offerUri: offerUri, docTypes: [], txCodeValue: nil)

    XCTAssertEqual(RecordingURLProtocol.requested.filter { $0 == offerAddress }.count, 1)
  }

  func testIssueDocumentsByOfferUrl_WhenAnotherOfferWasResolvedSince_ThenTheFirstIsNotFetchedAgain() async {
    let otherAddress = URL(string: "https://issuer.example/offers/2")!
    RecordingURLProtocol.serve(offer(issuer: issuer), at: offerAddress)
    RecordingURLProtocol.serve(offer(issuer: issuer), at: otherAddress)
    let controller = makeController()
    let offerUri = byReference(offerAddress.absoluteString)
    _ = await resolutionError(offerUri: offerUri, controller: controller)
    _ = await resolutionError(offerUri: byReference(otherAddress.absoluteString), controller: controller)

    _ = try? await controller.issueDocumentsByOfferUrl(offerUri: offerUri, docTypes: [], txCodeValue: nil)

    XCTAssertEqual(RecordingURLProtocol.requested.filter { $0 == offerAddress }.count, 1)
  }

  func testResolveOfferUrlDocTypes_WhenTheFetchedOfferCannotBeRead_ThenFailsAsWalletKitDoes() async {
    RecordingURLProtocol.serve("<html></html>", at: offerAddress)

    let error = await resolutionError(offerUri: byReference(offerAddress.absoluteString), controller: makeController())

    XCTAssertEqual((error as? WalletError)?.code, .offerResolutionFailed)
    XCTAssertEqual(RecordingURLProtocol.requested, [offerAddress])
  }

  func testIssueDocumentsByOfferUrl_WhenAnUnresolvedOfferNamesAnotherIssuer_ThenRefusesIt() async {
    RecordingURLProtocol.serve(offer(issuer: "https://attacker.example"), at: offerAddress)

    do {
      _ = try await makeController().issueDocumentsByOfferUrl(
        offerUri: byReference(offerAddress.absoluteString),
        docTypes: [],
        txCodeValue: nil
      )
      XCTFail("Expected the offer to be refused")
    } catch {
      XCTAssertEqual(error as? WalletCoreError, .issuerNotConfigured)
    }
    XCTAssertEqual(RecordingURLProtocol.requested, [offerAddress])
  }
}

private extension TestWalletKitControllerOffer {

  func offer(issuer: String) -> String {
    "{\"credential_issuer\":\"\(issuer)\",\"credential_configuration_ids\":[\"pid\"]}"
  }

  func byReference(_ address: String) -> String {
    "openid-credential-offer://?credential_offer_uri="
    + (address.addingPercentEncoding(withAllowedCharacters: .alphanumerics) ?? "")
  }

  func resolutionError(offerUri: String, controller: WalletKitControllerImpl) async -> Error? {
    do {
      _ = try await controller.resolveOfferUrlDocTypes(offerUri: offerUri)
      return nil
    } catch {
      return error
    }
  }

  /// The controller with a real WalletKit, configured for `issuer` alone, whose requests all go through
  /// `RecordingURLProtocol`.
  func makeController() -> WalletKitControllerImpl {
    let walletKitConfig = MockWalletKitConfig()
    stub(walletKitConfig) { mock in
      when(mock.logFileName.get).thenReturn(nil)
      when(mock.validateIssuerRegistrationCertificate.get).thenReturn(false)
      when(mock.vpConfig.get).thenReturn(OpenId4VpConfiguration())
      when(mock.userAuthenticationRequired.get).thenReturn(false)
      when(mock.trustConfiguration.get).thenReturn(
        TrustConfiguration(trustSource: .staticList(StaticListTrustSource(rootCertificates: [])))
      )
      when(mock.issuersConfig.get).thenReturn(
        ["issuer": VciConfig(config: OpenId4VciConfiguration(credentialIssuerURL: issuer), order: 1)]
      )
      when(mock.transactionLogger.get).thenReturn(StubTransactionLogger())
      when(mock.trustMarkSource.get).thenReturn(
        .static(
          information: TrustMarkInformation(
            trustMarkResourceURL: "https://issuer.example/trust-mark",
            listOfCertifiedWalletsURL: "https://issuer.example/wallets",
            walletSolutionInfoPageURL: "https://issuer.example/wallet"
          )
        )
      )
    }
    let configLogic = MockConfigLogic()
    stub(configLogic) { mock in
      when(mock.keyChainConfig.get).thenReturn(
        KeyChainConfig(documentStorageServiceName: "offer-tests", keychainAccessGroup: "offer-tests")
      )
    }
    let configuration = URLSessionConfiguration.ephemeral
    configuration.protocolClasses = [RecordingURLProtocol.self]

    return WalletKitControllerImpl(
      walletKitConfig: walletKitConfig,
      configLogic: configLogic,
      keyChainController: MockKeyChainController(),
      sessionCoordinatorHolder: MockSessionCoordinatorHolder(),
      bookmarkStorageController: StubStorageController<Bookmark>(),
      transactionLogStorageController: StubStorageController<TransactionLog>(),
      revokedDocumentStorageController: StubStorageController<RevokedDocument>(),
      failedReIssuedDocStorageController: StubStorageController<FailedReIssuedDocument>(),
      statusRefreshFailureStorageController: StubStorageController<StatusRefreshFailure>(),
      storageEraseController: StubStorageEraseController(),
      networkSessionProvider: StubNetworkSessionProvider(urlSession: URLSession(configuration: configuration)),
      documentRegistrationManager: MockDocumentRegistrationManager(),
      prefsController: MockPrefsController(),
      registrationCheckProvider: MockRegistrationCheckProvider()
    )
  }

  /// Answers every request of a session it is installed in with the body `serve(_:at:)` set for its address, or
  /// with 404, and records the addresses asked for.
  final class RecordingURLProtocol: URLProtocol {

    private struct State: Sendable {
      var bodies: [URL: Data] = [:]
      var requested: [URL] = []
    }

    private static let state = OSAllocatedUnfairLock(initialState: State())

    static var requested: [URL] {
      state.withLock { $0.requested }
    }

    static func reset() {
      state.withLock { $0 = State() }
    }

    static func serve(_ body: String, at address: URL) {
      state.withLock { $0.bodies[address] = Data(body.utf8) }
    }

    override static func canInit(with request: URLRequest) -> Bool {
      true
    }

    override static func canonicalRequest(for request: URLRequest) -> URLRequest {
      request
    }

    override func startLoading() {
      guard let address = request.url else {
        client?.urlProtocol(self, didFailWithError: URLError(.badURL))
        return
      }
      let body = Self.state.withLock { state in
        state.requested.append(address)
        return state.bodies[address]
      }
      guard let response = HTTPURLResponse(
        url: address,
        statusCode: body == nil ? 404 : 200,
        httpVersion: nil,
        headerFields: ["Content-Type": "application/json"]
      ) else {
        client?.urlProtocol(self, didFailWithError: URLError(.badServerResponse))
        return
      }
      client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
      client?.urlProtocol(self, didLoad: body ?? Data())
      client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {}
  }

  /// Hands out the session the test built.
  struct StubNetworkSessionProvider: NetworkSessionProvider {
    let urlSession: URLSession
  }

  /// A store that holds nothing: it stores nothing and reads no record.
  actor StubStorageController<Value: Sendable>: StorageController {
    func store(_ value: Value) async throws {}
    func store(_ values: [Value]) async throws {}
    func update(_ value: Value) async throws {}

    func retrieve(_ identifier: String) async throws -> Value {
      throw logic_storage.StorageError.itemNotFound
    }

    func retrieveAll() async throws -> [Value] {
      []
    }

    func delete(_ identifier: String) async throws {}
    func deleteAll() async throws {}
  }

  /// An erase that does nothing.
  actor StubStorageEraseController: StorageEraseController {
    func eraseStore() async throws {}
  }

  /// A transaction logger that keeps nothing.
  actor StubTransactionLogger: TransactionLogger {
    func log(transaction: TransactionEntry) async throws {}
  }
}

extension TestWalletKitControllerOffer.StubStorageController: BookmarkStorageController where Value == Bookmark {}
extension TestWalletKitControllerOffer.StubStorageController: RevokedDocumentStorageController where Value == RevokedDocument {}
extension TestWalletKitControllerOffer.StubStorageController: FailedReIssuedDocStorageController where Value == FailedReIssuedDocument {}
extension TestWalletKitControllerOffer.StubStorageController: StatusRefreshFailureStorageController where Value == StatusRefreshFailure {}

extension TestWalletKitControllerOffer.StubStorageController: TransactionLogStorageController where Value == TransactionLog {

  func retrieve(parentPresentationId: String) async throws -> [TransactionLog] {
    []
  }

  func retrieveRevision() async -> String {
    ""
  }
}
