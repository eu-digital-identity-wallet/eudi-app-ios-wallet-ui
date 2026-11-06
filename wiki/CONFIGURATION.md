# How to configure the application

## Table of contents

* [General configuration](#general-configuration)
* [Production configuration reference](#production-configuration-reference)
* [DeepLink Schemas configuration](#deeplink-schemas-configuration)
* [Scoped Issuance Document Configuration](#scoped-issuance-document-configuration)
* [How to work with self-signed certificates](HOW_TO_BUILD.md#how-to-work-with-self-signed-certificates-on-ios)
* [Theme configuration](#theme-configuration)
* [Pin Storage configuration](#pin-storage-configuration)
* [PIN throttle configuration](#pin-throttle-configuration)
* [Session lock configuration](#session-lock-configuration)
* [Analytics configuration](#analytics-configuration)
* [Document Provider extension configuration](#document-provider-extension-configuration)
* [Trust Mark configuration](#trust-mark-configuration)

## General configuration

The application allows the configuration of:

1. Issuing API

Via the *WalletKitConfig* protocol inside the logic-core module.

```swift
protocol WalletKitConfig: Sendable {
  /**
   * VCI Configuration, keyed by issuer host.
   *
   * `allowPlainJwtProof` is set per issuer and defaults to `false`, which keeps the HAIP-compliant
   * proof policy: only attested proofs (`attestation`, or `jwt` with key attestation) are sent.
   * Set it to `true` only for an issuer that does not support key attestation and requires a plain
   * JWT proof; the proof is then bound to a key without wallet attestation, using ES256/ES384/ES512.
   *
   * `encryptionSupportConfig` is set per issuer and keeps wallet-kit's default: with
   * `credentialResponseEncryptionPolicy` `.supported`, the credential request and response are
   * encrypted whenever the issuer's metadata advertises encryption, and sent in plain JSON over TLS
   * otherwise. Set it to `.required` to refuse an issuer that does not support encryption.
   * `ecConfig`, `rsaConfig` and `supportedEncryptionMethods` restrict the key types and methods used.
   */
  var issuersConfig: [String: VciConfig] { get }
}
```
Based on the Build Variant of the Wallet (e.g., Dev)

```swift
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

  var issuersConfig: [String: VciConfig] {
  let openId4VciConfigurations: [VciConfig] = {
    switch configLogic.appBuildVariant {
      case .DEMO:
        return [
          .init(
            config: .init(
                credentialIssuerURL: "your_demo_issuer_url",
                clientId: "your_demo_client_id_or_nil",
                keyAttestationsConfig: .init(
                  walletAttestationsProvider: walletKitAttestationProvider,
                  popKeyOptions: KeyOptions(
                    secureAreaName: SecureEnclaveSecureArea.name,
                    accessControl: .empty
                  )
                ),
                authFlowRedirectionURI: URL(string: "your_demo_redirect")!,
                parUsage: .required(authorizationCodeDPoPBinding: should_bind_par_dpop_bool),
                allowPlainJwtProof: should_allow_plain_jwt_proof_bool,
                requireDpop: should_use_dpop_bool,
                issuerMetadataPolicy: trustConfiguration.issuerMetadataPolicy,
                validateRegistrationCertificate: validateIssuerRegistrationCertificate,
                encryptionSupportConfig: .init(credentialResponseEncryptionPolicy: .supported)
            ),
            order: issuer_order_int
          )
        ]
            
        case .DEV:
          return [
            .init(
              config: .init(
                  credentialIssuerURL: "your_dev_issuer_url",
                  clientId: "your_dev_client_id_or_nil",
                  keyAttestationsConfig: .init(
                    walletAttestationsProvider: walletKitAttestationProvider,
                    popKeyOptions: KeyOptions(
                      secureAreaName: SecureEnclaveSecureArea.name,
                      accessControl: .empty
                    )
                  ),
                  authFlowRedirectionURI: URL(string: "your_dev_redirect")!,
                  parUsage: .required(authorizationCodeDPoPBinding: should_bind_par_dpop_bool),
                  allowPlainJwtProof: should_allow_plain_jwt_proof_bool,
                  requireDpop: should_use_dpop_bool,
                  issuerMetadataPolicy: trustConfiguration.issuerMetadataPolicy,
                  validateRegistrationCertificate: validateIssuerRegistrationCertificate,
                  encryptionSupportConfig: .init(credentialResponseEncryptionPolicy: .supported)
              ),
              order: issuer_order_int
            )
          ]
        }
    }()

	// ...
	}
}
```

Keep the three parameters the reference app sets on every issuer, or a copied entry falls back to
WalletKit's defaults. `issuerMetadataPolicy: trustConfiguration.issuerMetadataPolicy` requires
signed issuer metadata whose signer chains to the trusted lists, since `requireSignedMetadata` is
`true`; the default, `.ignoreSigned`, accepts unsigned metadata. `validateRegistrationCertificate`
passes the "Check Registration Certificates" setting through (see
`validateIssuerRegistrationCertificate` below); the default is `false`. `popKeyOptions` keeps the
client-attestation proof-of-possession key in the Secure Enclave; without it WalletKit creates a
software key in the Keychain.

`allowPlainJwtProof` selects the credential proof policy for that issuer. Leave it `false` (the default) to stay HAIP-compliant: the wallet sends only attested proofs, either the `attestation` proof type or a `jwt` proof carrying a key attestation from the Wallet Provider. Set it to `true` only for an issuer that does not support key attestation and requires a plain JWT proof; the wallet then also accepts plain `jwt` proofs signed with ES256, ES384 or ES512, and the proof key is no longer attested. The reference issuers require attested proofs, so every issuer in this repo sets it to `false`.

`encryptionSupportConfig` selects the credential request and response encryption policy for that issuer. Every issuer in this repo keeps wallet-kit's default, `credentialResponseEncryptionPolicy: .supported`: the wallet encrypts the credential request and asks for an encrypted response whenever the issuer's metadata advertises encryption, and otherwise exchanges plain JSON over TLS. Set it to `.required` to refuse an issuer that does not support encryption; issuance then fails instead of falling back to plain JSON. `ecConfig`, `rsaConfig` and `supportedEncryptionMethods` restrict the key types and content encryption methods the wallet uses, and default to EC P-256, RSA 2048 and every method the platform supports.

2. Wallet Attestation Provider

Via the *WalletProviderAttestationConfig* protocol inside the logic-core module.

```swift
protocol WalletProviderAttestationConfig: Sendable {
  var walletProviderAttestationUrl: String { get }
}
```

Based on the Build Variant of the Wallet (e.g., Dev)

```swift
final class WalletProviderAttestationConfigImpl: WalletProviderAttestationConfig {

  let configLogic: ConfigLogic

  init(configLogic: ConfigLogic) {
    self.configLogic = configLogic
  }

  var walletProviderAttestationUrl: String {
    switch configLogic.appBuildVariant {
    case .DEMO:
      "your_demo_wallet_provider_host"
    case .DEV:
      "your_dev_wallet_provider_host"
    }
  }
}
```

3. Trust configuration

Via the *WalletKitConfig* protocol inside the logic-core module.

```swift
protocol WalletKitConfig: Sendable {
  /**
   * Trust configuration: ETSI LoTE (List of Trusted Entities) trust sources,
   * verification-context mappings and trust policies used for reader / issuer validation.
   */
  var trustConfiguration: TrustConfiguration { get }
}
```

The *WalletKitConfigImpl* implementation of the *WalletKitConfig* protocol can be located inside the logic-core module. The resulting `TrustConfiguration` is passed to `EudiWallet` as the `trustConfig` argument in `WalletKitController`.

The primary trust source is an ETSI LoTE (List of Trusted Entities) source that fetches signed trusted lists (PID / WRPAC / PubEAA providers) at runtime. A static list of bundled root certificates is configured as the `fallbackTrustSource`. These fallback certificates ship with this repo as DER files in [`Wallet/Certificate`](../Wallet/Certificate) (e.g. `pidissuerca02_eu.der`, `r45_staging.der`). The file names — without the `.der` extension — must match the array in `WalletKitConfigImpl.staticRootCertificates`, which loads each via `loadCertificate(_:)`. Replace the LoTE endpoints and the fallback anchors with your production values before go-live.

```swift
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
          revocationPolicy: .disabled
        )
      ),
      fallbackTrustSource: .staticList(
        StaticListTrustSource(
          rootCertificates: staticRootCertificates,
          revocationPolicy: .ocspOnly
        )
      ),
      defaultPolicy: .warning,
      docTypePolicies: [
        DocumentTypeIdentifier.mDocPid.rawValue: .enforce,
        DocumentTypeIdentifier.sdJwtPid.rawValue: .enforce
      ],
      requireSignedMetadata: true,
      statusTrustPolicy: .warning,
      readerTrustPolicy: .enforce,
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
```

**Document signer trust.** `defaultPolicy` applies to the certificate that signs each issued
document, validated against the issuer trusted lists above. With `.enforce`, an issued document
whose signer chain is not trusted is refused and not stored, and the issuance ends on the
"Issuance blocked" alert. With `.warning`, the failure is only logged and the document is stored.
`docTypePolicies` overrides the policy for specific doc types. A doc type with no verification
context in either trust source cannot be validated, so under `.enforce` it is refused even when
its issuer is legitimate. Map every doc type the wallet issues before enforcing.

The app enforces signer trust for the PID only and warns for every other
attestation: those doc types have no verification context, so enforcing them would refuse every
EAA. `revocationPolicy: .disabled` turns off PKIX revocation checks for the dev trust lists, as
`relaxPkixRevocation()` does on Android; choose another policy for production. The static fallback sets
`.ocspOnly` explicitly, so that the library default (`.crlPriority` since MdocSecurity 0.28.4) does not change it.
Every policy other than `.disabled` needs a positive answer for every certificate below a list entry; see GO_LIVE
[Trust Store](GO_LIVE.md#trust-store).

**Two trust layers.** An access certificate (WRPAC) answers *who is this party*, a registration
certificate (WRPRC) answers *what is it registered to do* — the registered identity, declared
purpose, privacy policy, and the attestation types and claims the party may issue or request. They
are validated independently and against separate trusted lists, so passing one says nothing about
the other. `wrprcProviders` is what makes the second layer possible; leave it `nil` and no
registration certificate can be validated in either direction.

The app treats the two directions differently, and the asymmetry is deliberate:

* **Issuance refuses.** A document is stored only when the issuer's registration is verified and
  covers what is being issued. A registration that fails validation, or that does not list the
  offered attestation, stops the flow on the "Issuance blocked" alert. Both flows resolve the
  registration before anything is issued, so that refusal happens up front: a credential offer is
  resolved first, and the issuer-list flow asks for the issuer's registration before it starts
  (`AddDocumentInteractorImpl.issueDocument`), as does a re-issue; a lookup that fails stops the flow,
  a trust failure as "Issuance blocked" and any other error as a failure the user can retry. The
  outcome is checked again after the kit has
  issued, as a fallback, and a refusal there deletes any document already written to storage. A
  registration that was never established, such as a certificate that cannot be decoded, is
  refused as well, whatever `wrprcVciTrustPolicy` says.
* **Presentation warns.** A request whose registration could not be validated, or that reaches
  beyond the registered scope, still reaches the consent screen. It is shown without the verified
  badge, the claims outside the registered scope are marked, and Share stays disabled until the user
  acknowledges the warning. The acknowledgement is deliberately not remembered between requests. A
  certificate that failed validation still describes the requester where it decoded far enough to
  do so, since the warning and the missing badge already carry the verdict.

All of the registration behaviour above is conditional on `validateIssuerRegistrationCertificate`.
With it off no verifier registration is resolved or displayed on either flow, and the requester is
identified by its access certificate alone. Remote presentation skips the check outright, since the
setting reaches `OpenId4VpConfiguration` and no registration policy is installed. Proximity still
performs it inside WalletKit, which exposes no equivalent flag, but the app ignores the result.

One check does not depend on the setting. A proximity reader that does not authenticate with a trusted
reader certificate (no reader certificate, or one that failed validation) gets the warning "The identity
of this relying party could not be verified" ahead of any registration outcome: no verified badge, the
generic name instead of the one in its certificate (a verified registration certificate still names it,
as on Android), and Share stays disabled until the user acknowledges it
(`RelyingPartyRegistration.toWarning(isRelyingPartyTrusted:)`, which returns
`RegistrationWarning.accessCertificateNotTrusted`). Remote presentation passes the request's own verdict
as well (`PresentationRequest.isTrusted`), as the Android wallet does. With the configured client
identifier schemes, WalletKit refuses a verifier that does not authenticate before the consent screen,
so the warning does not arise there in practice.

Two settings govern the issuance side. Nothing is refused on this basis while the first is off, and
the first governs presentation as well:

| Setting | Where | Effect |
|---|---|---|
| `validateIssuerRegistrationCertificate` | `WalletKitConfig` | Turns WRPRC validation on, for OpenID4VCI and for presentation alike. It is exposed as **Check Registration Certificates** in Settings and **defaults to off**; a change takes effect after the app restarts. Off means no registration is ever evaluated: issuance never refuses on this basis, and no verifier registration is resolved or shown. An issuer that publishes no `issuer_info` never reaches the validation hook at all, so no registration is established and the app refuses on that basis; enabling this against such an issuer fails every issuance. |
| `wrprcVciTrustPolicy` | `TrustConfiguration` | Decides what a failed WRPRC check does to an **issuance** inside WalletKit. `.enforce` refuses: an expired, revoked or suspended certificate, a missing status list, a status-list token that fails authentication, a broken trust chain, or an offer reaching past the registered scope all stop the flow. `.warning` lets WalletKit go on, but the app refuses an issuance on any registration warning, whatever the policy (`WalletKitController.makeIssuerRegistration`), so the same cases are still refused. A registration certificate that cannot be decoded at all establishes no registration, and the app refuses that issuance under either policy, as the Android wallet does. |

`wrprcVpTrustPolicy` is the same decision for **presentations**, and the app deliberately sets it to
`.warning` so a failed check reaches the consent screen behind an acknowledgement rather than ending
the flow. A single policy governed both directions until wallet-kit 0.40.2, which could not express
that asymmetry.

`readerTrustPolicy` decides what an untrusted access certificate (WRPAC) does to an OpenID4VP
request, independently of both. The app keeps it at `.enforce`, as `enforceIfPresent()` does on
Android: a signed request whose reader certificate chain is not trusted is refused. Under
`.warning` (wallet-kit 0.56.0 and later) such a request proceeds and reports
`ReaderAuthenticationStatus.authenticatedWithUntrustedCertificate`; the app treats only
`.authenticated` as a trusted reader, so it is not shown as trusted.

Note what none of these policies changes: WalletKit reports a WRPRC status list that cannot be retrieved only
as a warning. The app refuses an issuance on any registration warning, so an unreachable status list
blocks the issuance, a transient network failure included; a presentation reaches the consent screen
behind the warning.

4. VP API

Via the *WalletKitConfig* protocol inside the logic-core module.

```swift
protocol WalletKitConfig: Sendable {
  /**
   * VP Configuration
   */
  var vpConfig: OpenId4VpConfiguration { get }
}
```

The preregistered scheme is optional. If you want to use it, please add the following: the `OpenID4VP` import and the `.preregistered` option in the `clientIdSchemes` array. List only schemes that authenticate the verifier. With `.redirectUri`, a verifier that did not authenticate would reach the consent screen, which passes the request's own verdict (`onReceivedRegistration(_:isRelyingPartyTrusted:)`) and so shows the access-certificate warning (`RegistrationWarning.accessCertificateNotTrusted`), with Share disabled until the user acknowledges it.

```swift
import OpenID4VP

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

  var vpConfig: OpenId4VpConfiguration {
    .init(
      clientIdSchemes: [
        .x509SanDns,
        .x509Hash,
        .preregistered(
          [
            PreregisteredClient(
              clientId: "your_verifier_id",
              verifierLegalName: "your_verifier_legal_name",
              webKeys: your_verifier_web_key_set,
              jarSigningAlg: your_verifier_signing_algorithm
            )
          ]
        )
      ],
      supportedTransactionDataTypes: supportedTransactionDataTypes,
      validateRegistrationCertificate: validateIssuerRegistrationCertificate
    )
  }
}
```

`webKeys` is the verifier's public key set; `WebKeySet(_:)` also parses a JWKS JSON string.
`jarSigningAlg` defaults to RS256. Set it when the verifier signs its requests with another
algorithm, for example `JWSAlgorithm(.ES256)`. Keep the last two arguments of the configuration, as
the reference app passes them. The initialiser's defaults are an empty
`supportedTransactionDataTypes`, which rejects every request that carries transaction data, RQES
requests included, and `validateRegistrationCertificate: true`, which turns WRPRC checks on whatever
the "Check Registration Certificates" setting says.

5. RQES

Via the *RQESConfig* class, which implements the *EudiRQESUiConfig* protocol from the RQESUi SDK, inside the logic-business module.

The SDK protocol defines five members. `rssps` and `printLogs` are required; `translations`, `theme`
and `transactionLogger` have SDK-provided default implementations, so the wallet may omit them. The
reference app overrides neither `translations` nor `theme`, and supplies `transactionLogger` so that
signing transactions are recorded alongside the presentation and issuance ones:

```swift
public protocol EudiRQESUiConfig: Sendable {
  var rssps: [QTSPData] { get }                                  // Required.
  var printLogs: Bool { get }                                    // Required.
  var translations: [String: [LocalizableKey: String]] { get }  // Optional — defaults to [:] (English).
  var theme: ThemeProtocol { get }                               // Optional — defaults to the SDK theme.
  var transactionLogger: (any TransactionLogger)? { get }       // Optional — defaults to nil (no logging).
}
```

The SDK emits one signing transaction entry per signed document, stored or updated by its
`transactionIdentifier`. Failures inside the logger never interrupt signing.

Based on the Build Variant and Type of the Wallet (e.g., Dev Debug)

```swift
final class RQESConfig: EudiRQESUiConfig {

  let buildVariant: AppBuildVariant
  let buildType: AppBuildType
  let transactionLogger: (any TransactionLogger)?

  init(
    buildVariant: AppBuildVariant,
    buildType: AppBuildType,
    transactionLogger: (any TransactionLogger)? = nil
  ) {
    self.buildVariant = buildVariant
    self.buildType = buildType
    self.transactionLogger = transactionLogger
  }

  var rssps: [QTSPData] {
    return switch buildVariant {
    case .DEV:
      [
        .init(
          name: "your_dev_name",
          rsspId: "your_dev_rssp",
          tsaUrl: "your_dev_tsa",
          clientId: "your_dev_clientid",
          clientSecret: "your_dev_secret",
          authFlowRedirectionURI: "your_dev_redirect",
          hashAlgorithm: .SHA256,
          includeRevocationInfo: false
        )
      ]
    case .DEMO:
      [
        .init(
          name: "your_demo_name",
          rsspId: "your_demo_rssp",
          tsaUrl: "your_demo_tsa",
          clientId: "your_demo_clientid",
          clientSecret: "your_demo_secret",
          authFlowRedirectionURI: "your_demo_redirect",
          hashAlgorithm: .SHA256,
          includeRevocationInfo: false
        )
      ]
    }
  }

  var printLogs: Bool {
    buildType == .DEBUG
  }
}
```

6. Wallet Activation

You can enable or disable the PID Wallet Activation flow. If you choose to enable this feature, the Wallet will not be operational until a PID is issued.
With this feature disabled, there are no such limitations, and the Wallet can operate without a PID being issued beforehand.

Via the *ConfigLogic* protocol inside the logic-business module.

```swift
public protocol ConfigLogic: Sendable {

  /**
   * Wallet requires PID Activation
   */
  var forcePidActivation: Bool { get }
}
```

## Production configuration reference

For production deployments, do not only edit the existing Dev or Demo values. Create a dedicated
production scheme, production build configuration, and `PROD` app build variant, then provide
production values for every config surface listed below.

| Configuration area | Source file | Production value to provide |
| --- | --- | --- |
| Build variant/type | `Wallet/Config/*.xcconfig`, `ConfigLogic.swift` | `BUILD_VARIANT = PROD`, `BUILD_TYPE = RELEASE` for production archives. |
| Issuers | `WalletKitConfig.swift` | Production OpenID4VCI issuer URLs, client IDs, redirect URIs, PAR/DPoP policy, proof-type policy (`allowPlainJwtProof`), signed-metadata policy (`issuerMetadataPolicy`), registration check (`validateRegistrationCertificate`), credential encryption policy (`encryptionSupportConfig`), PoP key options (`popKeyOptions`), logo origins (`logoOrigins`) and display order. |
| Wallet provider attestation | `WalletProviderAttestationConfig.swift` | Production Wallet Provider host used for wallet/key attestation. |
| Reader trust anchors | `WalletKitConfig.swift`, certificate resources | Production IACA/reader/verifier trust anchors only. |
| OpenID4VP | `WalletKitConfig.swift` | Approved client ID schemes, preregistered verifier entries where needed, the accepted transaction data types (`supportedTransactionDataTypes`), and the registration check (`validateRegistrationCertificate`). |
| WalletKit storage/auth | `WalletKitConfig.swift`, `ConfigLogic.swift` | Production Keychain service/access group and `userAuthenticationRequired` decision. For LoA High PID and other high-assurance EAA/QEAA credentials, require strong local authentication and Keychain/Secure Enclave-backed protection unless an approved remote high-assurance key protection design replaces local key use. |
| WalletKit attestation key options | `WalletKitConfig.swift` (`keyOptions`) | Curve, secure area, access protection, access control, and key purposes used when creating attestation/proof keys during issuance, reissuance, deferred issuance, and resume. For LoA High PID and other high-assurance EAA/QEAA credentials, require Secure Enclave (with `.P256`) plus appropriate `accessProtection`/`accessControl`, or an approved remote high-assurance key protection design. |
| Session lock | `AuthenticationConfig.swift` in `logic-authentication`, `ConfigUiLogic.swift` in `logic-ui` | Confirm `backgroundLockTimeout`, `idleLockTimeout` and `protectedFlowLockTimeout`, and keep `protectedFlowRouteKeys`, `loginRouteKeys` and `coveringScreenModules` in step with your screens; see [Session lock configuration](#session-lock-configuration). |
| Pictures of the holder | `ConfigUiLogic.swift` in `logic-ui` | `userImageClaimKeys` lists the claims, by the last element of their path, that hold a picture of the holder (`portrait`, `picture`). A request for one shows a biometric-data notice, and Share (Accept in the ID Provider extension) asks for confirmation while it would be disclosed. Add the claims your credentials use. |
| Screen capture | `ConfigUiLogic.swift` in `logic-ui` | `hideContentWhileCaptured` is false in the reference configuration, so that screens can be recorded in development and testing. Set it to true for production: while the screen is recorded, mirrored or shared, the wallet shows a cover over every screen, sheet and alert, the ID Provider extension's screens included, and cannot be used on the device; while the app is inactive or in the background (the app switcher, Face ID and other system prompts) the cover shows only the wallet's mark (`ScreenCaptureController`). The keyboard is put away while the cover shows. Screenshots cannot be blocked on iOS. See GO_LIVE [Screenshots, Screen Recording, And Sensitive UI](GO_LIVE.md#screenshots-screen-recording-and-sensitive-ui). |
| PIN rules | `AuthenticationConfig.swift` in `logic-authentication` | Confirm `commonPins` and whether setup and login need a device passcode (`requireDeviceSecure`, off by default). |
| PIN throttle policy | `AuthenticationConfig.swift` in `logic-authentication` | Confirm `maxFailedPinAttempts` and `pinLockoutDurations` meet policy. Decide what happens once the final lockout tier is reached (e.g. wipe, support flow, device-credential step-up). |
| Document / WalletKit key storage | `EudiWalletConfiguration`, `ConfigLogic.keyChainConfig`, WalletKit-supported storage APIs | Default app configuration uses WalletKit storage with the configured Keychain service and access group. If production requires alternative local secure storage, a remote-backed key service, or an external protection SDK, use WalletKit-supported extension points and document the exact SDK/API. Start-up reads wallet-storage's `KeyChainStorageService` items to decide whether PIN creation is safe (`WalletKitController.hasStoredDocuments()`); another `DataStorageService` needs its own implementation of that check, see GO_LIVE [PIN Storage](GO_LIVE.md#pin-storage). |
| Wallet attestation key storage | `WalletKitAttestationProviderImpl`, `WalletProviderAttestationConfig.swift`, Wallet Provider policy | Use when wallet attestation keys must be generated, stored, attested, or unlocked by a custom provider, platform-backed key policy, or remote high-assurance key service. |
| Issuance proof / DPoP key handling | `WalletKitConfig.swift` issuer configuration and WalletKit OpenID4VCI integration | Prefer DPoP where supported. Use WalletKit-supported custom key handling when proof-of-possession keys require specific authentication, Secure Enclave/Keychain policy, remote high-assurance protection, or issuer-specific key policy. |
| Remote presentation ephemeral key handling | `WalletKitConfig.swift`, `WalletKitController.startSameDevicePresentation(deepLink:)` and `startCrossDevicePresentation(urlString:)`, WalletKit OpenID4VP integration | Ephemeral protocol key material must be generated per transaction, not reused across verifiers, and not persisted beyond the protocol flow. If WalletKit exposes a dedicated ephemeral key-storage option, configure it in the production integration and document the exact SDK API. |
| Document issuance | `WalletKitConfig.swift` | Production credential policy, batch size, and reissuance thresholds. |
| Revocation/status | `WalletKitConfig.swift` | Production status-check interval and failure behavior, and `workerStopTimeoutSeconds` (30 s): how long the factory reset waits for a background check under way before it gives up without deleting anything. |
| Trust Mark | `WalletKitConfig.swift` (`trustMarkSource`) | Production Trust Mark resource URL, list of certified wallets URL, and the wallet's certification page URL. See [Trust Mark configuration](#trust-mark-configuration). |
| RQES | `RQESConfig.swift` | Production QTSP/RSSP endpoint, TSA, client ID, redirect URI, hash policy, and logging policy. Do not hardcode production secrets. |
| Deep links | `Wallet/Wallet.plist`, deep-link parsing code | Production URI schemes and strict validation. |
| Entitlements | `EudiWallet.entitlements`, extension entitlements | Production App Groups, Keychain access groups, document-provider capabilities, and mobile document types. |
| Analytics | `AnalyticsConfig.swift` | Privacy-reviewed provider setup with no PID, credential, token, or verifier payload collection. |

The full production checklist, hardening guidance, OWASP MASVS mapping, and release evidence
requirements are documented in the [production go-live guide](GO_LIVE.md).

## DeepLink Schemas configuration

According to the specifications, issuance, presentation, and RQES require deep-linking for the same device flows.

If you want to change or add your own, you can do it by adjusting the *Wallet.plist* file. The URL schemes live under the `CFBundleURLTypes` key. The app reads only the first entry of that array (`UrlSchemaControllerImpl.retrieveSchemas(with:)`), so add a scheme to that entry's `CFBundleURLSchemes`, not as a new entry:

```xml
<key>CFBundleURLTypes</key>
<array>
	<dict>
		<key>CFBundleTypeRole</key>
		<string>Editor</string>
		<key>CFBundleURLName</key>
		<string>$(PRODUCT_BUNDLE_IDENTIFIER)</string>
		<key>CFBundleURLSchemes</key>
		<array>
			<string>eudi-openid4vp</string>
			<string>mdoc-openid4vp</string>
			<string>openid4vp</string>
			<string>haip-vp</string>
			<string>openid-credential-offer</string>
			<string>haip-vci</string>
			<string>rqes</string>
		</array>
	</dict>
</array>
```

Let's assume you want to add a new one for the credential offer (e.g., custom-my-offer://), the *Wallet.plist* should look like this:

```xml
<key>CFBundleURLTypes</key>
<array>
	<dict>
		<key>CFBundleTypeRole</key>
		<string>Editor</string>
		<key>CFBundleURLName</key>
		<string>$(PRODUCT_BUNDLE_IDENTIFIER)</string>
		<key>CFBundleURLSchemes</key>
		<array>
			<string>eudi-openid4vp</string>
			<string>mdoc-openid4vp</string>
			<string>openid4vp</string>
			<string>haip-vp</string>
			<string>openid-credential-offer</string>
			<string>haip-vci</string>
			<string>rqes</string>
			<string>custom-my-offer</string>
		</array>
	</dict>
</array>
```

After the *Wallet.plist* adjustment, you must also adjust the `DeepLink.Action` enum in `Modules/logic-ui/Sources/Model/DeepLink.swift`.

Current Implementation (simplified — the real enum also defines the private `name` and `getSchemas(with:)` helpers that `parseType` relies on):

```swift
public extension DeepLink {
  enum Action: String, Equatable, Sendable {

    case openid4vp
    case credential_offer
    case haip_vci
    case haip_vp
    case rqes

    static func parseType(
      with scheme: String,
      and urlSchemaController: UrlSchemaController
    ) -> Action? {
      switch scheme {
      case _ where openid4vp.getSchemas(with: urlSchemaController).contains(scheme),
        _ where haip_vp.getSchemas(with: urlSchemaController).contains(scheme):
        return .openid4vp
      case _ where credential_offer.getSchemas(with: urlSchemaController).contains(scheme),
        _ where haip_vci.getSchemas(with: urlSchemaController).contains(scheme):
        return .credential_offer
      case _ where rqes.getSchemas(with: urlSchemaController).contains(scheme):
        return .rqes
      default:
        return nil
      }
    }
  }
}
```

Adjusted with the new schema:

```swift
public extension DeepLink {
  enum Action: String, Equatable, Sendable {

    case openid4vp
    case credential_offer
    case haip_vci
    case haip_vp
    case rqes
    case custom_my_offer

    static func parseType(
      with scheme: String,
      and urlSchemaController: UrlSchemaController
    ) -> Action? {
      switch scheme {
      case _ where openid4vp.getSchemas(with: urlSchemaController).contains(scheme),
        _ where haip_vp.getSchemas(with: urlSchemaController).contains(scheme):
        return .openid4vp
      case _ where credential_offer.getSchemas(with: urlSchemaController).contains(scheme),
        _ where haip_vci.getSchemas(with: urlSchemaController).contains(scheme),
        _ where custom_my_offer.getSchemas(with: urlSchemaController).contains(scheme):
        return .credential_offer
      case _ where rqes.getSchemas(with: urlSchemaController).contains(scheme):
        return .rqes
      default:
        return nil
      }
    }
  }
}
```

An `rqes` link opens only when its scheme, host and path match a signing service's `authFlowRedirectionURI` in
`RQESConfig` (`DeepLinkControllerImpl.hasDeepLink(url:)`); change both together.

A scheme belongs to an action when it contains the action's name with `_` written as `-`, so
`custom_my_offer` finds `custom-my-offer`. `DeepLinkControllerImpl.handleDeepLinkAction` in
`Modules/logic-ui/Sources/Controller/DeepLinkController.swift` switches over every `Action` case, so
add the new case to the branch that handles its flow, as `haip_vci` is, or the module does not
compile:

```swift
    switch deepLinkExecutable.action {
    // ...
    case .credential_offer, .haip_vci, .custom_my_offer:
      // ...
    }
```

## Scoped Issuance Document Configuration

The credential configuration is derived directly from the issuer's metadata. The issuer URL is configured via the `issuersConfig` property (its `VciConfig` entries) inside the logic-core module in *WalletKitConfigImpl*.
If you want to add or adjust the displayed scoped documents, you must modify the issuer's metadata, and the wallet will automatically resolve your changes.

Issuer logos load only over `https`, from the issuer's own origin or one of that issuer's `VciConfig.logoOrigins`
(the backend issuers list `https://eudiw.dev`, as on Android), so one issuer's metadata cannot point at another
issuer's origins (`IssuerLogoOrigins`, checked with `URL.isAllowedIssuerLogo(allowedOrigins:)`). An offer's logo
follows the configured issuer the offer link names; for an offer passed by address, the issuer whose origin served
it, even when the fetched offer names another configured issuer.
Every remote image, relying-party and Trust Mark logos included, loads only over `https` (`RemoteImagePolicy`). A
redirect is followed only within the image's origin and over `https`, a download stops once it exceeds
`RemoteImagePolicy.maxImageByteCount` (2 MiB) whether or not the response declares its size
(`RemoteImageDownloadOperation`), and a large image is scaled down while it is decoded. The placeholder icon shows
otherwise. The rule applies even when Core or Kit pass an `http` address. An SVG within 2 MiB is still parsed and
drawn (`SDWebImageSVGCoder`), whatever size it declares, so a hostile but allowed source can slow the screen down;
Android has the same residual.
Images inside credentials, such as the portrait, are decoded within Android's limits (`ImageDecodeLimits`): an
image above 40 megapixels is not decoded, and a side above 2048 px is scaled down while decoding.

Credential offers are accepted only from the issuers in `issuersConfig` (`OfferIssuer`; the link is checked before
anything is fetched). An offer that carries itself in the link must name a configured issuer as its
`credential_issuer`, written exactly as its `credentialIssuerURL`; an offer passed by address must be fetched over
`https` from a configured issuer's origin. Any other offer is refused with "This offer comes from an issuer that
this wallet is not set up to use", as on Android, because wallet-kit would otherwise give an unknown issuer the
first configured issuer's client settings. The wallet fetches an offer passed by address itself, and that offer must
name a configured issuer as its `credential_issuer` in turn, compared exactly; WalletKit then gets it by value and
does not fetch it again. An offer that cannot be fetched or read fails with WalletKit's "Credential offer from
server cannot be trusted." To accept an issuer's offers, add a `VciConfig` entry for it to `issuersConfig` in the
build variants that need it.

## How to work with self-signed certificates

For instructions on working with self-signed certificates during local development, see [HOW_TO_BUILD.md](HOW_TO_BUILD.md#how-to-work-with-self-signed-certificates-on-ios).

## Theme configuration

Branding and theming are split across three layers:

1. **The SwiftUI theme** (`logic-resources` module) — colors, typography/fonts, shapes, dimensions,
   and in-app images, all reachable through `Theme.shared` (a `ThemeProtocol`) and its five managers
   (`color`, `image`, `shape`, `font`, `dimension`).
2. **Branding assets** — app icon, app display name, bundle id, splash/launch screen, deep-link
   schemes, and brand strings, defined in the `Wallet/` app target (`Assets.xcassets`,
   `Wallet.plist`, `Config/*.xcconfig`), its build settings in
   `EudiReferenceWallet.xcodeproj/project.pbxproj`, plus the `logic-resources` images and strings.
3. **Sub-SDK theming** — the RQES signing UI carries its own theme and translations (see the RQES
   subsection under [General configuration](#general-configuration)).

The five themeable aspects of the SwiftUI theme are described by the *ThemeConfiguration* struct:

1. Colors
2. Images
3. Shape
4. Fonts
5. Dimension

> The theme is applied at runtime through `Theme.shared`, which is built from the reference managers
> in `Modules/logic-resources/Sources/Manager/`. Those managers read their values from the asset
> catalogs in `logic-resources` (and, for fonts, an optional `WalletFontConfig.plist`). For most
> rebrands you edit the asset catalogs directly; swapping the whole theme programmatically (via
> `Theme.config(...)` with a custom `ThemeConfiguration`) is supported for advanced/runtime setups
> but **not** used by default — see **[THEMING.md](THEMING.md)**.

For a complete, step-by-step rebranding and retheming guide — covering every file you need to change,
a quick-start checklist, colors (light/dark), fonts, logos, the app icon, app name, splash screen,
RQES theming, and a production/accessibility checklist — see **[THEMING.md](THEMING.md)**.

## Pin Storage configuration

The application allows the configuration of the PIN storage. You can configure the following:

1. Where the pin will be stored
2. From where the pin will be retrieved
3. Pin matching and validity

Via the *LogicAuthAssembly* inside the logic-authentication module. The assembly already registers the full authentication stack — the default `PinStorageProvider` is `KeychainPinStorageProvider`:

```swift
public final class LogicAuthAssembly: Assembly {

  public init() {}

  public func assemble(container: Container) {
    container.register(AuthenticationConfig.self) { _ in AuthenticationConfigImpl() }
      .inObjectScope(ObjectScope.container)

    container.register(PinStorageProvider.self) { r in
      KeychainPinStorageProvider(keyChainController: r.force(KeyChainController.self))
    }
    .inObjectScope(ObjectScope.graph)

    // PinStorageController, PinThrottleProvider, PinThrottleController, SessionController,
    // WalletResetController, DeviceLockController and SystemBiometryController are also registered here.
  }
}
```

To use your own storage, implement the *PinStorageProvider* protocol and **replace** the `KeychainPinStorageProvider` registration above inside *LogicAuthAssembly*. The protocol is internal to the logic-authentication module, so the implementation must live in that module too, under a name of its own.

Implementation Example:

```swift
final class CustomPinStorageProvider: PinStorageProvider {

  private let keyChainController: KeyChainController

  init(keyChainController: KeyChainController) {
    self.keyChainController = keyChainController
  }

  func hasPin() throws -> Bool {
    // Implementation
  }

  func setPin(with pin: String) throws {
    // Implementation
  }

  func isPinValid(with pin: String) -> Bool {
    // Implementation
  }
}
```

Config Example:

```swift
container.register(PinStorageProvider.self) { r in
  CustomPinStorageProvider(keyChainController: r.force(KeyChainController.self))
}
.inObjectScope(ObjectScope.graph)
```

`hasPin()` must throw when the record cannot be read and return `false` only when there is no complete
record, a partial one included: the start-up gate offers PIN creation only on `false`, and only when
the Keychain holds no wallet-storage document item in any status, deferred and pending included
(`WalletKitController.hasStoredDocuments()`; start-up loads none). Another `DataStorageService` must
replace that check.
`setPin(with:)` must write the whole record or leave the previous one (or none), and throw when it
cannot. Read and write through `KeyChainController.fetchData`, `fetchValue` and `saveValue`, which throw
`KeyChainError`; `getData`, `getValue` and `storeValue` discard the status. A process killed between the
writes is not covered; see GO_LIVE [PIN Storage](GO_LIVE.md#pin-storage).

The PIN storage layer handles hashing, persistence, and validation. Brute-force protection (failure counting, escalating lockouts) is a separate concern handled by `PinThrottleController` — see [PIN throttle configuration](#pin-throttle-configuration).

## PIN throttle configuration

The application protects against brute-force PIN attempts via an escalating lockout mechanism. After a configurable number of consecutive failed attempts the PIN input is disabled for an increasing duration. Lockout state is persisted in the iOS Keychain via `KeyChainController` (using the shared keychain access group, so the main app and the document-provider extension share state), so the state survives process death and app updates. It runs on the monotonic clock and the boot it began in, not the wall clock (`MonotonicClock`), so a restart during a lockout begins it again in full and a change of the date does not end it early; a lockout that has run its course is cleared, keeping its level, once the app has seen it end, and a Keychain read that fails counts as the longest lockout. An update from a build before the monotonic lockout ends a lockout under way, keeping its level. State is reset on any successful PIN or biometric authentication.

The policy is configurable via the `AuthenticationConfig` protocol inside the `logic-authentication` module:

```swift
public protocol AuthenticationConfig: Sendable {

  /// Number of consecutive wrong PIN attempts allowed before the user is locked out.
  var maxFailedPinAttempts: Int { get }

  /// Lockout durations (in seconds) applied each time the user reaches `maxFailedPinAttempts`.
  /// The list indexes by lockout level (0 = first lockout). Once the user exceeds the
  /// size of the list, the last entry is reused for every subsequent lockout.
  var pinLockoutDurations: [TimeInterval] { get }

  /// Seconds in the background after which the wallet locks: returning to it then requires login.
  var backgroundLockTimeout: TimeInterval { get }

  /// Seconds without interaction after which the wallet locks, on every screen.
  var idleLockTimeout: TimeInterval { get }

  /// Replaces `backgroundLockTimeout` while an issuance, presentation or signing is in progress, since
  /// these can send the user to a website and back. It also caps how long another screen, such as the
  /// RQES SDK's or the issuer's sign-in, may cover the wallet's own: the idle timeout pauses meanwhile, and
  /// the wallet locks when a cover this long ends, or once the issuer's sign-in has lasted this long.
  var protectedFlowLockTimeout: TimeInterval { get }

  /// PINs refused as too easy to guess, besides one digit repeated and ascending or descending runs: the Android
  /// wallet's list. Add the PINs your policy names.
  var commonPins: Set<String> { get }

  /// Whether the wallet can be set up, and logged in to, only on a device with a passcode. When false, a device
  /// without one gets a warning on the PIN screen at setup and on the login screen, and the user goes on, as on
  /// Android.
  var requireDeviceSecure: Bool { get }
}
```

A new PIN is refused when it is one digit repeated, an ascending or descending run of digits, or one of
`commonPins` (`AuthenticationConfig.isWeakPin`). The PIN screen refuses it when it is entered, and
`QuickPinInteractor.setPin` when it is set or changed. During setup the PIN screen, and at each login the login
screen (`BiometryViewModel` with `isPreAuthorization`, the ID Provider extension's login included), check for a device
passcode (`DeviceLockController`) and warn when there is none; with `requireDeviceSecure` they accept no PIN, and the
login screen no Face ID or Touch ID, until one is set. Both check again whenever the app comes back, and setup also
when the first PIN is entered. The passcode check does not apply when the PIN of a set-up wallet is changed, nor to the
confirmations before a presentation (Accept in the extension included), a reset or the biometric unlock switch; the
weak-PIN rule applies to every new PIN. The defaults are the Android wallet's.

Default policy (`AuthenticationConfigImpl`):

```swift
struct AuthenticationConfigImpl: AuthenticationConfig {

  public let maxFailedPinAttempts: Int = 3
  public let pinLockoutDurations: [TimeInterval] = [30, 90, 300]
  public let backgroundLockTimeout: TimeInterval = 60
  public let idleLockTimeout: TimeInterval = 300
  public let protectedFlowLockTimeout: TimeInterval = 600
  public let commonPins: Set<String> = [
    "123123", "121212", "112233", "123321", "102030", "147258", "159753", "789456", "696969", "000123"
  ]
  public let requireDeviceSecure: Bool = false
}
```

Resulting behavior with the defaults:

| Event | Behavior |
| --- | --- |
| 3 consecutive wrong PIN attempts | First lockout: 30 seconds. |
| 3 more wrong attempts after lockout ends | Second lockout: 90 seconds. |
| 3 more wrong attempts | Third lockout: 5 minutes. |
| Each subsequent batch of 3 wrong attempts | 5 minutes (last list entry reused). |
| Successful PIN or biometric authentication | Failure counter and lockout level reset. |
| App kill | Active lockout window persists. |
| Device reboot during a lockout | The lockout begins again in full: the monotonic clock restarts at boot. |
| Lockout over, then device reboot | No new lockout once the app has seen it end, which clears it and keeps its level. |
| Device date or time changed | No effect: the lockout runs on the monotonic clock. |
| Keychain read fails | Counts as a lockout of the longest configured duration. |
| Update from a build with the wall-clock lockout | Ends a lockout in progress; the level is kept. |

You can change the policy by providing your own `AuthenticationConfig` conformance and wiring it through `LogicAuthAssembly`:

```swift
container.register(AuthenticationConfig.self) { _ in
  AuthenticationConfigImpl()
}
.inObjectScope(ObjectScope.container)
```

The lockout is enforced by `PinThrottleController` and applied wherever `BiometryViewModel` asks for the PIN (the login, the confirmations before sharing, the factory reset and the biometric unlock switch in Settings, and the ID Provider extension before it shows a request and again on Accept) and in the change-PIN validation step (`QuickPinViewModel`). While locked:

* The PIN input field is disabled (no keyboard, no edits).
* No PIN is submitted. The PIN screens have no proceed button: they submit on the sixth digit, which is ignored while locked.
* The existing inline error slot of the PIN view shows a countdown message formatted from the `quick_pin_locked_out` string resource. The message takes two format arguments — the configured `maxFailedPinAttempts` and the remaining time as `mm:ss` — so changing the config values updates the user-facing message automatically.
* On screens that offer biometrics, the biometric icon stays interactive, except at login while a required passcode is missing. A successful biometric authentication clears the throttle.

## Session lock configuration

The wallet starts locked. Login (the PIN or biometric screen at start-up) and PIN creation unlock it, and
`SessionController` locks it again, with the same rules as the Android wallet:

| Situation | Locks after | Setting |
| --- | --- | --- |
| In the background | 60 seconds | `AuthenticationConfig.backgroundLockTimeout` |
| In the background from an issuance, a presentation's request or loading screen (not the proximity QR screen), a signing or reset screen or a PIN or biometric confirmation, or while another screen covers the wallet's own on return | 10 minutes | `AuthenticationConfig.protectedFlowLockTimeout`, screens in `ConfigUiLogic.protectedFlowRouteKeys` |
| No interaction, on any screen | 5 minutes | `AuthenticationConfig.idleLockTimeout` |
| Covered by another screen (the RQES SDK's, the issuer's sign-in) for this long, when the wallet's screen returns | 10 minutes | `AuthenticationConfig.protectedFlowLockTimeout` |
| The issuer's sign-in lasting this long, while it is still open | 10 minutes | `AuthenticationConfig.protectedFlowLockTimeout` |

While another screen covers the wallet's own, the idle timeout pauses, since the wallet cannot see
interaction there; when the cover goes after less than 10 minutes, the idle timeout restarts. The RQES
SDK's screens are recognised by their module: a screen covers the wallet when a controller presented over it
belongs to a module in `ConfigUiLogic.coveringScreenModules` (`UIApplication.isWalletCovered(byModules:)`). The
default lists only the RQES SDK, `EudiRQESUi`; add the module of any other SDK your build presents the same way. The
issuance interactors mark the calls that can show the issuer's sign-in
(`SessionController.duringExternalFlow`). The background limit is chosen when the app returns, from the
screen it left and what covers the wallet then, as on Android. A lock ends every such cover (the screen-capture cover of
`hideContentWhileCaptured` is separate).

On Android only the RQES screens pause the idle timeout, because the issuer's sign-in opens in the
browser and the wallet goes to the background. On iOS wallet-kit shows the sign-in in a sheet inside the
wallet's own scene, which stays active, so without the pause the idle timeout would end the session while
the user fills in the issuer's form. The pause is therefore bounded: a sign-in that is still open after
`protectedFlowLockTimeout` locks the wallet, so an issuance that never returns cannot keep it open.
Wallet-kit's client attestation also has a lifetime of its own, and the dev issuer refuses a sign-in that
outlasts it ("Client Attestation has expired"); that limit is wallet-kit's, not the session lock's.

* Interaction is any touch in the app's windows (sheets and the RQES SDK's screens included), text input,
  and a VoiceOver focus change (`UserInteractionController`).
* Time comes from a monotonic clock that keeps running while the device sleeps, so changing the clock
  does not extend a session.
* A lock dismisses whatever is presented over the wallet, the RQES screens included, and returns to the
  start-up screen, which asks for login (`RouterHost.requireLoginIfLocked`). After login the user starts
  again from the dashboard; the flow that was on screen does not resume. A lock, and a wallet link that
  returns to the dashboard, also end a running presentation, so a proximity session stops with its
  screens, as on Android (`SessionCoordinatorHolder.clear`). While locked, the navigation
  opens only the screens in `ConfigUiLogic.loginRouteKeys` (start-up, login, PIN creation, the Trust Mark
  introduction), so work that finishes after a lock cannot reopen the wallet.
* `SessionLockController` applies the timeout when the app returns, before an incoming link is handled,
  and every second while the app is in front. A wallet link that arrives while the wallet is locked is
  kept, in memory for this process only, and opens after login; it starts no presentation session before
  then. A link of no wallet type is dropped.
* The background time counts from when the app left, also when a login completes after that, for example a
  PIN check that finishes as the user switches away: the app locks on return once `backgroundLockTimeout`
  has passed. The PIN or biometric screen is in `protectedFlowRouteKeys` as a flow's confirmation, but the
  login itself does not count: it counts only when the path also holds a screen past login
  (`RouterHost.isInProtectedFlow()`). A background from an earlier absence was already cleared when the app
  came back while locked (`SessionController.lockIfExpired()`). As on Android.
* The proximity QR screen is not in `protectedFlowRouteKeys`. From the moment its QR code is ready (WalletKit is
  then advertising over Bluetooth), the app going to the background (the user leaves the app or locks the phone)
  stops the session and its advertising, and closes the screen if it is still in front
  (`ProximityConnectionViewModel.setPhase(with:)`). A code that becomes ready after the user has left is stopped at
  once; if the user returns before it is ready, the session goes on. `.inactive` (Control Center, a system sheet)
  changes nothing. Once a reader's request has arrived, the session belongs to the request screen, a protected-flow
  screen.
* `ConfigUiLogic.protectedFlowRouteKeys` and `loginRouteKeys` list the screens by `AppRoute.info.key`, as
  the Android wallet's `protectedFlowScreens` and `loginScreens` do. A custom flow screen that sends the
  user to a website and back belongs in the first; a custom screen shown before login, in the second.

## Analytics configuration

The application allows the configuration of multiple analytics providers. You can configure the following:

1. Initializing the provider (e.g., Firebase, Appcenter, etc)
2. Screen logging
3. Event logging

Via the *AnalyticsConfig* and *LogicAnalyticsAssembly* inside the logic-analytics module.

```swift
protocol AnalyticsConfig: Sendable {
  /**
   * Supported Analytics Provider, e.g. Firebase
   */
  var analyticsProviders: [String: AnalyticsProvider] { get }
}
```

You can implement the *AnalyticsProvider* protocol and add it to your *AnalyticsConfigImpl* `analyticsProviders` variable (the value typically carries the provider's token/key). You do **not** register `AnalyticsConfigImpl` in the DI graph yourself: `LogicAnalyticsAssembly` discovers it at runtime by name via the Objective-C runtime (`NSClassFromString("AnalyticsConfigImpl")`) and registers it automatically. For this to work, `AnalyticsConfigImpl` **must be an `NSObject` subclass that the Objective-C runtime knows as `AnalyticsConfigImpl`**: declare it `@objc(AnalyticsConfigImpl)`, since `NSClassFromString` does not find a Swift class by its unqualified name. Without the attribute, or as a `struct`, the lookup or the runtime cast fails and analytics is silently skipped. `AnalyticsConfig` and `AnalyticsProvider` are internal to the logic-analytics module, so `AnalyticsConfigImpl` and your provider must live in that module.

Implementation Example:

```swift
struct AppCenterProvider: AnalyticsProvider {
 
  func initialize(key: String) {
    AppCenter.start(
      withAppSecret: key,
      services: [
        Analytics.self
      ]
    )
  }
 
  func logScreen(screen: String, arguments: [String: String]) {
    if Analytics.enabled {
      logEvent(event: screen, arguments: arguments)
    }
  }
 
  func logEvent(event: String, arguments: [String: String]) {
    Analytics.trackEvent(event, withProperties: arguments)
  }
}
```

Config Example:

```swift
@objc(AnalyticsConfigImpl)
final class AnalyticsConfigImpl: NSObject, AnalyticsConfig {
  var analyticsProviders: [String: AnalyticsProvider] {
    return ["YOUR_OWN_KEY": AppCenterProvider()]
  }
}
```

`LogicAnalyticsAssembly` then registers it for you (no manual `container.register` call needed):

```swift
private func registerConfig(with container: Container) {
  guard
    let object = NSClassFromString("AnalyticsConfigImpl") as? NSObject.Type,
    let config = object.init() as? AnalyticsConfig
  else {
    return
  }
  container.register(AnalyticsConfig.self) { _ in config }
    .inObjectScope(ObjectScope.graph)
}
```

## Document Provider extension configuration

This section explains how the Identity Document Provider extension is wired and how to configure `SHARED_APP_GROUP_IDENTIFIER`.

### Why `SHARED_APP_GROUP_IDENTIFIER` matters

The extension reads Wallet data through `DcApiHandler`, which is initialized with:

- a shared keychain access group
- a shared document storage service name

The keychain access group for the extension is defined in `EudiReferenceWalletIDProvider/EudiReferenceWalletIDProvider.entitlements` as:

```xml
<key>keychain-access-groups</key>
<array>
  <string>$(AppIdentifierPrefix)$(SHARED_APP_GROUP_IDENTIFIER)</string>
</array>
```

`SHARED_APP_GROUP_IDENTIFIER` must match the main app's effective keychain group for the same build configuration (Dev or Demo), otherwise the extension cannot access the same keychain-backed wallet context.

The extension also asks for the wallet PIN or biometrics before it shows a request. It reads the PIN record and the PIN lockout state from the same shared keychain group, and the biometry and "Allow document requests from apps and websites (DC API)" settings from the App Group (`com.apple.security.application-groups`, `group.$(SHARED_APP_GROUP_IDENTIFIER)`), so both entitlements must match the main app's.

### Step-by-step setup

1. **Set `SHARED_APP_GROUP_IDENTIFIER` for all extension build configurations**

In the extension target build settings (`EudiReferenceWallet.xcodeproj/project.pbxproj`), ensure `SHARED_APP_GROUP_IDENTIFIER` is set for:

- Debug Dev
- Release Dev
- Debug Demo
- Release Demo

Current values in this repository:

- Dev: `eu.europa.ec.euidi.dev`
- Demo: `eu.europa.ec.euidi`

2. **Ensure extension entitlements use that value**

In `EudiReferenceWalletIDProvider/EudiReferenceWalletIDProvider.entitlements`, keep:

```xml
<string>$(AppIdentifierPrefix)$(SHARED_APP_GROUP_IDENTIFIER)</string>
```

3. **Ensure the main app has matching keychain sharing**

In `EudiWallet.entitlements`, the main app uses:

```xml
<string>$(AppIdentifierPrefix)$(PRODUCT_BUNDLE_IDENTIFIER)</string>
```

For Dev/Demo setups in this project, `PRODUCT_BUNDLE_IDENTIFIER` of the main app maps to the same logical identifiers (`eu.europa.ec.euidi.dev` / `eu.europa.ec.euidi`), so the group stays aligned with the extension.

4. **Verify extension DI initialization**

The extension entry point is `EudiReferenceWalletIDProvider/DocumentProviderExtension.swift`.

At startup it initializes `DocumentProviderDIContainer`, which assembles `LogicIDPModule`. `LogicIDPModule` creates `DcApiHandler` with:

- `serviceName`: derived by `Bundle.getDocumentStorageServiceName()`
- `accessGroup`: derived by `Bundle.getKeychainAccessGroup()`

5. **Verify registration from wallet to extension**

In `Modules/logic-core/Sources/Controller/WalletKitController.swift`, documents are registered to `IdentityDocumentProviderRegistrationStore` (iOS 26+) through `DocumentRegistrationManager`.

Only CBOR documents without a revocation record are registered (`document.docDataFormat == .cbor`), which controls what the extension can serve for Identity Document requests. While "Allow document requests from apps and websites (DC API)" is off in Settings (`Prefs.Key.offerDocumentsToApps`, on by default), nothing is registered.

The wallet registers while iOS reports its authorisation as `authorized` or `notDetermined`: iOS stays at `notDetermined` until the app's first registration, which is what authorises it. A user who turns the wallet off as a document provider (`notAuthorized`) gets no registrations.

Registrations are reconciled against wallet storage after every operation that adds or removes a document, when a revocation check stores or clears a record, when that setting changes, and, in a task of its own, once the dashboard has first loaded the documents after login or PIN creation (start-up loads none): a registration whose document is no longer held is removed.

### Validation checklist

- Wallet app and extension both sign correctly with your Team ID.
- Extension target has `EudiReferenceWalletIDProvider.entitlements` assigned.
- `SHARED_APP_GROUP_IDENTIFIER` is present for all extension configurations.
- Main app and extension resolve to the same runtime keychain access group.
- On iOS 26.0 and later, registered CBOR documents appear in the extension request flow.
- The extension asks for the PIN or biometrics before it shows a request, and again on Accept.
- The requester is shown without the verified badge and with the warning that its identity could not be
  verified; Accept waits for its acknowledgement. `DcApiHandler` returns no reader trust verdict (see GO_LIVE).

## Trust Mark configuration

[`WalletKitConfig.trustMarkSource`](../Modules/logic-core/Sources/Config/WalletKitConfig.swift)
selects how Trust Mark information is supplied. All build variants use this static default:

```swift
var trustMarkSource: TrustMarkSource {
  .static(
    information: TrustMarkInformation(
      trustMarkResourceURL: "https://gist.githubusercontent.com/sraptis-scy/025334375fe26177d9a7bcb60fd8a93f/raw/TrustMarkResource.json",
      listOfCertifiedWalletsURL: "https://eidas.ec.europa.eu/efda/wallet/certified",
      walletSolutionInfoPageURL: "https://eidas.ec.europa.eu/efda/wallet/certified?id=WALLET_SOLUTION_ID"
    )
  )
}
```

`WalletKitController` passes the configured source to `EudiWallet`:

```swift
EudiWallet(
  eudiWalletConfig: EudiWalletConfiguration(
    // ...
  ),
  trustConfig: walletKitConfig.trustConfiguration,
  // ...
  trustMarkSource: walletKitConfig.trustMarkSource
)
```

To change the Trust Mark settings, return a different `trustMarkSource` from `WalletKitConfigImpl`,
switching on `configLogic.appBuildVariant` when the values differ per variant. Use `.static` for
predefined information, or `.dynamic(provider:)` with a `TrustMarkProvider` that supplies the
information at runtime.

WalletKit fetches JSON from `trustMarkResourceURL`. The Trust Mark screen displays the image from
`image.url` above the localized text from the resource. A relative `image.url` is resolved against
`trustMarkResourceURL`, and SVG images are supported.

"EUDI Wallet Provider Trusted List" opens `listOfCertifiedWalletsURL` in the browser.
"Certification information page" opens `walletSolutionInfoPageURL` in the browser.
Both links include an external-link icon and are available in the introduction and About views.

Static configuration does not bundle the resource or make it available offline. The configured
Gist is a development sample and `WALLET_SOLUTION_ID` is a literal placeholder. Displaying the
information does not verify certification, recognition, expiry, revocation or wallet instance
attestation. See [Trust Mark deployment](GO_LIVE.md#trust-mark-deployment) before using a production
configuration.
