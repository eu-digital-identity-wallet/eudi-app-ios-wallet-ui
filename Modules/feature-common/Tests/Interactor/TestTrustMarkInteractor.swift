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
import logic_core
import logic_resources
@testable import feature_common
@testable import logic_test
@testable import feature_test

final class TestTrustMarkInteractor: EudiTest {

  var interactor: TrustMarkInteractor!
  var walletKitTrustMarkController: MockWalletKitTrustMarkController!
  var prefsController: MockPrefsController!

  override func setUp() {
    super.setUp()
    self.walletKitTrustMarkController = MockWalletKitTrustMarkController()
    self.prefsController = MockPrefsController()
    self.interactor = TrustMarkInteractorImpl(
      walletKitTrustMarkController: walletKitTrustMarkController,
      prefsController: prefsController
    )
    stub(prefsController) { mock in
      when(mock.setValue(any(), forKey: any())).thenDoNothing()
    }
  }

  override func tearDown() {
    self.interactor = nil
    self.walletKitTrustMarkController = nil
    self.prefsController = nil
  }

  func testGetTrustMark_WhenDomainHasTextAndAbsoluteWebUrls_ThenReturnDisplayDataWithoutCompletingIntroduction() async {
    // Given
    stubGetTrustMark(with: domain())
    // When
    let state = await interactor.getTrustMark()
    // Then
    XCTAssertEqual(
      state,
      .success(
        uiModel(
          imageUrl: URL(string: "https://example.com/trustmark/image.svg"),
          text: "Officially Certified And Trusted EUDI Wallet",
          certifiedWalletsUrl: URL(string: "https://example.com/certified"),
          walletSolutionUrl: URL(string: "https://example.com/certified?id=WALLET")
        )
      )
    )
    verify(prefsController, never()).setValue(any(), forKey: any())
  }

  func testGetTrustMark_WhenDomainHasNoText_ThenOmitTextAndKeepImageAndLinks() async throws {
    // Given
    stubGetTrustMark(with: domain(localisedText: nil))
    // When
    let state = await interactor.getTrustMark()
    // Then
    let trustMark = try XCTUnwrap(successModel(from: state))
    XCTAssertNil(trustMark.text)
    XCTAssertNotNil(trustMark.imageUrl)
    XCTAssertNotNil(trustMark.certifiedWalletsUrl)
    XCTAssertNotNil(trustMark.walletSolutionUrl)
  }

  func testGetTrustMark_WhenImageHasRelativeSvgPath_ThenResolveAgainstResourceUrlIgnoringImageName() async throws {
    // Given
    stubGetTrustMark(
      with: domain(
        resourceUrl: "https://example.com/trustmark/resource/TrustMarkResource.json",
        imageName: "eudi-wallet-trustmark-logo.png",
        imageUrl: "../assets/logo.svg"
      )
    )
    // When
    let state = await interactor.getTrustMark()
    // Then
    let trustMark = try XCTUnwrap(successModel(from: state))
    XCTAssertEqual(trustMark.imageUrl, URL(string: "https://example.com/trustmark/assets/logo.svg"))
  }

  func testGetTrustMark_WhenImageUrlIsBlankMalformedOrNotWeb_ThenOnlyImageIsUnavailable() async throws {
    for imageUrl in ["", "   ", "http://", "ftp://example.com/logo.svg", "file:///tmp/logo.svg"] {
      // Given
      stubGetTrustMark(with: domain(resourceUrl: "", imageUrl: imageUrl))
      // When
      let state = await interactor.getTrustMark()
      // Then
      let trustMark = try XCTUnwrap(successModel(from: state), "imageUrl: \(imageUrl)")
      XCTAssertNil(trustMark.imageUrl, "imageUrl: \(imageUrl)")
      XCTAssertNotNil(trustMark.certifiedWalletsUrl, "imageUrl: \(imageUrl)")
      XCTAssertNotNil(trustMark.walletSolutionUrl, "imageUrl: \(imageUrl)")
    }
  }

  func testGetTrustMark_WhenLinkTargetsAreInvalid_ThenOmitThemAndKeepUsableContent() async throws {
    for target in ["/certified", "not a url", "mailto:info@example.com", "https://user:pass@example.com/certified"] {
      // Given
      stubGetTrustMark(with: domain(certifiedWalletsUrl: target, walletSolutionUrl: target))
      // When
      let state = await interactor.getTrustMark()
      // Then
      let trustMark = try XCTUnwrap(successModel(from: state), "target: \(target)")
      XCTAssertNil(trustMark.certifiedWalletsUrl, "target: \(target)")
      XCTAssertNil(trustMark.walletSolutionUrl, "target: \(target)")
      XCTAssertNotNil(trustMark.imageUrl, "target: \(target)")
      XCTAssertNotNil(trustMark.text, "target: \(target)")
    }
  }

  func testGetTrustMark_WhenTrustMarkManagerIsMissing_ThenReturnLoadErrorWithoutCompletingIntroduction() async {
    // Given
    stubGetTrustMark(throwing: WalletCoreError.unableToFetchTrustMark)
    // When
    let state = await interactor.getTrustMark()
    // Then
    XCTAssertEqual(state, .failure(LocalizableStringKey.trustMarkLoadError.toString))
    verify(prefsController, never()).setValue(any(), forKey: any())
  }

  func testGetTrustMark_WhenResourceFetchOrParsingFails_ThenReturnLoadErrorWithoutCompletingIntroduction() async {
    for error in [URLError(.badServerResponse), DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: ""))] as [Error] {
      // Given
      stubGetTrustMark(throwing: error)
      // When
      let state = await interactor.getTrustMark()
      // Then
      XCTAssertEqual(state, .failure(LocalizableStringKey.trustMarkLoadError.toString))
    }
    verify(prefsController, never()).setValue(any(), forKey: any())
  }

  func testGetTrustMark_WhenLoaded_ThenLinkedParagraphsMarkOnlyTheNamedPhrase() async throws {
    // Given
    stubGetTrustMark(with: domain())
    // When
    let state = await interactor.getTrustMark()
    // Then
    let trustMark = try XCTUnwrap(successModel(from: state))
    for (paragraph, link) in [
      (trustMark.certificationDescription, LocalizableStringKey.trustMarkCertifiedWalletsLink.toString),
      (trustMark.certificationInformationDescription, LocalizableStringKey.trustMarkCertificationInformationLink.toString)
    ] {
      let range = try XCTUnwrap(paragraph.linkRange)
      let text = Array(paragraph.text)
      XCTAssertEqual(String(text[range]), link)
    }
  }

  func testCompleteIntroduction_WhenResourceLoadingHasFailed_ThenCompletionIsStillSaved() async {
    // Given
    stubGetTrustMark(throwing: URLError(.notConnectedToInternet))
    _ = await interactor.getTrustMark()
    // When
    await interactor.completeIntroduction()
    // Then
    verify(prefsController, times(1)).setValue(any(), forKey: Prefs.Key.trustMarkIntroductionCompleted)
  }
}

private extension TestTrustMarkInteractor {

  func domain(
    resourceUrl: String = "https://example.com/trustmark/TrustMarkResource.json",
    imageName: String = "eudi-wallet-trustmark-logo.png",
    imageUrl: String = "https://example.com/trustmark/image.svg",
    localisedText: String? = "Officially Certified And Trusted EUDI Wallet",
    certifiedWalletsUrl: String = "https://example.com/certified",
    walletSolutionUrl: String = "https://example.com/certified?id=WALLET"
  ) -> TrustMarkDomain {
    TrustMarkDomain(
      resourceUrl: resourceUrl,
      imageName: imageName,
      imageUrl: imageUrl,
      localisedText: localisedText,
      certifiedWalletsUrl: certifiedWalletsUrl,
      walletSolutionUrl: walletSolutionUrl
    )
  }

  func uiModel(
    imageUrl: URL?,
    text: String?,
    certifiedWalletsUrl: URL?,
    walletSolutionUrl: URL?
  ) -> TrustMarkUIModel {
    TrustMarkUIModel(
      imageUrl: imageUrl,
      text: text,
      certifiedWalletsUrl: certifiedWalletsUrl,
      walletSolutionUrl: walletSolutionUrl,
      certificationDescription: paragraph(
        text: { .trustMarkCertificationDescription($0) },
        link: .trustMarkCertifiedWalletsLink
      ),
      certificationInformationDescription: paragraph(
        text: { .trustMarkCertificationInformationDescription($0) },
        link: .trustMarkCertificationInformationLink
      )
    )
  }

  func paragraph(
    text: ([String]) -> LocalizableStringKey,
    link: LocalizableStringKey
  ) -> TrustMarkParagraphUIModel {
    let label = link.toString
    let value = text([label]).toString
    let range = value.range(of: label).map {
      value.distance(from: value.startIndex, to: $0.lowerBound)..<value.distance(from: value.startIndex, to: $0.upperBound)
    }
    return TrustMarkParagraphUIModel(text: value, linkRange: range)
  }

  func successModel(from state: LoadTrustMarkPartialState) -> TrustMarkUIModel? {
    guard case .success(let trustMark) = state else { return nil }
    return trustMark
  }

  func stubGetTrustMark(with domain: TrustMarkDomain) {
    stub(walletKitTrustMarkController) { mock in
      when(mock.getTrustMark()).thenReturn(domain)
    }
  }

  func stubGetTrustMark(throwing error: Error) {
    stub(walletKitTrustMarkController) { mock in
      when(mock.getTrustMark()).thenThrow(error)
    }
  }
}
