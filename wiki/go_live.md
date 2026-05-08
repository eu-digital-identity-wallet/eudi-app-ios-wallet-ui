# EUDI iOS Wallet Go-Live Guide

This guide explains how an integrator, implementer, or Member State team can take this iOS
reference wallet and turn it into a production candidate.

It complements:

* [How to build](how_to_build.md)
* [How to configure the application](configuration.md)
* [Main README](../README.md)

The reference application is not production ready as delivered. It uses demo services, demo trust
anchors, broad custom-scheme deep links, source-level configuration, and security defaults that must
be reviewed for a high-assurance wallet. Treat this guide as a go-live work plan, not as a legal
certification or a replacement for a full security assessment.

## Audience

This guide is for technical teams that will operate or integrate a production wallet, including:

* Member State wallet teams.
* Wallet providers.
* iOS application developers.
* Issuer, verifier, wallet-provider, and QTSP integration teams.
* Security, privacy, compliance, and accreditation teams.
* CI/CD and release engineers.

Readers should understand iOS development, Xcode, Swift Package Manager, Apple signing and
provisioning, OAuth/OpenID flows, TLS, and mobile security basics.

## Production Principle

Do not publish the application by only archiving `Release Demo` or `Release Dev`.

Create a separate production scheme and build configuration, replace every demo endpoint and
certificate, perform a MASVS-aligned assessment, add runtime hardening, and run a formal release
process.

## Go-Live Checklist

Use this checklist before the first production release.

| Area | Required production outcome |
| --- | --- |
| App identity | Final bundle identifier, app name, icon, Apple Developer team, App Store Connect app record, and distribution channel are defined. |
| Build configurations | A dedicated production scheme and production build configuration exist, for example `EUDI Wallet Prod` and `Release Prod`; Dev and Demo remain non-production only. |
| Signing | Distribution certificates, provisioning profiles, App Groups, Keychain Sharing, and required entitlements are controlled and documented. |
| Issuers | All OpenID4VCI issuer URLs point to production issuer services controlled or approved by the implementer. |
| Wallet provider | `walletProviderAttestationUrl` points to the production Wallet Provider service and supports the expected attestation endpoints. |
| Trust anchors | Demo and development certificates are replaced by production IACA, reader, verifier, or trust-framework anchors. |
| RQES | QTSP, TSA, client ID, redirect URI, and signing policy are production values. No QTSP client secret is hardcoded in the app. |
| Secrets | No production secret is hardcoded in Swift, plist files, xcconfig files, or build settings. |
| Network | App Transport Security is enforced; trust-all certificate logic is absent; TLS policy and certificate pinning strategy are agreed. |
| Storage | Wallet data, Keychain items, SwiftData stores, logs, and App Group containers are protected, excluded from inappropriate backup, and migration-safe. |
| Authentication | PIN, biometrics, device credential fallback, key authentication, lockout, recovery, and reset policies are approved. |
| Deep links | All inbound URI schemes, redirect URIs, hosts, and parameters are validated and threat-modeled. |
| Logs | Production logs do not include PID, credentials, tokens, request objects, signatures, keys, or user decisions. |
| App hardening | Apple App Attest/DeviceCheck, commercial protection, or a manual RASP strategy is implemented and connected to backend risk policy. |
| MASVS | Controls are mapped to evidence and tested with static, dynamic, and manual security testing. |
| Privacy | DPIA, data minimization, retention, telemetry, consent, privacy manifest, App Store privacy labels, and privacy notice are complete. |
| Operations | Monitoring, incident response, vulnerability disclosure, certificate rotation, and forced update processes exist. |

## Current Project Shape

The application is a modular iOS project. Important modules and targets for production are:

| Module or target | Production relevance |
| --- | --- |
| `Wallet` | Main app entry point, plist values, build configuration files, app launch, and deep-link registration. |
| `EudiReferenceWalletIDProvider` | Identity Document Provider extension for Digital Credentials API presentment on supported iOS versions. |
| `logic-core` | WalletKit integration, issuer configuration, presentation, document issuance, document registration, revocation, transaction logging. |
| `logic-business` | Global app config, build variant parsing, RQES config, Keychain controller, preferences, Bluetooth and shared helpers. |
| `logic-authentication` | PIN storage provider, PIN controller, biometric controller. |
| `logic-storage` | SwiftData storage for bookmarks, transactions, revoked documents, and failed reissuance data. |
| `logic-api` | `URLSession` provider and network request helpers. |
| `logic-analytics` | Optional analytics provider integration. |
| `logic-resources` | Strings, images, theme, localized resources. |
| `logic-ui` | Shared SwiftUI components, deep-link parsing, scanner, request UI. |
| `logic-assembly` | Dependency injection graph and app routing assembly. |
| `feature-*` | User-facing flows for startup, dashboard, issuance, presentation, proximity, and common features. |
| `fastlane` | Test, versioning, archive, TestFlight/App Store upload, tagging, and GitHub release automation. |

Current schemes:

* `EUDI Wallet Dev`
* `EUDI Wallet Demo`

Current build configurations:

* `Debug Dev`
* `Release Dev`
* `Debug Demo`
* `Release Demo`

Current `.xcconfig` files:

* `Wallet/Config/WalletDev.xcconfig`
* `Wallet/Config/WalletDevRelease.xcconfig`
* `Wallet/Config/WalletDemo.xcconfig`
* `Wallet/Config/WalletDemoRelease.xcconfig`

For production, add and use a dedicated production scheme and configuration, for example:

* `EUDI Wallet Prod`
* `Debug Prod`
* `Release Prod`
* `Wallet/Config/WalletProd.xcconfig`
* `Wallet/Config/WalletProdRelease.xcconfig`

## Source Of Truth Files

Keep these files under strict review:

| File | Why it matters |
| --- | --- |
| `Wallet/Config/*.xcconfig` | Defines build type, build variant, changelog URL, and other compile-time values consumed by the plist and config logic. |
| `Wallet/Wallet.plist` | Defines build metadata, URL schemes, Team ID, encryption export flag, and app-level plist values. |
| `EudiReferenceWallet.xcodeproj/project.pbxproj` | Defines schemes, build configurations, bundle identifiers, signing style, provisioning profiles, app display name, usage descriptions, and extension settings. |
| `EudiWallet.entitlements` | Defines main app Keychain Sharing, App Groups, and Identity Document Provider mobile document types. |
| `EudiReferenceWalletIDProvider/EudiReferenceWalletIDProvider.entitlements` | Defines extension App Groups and Keychain Sharing through `SHARED_APP_GROUP_IDENTIFIER`. |
| `EudiReferenceWalletIDProvider/DocumentProviderExtension.swift` | Extension entry point for Identity Document Provider requests. |
| `EudiReferenceWalletIDProvider/Domain/DI/LogicIDPModule.swift` | Initializes `DcApiHandler` with shared service name and Keychain access group. |
| `Modules/logic-business/Sources/Config/ConfigLogic.swift` | Parses app build type and build variant, exposes app behavior toggles, RQES config, and Keychain config. |
| `Modules/logic-business/Sources/Config/RQESConfig.swift` | Defines QTSP/RSSP, TSA, OAuth client, redirect URI, hash algorithm, and RQES logging behavior. |
| `Modules/logic-core/Sources/Config/WalletKitConfig.swift` | Main WalletKit production configuration: issuers, OpenID4VP, trust anchors, document categories, logging, revocation, and issuance rules. |
| `Modules/logic-core/Sources/Config/WalletProviderAttestationConfig.swift` | Defines the wallet provider attestation host. |
| `Modules/logic-core/Sources/Controller/WalletKitController.swift` | Constructs `EudiWallet`, wires WalletKit config, starts presentation, issuance, revocation, logging, and document registration. |
| `Modules/logic-authentication/Sources/Storage/KeychainPinStorageProvider.swift` | Defines PIN hashing, salt, PBKDF2 iteration count, and constant-time comparison. |
| `Modules/logic-business/Sources/Controller/KeyChainController.swift` | Defines Keychain service, access group, accessibility class, and biometric Keychain validation. |
| `Modules/logic-storage/Sources/Config/StorageConfig.swift` | Defines SwiftData store location, App Group container selection, and local storage schema. |
| `Modules/logic-api/Sources/Provider/NetworkSessionProvider.swift` | Defines the shared network session used by app network calls. |
| `Modules/logic-analytics/Sources/Config/AnalyticsConfig.swift` | Defines analytics provider configuration. |
| `.github/workflows/*.yml` | Defines SAST, SCA, and secret scanning workflows. |
| `security/gitleaks/gitleaks.toml` | Defines local secret scanning rules. |
| `fastlane/Fastfile` | Defines iOS test, versioning, archive, upload, tag, and release lanes. |

## Create A Production Scheme And Configuration

Do not reuse `Demo` for production. Add a new production build configuration so production values are
isolated, reviewable, and testable.

### 1. Add `PROD` To `AppBuildVariant`

Edit:

```text
Modules/logic-business/Sources/Config/ConfigLogic.swift
```

Current shape:

```swift
public enum AppBuildVariant: String, Sendable {
  case DEMO, DEV
}
```

Production shape:

```swift
public enum AppBuildVariant: String, Sendable {
  case DEMO, DEV, PROD
}
```

Then update every `switch configLogic.appBuildVariant` to include `.PROD`.

At minimum, production values must be added in:

* `WalletKitConfigImpl.issuersConfig`
* `WalletKitConfigImpl.documentIssuanceConfig`
* `WalletProviderAttestationConfigImpl.walletProviderAttestationUrl`
* `RQESConfig.rssps`

### 2. Add Production `.xcconfig` Files

Create:

```text
Wallet/Config/WalletProd.xcconfig
Wallet/Config/WalletProdRelease.xcconfig
```

Recommended starting shape:

```text
BUILD_TYPE = DEBUG
BUILD_VARIANT = PROD
CHANGELOG_URL = https:/$()/wallet.example.eu/releases
```

```text
BUILD_TYPE = RELEASE
BUILD_VARIANT = PROD
CHANGELOG_URL = https:/$()/wallet.example.eu/releases
```

Use the escaped `https:/$()/...` form only where Xcode build settings require it. The runtime value
should resolve to a normal HTTPS URL.

Do not put secrets into `.xcconfig` files. Values in these files are visible in source control and
can be extracted from built products.

### 3. Add `Debug Prod` And `Release Prod`

In Xcode project settings:

1. Duplicate `Debug Demo` as `Debug Prod`.
2. Duplicate `Release Demo` as `Release Prod`.
3. Assign `WalletProd.xcconfig` to `Debug Prod`.
4. Assign `WalletProdRelease.xcconfig` to `Release Prod`.
5. Repeat for all targets that need the configuration:
   * Main app target.
   * Identity Document Provider extension target.
   * Project-level build settings if applicable.

For the extension target, set production `SHARED_APP_GROUP_IDENTIFIER` so it matches the main app's
effective Keychain access group and App Group.

### 4. Add A Production Scheme

Create a new shared scheme, for example:

```text
EUDI Wallet Prod
```

Recommended scheme mapping:

| Scheme action | Build configuration |
| --- | --- |
| Run | `Debug Prod` |
| Test | `Debug Prod` |
| Analyze | `Debug Prod` |
| Profile | `Release Prod` |
| Archive | `Release Prod` |

Check the scheme into source control under:

```text
EudiReferenceWallet.xcodeproj/xcshareddata/xcschemes
```

### 5. Build The Production Configuration

Example build:

```bash
xcodebuild \
  -project EudiReferenceWallet.xcodeproj \
  -scheme "EUDI Wallet Prod" \
  -configuration "Release Prod" \
  -destination "generic/platform=iOS" \
  clean build
```

Example archive:

```bash
xcodebuild \
  -project EudiReferenceWallet.xcodeproj \
  -scheme "EUDI Wallet Prod" \
  -configuration "Release Prod" \
  -destination "generic/platform=iOS" \
  -archivePath build/EudiWalletProd.xcarchive \
  clean archive
```

Export with an export options plist that includes all relevant bundle identifiers and provisioning
profiles, including the extension.

## Application Identity

Production identity values must be final before external testing.

| Setting | Current location | Production guidance |
| --- | --- | --- |
| Bundle identifier | `PRODUCT_BUNDLE_IDENTIFIER` in Xcode build settings | Use a final reverse-DNS identifier owned by the implementer, for example `eu.example.wallet`. Changing it after App Store release creates a different app identity. |
| Extension bundle identifier | Extension target `PRODUCT_BUNDLE_IDENTIFIER` | Use a child identifier of the main app, for example `eu.example.wallet.EudiReferenceWalletIDProvider`. |
| App display name | `INFOPLIST_KEY_CFBundleDisplayName` | Use the official wallet name approved for the Member State or wallet provider. |
| App icon | Asset catalogs and target settings | Replace reference assets with production brand assets. |
| Apple team | `DEVELOPMENT_TEAM`, `APP_TEAM_ID`, App Store Connect | Use the production Apple Developer Program team. |
| Version | `MARKETING_VERSION`, Fastlane lane mutation | Use the approved public versioning scheme. |
| Build number | `CURRENT_PROJECT_VERSION`, `CFBundleVersion`, Fastlane lane mutation | Must monotonically increase for App Store Connect. |
| Minimum iOS | Swift packages and project deployment target | Current packages target iOS 17. Confirm this with the device support policy. |
| Category | `INFOPLIST_KEY_LSApplicationCategoryType` | Review App Store category and public-sector distribution needs. |

Recommended:

* Dev and Demo apps should have visibly different names and bundle IDs.
* Production should not use `.dev`, `.demo`, or similar suffixes.
* Production icons should differ from Dev/Demo where those variants can be installed side by side.
* App Store Connect metadata, privacy labels, support URL, marketing URL, and age rating must be
  reviewed by the legal and privacy teams.

## Release Signing

iOS production signing requires both the main app and extension to be provisioned correctly.

Before release:

* Create or confirm the explicit App ID for the main app.
* Create or confirm the explicit App ID for the Identity Document Provider extension.
* Enable required capabilities for both identifiers.
* Create distribution provisioning profiles for the selected distribution channel.
* Ensure CI has access to certificates and profiles through an approved secret management process.
* Do not commit `.p12`, `.cer`, `.mobileprovision`, App Store Connect keys, passwords, or private keys.

Main app capabilities to review:

| Capability | Current project area | Production guidance |
| --- | --- | --- |
| Keychain Sharing | `EudiWallet.entitlements` | Must use the production bundle identifier or approved access group. |
| App Groups | `EudiWallet.entitlements` | Must match the production app and extension group. |
| Identity Document Provider mobile document types | `EudiWallet.entitlements` | Include only document types that the production app can serve and that policy approves. |

Extension capabilities to review:

| Capability | Current project area | Production guidance |
| --- | --- | --- |
| App Groups | `EudiReferenceWalletIDProvider.entitlements` | `group.$(SHARED_APP_GROUP_IDENTIFIER)` must match the main app group. |
| Keychain Sharing | `EudiReferenceWalletIDProvider.entitlements` | `$(AppIdentifierPrefix)$(SHARED_APP_GROUP_IDENTIFIER)` must resolve to the same logical Keychain group used by the main app. |
| Digital Credentials API entitlement | Apple Developer account and profiles | Required for production Identity Document Provider behavior where applicable. Confirm entitlement approval and provisioning profile contents. |

Signing checks:

```bash
codesign -d --entitlements :- build/EudiWalletProd.xcarchive/Products/Applications/EudiWallet.app
codesign -d --entitlements :- build/EudiWalletProd.xcarchive/Products/Applications/EudiWallet.app/PlugIns/EudiReferenceWalletIDProvider.appex
```

Archive the output as release evidence.

## CI/CD Release Pipeline

The current Fastlane lane is useful as a starting point, but production release automation must be
intentional and controlled.

Current key lanes:

| Lane | Purpose |
| --- | --- |
| `ios tests` | Runs tests with `scan`. |
| `ios code_coverage` | Runs tests with coverage and generates `xcov` output. |
| `ios deploy` | Pulls Git, creates an App Store Connect API key, computes build number, updates version/build values, archives, uploads to TestFlight/App Store Connect, resets project version values, tags, and optionally creates a GitHub release. |
| `ios upload_appstore` | Uploads an IPA with `pilot`. |
| `ios update_build_number` | Updates build number in plist and Xcode project. |
| `ios update_version` | Updates marketing version in Xcode project. |

Required production improvements:

* Use the production scheme and configuration explicitly.
* Update `build_app` export options so provisioning profile mappings include both the main app and
  the Identity Document Provider extension.
* Fail the pipeline if production artifacts contain demo endpoints or sample secrets.
* Run tests, SAST, SCA, secret scan, and plist/entitlement checks before upload.
* Archive the signed IPA, dSYM files, dependency report, SBOM, test reports, and evidence package.
* Store App Store Connect API keys in CI secret storage only.
* Run from a clean working tree.
* Avoid mutating tracked version files without either committing the release change or resetting the
  workspace in a controlled CI-only step.

Example production environment variables:

| Variable | Meaning |
| --- | --- |
| `APP_PROJECT` | `EudiReferenceWallet.xcodeproj` |
| `APP_SCHEME` | Production scheme, for example `EUDI Wallet Prod` |
| `APP_BUILD_TYPE` | Release label used by Fastlane tags, for example `Prod` |
| `APP_TARGETS` | Comma-separated targets to version, including app and extension where needed. |
| `APP_VERSION_CONFIG` | Production release build configuration name, for example `Release Prod`. |
| `APP_TAG` | Tag namespace or brand segment. |
| `APP_BUNDLE_ID` | Production main app bundle identifier. |
| `APP_PROVISION_PROFILE` | Main app distribution provisioning profile name. |
| `APP_EXTENSION_BUNDLE_ID` | Identity Document Provider extension bundle identifier. |
| `APP_EXTENSION_PROVISION_PROFILE` | Extension distribution provisioning profile name. |
| `CONNECT_KEY_ID` | App Store Connect API key ID. |
| `CONNECT_ISSUER_ID` | App Store Connect API issuer ID. |
| `CONNECT_KEY_PATH` | Path to the private key file injected by CI. |
| `CONNECT_APPLE_ID` | Apple account used by Fastlane metadata. |
| `CONNECT_ITC_TEAM_ID` | App Store Connect team ID. |
| `CONNECT_TEAM_NAME` | Developer team name. |
| `CONNECT_TEAM_ID` | Developer team ID. |
| `TESTFLIGHT_GROUPS` | Comma-separated TestFlight groups. |
| `PROD_REMOTE_REPO` | Optional remote used to push production tags. |
| `GITHUB_RELEASE_REPO` | Optional GitHub release repository. |
| `GITHUB_RELEASE_TOKEN` | Optional token used to create GitHub releases. |

Current lane caveat:

The checked-in `deploy` lane maps only `APP_BUNDLE_ID` to `APP_PROVISION_PROFILE` in
`export_options`. Before production use, extend the lane to export the embedded extension with its
own profile mapping:

```ruby
build_app(
  scheme: ENV["APP_SCHEME"],
  export_method: "app-store",
  export_options: {
    provisioningProfiles: {
      ENV["APP_BUNDLE_ID"] => ENV["APP_PROVISION_PROFILE"],
      ENV["APP_EXTENSION_BUNDLE_ID"] => ENV["APP_EXTENSION_PROVISION_PROFILE"]
    }
  }
)
```

For the complete lane usage notes, see [../fastlane/USAGE.md](../fastlane/USAGE.md).

## Dependency Versions

Current production-relevant dependency sources include:

| Dependency | Current version or source | Production guidance |
| --- | --- | --- |
| Swift tools | `6.2` in package manifests | Confirm CI and Xcode version support this toolchain. |
| iOS platform | `.iOS(.v17)` in package manifests | Confirm policy and market support for iOS 17 and later. |
| EUDI WalletKit | `0.28.2` exact | Keep exact or otherwise pinned; review release notes before upgrades. |
| EUDI RQES UI | `0.4.0` exact | Keep exact or otherwise pinned; review QTSP behavior after upgrades. |
| EUDI OpenID4VCI | `0.35.1` resolved transitively | Review metadata, PAR, DPoP, and credential offer compatibility. |
| EUDI SIOP OpenID4VP | `0.33.0` resolved transitively | Review OpenID4VP profile and verifier trust behavior. |
| EUDI ISO 18013 libraries | `0.14.0` resolved transitively | Review proximity and mdoc compatibility. |
| EUDI Wallet Storage | `0.11.3` resolved transitively | Review secure storage, migrations, and backup behavior. |
| KeychainAccess | `4.2.2` resolved | Review accessibility classes and access group behavior. |
| BluetoothKit | `master` branch | Prefer pinned tags or commits for production dependency governance. |
| Swinject | `2.10.0` resolved | Review dependency injection graph changes during upgrades. |

Production dependency rules:

* Keep `Package.resolved` committed and reviewed.
* Avoid branch dependencies for production unless the commit is pinned and approved.
* Generate an SBOM for each release.
* Run SCA before each release.
* Review all transitive dependencies used by WalletKit, RQES, DC API, cryptography, parsing, and UI.

## WalletKitConfig Overview

The most important production file is:

```text
Modules/logic-core/Sources/Config/WalletKitConfig.swift
```

It implements:

```swift
protocol WalletKitConfig: Sendable {
  var issuersConfig: [String: VciConfig] { get }
  var vpConfig: OpenId4VpConfiguration { get }
  var trustedReaderRootCertificates: [x5chain] { get }
  var userAuthenticationRequired: Bool { get }
  var logFileName: String { get }
  var documentsCategories: DocumentCategories { get }
  var transactionLogger: TransactionLogger { get }
  var revocationIntervalSeconds: TimeInterval { get }
  var documentIssuanceConfig: DocumentIssuanceConfig { get }
}
```

Each property must be reviewed.

## `EudiWalletConfiguration`

`WalletKitController` creates the wallet with:

```swift
EudiWalletConfiguration(
  serviceName: configLogic.keyChainConfig.documentStorageServiceName,
  accessGroup: configLogic.keyChainConfig.keychainAccessGroup,
  userAuthenticationRequired: walletKitConfig.userAuthenticationRequired,
  trustedReaderRootCertificates: walletKitConfig.trustedReaderRootCertificates,
  deviceAuthMethod: .deviceSignature,
  uiCulture: Locale.current.systemLanguageCode,
  logFileName: walletKitConfig.logFileName
)
```

Production meaning:

| Setting | Meaning | Production guidance |
| --- | --- | --- |
| `serviceName` | Keychain service name used by WalletKit storage. | Must be stable across app updates and match extension access needs. |
| `accessGroup` | Keychain access group. | Must match signed entitlements and extension sharing requirements. |
| `userAuthenticationRequired` | Whether WalletKit secure storage requires local user authentication. | For high-assurance credentials, strongly consider `true`; test all issuance, presentation, extension, and background behavior. |
| `trustedReaderRootCertificates` | Trust anchors for proximity reader authentication and supported verification flows. | Replace demo anchors with production trust anchors only. |
| `deviceAuthMethod` | Device authentication method used by WalletKit. | Current value is `.deviceSignature`; confirm with WalletKit and assurance policy. |
| `uiCulture` | Locale passed to WalletKit. | Confirm supported locales and fallback behavior. |
| `logFileName` | WalletKit log file name. | Disable or heavily redact production logs unless support policy requires a controlled log export. |

### User Authentication For WalletKit Storage

Current code:

```swift
var userAuthenticationRequired: Bool {
  false
}
```

Production decision:

* `false` relies on app-level PIN/biometric flows and Keychain/App Sandbox protections.
* `true` can bind WalletKit storage access to platform local authentication, but it must be tested
  with all flows, including extension access, reissuance, revocation checks, and background behavior.

Recommended production process:

1. Decide which actions require local authentication:
   * App unlock.
   * PID issuance.
   * Credential presentation.
   * RQES signing.
   * Export or support log creation.
   * Document deletion or wallet reset.
2. Test WalletKit behavior with `userAuthenticationRequired = true`.
3. Decide fallback behavior for devices without biometrics or passcode.
4. Document the UX and support impact.

## OpenID4VP Configuration

Current code:

```swift
var vpConfig: OpenId4VpConfiguration {
  .init(
    clientIdSchemes: [.x509SanDns, .x509Hash],
    allowPresentingPartialClaims: true
  )
}
```

Production meaning:

| Setting | Meaning | What to put in production |
| --- | --- | --- |
| `.x509SanDns` | Verifier client identity is bound to a DNS name in an X.509 certificate. | Use when verifier certificates and trust anchors are managed and audited. |
| `.x509Hash` | Verifier identity is bound to a certificate hash. | Use when the verifier ecosystem requires hash-based certificate binding. |
| `.preregistered` | Verifiers are explicitly configured in the wallet. | Use for closed pilots or controlled ecosystems. Add production verifier API URL, legal name, and client ID. |
| `allowPresentingPartialClaims` | Whether the wallet can present a subset of requested claims. | Align with legal, UX, and relying-party policy. |

If using preregistered verifiers, add the relevant import and production entries:

```swift
import SiopOpenID4VP

var vpConfig: OpenId4VpConfiguration {
  .init(
    clientIdSchemes: [
      .x509SanDns,
      .x509Hash,
      .preregistered(
        [
          PreregisteredClient(
            clientId: "my-production-verifier-client-id",
            verifierApiUri: "https://verifier.example.eu",
            verifierLegalName: "Example Member State Verifier"
          )
        ]
      )
    ],
    allowPresentingPartialClaims: true
  )
}
```

Rules:

* `verifierApiUri` must be HTTPS.
* `verifierLegalName` must be the official entity name shown to users.
* `clientId` must match verifier registration and protocol profile.
* Do not include development verifier URLs in production.
* If a verifier is not trusted, the user interface must clearly show that status before disclosure.

## Digital Credentials API And Identity Document Provider

The iOS project includes an Identity Document Provider extension under:

```text
EudiReferenceWalletIDProvider
```

The extension allows supported iOS versions to surface the app as a provider for mobile document
web presentment through Apple's Identity Document Services APIs.

Production tasks:

* Confirm entitlement approval for Digital Credentials API / Mobile Document Provider.
* Confirm the main app and extension provisioning profiles contain the required entitlements.
* Confirm App Group and Keychain Sharing values match for the main app and extension.
* Confirm only production-supported document types are listed in `EudiWallet.entitlements`.
* Confirm registration and deregistration behavior for active, expired, revoked, and deleted
  documents.
* Confirm the extension authorization UI clearly shows requester identity, requested attributes,
  purpose, and user decision.

Current registration behavior:

* `WalletKitController` registers documents through `DocumentRegistrationManager`.
* Registration is only attempted on iOS versions where the API is available.
* Only CBOR documents are registered (`document.docDataFormat == .cbor`).

Production validation:

* Install the signed production build on a supported iOS version.
* Issue a supported CBOR document.
* Confirm the document is registered with the system.
* Trigger a web presentment request.
* Confirm the extension appears and can authorize or deny the request.
* Delete or revoke the document and confirm registration is removed or no longer usable.

## Reader Trust Store

Current code loads DER certificates by resource name:

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

Production guidance:

* Remove demo and staging trust anchors that are not part of the production trust framework.
* Add only production IACA, reader root, verifier, or scheme certificates approved for launch.
* Use clear file names, for example `ms_iaca_2026.der`.
* Document certificate owner, fingerprint, serial number, validity period, source, and rotation plan.
* Add tests or CI checks that production builds include expected anchors and exclude demo anchors.

Certificate governance:

* Store public trust anchors in version control only if policy allows it.
* Do not store private keys in the app repository.
* Define rotation before expiry.
* Define emergency distrust and app update procedures.

## Issuer Configuration: `issuersConfig`

Current demo code contains issuer URLs such as:

```swift
credentialIssuerURL: "https://issuer.eudiw.dev"
credentialIssuerURL: "https://issuer-backend.eudiw.dev"
credentialIssuerURL: "https://ec.dev.issuer.eudiw.dev"
credentialIssuerURL: "https://dev.issuer-backend.eudiw.dev"
```

Production values must point to your production OpenID4VCI issuers.

Example production shape:

```swift
case .PROD:
  return [
    .init(
      config: .init(
        credentialIssuerURL: "https://issuer.pid.example.eu",
        clientId: "wallet-prod",
        keyAttestationsConfig: .init(walletAttestationsProvider: walletKitAttestationProvider),
        authFlowRedirectionURI: URL(string: "eu.example.wallet://authorization")!,
        requirePAR: true,
        requireDpop: true,
        cacheIssuerMetadata: true
      ),
      order: 0
    )
  ]
```

| Field | Meaning | Production value |
| --- | --- | --- |
| `credentialIssuerURL` | Base URL of an OpenID4VCI credential issuer. | Your production issuer base URL. It must expose valid issuer and authorization metadata. |
| `clientId` | Wallet client identifier known to the issuer or authorization server. | Use the registered production wallet client ID. |
| `keyAttestationsConfig` | Wallet/key attestation provider used during issuance. | Use the production wallet attestation provider. |
| `authFlowRedirectionURI` | Redirect URI used after authorization. | Must match production URL scheme registration and issuer client registration. |
| `requirePAR` | Whether pushed authorization requests are required. | Prefer `true` where the production profile requires PAR. |
| `requireDpop` | Whether DPoP is required. | Prefer `true` where the production profile requires sender-constrained tokens. |
| `cacheIssuerMetadata` | Whether issuer metadata is cached. | Enable only with a metadata refresh and incident strategy. |
| `order` | Display/order preference for scoped issuance. | Use deterministic ordering approved by product owners. |

Rules:

* Use HTTPS.
* Do not include demo issuers in production.
* Do not point production wallets to development or staging issuers.
* Confirm issuer metadata contains only production credential configurations.
* Confirm issuer credential signing keys, status endpoints, and trust chains are production keys.
* Confirm issuer and wallet agree on redirect URI, client ID, PAR, DPoP, and attestation policy.

## Wallet Provider Attestation

Current code:

```swift
var walletProviderAttestationUrl: String {
  switch configLogic.appBuildVariant {
  case .DEMO:
    "https://wallet-provider.eudiw.dev"
  case .DEV:
    "https://dev.wallet-provider.eudiw.dev"
  }
}
```

Production value:

```swift
case .PROD:
  "https://wallet-provider.example.eu"
```

Production requirements:

* Host must be HTTPS.
* Host must be controlled or formally approved by the wallet provider.
* Backend must validate wallet instance, key attestation, nonce freshness, replay protection, app
  version, and app integrity signals.
* Availability must match issuance availability because issuance can depend on wallet attestation.
* Monitoring and incident response must cover attestation endpoints.

## Document Issuance Rules

Current code configures:

* Default credential policy: `.rotateUse`, `numberOfCredentials: 1`.
* PID document-specific policy: `.oneTimeUse`.
* Current Demo PID batch size: `10`.
* Current Dev PID batch size: `60`.
* Reissuance rule:
  * `minNumberOfCredentials: 2`
  * `minExpirationHours: 14`
  * `backgroundIntervalSeconds: 300`

Production decisions:

| Decision | Guidance |
| --- | --- |
| Credential policy | Align with issuer policy, privacy goals, and verifier ecosystem. |
| Batch size | Use the smallest value that supports expected offline or high-availability needs. |
| Reissuance threshold | Choose values that avoid user disruption without excessive unused credential material. |
| Background behavior | Confirm iOS background execution constraints and user consent. |
| Failure handling | Store failed reissuance cases without leaking sensitive document data. |

Add a `.PROD` branch in `documentIssuanceConfig` and document why each value was chosen.

## Document Categories

Document categories are configured in:

```text
Modules/logic-core/Sources/Config/WalletKitConfig.swift
```

Production tasks:

* Keep only document types supported by production issuers and policy.
* Confirm category names with UX and localization teams.
* Confirm unsupported or experimental document types do not appear in production.
* Confirm document type identifiers match issuer metadata exactly.

## Revocation And Status Checking

Current code:

```swift
var revocationIntervalSeconds: TimeInterval {
  300
}
```

Production decisions:

* Confirm which credentials have status or revocation endpoints.
* Confirm how often status should be refreshed.
* Avoid excessive polling that creates privacy, cost, or availability issues.
* Define behavior when status endpoints are unavailable.
* Define UX for revoked, suspended, expired, or unknown-status documents.
* Include revocation and status checking in test plans.

## RQES Configuration

Current code configures RQES in:

```text
Modules/logic-business/Sources/Config/RQESConfig.swift
```

Current demo/dev values include:

* RSSP/CSC endpoint.
* TSA URL.
* OAuth client ID.
* Sample client secret.
* Redirect URI: `rqes://oauth/callback`.
* Hash algorithm: `.SHA256`.
* `includeRevocationInfo: false`.
* `printLogs` enabled for debug builds.

Production example:

```swift
case .PROD:
  [
    .init(
      name: "Production QTSP",
      rsspId: "https://qtsp.example.eu/csc/v2",
      tsaUrl: "https://tsa.example.eu/qualified",
      clientId: "wallet-prod-rqes",
      clientSecret: "",
      authFlowRedirectionURI: "eu.example.wallet.rqes://oauth/callback",
      hashAlgorithm: .SHA256,
      includeRevocationInfo: true
    )
  ]
```

Production rules:

* Do not hardcode production client secrets in the app.
* If the QTSP requires confidential-client behavior, place secret-bearing operations on a backend.
* Register production redirect URIs with the QTSP/authorization server.
* Use a production-specific URI scheme.
* Confirm `includeRevocationInfo` with the signing policy and QTSP.
* Disable verbose logs in production.
* Test success, cancellation, network failure, expired authorization, and rejected signing flows.

## ConfigLogic

`ConfigLogic` exposes production-significant behavior:

```swift
public protocol ConfigLogic: Sendable {
  var appBuildType: AppBuildType { get }
  var appBuildVariant: AppBuildVariant { get }
  var appVersion: String { get }
  var rqesConfig: EudiRQESUiConfig { get }
  var changelogUrl: URL? { get }
  var forcePidActivation: Bool { get }
  var keyChainConfig: KeyChainConfig { get }
}
```

Production decisions:

| Property | Production guidance |
| --- | --- |
| `appBuildType` | Must resolve to `RELEASE` for production archives. |
| `appBuildVariant` | Must resolve to `PROD` after adding production configuration. |
| `appVersion` | Must match release evidence and App Store Connect version. |
| `rqesConfig` | Must return production QTSP values. |
| `changelogUrl` | Must be an HTTPS user-facing production URL or nil if not supported. |
| `forcePidActivation` | Decide whether wallet functionality requires PID issuance before other actions. Current value is `false`. |
| `keyChainConfig` | Must resolve stable, signed, production Keychain service and access group values. |

## Deep Links And Redirect URIs

The app currently registers these schemes in `Wallet/Wallet.plist`:

```xml
<string>eudi-openid4vp</string>
<string>mdoc-openid4vp</string>
<string>openid4vp</string>
<string>haip-vp</string>
<string>openid-credential-offer</string>
<string>haip-vci</string>
<string>rqes</string>
```

Production guidance:

* Use production-specific custom schemes where allowed, for example `eu.example.wallet`.
* Keep only schemes required by supported production protocols.
* Register redirect URIs with issuers, verifiers, and QTSPs exactly.
* Avoid generic schemes where they increase collision or hijacking risk.
* Validate scheme, path, host, query parameters, request objects, and expected flow type.
* Reject malformed, oversized, unexpected, or cross-flow URLs.
* Threat-model same-device flows, QR flows, browser redirects, and extension flows.

Files to review:

* `Wallet/Wallet.plist`
* `Modules/logic-ui/Sources/Controller/DeepLinkController.swift`
* `Modules/logic-ui/Sources/Extension/DeepLink+Extensions.swift`
* Issuance and presentation interactors that consume parsed deep links.

## Entitlements, Plist Values, And Permissions

Production review areas:

| Area | Current location | Production guidance |
| --- | --- | --- |
| Camera usage description | Xcode build settings `INFOPLIST_KEY_NSCameraUsageDescription` | Explain QR scanning in user-facing, localized text. |
| Bluetooth usage description | Xcode build settings `INFOPLIST_KEY_NSBluetoothAlwaysUsageDescription` | Explain proximity presentation in user-facing, localized text. |
| Face ID usage description | Xcode build settings `INFOPLIST_KEY_NSFaceIDUsageDescription` | Explain biometric unlock or credential access in user-facing, localized text. |
| App Groups | Main and extension entitlements | Use production group IDs and profiles. |
| Keychain groups | Main and extension entitlements | Confirm the runtime access group matches app and extension needs. |
| Mobile document types | Main app entitlements | Include only production-supported document types. |
| Encryption export flag | `ITSAppUsesNonExemptEncryption` in `Wallet.plist` | Confirm with legal/export compliance. Do not assume the sample value applies. |
| Privacy manifest | `PrivacyInfo.xcprivacy` | Add and audit privacy manifests for required-reason APIs, tracking domains, data collection, and SDK declarations. |

Privacy manifest note:

Apple requires apps and SDKs that use covered required-reason APIs to declare approved reasons in a
privacy manifest. Treat the manifest as a production release input: review direct app code, the
Identity Document Provider extension, WalletKit/RQES/analytics SDKs, and third-party dependencies
before App Store submission, and keep declarations aligned with App Store privacy labels.

## Network Security

The app uses `URLSession.shared` through:

```text
Modules/logic-api/Sources/Provider/NetworkSessionProvider.swift
```

iOS App Transport Security applies to `URLSession` connections by default. Production must keep TLS
validation strict.

Production rules:

* Use HTTPS for issuers, verifiers, wallet provider, QTSP, TSA, changelog, and analytics endpoints.
* Do not add trust-all `URLSessionDelegate` logic to production.
* Do not disable ATS globally.
* Avoid broad `NSExceptionDomains`; any exception must be documented, justified, and time-bounded.
* Decide whether certificate pinning is required by policy.
* If pinning is used, define backup pins and rotation procedures.
* Do not log full URLs with authorization codes, credential offers, tokens, request objects, or PII.

## Local Development With Self-Signed Certificates

The build and configuration docs describe temporary self-signed certificate handling for local
development.

Production warning:

* Self-signed or trust-all delegates must not exist in production source, configuration, or builds.
* CI should fail if production builds contain `SelfSignedDelegate`, `useCredential` trust bypasses,
  or code that accepts arbitrary `serverTrust`.

## Storage And Local Data Protection

Production storage includes:

* WalletKit secure storage.
* Keychain values.
* PIN hash, salt, and iteration count.
* SwiftData local store.
* UserDefaults values.
* App Group container data.
* WalletKit log file.
* Transaction and revoked document records.

### Keychain

Current Keychain controller:

```swift
keyChain = Keychain(
  service: service,
  accessGroup: accessGroup
)
.accessibility(.whenUnlocked)
```

Biometric validation key:

```swift
.accessibility(
  .whenPasscodeSetThisDeviceOnly,
  authenticationPolicy: [.biometryAny]
)
```

Production decisions:

* Confirm the default Keychain accessibility class.
* Consider `ThisDeviceOnly` classes where migration/backup is not allowed.
* Confirm whether Keychain items should survive device restore.
* Confirm behavior when the device passcode is removed.
* Confirm behavior when biometric enrollment changes.
* Confirm app and extension Keychain sharing.

### PIN Storage

Current PIN storage uses:

* Random 32-byte salt from `SecRandomCopyBytes`.
* PBKDF2-HMAC-SHA256.
* 210,000 iterations.
* 32-byte derived key.
* Constant-time comparison.
* Keychain storage for salt, hash, and iteration count.

Production tasks:

* Confirm PIN length, complexity, and retry UX.
* Add failed attempt rate limiting or lockout according to policy.
* Consider server-side risk signals for repeated failures.
* Avoid logging PIN validation results beyond coarse categories.
* Include PIN setup, change, lockout, and recovery in test plans.

### SwiftData Store

Current local storage uses SwiftData and chooses the App Group container when available:

```swift
return "group.\(mainBundleID)"
```

Production tasks:

* Confirm which data is stored in SwiftData.
* Confirm whether the store is in the shared App Group container.
* Apply file protection where required.
* Exclude sensitive files from backup if policy requires it.
* Define migration behavior before release.
* Test upgrade from previous production builds.
* Test extension access to shared data.

### UserDefaults

Current preferences include:

* `biometryEnabled`
* `cachedDeepLink`
* `runAtLeastOnce`
* `language`

Production rules:

* Do not store tokens, credential payloads, PID attributes, private keys, or secrets in UserDefaults.
* Treat cached deep links as sensitive if they may contain request details.
* Clear transient values after use.

## Logging And Audit

Logging appears in several areas:

* WalletKit log file through `logFileName`.
* Transaction logging through `TransactionLogger`.
* Analytics providers through `logic-analytics`.
* Debug logs from SDKs where enabled.
* RQES `printLogs`.

Production rules:

* Disable verbose logs in Release Prod.
* Redact or avoid PID, credential payloads, verifier request objects, tokens, authorization codes,
  signatures, keys, document numbers, dates of birth, addresses, and user decisions.
* Do not expose logs through support flows unless the user consents and redaction is enforced.
* Define retention, access control, export, deletion, and incident handling for logs.

Useful production event categories:

* `issuance_started`
* `issuance_completed`
* `issuance_failed`, with coarse error category.
* `presentation_started`
* `presentation_completed`
* `presentation_cancelled`
* `revocation_status_refresh_failed`, with coarse cause.
* `rqes_signing_started`
* `rqes_signing_completed`
* `rqes_signing_failed`, with coarse cause.

Avoid:

* Full URLs containing query parameters.
* Raw exception messages from protocol libraries if they may include payloads.
* User names, birth dates, addresses, document numbers, or credential claims.

## Screenshots, Screen Recording, And Sensitive UI

iOS does not provide a universal way to block screenshots. Production should still reduce leakage.

Review screens that show:

* PID attributes.
* mDL attributes.
* Presentation request details.
* QR codes.
* Transaction history.
* RQES signing details.
* Error details from backend responses.

Production actions:

* Observe screen capture state where useful.
* Hide or blur highly sensitive content when the app enters background.
* Ensure the app switcher snapshot does not expose sensitive data.
* Avoid putting secrets or full credential data in notifications.
* Avoid copying sensitive values to the clipboard.
* Add manual tests for screenshots, app switching, screen recording, and AirPlay/mirroring behavior.

## Authentication And Biometrics

The app supports PIN and system biometrics.

Production decisions:

| Area | Guidance |
| --- | --- |
| PIN length | Define minimum length and whether numeric-only is acceptable. |
| PIN retry policy | Add lockout/rate limiting for repeated failures. |
| Biometric opt-in | Decide whether biometrics are optional or required for specific operations. |
| Device credential fallback | Decide whether passcode fallback is allowed. |
| Biometric enrollment change | Test and define whether access is invalidated when biometrics change. |
| High-risk operation step-up | Require re-authentication before issuance, presentation, RQES signing, reset, or document deletion where policy requires it. |
| Recovery | Define user-facing recovery and reset policy. |

## Analytics And Telemetry

The project includes an analytics abstraction but no production analytics provider by default.

Production rules:

* Do not collect PID, credential claims, document identifiers, verifier payloads, tokens, or precise
  user decisions.
* Use coarse operational events.
* Obtain consent where required.
* Make analytics optional where policy requires it.
* Document retention, processors, cross-border transfers, and user rights.
* Ensure analytics SDKs are included in the privacy manifest and App Store privacy labels.

## App Attest, DeviceCheck, And App Hardening

Runtime Application Self-Protection is needed because iOS apps can be extracted, patched,
re-signed, instrumented, and run on compromised devices.

Hardening does not make the app impossible to attack. It increases cost, improves detection, and
gives the backend risk signals.

Use one of the following hardening paths, or a layered combination.

## Hardening Path A: Apple App Attest And DeviceCheck

Apple's closest equivalent to a platform app integrity signal is App Attest, part of DeviceCheck.
Use this path if the production wallet can rely on Apple platform services and backend verification.

App Attest can help your backend determine whether requests come from a legitimate instance of your
app. The app generates a key, Apple attests to that key, and the backend later verifies assertions
signed by that key for sensitive actions.

Recommended architecture:

```text
iOS app
  -> requests backend challenge for a high-risk action
  -> creates App Attest assertion over the challenge and action data
  -> sends assertion, key identifier, app version, and action context to backend
Backend
  -> validates key registration and assertion
  -> validates bundle ID, team ID, nonce/challenge, timestamp, and replay state
  -> applies risk policy
  -> returns allow, step-up, limited mode, or deny
```

Do not make final trust decisions only on the device. Verify App Attest attestations and assertions
server-side.

When to require an App Attest assertion:

* Wallet activation.
* PID issuance.
* High-risk credential issuance.
* Credential presentation to remote verifiers.
* RQES enrollment or signing.
* Recovery/reset operations.
* Suspicious behavior, for example repeated PIN failures.

Minimum backend checks:

* Challenge/nonce matches the action and has not been reused.
* Bundle identifier matches production.
* Team identifier matches production.
* App version is allowed.
* Assertion is fresh.
* Key identifier is registered for the wallet instance or user session.
* Request is bound to the authenticated user/session where applicable.
* Action data hash matches what the backend expected.

DeviceCheck can provide additional device-level state signals, but it is not a complete device
compromise detector. Use it as part of a risk model.

Policy examples:

| Verdict or validation outcome | Suggested action |
| --- | --- |
| Valid App Attest assertion for expected app and action | Continue. |
| Missing assertion for high-risk action | Require update, step-up, or block according to policy. |
| Invalid assertion or replay | Block high-risk action and log security event. |
| Unsupported device or unavailable Apple service | Apply documented fallback, limited mode, or retry policy. |
| Repeated integrity failures | Suspend high-risk operations and require support or reinstall. |

Important limitations:

* App Attest does not prove that the OS is uncompromised.
* App Attest availability and behavior must be tested across supported devices and iOS versions.
* Backend design is required; device-only checks are insufficient for high assurance.

## Hardening Path B: Commercial iOS Protection

Use this path when you need stronger code hardening and runtime protection than standard release
build settings.

Commercial iOS application protection products can provide:

* Swift and Objective-C symbol obfuscation.
* String and resource encryption.
* Control-flow obfuscation.
* Anti-tamper and re-signing detection.
* Anti-debugging.
* Jailbreak and system compromise signals.
* Hooking and instrumentation detection.
* RASP callbacks distributed throughout the app.

Recommended use:

* Protect release builds only.
* Protect protocol, attestation, storage, RASP, and anti-tamper code paths.
* Protect constants that reveal backend behavior, while assuming URLs are still discoverable.
* Integrate RASP responses with backend risk policy.
* Keep symbolication artifacts and mapping files outside the repo.
* Test accessibility, performance, startup time, crash reporting, and battery after hardening.
* Test WalletKit, RQES, SPM packages, Swift concurrency, and the app extension after hardening.

Commercial hardening checklist:

* Enable name obfuscation where compatible with Swift, reflection, and SDKs.
* Enable string encryption for sensitive constants.
* Enable resource protection where supported.
* Enable tamper/re-signing detection.
* Enable debugger detection.
* Enable jailbreak and emulator/simulator policy checks.
* Enable hook/framework detection.
* Enable callback integration with backend risk enforcement.
* Keep dSYM and mapping files secure.
* Run full functional and security regression tests on protected artifacts.

Do not rely on a commercial tool alone. Pair it with:

* Server-side App Attest.
* Secure storage.
* Strong authentication.
* Secure network policy.
* MASVS testing.

## Hardening Path C: Manual RASP Controls

Use this path when App Attest is not sufficient by itself or when commercial tooling is not
available.

Manual controls are easier to bypass than mature commercial hardening. Implement them as layered
signals, obfuscate them, and enforce high-risk outcomes on the backend where possible.

### Manual Control 1: Bundle Metadata And Signing Identity Signals

At runtime, you can compare bundle metadata with expected production values, but do not treat
`Info.plist` values as proof of signing identity. A re-signed or modified app can alter bundle
metadata.

Example metadata-only shape:

```swift
struct AppMetadataSignal {
  static func hasExpectedBundleIdentifier() -> Bool {
    let expectedBundleID = "eu.example.wallet"

    return Bundle.main.bundleIdentifier == expectedBundleID
  }
}
```

If you add local code-signing or entitlement inspection, implement it with platform security APIs and
treat the result as advisory. The authoritative identity control should be server-side App Attest
validation that checks the production bundle identifier, team identifier, environment, nonce,
timestamp, and replay state.

Production rules:

* Treat bundle metadata checks as weak local signals.
* Also validate app identity server-side through App Attest.
* Do not read a custom `Team ID` `Info.plist` key as signing proof.
* Obfuscate expected values if used locally.
* Treat failure as high risk for issuance, presentation, and signing.

### Manual Control 2: Debugger Detection

Example shape:

```swift
import Darwin

func isDebuggerAttached() -> Bool {
  var info = kinfo_proc()
  var mib = [CTL_KERN, KERN_PROC, KERN_PROC_PID, getpid()]
  var size = MemoryLayout<kinfo_proc>.stride

  let result = sysctl(&mib, u_int(mib.count), &info, &size, nil, 0)
  guard result == 0 else { return false }

  return (info.kp_proc.p_flag & P_TRACED) != 0
}
```

Use it as a signal. Do not put all protection behind one obvious branch.

### Manual Control 3: Jailbreak And System Compromise Signals

Signals can include:

* Known jailbreak file paths.
* Writable system paths.
* Ability to open known package manager URL schemes.
* Suspicious dynamic libraries.
* Unexpected sandbox escape behavior.

Example shape:

```swift
func hasSuspiciousFiles() -> Bool {
  let paths = [
    "/Applications/Cydia.app",
    "/Library/MobileSubstrate/MobileSubstrate.dylib",
    "/bin/bash",
    "/usr/sbin/sshd",
    "/etc/apt"
  ]
  return paths.contains { FileManager.default.fileExists(atPath: $0) }
}
```

Rules:

* Expect bypasses.
* Avoid collecting excessive device data.
* Combine weak signals into a risk score.
* Make policy decisions transparent enough for public-sector accountability.

### Manual Control 4: Simulator And Test Environment Policy

Production builds should define whether simulator execution is allowed.

Example shape:

```swift
func isSimulator() -> Bool {
#if targetEnvironment(simulator)
  return true
#else
  return false
#endif
}
```

For public production apps, simulator checks are mainly useful as a release sanity check and risk
signal. Do not rely on them as a strong control.

### Manual Control 5: Hooking And Instrumentation Detection

Signals can include:

* Loaded libraries with suspicious names.
* Frida-related ports or process artifacts.
* Unexpected writable/executable memory mappings.
* Known hooking framework traces.

Treat as high-risk for signing, issuance, and presentation.

### Manual Control 6: Anti-Tamper Backend Binding

For high-risk operations, send a signed or App Attest-backed risk envelope to your backend:

```json
{
  "appVersion": "2026.05.1",
  "bundleId": "eu.example.wallet",
  "teamId": "ABCDE12345",
  "deviceRisk": "LOW",
  "debugger": false,
  "jailbreakSignals": [],
  "nonce": "server-issued-nonce",
  "timestamp": "2026-05-08T10:00:00Z"
}
```

The backend should:

* Issue nonces.
* Reject replays.
* Bind the risk envelope to the user session and action.
* Treat device-side claims as hints unless backed by App Attest or another trusted signal.

### Manual Control 7: Release Build Hygiene

Production rules:

* Build with release optimization.
* Do not ship debug menus or debug endpoints.
* Strip unnecessary symbols.
* Store dSYM files securely for crash analysis.
* Disable verbose logs.
* Ensure the app is not signed with development profiles.
* Ensure production app and extension are signed by the expected Team ID.

## OWASP MASVS Production Alignment

OWASP MASVS v2 is organized by control groups. Use MASVS together with MASTG, MASWE, and the OWASP
MAS Checklist to define your test profile and evidence.

Official references:

* https://mas.owasp.org/MASVS/
* https://mas.owasp.org/MASTG/

### MASVS-STORAGE

Controls to evidence:

* Sensitive data is stored only in app-private storage, Keychain, or approved App Group containers.
* Wallet documents and local database data are protected at rest.
* PIN hashes are salted and derived with PBKDF2.
* Keychain accessibility classes match policy.
* Backups do not include sensitive data unless explicitly approved.
* Logs do not contain sensitive data.
* Temporary files are removed.
* Clipboard is not used for secrets.
* App switcher snapshots and screen capture do not expose sensitive screens.

Project-specific actions:

* Review WalletKit storage and Keychain configuration.
* Review SwiftData store location and file protection.
* Review App Group container contents.
* Add PIN lockout or rate limiting.
* Redact or remove file logging.
* Add tests that inspect app data after flows.

### MASVS-CRYPTO

Controls to evidence:

* Approved algorithms are used.
* Random values use secure randomness.
* Keychain and Secure Enclave capabilities are used where appropriate.
* Keys are invalidated or rotated according to policy.
* No hardcoded cryptographic keys are used.
* Credential signing algorithms match the trust framework.

Project-specific actions:

* Review WalletKit cryptographic defaults.
* Review `userAuthenticationRequired`.
* Review PIN PBKDF2 parameters.
* Review RQES hash algorithm and signing policy.
* Confirm no production private keys or secrets exist in app code.

### MASVS-AUTH

Controls to evidence:

* Local authentication is required for sensitive operations.
* PIN storage is resistant to offline attack.
* Failed authentication is rate-limited.
* Biometric authentication is correctly bound and invalidated according to policy.
* Server-side authorization is enforced for network operations.

Project-specific actions:

* Add PIN attempt lockout.
* Decide device credential fallback policy.
* Consider WalletKit user authentication requirements.
* Test biometric enrollment changes.
* Test authentication bypass attempts.

### MASVS-NETWORK

Controls to evidence:

* TLS validation is strict.
* ATS is enforced.
* No trust-all certificate delegate is present.
* Sensitive data is not logged in network logs.
* Certificate pinning is used where justified.
* Backend APIs authenticate and authorize requests.

Project-specific actions:

* Remove self-signed development code from production.
* Pin production wallet-provider or issuer endpoints if policy requires it.
* Verify issuer, verifier, QTSP, and TSA TLS with automated tests.
* Check production app for demo hostnames.

### MASVS-PLATFORM

Controls to evidence:

* Deep links are validated.
* App extension communication is scoped and protected.
* Entitlements are minimal and correct.
* Permissions are minimal and runtime-scoped.
* WebViews are hardened where used.
* Clipboard, screenshots, notifications, and app switcher snapshots do not leak sensitive data.

Project-specific actions:

* Threat-model inbound URLs.
* Tighten scheme handling.
* Review App Groups and Keychain Sharing.
* Review Identity Document Provider extension authorization UI.
* Request camera, Bluetooth, and Face ID permissions only for relevant flows.

### MASVS-CODE

Controls to evidence:

* Dependencies are current and pinned.
* SCA is run.
* Unsafe dynamic loading is absent.
* Debug code is absent in release.
* Error handling avoids sensitive disclosure.
* App targets a supported platform version.
* Update enforcement exists where policy requires it.

Project-specific actions:

* Run Dependency Check or equivalent SCA and generate an SBOM.
* Add release checks for demo endpoints.
* Review exception messages shown to users.
* Implement forced update or minimum supported version through backend policy.
* Review branch-based SPM dependencies.

### MASVS-RESILIENCE

Controls to evidence:

* App integrity is checked.
* Runtime tampering is detected.
* Debugging, jailbreak, simulator, and hooking signals are handled.
* Official distribution channel and signing identity are verified.
* Hardening controls are tested and connected to backend policy.

Project-specific actions:

* Use App Attest/DeviceCheck, commercial protection, or manual RASP controls.
* Verify release signing and entitlements.
* Store symbolication artifacts securely.
* Add backend risk enforcement for high-risk actions.

### MASVS-PRIVACY

Controls to evidence:

* Data minimization is applied.
* User consent is clear before disclosure.
* Analytics avoids personal data.
* Retention is defined.
* Logs and transaction history are privacy-reviewed.
* Permissions are justified.
* Privacy notice, privacy manifest, and App Store privacy labels are accurate.

Project-specific actions:

* Review presentation request UI for clarity.
* Review transaction log contents.
* Review analytics providers and SDK privacy manifests.
* Complete DPIA before production.
* Verify App Store privacy declarations.

## Production Backend Requirements

The mobile app cannot go live alone. The following services must be production ready.

### Issuer

Must provide:

* OpenID4VCI metadata.
* Authorization server metadata.
* Production credential configurations.
* Credential signing keys and certificate chains.
* Wallet/client attestation validation.
* PAR and DPoP behavior according to profile.
* Credential status/revocation support.
* Rate limits and fraud controls.
* Audit logs.
* Incident and key rotation processes.

### Verifier

Must provide:

* OpenID4VP request creation.
* Client identity through X.509, preregistration, or another approved scheme.
* Request signing where required.
* Redirect handling.
* Data minimization by request.
* Trust framework integration.
* User-facing legal name and purpose.

### Wallet Provider

Must provide:

* Wallet instance attestation.
* Wallet unit/key attestation.
* App/device risk policy.
* App Attest verification where used.
* Nonce and replay protection.
* Availability aligned with issuance.
* Monitoring and abuse controls.

### QTSP/RQES

Must provide:

* Production CSC endpoint.
* OAuth/OIDC client registration.
* Redirect URI registration.
* TSA endpoint if required.
* Certificate retrieval trust config.
* Signing policy and audit evidence.

## Build, Install, And Use In Production Testing

### Build

For existing demo release:

```bash
xcodebuild \
  -project EudiReferenceWallet.xcodeproj \
  -scheme "EUDI Wallet Demo" \
  -configuration "Release Demo" \
  -destination "generic/platform=iOS" \
  clean build
```

For recommended production scheme:

```bash
xcodebuild \
  -project EudiReferenceWallet.xcodeproj \
  -scheme "EUDI Wallet Prod" \
  -configuration "Release Prod" \
  -destination "generic/platform=iOS" \
  clean build
```

### Archive

```bash
xcodebuild \
  -project EudiReferenceWallet.xcodeproj \
  -scheme "EUDI Wallet Prod" \
  -configuration "Release Prod" \
  -destination "generic/platform=iOS" \
  -archivePath build/EudiWalletProd.xcarchive \
  clean archive
```

### Export IPA

```bash
xcodebuild \
  -exportArchive \
  -archivePath build/EudiWalletProd.xcarchive \
  -exportPath build/export \
  -exportOptionsPlist ExportOptionsProd.plist
```

Production `ExportOptionsProd.plist` must map all bundle IDs to their production provisioning
profiles, including the extension.

### Test Core Flows

Before release candidate approval, test:

* First launch.
* PIN creation.
* PIN change.
* Incorrect PIN attempts and lockout.
* Biometric enablement.
* Biometric enrollment change.
* PID issuance from list.
* Credential offer issuance by QR.
* Authorization-code issuance redirect.
* Deferred issuance.
* Reissuance.
* Revocation/status checks.
* Same-device OpenID4VP presentation.
* Cross-device presentation.
* Proximity QR/BLE.
* Identity Document Provider extension presentment on supported iOS versions.
* RQES signing.
* RQES cancellation.
* Network unavailable.
* Backend unavailable.
* Expired credential.
* Revoked credential.
* Malformed deep links.
* Malicious credential offer.
* App update from previous production version.

## Production Test Matrix

Minimum device coverage:

| Category | Coverage |
| --- | --- |
| iOS versions | iOS 17 through current supported production version; include iOS versions required by Identity Document Provider APIs if used. |
| Devices | Multiple iPhone generations, Face ID devices, Touch ID devices if supported, devices without biometrics if allowed. |
| Secure hardware | Confirm Secure Enclave/Keychain behavior and passcode/no-passcode policy. |
| Biometric states | None enrolled, enrolled, enrollment changed, lockout, unavailable. |
| Network | Wi-Fi, cellular, captive portal, offline, TLS failure, proxy test environment. |
| Locale | All supported Member State languages. |
| Accessibility | VoiceOver, Dynamic Type, display zoom, reduced motion, contrast. |
| Permissions | Denied camera, denied Bluetooth, denied Face ID, later granted, later revoked. |
| Distribution | Fresh install, TestFlight install, App Store install, update, reinstall, restore attempt if applicable. |
| Extension | Main app and extension sharing, document registration, document deletion, app update. |
| Security | Debugger, jailbroken test device if available, simulator policy, re-signed app, instrumented app, proxy. |

## Release Evidence Package

For every production release, archive:

* Source commit hash.
* Version and build number.
* Build environment details.
* Xcode and Swift versions.
* Dependency lock or dependency report.
* SBOM.
* SCA report.
* Secret scan report.
* SAST report.
* SwiftLint or equivalent lint report.
* Unit and UI test reports.
* MASVS test report.
* Penetration test report or delta assessment.
* Signed IPA hash.
* App and extension entitlements.
* Provisioning profile UUIDs and expiration dates.
* Signing certificate fingerprint and Team ID.
* dSYM files stored securely.
* Privacy manifest and App Store privacy label review.
* Change log.
* Rollback and incident plan.

## Pre-Release Automated Checks

Add CI checks that fail if production artifacts contain demo values.

Search for:

```text
eudiw.dev
dev.wallet-provider
wallet-provider.eudiw.dev
issuer.eudiw.dev
issuer-backend.eudiw.dev
ec.dev.issuer.eudiw.dev
dev.issuer-backend.eudiw.dev
somesecret
somesecret2
localhost
127.0.0.1
SelfSignedDelegate
serverTrust
completionHandler(.useCredential
rqes://oauth/callback
eu.europa.ec.euidi.dev
```

Also check:

* Production scheme archives `Release Prod`.
* Production `BUILD_VARIANT` resolves to `PROD`.
* Main app and extension bundle IDs are production IDs.
* Main app and extension are signed by the expected Team ID.
* Production provisioning profiles are used.
* Production entitlements contain expected App Groups and Keychain groups.
* Production app does not contain debug-only endpoints.
* RQES production config does not contain hardcoded client secrets.
* App Attest or selected hardening path is enabled for high-risk backend operations.
* Required privacy manifest files and App Store privacy declarations are complete.

## Operational Readiness

Before going live, define:

* App support model.
* Backend monitoring dashboards.
* Wallet Provider SLA.
* Issuer SLA.
* QTSP SLA.
* Incident response contacts.
* Vulnerability disclosure process.
* Certificate expiry monitoring.
* Emergency app update process.
* Forced minimum-version process.
* Key compromise process.
* User communication templates.
* Data retention and deletion process.
* Backup and restore policy.
* Audit log access policy.
* App Store Connect roles and approval workflow.

## Incident Scenarios To Rehearse

Rehearse these before launch:

* Issuer signing key compromise.
* Wallet signing key compromise.
* Wallet Provider outage.
* QTSP outage.
* Production certificate expiry.
* Bad app release.
* RASP false positive affecting real users.
* App Attest service degradation or backend validation failure.
* Revocation/status service outage.
* Credential metadata mistake.
* Privacy incident from logs or analytics.
* App Group or Keychain access group misconfiguration.
* Vulnerability report requiring coordinated disclosure.

## User-Facing Production Behavior

Production UX must clearly explain:

* Why PIN is required.
* Why biometric authentication is optional or required.
* Why camera permission is needed.
* Why Bluetooth permission is needed for proximity.
* What data a verifier is requesting.
* Whether the verifier is trusted.
* What happens if a document is revoked or expired.
* What happens if app/device integrity checks fail.
* How users recover access.
* How users delete wallet data.
* How users get support.

Avoid technical error messages for users. Log coarse diagnostic categories separately after
redaction.

## Final Go-Live Gate

Do not publish until all of these are true:

* `Release Prod` exists and is the only production artifact.
* No demo URLs or demo secrets remain in production code/resources.
* Production signing is controlled and documented.
* Production app and extension entitlements are correct.
* Production trust anchors are installed and documented.
* Issuer, verifier, wallet provider, Identity Document Provider extension, and QTSP integrations
  pass end-to-end testing.
* MASVS assessment is complete with accepted residual risks.
* App Attest/hardening strategy is implemented and tested.
* Privacy and legal reviews are complete.
* Operational monitoring and incident response are ready.
* A rollback or emergency update path exists.

## Reference Links

* EUDI iOS WalletKit: https://github.com/eu-digital-identity-wallet/eudi-lib-ios-wallet-kit
* EUDI Architecture Reference Framework: https://github.com/eu-digital-identity-wallet/eudi-doc-architecture-and-reference-framework
* Apple DeviceCheck and App Attest: https://developer.apple.com/documentation/devicecheck
* Apple App Attest server validation: https://developer.apple.com/documentation/devicecheck/validating-apps-that-connect-to-your-server
* Apple Identity Document Provider registration: https://developer.apple.com/documentation/identitydocumentservices/identitydocumentproviderregistrationstore
* Apple Identity Document Provider extension: https://developer.apple.com/documentation/identitydocumentservicesui/identitydocumentprovider
* Apple privacy manifests and required reason APIs: https://developer.apple.com/documentation/bundleresources/describing-use-of-required-reason-api
* Apple URLSession and App Transport Security: https://developer.apple.com/documentation/foundation/urlsession
* Apple preparing apps for distribution: https://developer.apple.com/documentation/xcode/preparing-your-app-for-distribution
* OWASP MASVS: https://mas.owasp.org/MASVS/
* OWASP MASTG: https://mas.owasp.org/MASTG/
