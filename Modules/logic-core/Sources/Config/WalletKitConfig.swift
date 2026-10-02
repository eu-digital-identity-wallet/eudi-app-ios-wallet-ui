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
import Foundation
import logic_business
import EudiWalletKit
import EudiEtsi1196x2
import MdocDataModel18013
import struct OpenID4VP.SupportedTransactionDataType
import struct OpenID4VP.TransactionDataType

protocol WalletKitConfig: Sendable {

  /**
   * VCI Configuration, keyed by issuer host.
   *
   * `allowPlainJwtProof` is set per issuer and defaults to `false`, which keeps the HAIP-compliant
   * proof policy: only attested proofs (`attestation`, or `jwt` with key attestation) are sent.
   * Set it to `true` only for an issuer that does not support key attestation and requires a plain
   * JWT proof; the proof is then bound to a key without wallet attestation, using ES256/ES384/ES512.
   */
  var issuersConfig: [String: VciConfig] { get }

  /**
   * Whether the issuer's WRP registration certificate (WRPRC), delivered in the issuer metadata
   * `issuer_info`, is validated during issuance.
   *
   * Requires `trustConfiguration.requireSignedMetadata`, which supplies the WRPAC the certificate
   * is bound to. Note that a missing WRPRC is a hard failure in the OpenID4VCI library, not a
   * warning: enabling this against an issuer that does not publish `issuer_info` fails every
   * issuance.
   */
  var validateIssuerRegistrationCertificate: Bool { get }

  /**
   * VP Configuration
   */
  var vpConfig: OpenId4VpConfiguration { get }

  /**
   * Transaction data types the wallet accepts in an OpenID4VP request.
   *
   * The OpenID4VP library rejects any request carrying `transaction_data` whose type is not
   * listed here, so an empty list rejects every request with transaction data.
   */
  var supportedTransactionDataTypes: [SupportedTransactionDataType] { get }

  /**
   * Trust configuration: ETSI LoTE (List of Trusted Entities) trust sources,
   * verification-context mappings and trust policies used for reader / issuer validation.
   */
  var trustConfiguration: TrustConfiguration { get }

  /**
   * User authentication required accessing core's secure storage
   */
  var userAuthenticationRequired: Bool { get }

  /**
   * KeyOptions for creating & accessing attestation keys
   */
  var keyOptions: KeyOptions? { get }

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
  var revocationIntervalSeconds: TimeInterval { get }

  /**
   * Configuration for document issuance, including default rules and specific overrides.
   */
  var documentIssuanceConfig: DocumentIssuanceConfig { get }

  /**
   * Provides the information used to display the wallet's Trust Mark and link to its
   * certification page and the list of certified wallets.
   */
  var trustMarkSource: TrustMarkSource { get }
}

struct WalletKitConfigImpl: WalletKitConfig {

  let configLogic: ConfigLogic
  let transactionLoggerImpl: TransactionLogger
  let walletKitAttestationProvider: WalletKitAttestationProvider
  let prefsController: PrefsController

  init(
    configLogic: ConfigLogic,
    transactionLogger: TransactionLogger,
    walletKitAttestationProvider: WalletKitAttestationProvider,
    prefsController: PrefsController
  ) {
    self.configLogic = configLogic
    self.transactionLoggerImpl = transactionLogger
    self.walletKitAttestationProvider = walletKitAttestationProvider
    self.prefsController = prefsController
  }

  var userAuthenticationRequired: Bool {
    false
  }

  var keyOptions: KeyOptions? {
    KeyOptions(
      curve: .P256,
      secureAreaName: SecureEnclaveSecureArea.name,
      accessControl: .empty
    )
  }

  var validateIssuerRegistrationCertificate: Bool {
    prefsController.getBool(forKey: .validateIssuerRegistrationCertificate)
  }

  var issuersConfig: [String: VciConfig] {

    let openId4VciConfigurations: [VciConfig] = {
      switch configLogic.appBuildVariant {
      case .DEMO:
        return [
          .init(
            config: .init(
              credentialIssuerURL: "https://issuer.eudiw.dev",
              clientId: "eudiw-abca",
              keyAttestationsConfig: .init(
                walletAttestationsProvider: walletKitAttestationProvider,
                popKeyOptions: KeyOptions(
                  secureAreaName: SecureEnclaveSecureArea.name,
                  accessControl: .empty
                )
              ),
              authFlowRedirectionURI: URL(string: "eu.europa.ec.euidi://authorization")!,
              parUsage: .required(authorizationCodeDPoPBinding: true),
              allowPlainJwtProof: false,
              requireDpop: true,
              issuerMetadataPolicy: trustConfiguration.issuerMetadataPolicy,
              validateRegistrationCertificate: validateIssuerRegistrationCertificate,
              cacheIssuerMetadata: false
            ),
            order: 1
          ),
          .init(
            config: .init(
              credentialIssuerURL: "https://issuer-backend.eudiw.dev",
              clientId: "eudiw-abca",
              keyAttestationsConfig: .init(
                walletAttestationsProvider: walletKitAttestationProvider,
                popKeyOptions: KeyOptions(
                  secureAreaName: SecureEnclaveSecureArea.name,
                  accessControl: .empty
                )
              ),
              authFlowRedirectionURI: URL(string: "eu.europa.ec.euidi://authorization")!,
              parUsage: .required(authorizationCodeDPoPBinding: true),
              allowPlainJwtProof: false,
              requireDpop: true,
              issuerMetadataPolicy: trustConfiguration.issuerMetadataPolicy,
              validateRegistrationCertificate: validateIssuerRegistrationCertificate,
              cacheIssuerMetadata: false
            ),
            order: 0
          )
        ]
      case .DEV:
        return [
          .init(
            config: .init(
              credentialIssuerURL: "https://ec.dev.issuer.eudiw.dev",
              clientId: "eudiw-abca",
              keyAttestationsConfig: .init(
                walletAttestationsProvider: walletKitAttestationProvider,
                popKeyOptions: KeyOptions(
                  secureAreaName: SecureEnclaveSecureArea.name,
                  accessControl: .empty
                )
              ),
              authFlowRedirectionURI: URL(string: "eu.europa.ec.euidi://authorization")!,
              parUsage: .required(authorizationCodeDPoPBinding: true),
              allowPlainJwtProof: false,
              requireDpop: true,
              issuerMetadataPolicy: trustConfiguration.issuerMetadataPolicy,
              validateRegistrationCertificate: validateIssuerRegistrationCertificate,
              cacheIssuerMetadata: false
            ),
            order: 1
          ),
          .init(
            config: .init(
              credentialIssuerURL: "https://dev.issuer-backend.eudiw.dev",
              clientId: "eudiw-abca",
              keyAttestationsConfig: .init(
                walletAttestationsProvider: walletKitAttestationProvider,
                popKeyOptions: KeyOptions(
                  secureAreaName: SecureEnclaveSecureArea.name,
                  accessControl: .empty
                )
              ),
              authFlowRedirectionURI: URL(string: "eu.europa.ec.euidi://authorization")!,
              parUsage: .required(authorizationCodeDPoPBinding: true),
              allowPlainJwtProof: false,
              requireDpop: true,
              issuerMetadataPolicy: trustConfiguration.issuerMetadataPolicy,
              validateRegistrationCertificate: validateIssuerRegistrationCertificate,
              cacheIssuerMetadata: false
            ),
            order: 0
          )
        ]
      }
    }()

    return openId4VciConfigurations.reduce(
      into: [String: VciConfig]()
    ) { dict, config in
      guard
        let issuer = config.config.credentialIssuerURL,
        let url = URL(string: issuer),
        let host = url.host
      else {
        return
      }
      dict[host] = config
    }
  }

  var vpConfig: OpenId4VpConfiguration {
    .init(
      clientIdSchemes: [.x509SanDns, .x509Hash],
      supportedTransactionDataTypes: supportedTransactionDataTypes,
      validateRegistrationCertificate: validateIssuerRegistrationCertificate
    )
  }

  var supportedTransactionDataTypes: [SupportedTransactionDataType] {
    let types = [
      TransactionDataTypeIdentifier.qesApproval.rawValue
    ]
    return [.default()] + types.compactMap {
      try? SupportedTransactionDataType(type: TransactionDataType(value: $0))
    }
  }

  var trustConfiguration: TrustConfiguration {
    let loteLocations = SupportedLists<NSString>(
      pidProviders: "https://trustedlist.serviceproviders.eudiw.dev/LOTE/json/PIDProviders.jwt",
      walletProviders: nil,
      wrpacProviders: "https://trustedlist.serviceproviders.eudiw.dev/LOTE/json/WRPACProviders.jwt",
      wrprcProviders: "https://trustedlist.serviceproviders.eudiw.dev/LOTE/json/WRPRCProviders.jwt",
      pubEaaProviders: "https://trustedlist.serviceproviders.eudiw.dev/LOTE/json/PubEAAProviders.jwt",
      qeaProviders: nil,
      eaaProviders: [:]
    )

    let classifications: EtsiContextTypeMappings = [
      DocumentTypeIdentifier.mDocPid.rawValue: .pid,
      DocumentTypeIdentifier.sdJwtPid.rawValue: .pid
    ]

    return TrustConfiguration(
      trustSource: .etsi(
        EtsiTrustSource(
          loteLocations: loteLocations,
          contextTypeMappings: classifications,
          isRevocationEnabled: false
        )
      ),
      fallbackTrustSource: .staticList(
        StaticListTrustSource(rootCertificates: staticRootCertificates)
      ),
      defaultPolicy: .warning,
      docTypePolicies: [
        DocumentTypeIdentifier.mDocPid.rawValue: .enforce,
        DocumentTypeIdentifier.sdJwtPid.rawValue: .enforce
      ],
      requireSignedMetadata: true,
      statusTrustPolicy: .warning,
      wrprcVpTrustPolicy: .warning,
      wrprcVciTrustPolicy: .enforce
    )
  }

  var staticRootCertificates: [Data] {
    [
      "pidissuerca02_cz",
      "pidissuerca02_ee",
      "pidissuerca02_eu",
      "pidissuerca02_lu",
      "pidissuerca02_nl",
      "pidissuerca02_pt",
      "pidissuerca02_ut",
      "r45_staging"
    ].compactMap { loadCertificate($0) }
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
        .other(formatType: "eu.europa.ec.eudi.pda1.1"),
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

  var revocationIntervalSeconds: TimeInterval {
    300
  }

  var documentIssuanceConfig: DocumentIssuanceConfig {
    return switch configLogic.appBuildVariant {
    case .DEMO:
      DocumentIssuanceConfig(
        defaultCredentialOptions: CredentialOptions(
          credentialPolicy: .rotateUse,
          batchSize: 1
        ),
        documentSpecificCredentialOptions: [
          DocumentTypeIdentifier.mDocPid: CredentialOptions(
            credentialPolicy: .oneTimeUse,
            batchSize: 10
          ),
          DocumentTypeIdentifier.sdJwtPid: CredentialOptions(
            credentialPolicy: .oneTimeUse,
            batchSize: 10
          )
        ],
        reIssuanceBackgroundRule: ReIssuanceBackgroundRule(
          backgroundIntervalSeconds: 300
        )
      )
    case .DEV:
      DocumentIssuanceConfig(
        defaultCredentialOptions: CredentialOptions(
          credentialPolicy: .rotateUse,
          batchSize: 1
        ),
        documentSpecificCredentialOptions: [
          DocumentTypeIdentifier.mDocPid: CredentialOptions(
            credentialPolicy: .oneTimeUse,
            batchSize: 60
          ),
          DocumentTypeIdentifier.sdJwtPid: CredentialOptions(
            credentialPolicy: .oneTimeUse,
            batchSize: 60
          )
        ],
        reIssuanceBackgroundRule: ReIssuanceBackgroundRule(
          backgroundIntervalSeconds: 300
        )
      )
    }
  }

  var trustMarkSource: TrustMarkSource {
    .static(
      information: TrustMarkInformation(
        trustMarkResourceURL: "https://gist.githubusercontent.com/sraptis-scy/025334375fe26177d9a7bcb60fd8a93f/raw/TrustMarkResource.json",
        listOfCertifiedWalletsURL: "https://eidas.ec.europa.eu/efda/wallet/certified",
        walletSolutionInfoPageURL: "https://eidas.ec.europa.eu/efda/wallet/certified?id=WALLET_SOLUTION_ID"
      )
    )
  }
}

private extension WalletKitConfigImpl {
  func loadCertificate(_ name: String) -> Data? {
    guard let url = Bundle.main.url(forResource: name, withExtension: "der") else {
      return nil
    }
    return try? Data(contentsOf: url)
  }
}
