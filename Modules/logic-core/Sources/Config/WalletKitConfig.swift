/*
 * Copyright (c) 2023 European Commission
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
import Foundation
import logic_business
import EudiWalletKit

struct VciConfig: Sendable {
  public let issuerUrl: String
  public let clientId: String
  public let redirectUri: URL
  public let usePAR: Bool
  public let useDPoP: Bool
}

struct ReaderConfig: Sendable {
  public let trustedCerts: [Data]
}

protocol WalletKitConfig: Sendable {

  /**
   * VCI Configuration
   */
  var vciConfig: VciConfig { get }

  /**
   * Reader Configuration
   */
  var readerConfig: ReaderConfig { get }

  /**
   * User authentication required accessing core's secure storage
   */
  var userAuthenticationRequired: Bool { get }

  /**
   * Service name for documents key chain storage
   */
  var documentStorageServiceName: String { get }

  /**
   * The name of the file to be created to store logs
   */
  var logFileName: String { get }

  /**
   * Document categories
   */
  var documentsCategories: DocumentCategories { get }

  /**
   * Logger For Transactions
   */
  var transactionLogger: TransactionLogger { get }

  /**
   * The interval (in seconds) at which revocations are checked.
   */
  var revocationInterval: TimeInterval { get }
}

struct WalletKitConfigImpl: WalletKitConfig {

  let configLogic: ConfigLogic
  let transactionLoggerImpl: TransactionLogger

  init(
    configLogic: ConfigLogic,
    transactionLogger: TransactionLogger
  ) {
    self.configLogic = configLogic
    self.transactionLoggerImpl = transactionLogger
  }

  var userAuthenticationRequired: Bool {
    false
  }

  var vciConfig: VciConfig {
    return switch configLogic.appBuildVariant {
    case .DEMO:
        .init(
          issuerUrl: "https://issuer.eudiw.dev",
          clientId: "wallet-dev",
          redirectUri: URL(string: "eu.europa.ec.euidi://authorization")!,
          usePAR: true,
          useDPoP: true
        )
    case .DEV:
        .init(
          issuerUrl: "https://demo-utsteder.test.eidas2sandkasse.net",
          clientId: "wallet-dev",
          redirectUri: URL(string: "eu.europa.ec.euidi://authorization")!,
          usePAR: true,
          useDPoP: true
        )
    }
  }

  var readerConfig: ReaderConfig {
    let certificates = [
      "pidissuerca02_cz",
      "pidissuerca02_ee",
      "pidissuerca02_eu",
      "pidissuerca02_lu",
      "pidissuerca02_nl",
      "pidissuerca02_pt",
      "pidissuerca02_ut",
      "Cert1",
      "Cert2"
    ]
    let certsData: [Data] = certificates.compactMap {
      Data(name: $0, ext: "der")
    }
    return .init(trustedCerts: certsData)
  }

  var documentStorageServiceName: String {
    guard let identifier = Bundle.main.bundleIdentifier else {
      return "eudi.document.storage"
    }
    return "\(identifier).eudi.document.storage"
  }

  var logFileName: String {
    return "eudi-ios-wallet-logs"
  }

  var documentsCategories: DocumentCategories {
    [
      .Government: [
        .mDocPid,
        .sdJwtPid,
        .other(formatType: "org.iso.18013.5.1.mDL"),
        .other(formatType: "eu.europa.ec.eudi.pseudonym.age_over_18.1"),
        .other(formatType: "urn:eu.europa.ec.eudi:pseudonym_age_over_18:1"),
        .other(formatType: "eu.europa.ec.eudi.tax.1"),
        .other(formatType: "urn:eu.europa.ec.eudi:tax:1"),
        .other(formatType: "eu.europa.ec.eudi.pseudonym.age_over_18.deferred_endpoint"),
        .other(formatType: "eu.europa.ec.eudi.cor.1")
      ],
      .Travel: [
        .other(formatType: "org.iso.23220.2.photoid.1"),
        .other(formatType: "org.iso.23220.photoID.1"),
        .other(formatType: "org.iso.18013.5.1.reservation")
      ],
      .Finance: [
        .other(formatType: "eu.europa.ec.eudi.iban.1"),
        .other(formatType: "urn:eu.europa.ec.eudi:iban:1")
      ],
      .Education: [],
      .Health: [
        .other(formatType: "eu.europa.ec.eudi.hiid.1"),
        .other(formatType: "urn:eu.europa.ec.eudi:hiid:1"),
        .other(formatType: "eu.europa.ec.eudi.ehic.1"),
        .other(formatType: "urn:eu.europa.ec.eudi:ehic:1")
      ],
      .SocialSecurity: [
        .other(formatType: "eu.europa.ec.eudi.samplepda1.1"),
        .other(formatType: "urn:eu.europa.ec.eudi:pda1:1")
      ],
      .Retail: [
        .other(formatType: "eu.europa.ec.eudi.loyalty.1"),
        .other(formatType: "eu.europa.ec.eudi.msisdn.1"),
        .other(formatType: "urn:eu.europa.ec.eudi:msisdn:1")
      ],
      .Other: [
        .other(formatType: "eu.europa.ec.eudi.por.1"),
        .other(formatType: "urn:eu.europa.ec.eudi:por:1")
      ]
    ]
  }

  var transactionLogger: any TransactionLogger {
    return self.transactionLoggerImpl
  }

  var revocationInterval: TimeInterval {
    300
  }
}
