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
* [Analytics configuration](#analytics-configuration)
* [Document Provider extension configuration](#document-provider-extension-configuration)

## General configuration

The application allows the configuration of:

1. Issuing API

Via the *WalletKitConfig* protocol inside the logic-core module.

```swift
public protocol WalletKitConfig {
  /**
   * VCI Configuration
   */
  var issuersConfig: [String: VciConfig] { get }
}
```
Based on the Build Variant of the Wallet (e.g., Dev)

```swift
struct WalletKitConfigImpl: WalletKitConfig {

  let configLogic: ConfigLogic

  init(configLogic: ConfigLogic) {
    self.configLogic = configLogic
  }

  var issuersConfig: [String: VciConfig] {
  let openId4VciConfigurations: [OrderedVciConfig] = {
    switch configLogic.appBuildVariant {
      case .DEMO:
        return [
          .init(
            config: .init(
                credentialIssuerURL: "your_demo_issuer_url",
                clientId: "your_demo_client_id_or_nil",
                keyAttestationsConfig: .init(walletAttestationsProvider: walletKitAttestationProvider),
                authFlowRedirectionURI: URL(string: "your_demo_redirect")!,
                requirePAR: should_use_par_bool,
                requireDpop: should_use_dpop_bool,
                cacheIssuerMetadata: should_cache_metadata_bool
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
                  keyAttestationsConfig: .init(walletAttestationsProvider: walletKitAttestationProvider),
                  authFlowRedirectionURI: URL(string: "your_dev_redirect")!,
                  requirePAR: should_use_par_bool,
                  requireDpop: should_use_dpop_bool,
                  cacheIssuerMetadata: should_cache_metadata_bool
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

3. Trusted certificates

Via the *WalletKitConfig* protocol inside the logic-core module.

```swift
public protocol WalletKitConfig {
  /**
   * Reader Configuration
   */
  var trustedReaderRootCertificates: [x5chain] { get }
}
```

The *WalletKitConfigImpl* implementation of the *WalletKitConfig* protocol can be located inside the logic-core module.

The application's IACA certificates are located [here](https://github.com/eu-digital-identity-wallet/eudi-app-ios-wallet-ui/tree/main/Wallet/Sample)

```swift
  var trustedReaderRootCertificates: [x5chain] {
    let certificates = [
      "pidissuerca02_cz",
      "pidissuerca02_ee",
      "pidissuerca02_eu",
      "pidissuerca02_lu",
      "pidissuerca02_nl",
      "pidissuerca02_pt",
      "pidissuerca02_ut",
      "r45_staging"
    ]
    return certificates
      .compactMap { loadCertificate($0) }
      .map { [$0] }
  }
```

4. VP API

Via the *WalletKitConfig* protocol inside the logic-core module.

```swift
public protocol WalletKitConfig {
  /**
   * VP Configuration
   */
  var vpConfig: OpenId4VpConfiguration { get }
}
```

The preregistered scheme is optional. If you want to use it, please add the following: the `SiopOpenID4VP` import and the `.preregistered` option in the `clientIdSchemes` array.

```swift
import SiopOpenID4VP

struct WalletKitConfigImpl: WalletKitConfig {

  let configLogic: ConfigLogic

  init(configLogic: ConfigLogic) {
    self.configLogic = configLogic
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
              verifierApiUri: "your_verifier_url",
              verifierLegalName: "your_verifier_legal_name"
            )
          ]
        )
      ]
    )
  }
}
```

5. RQES

Via the *RQESConfig* struct, which implements the *EudiRQESUiConfig* protocol from the RQESUi SDK, inside the logic-business module.

```swift
final class RQESConfig: EudiRQESUiConfig {

  let buildVariant: AppBuildVariant
  let buildType: AppBuildType

  init(buildVariant: AppBuildVariant, buildType: AppBuildType) {
    self.buildVariant = buildVariant
    self.buildType = buildType
  }

  var rssps: [QTSPData]

  // Optional. Default is false.
  var printLogs: Bool

  // Optional. Default English translations will be used if not set.
  var translations: [String : [LocalizableKey : String]]

  // Optional. Default theme will be used if not set.
  var theme: ThemeProtocol
}
```

Based on the Build Variant and Type of the Wallet (e.g., Dev Debug)

```swift
final class RQESConfig: EudiRQESUiConfig {

  let buildVariant: AppBuildVariant
  let buildType: AppBuildType

  init(buildVariant: AppBuildVariant, buildType: AppBuildType) {
    self.buildVariant = buildVariant
    self.buildType = buildType
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
| Issuers | `WalletKitConfig.swift` | Production OpenID4VCI issuer URLs, client IDs, redirect URIs, PAR/DPoP policy, metadata caching policy, and display order. |
| Wallet provider attestation | `WalletProviderAttestationConfig.swift` | Production Wallet Provider host used for wallet/key attestation. |
| Reader trust anchors | `WalletKitConfig.swift`, certificate resources | Production IACA/reader/verifier trust anchors only. |
| OpenID4VP | `WalletKitConfig.swift` | Approved client ID schemes, preregistered verifier entries where needed, and partial claim disclosure policy. |
| WalletKit storage/auth | `WalletKitConfig.swift`, `ConfigLogic.swift` | Production Keychain service/access group and `userAuthenticationRequired` decision. For LoA High PID and other high-assurance EAA/QEAA credentials, require strong local authentication and Keychain/Secure Enclave-backed protection unless an approved remote high-assurance key protection design replaces local key use. |
| PIN throttle policy | `AuthenticationConfig.swift` in `logic-authentication` | Confirm `maxFailedPinAttempts` and `pinLockoutDurations` meet policy. Decide what happens once the final lockout tier is reached (e.g. wipe, support flow, device-credential step-up). |
| Document / WalletKit key storage | `EudiWalletConfiguration`, `ConfigLogic.keyChainConfig`, WalletKit-supported storage APIs | Default app configuration uses WalletKit storage with the configured Keychain service and access group. If production requires alternative local secure storage, a remote-backed key service, or an external protection SDK, use WalletKit-supported extension points and document the exact SDK/API. |
| Wallet attestation key storage | `WalletKitAttestationProviderImpl`, `WalletProviderAttestationConfig.swift`, Wallet Provider policy | Use when wallet attestation keys must be generated, stored, attested, or unlocked by a custom provider, platform-backed key policy, or remote high-assurance key service. |
| Issuance proof / DPoP key handling | `WalletKitConfig.swift` issuer configuration and WalletKit OpenID4VCI integration | Prefer DPoP where supported. Use WalletKit-supported custom key handling when proof-of-possession keys require specific authentication, Secure Enclave/Keychain policy, remote high-assurance protection, or issuer-specific key policy. |
| Remote presentation ephemeral key handling | `WalletKitConfig.swift`, `WalletKitController.startRemotePresentation(...)`, WalletKit OpenID4VP integration | Ephemeral protocol key material must be generated per transaction, not reused across verifiers, and not persisted beyond the protocol flow. If WalletKit exposes a dedicated ephemeral key-storage option, configure it in the production integration and document the exact SDK API. |
| Document issuance | `WalletKitConfig.swift` | Production credential policy, batch size, and reissuance thresholds. |
| Revocation/status | `WalletKitConfig.swift` | Production status-check interval and failure behavior. |
| RQES | `RQESConfig.swift` | Production QTSP/RSSP endpoint, TSA, client ID, redirect URI, hash policy, and logging policy. Do not hardcode production secrets. |
| Deep links | `Wallet/Wallet.plist`, deep-link parsing code | Production URI schemes and strict validation. |
| Entitlements | `EudiWallet.entitlements`, extension entitlements | Production App Groups, Keychain access groups, document-provider capabilities, and mobile document types. |
| Analytics | `AnalyticsConfig.swift` | Privacy-reviewed provider setup with no PID, credential, token, or verifier payload collection. |

The full production checklist, hardening guidance, OWASP MASVS mapping, and release evidence
requirements are documented in the [production go-live guide](GO_LIVE.md).

## DeepLink Schemas configuration

According to the specifications, issuance, presentation, and RQES require deep-linking for the same device flows.

If you want to change or add your own, you can do it by adjusting the *Wallet.plist* file.

```xml
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

After the *Wallet.plist* adjustment, you must also adjust the *DeepLinkController* inside the logic-ui module.

Current Implementation:

```swift
public extension DeepLink {
  enum Action: String, Equatable {

    case openid4vp
	case haip_vp
    case credential_offer
	case haip_vci
    case rqes
    case external

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
        return .external
      }
    }
  }
}
```

Adjusted with the new schema:

```swift
public extension DeepLink {
  enum Action: String, Equatable {

    case openid4vp
	case haip_vp
    case credential_offer
	case haip_vci
    case rqes
    case custom_my_offer
    case external

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
        return .external
      }
    }
  }
}
```

## Scoped Issuance Document Configuration

The credential configuration is derived directly from the issuer's metadata. The issuer URL is configured via the *VciConfig* property inside the logic-core module in *WalletKitConfigImpl*.
If you want to add or adjust the displayed scoped documents, you must modify the issuer's metadata, and the wallet will automatically resolve your changes.

## How to work with self-signed certificates

For instructions on working with self-signed certificates during local development, see [HOW_TO_BUILD.md](HOW_TO_BUILD.md#how-to-work-with-self-signed-certificates-on-ios).

## Theme configuration

The application allows the configuration of:

1. Colors
2. Images
3. Shape
4. Fonts
5. Dimension

Via the *ThemeConfiguration* struct.

## Pin Storage configuration

The application allows the configuration of the PIN storage. You can configure the following:

1. Where the pin will be stored
2. From where the pin will be retrieved
3. Pin matching and validity

Via the *LogicAuthAssembly* inside the logic-authentication module.

```swift
public final class LogicAuthAssembly: Assembly {

  public init() {}

  public func assemble(container: Container) {
  }
}
```

You can provide your storage implementation by implementing the *PinStorageProvider* protocol and then providing the implementation inside the Assembly DI Graph *LogicAuthAssembly*

Implementation Example:

```swift
final class KeychainPinStorageProvider: PinStorageProvider {

  private let keyChainController: KeyChainController

  init(keyChainController: KeyChainController) {
    self.keyChainController = keyChainController
  }

  func hasPin() -> Bool {
    // Implementation
  }

  func setPin(with pin: String) {
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
  KeychainPinStorageProvider(keyChainController: r.force(KeyChainController.self))
}
.inObjectScope(ObjectScope.graph)
```

The PIN storage layer handles hashing, persistence, and validation. Brute-force protection (failure counting, escalating lockouts) is a separate concern handled by `PinThrottleController` — see [PIN throttle configuration](#pin-throttle-configuration).

## PIN throttle configuration

The application protects against brute-force PIN attempts via an escalating lockout mechanism. After a configurable number of consecutive failed attempts the PIN input is disabled for an increasing duration. Lockout state is persisted in the iOS Keychain via `KeyChainController` (using the shared App-Group access group, so the main app and the document-provider extension share state), so it survives process death, device reboot, and app updates. State is reset on any successful PIN or biometric authentication.

The policy is configurable via the `AuthenticationConfig` protocol inside the `logic-authentication` module:

```swift
public protocol AuthenticationConfig: Sendable {

  /// Number of consecutive wrong PIN attempts allowed before the user is locked out.
  var maxFailedPinAttempts: Int { get }

  /// Lockout durations (in seconds) applied each time the user reaches `maxFailedPinAttempts`.
  /// The list indexes by lockout level (0 = first lockout). Once the user exceeds the
  /// size of the list, the last entry is reused for every subsequent lockout.
  var pinLockoutDurations: [TimeInterval] { get }
}
```

Default policy (`AuthenticationConfigImpl`):

```swift
public struct AuthenticationConfigImpl: AuthenticationConfig {

  public let maxFailedPinAttempts: Int = 3
  public let pinLockoutDurations: [TimeInterval] = [30, 90, 300]

  public init() {}
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
| App kill or device reboot | Active lockout window persists (wall-clock). |
| Device clock rolled back | Detected; user remains locked for the full duration. |

You can change the policy by providing your own `AuthenticationConfig` conformance and wiring it through `LogicAuthAssembly`:

```swift
container.register(AuthenticationConfig.self) { _ in
  AuthenticationConfigImpl()
}
.inObjectScope(ObjectScope.container)
```

The lockout is enforced by `PinThrottleController` and applied in both the login screen (`BiometryViewModel`) and the change-PIN validation step (`QuickPinViewModel`). While locked:

* The PIN input field is disabled (no keyboard, no edits).
* The proceed button is disabled.
* The existing inline error slot of the PIN view shows a countdown message formatted from the `quick_pin_locked_out` string resource. The message takes two format arguments — the configured `maxFailedPinAttempts` and the remaining time as `mm:ss` — so changing the config values updates the user-facing message automatically.
* On screens that offer biometrics, the biometric icon stays interactive. A successful biometric authentication clears the throttle.

## Analytics configuration

The application allows the configuration of multiple analytics providers. You can configure the following:

1. Initializing the provider (e.g., Firebase, Appcenter, etc)
2. Screen logging
3. Event logging

Via the *AnalyticsConfig* and *LogicAnalyticsAssembly* inside the logic-analytics module.

```swift
protocol AnalyticsConfig {
  /**
   * Supported Analytics Provider, e.g. Firebase
   */
  var analyticsProviders: [String: AnalyticsProvider] { get }
}
```

You can implement the *AnalyticsProvider* protocol and add it to your *AnalyticsConfigImpl* analyticsProviders variable.
You will also need the provider's token/key, thus requiring a [String: AnalyticsProvider] configuration.
The project uses Dependency Injection (DI), which requires adjusting the *LogicAnalyticsAssembly* graph to provide the configuration.

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
struct AnalyticsConfigImpl: AnalyticsConfig {
  var analyticsProviders: [String: AnalyticsProvider] {
    return ["YOUR_OWN_KEY": AppCenterProvider()]
  }
}
```

Config Construction via DI Graph Example:

```swift
container.register(AnalyticsConfig.self) { _ in
 AnalyticsConfigImpl()
}
.inObjectScope(ObjectScope.graph)
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

Only CBOR documents are registered (`document.docDataFormat == .cbor`), which controls what the extension can serve for Identity Document requests.

### Validation checklist

- Wallet app and extension both sign correctly with your Team ID.
- Extension target has `EudiReferenceWalletIDProvider.entitlements` assigned.
- `SHARED_APP_GROUP_IDENTIFIER` is present for all extension configurations.
- Main app and extension resolve to the same runtime keychain access group.
- On iOS 26+, registered CBOR documents appear in the extension request flow.
