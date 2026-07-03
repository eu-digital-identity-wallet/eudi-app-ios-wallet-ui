# EUDI iOS Wallet Go-Live Guide

This guide explains how an integrator, implementer, or Member State team can take this iOS
reference wallet and turn it into a production candidate.

It complements:

* [How to build](HOW_TO_BUILD.md)
* [How to configure the application](CONFIGURATION.md)
* [Theming and branding guide](THEMING.md)
* [Main README](../README.md)

The reference application is not production ready as delivered. It uses demo services, demo trust
anchors, broad custom-scheme deep links, source-level configuration, and security defaults that must
be reviewed for a high-assurance wallet. Treat this guide as a go-live work plan, not as a legal
certification or a replacement for a full security assessment.

## Table of contents

* [Audience](#audience)
* [Production Principle](#production-principle)
* [Out Of Scope](#out-of-scope)
* [Go-Live Checklist](#go-live-checklist)
* [Current Project Shape](#current-project-shape)
* [Source Of Truth Files](#source-of-truth-files)
* [Create A Production Scheme And Configuration](#create-a-production-scheme-and-configuration)
* [Application Identity](#application-identity)
* [Branding And Theme](#branding-and-theme)
* [Release Signing](#release-signing)
* [CI/CD Release Pipeline](#cicd-release-pipeline)
* [Dependency Governance](#dependency-governance)
* [WalletKitConfig Overview](#walletkitconfig-overview)
* [`EudiWalletConfiguration`](#eudiwalletconfiguration)
* [OpenID4VP Configuration](#openid4vp-configuration)
* [Digital Credentials API And Identity Document Provider](#digital-credentials-api-and-identity-document-provider)
* [Reader Trust Store](#reader-trust-store)
* [Issuer Configuration: `issuersConfig`](#issuer-configuration-issuersconfig)
* [Wallet Provider Attestation](#wallet-provider-attestation)
* [Document Issuance Rules](#document-issuance-rules)
* [Document Categories](#document-categories)
* [Revocation And Status Checking](#revocation-and-status-checking)
* [RQES Configuration](#rqes-configuration)
* [ConfigLogic](#configlogic)
* [Deep Links And Redirect URIs](#deep-links-and-redirect-uris)
* [Entitlements, Plist Values, And Permissions](#entitlements-plist-values-and-permissions)
* [Network Security](#network-security)
* [Local Development With Self-Signed Certificates](#local-development-with-self-signed-certificates)
* [Storage And Local Data Protection](#storage-and-local-data-protection)
* [Logging And Audit](#logging-and-audit)
* [Screenshots, Screen Recording, And Sensitive UI](#screenshots-screen-recording-and-sensitive-ui)
* [Authentication And Biometrics](#authentication-and-biometrics)
* [Analytics And Telemetry](#analytics-and-telemetry)
* [App Attest, DeviceCheck, And App Hardening](#app-attest-devicecheck-and-app-hardening)
* [Hardening Path A: Apple App Attest And DeviceCheck](#hardening-path-a-apple-app-attest-and-devicecheck)
* [Hardening Path B: Commercial iOS Protection](#hardening-path-b-commercial-ios-protection)
* [Hardening Path C: Manual RASP Controls](#hardening-path-c-manual-rasp-controls)
* [OWASP MASVS Production Alignment](#owasp-masvs-production-alignment)
* [Production Backend Requirements](#production-backend-requirements)
* [Build, Install, And Use In Production Testing](#build-install-and-use-in-production-testing)
* [Production Test Matrix](#production-test-matrix)
* [Release Evidence Package](#release-evidence-package)
* [Pre-Release Automated Checks](#pre-release-automated-checks)
* [Operational Readiness](#operational-readiness)
* [Incident Scenarios To Rehearse](#incident-scenarios-to-rehearse)
* [User-Facing Production Behavior](#user-facing-production-behavior)
* [Final Go-Live Gate](#final-go-live-gate)
* [Reference Links](#reference-links)

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

## Out Of Scope

This guide focuses on taking the iOS reference wallet application to a production-ready mobile
deployment posture. It does not define every backend, governance, or product decision around a
national wallet ecosystem.

The following items are out of scope and must be designed, implemented, assessed, and approved by
the Member State or wallet provider:

* Enrollment and identity proofing flows before PID issuance.
* Selfie capture, video capture, liveness detection, document scanning, face matching, registry
  lookup, or any equivalent national onboarding process.
* The integration contract between the wallet app, the issuer, and any identity-proofing or
  population-register backend.
* Legal certification, accreditation, conformity assessment, supervisory approval, and governance
  decisions.
* Full production implementation of issuer, verifier, wallet-provider, QTSP, or status-list backend
  services.
* Non-iOS form factors such as web wallets, browser extensions, Android apps, desktop apps, kiosk
  apps, or other native platforms.
* Migration from an existing national wallet product unless the implementer designs and tests that
  migration explicitly.

If the Member State requires selfie, video, remote identity proofing, in-person proofing, national
eID login, or another enrollment method, integrate that flow through the Member State onboarding and
issuer architecture. The app must only receive the production credential offer, authorization
redirect, or issuer-specific entry point after the enrollment policy has been satisfied.

## Go-Live Checklist

Use this checklist before the first production release.

| Area | Required production outcome |
| --- | --- |
| App identity | Final bundle identifier, app name, icon, Apple Developer team, App Store Connect app record, and distribution channel are defined. |
| Branding and theme | App name, app icon (every variant), in-app logos, light and dark color appearances, splash/launch screen, and any sub-SDK (RQES) theme are replaced with the production brand; no EUDI reference assets remain; text/background contrast meets accessibility targets. See [THEMING.md](THEMING.md). |
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
| Presentation relay risk | Relay attack risk is documented, verifier compensating controls are defined, and residual risk is accepted for each presentation scenario. |
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
| `logic-authentication` | PIN storage provider, PIN controller, biometric controller, PIN throttle/lockout, authentication configuration. |
| `logic-storage` | SwiftData storage for bookmarks, transactions, revoked documents, and failed reissuance data. |
| `logic-api` | `URLSession` provider and network request helpers. |
| `logic-analytics` | Optional analytics provider integration. |
| `logic-resources` | Strings, images, theme, localized resources. |
| `logic-ui` | Shared SwiftUI components, deep-link parsing, scanner, request UI. |
| `logic-assembly` | Dependency injection graph and app routing assembly. |
| `feature-*` | User-facing flows for startup, dashboard, issuance, presentation, proximity, and common features. |
| `logic-test` / `feature-test` | Shared test utilities, mock generation helpers, and test fixtures; not included in production targets. |
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
| `Modules/logic-authentication/Sources/Config/AuthenticationConfig.swift` | PIN lockout policy (max failed attempts, escalating lockout durations). |
| `Modules/logic-authentication/Sources/Storage/KeychainPinThrottleProvider.swift` | Keychain-persisted PIN failure counter, lockout level, lockout window timestamps; clock-rollback detection. |
| `Modules/logic-business/Sources/Controller/KeyChainController.swift` | Defines Keychain service, access group, accessibility class, and biometric Keychain validation. |
| `Modules/logic-storage/Sources/Config/StorageConfig.swift` | Defines SwiftData store location, App Group container selection, and local storage schema. |
| `Modules/logic-api/Sources/Provider/NetworkSessionProvider.swift` | Defines the shared network session used by app network calls. |
| `Modules/logic-analytics/Sources/Config/AnalyticsConfig.swift` | Defines analytics provider configuration. |
| `.github/workflows/*.yml` | Defines SAST, SCA, and secret scanning workflows. |
| `security/gitleaks/gitleaks.toml` | Defines local secret scanning rules. |
| `fastlane/Fastfile` | Defines iOS test, versioning, archive, upload, tag, and release lanes. |
| `Modules/logic-resources/Sources/Resources/Color.xcassets` | Brand color palette (light and dark appearances) and system/semantic color overrides. See [THEMING.md](THEMING.md). |
| `Modules/logic-resources/Sources/Resources/Images.xcassets` | In-app brand logos and illustrations used on the splash and headers. |
| `Wallet/Assets.xcassets` | Per-variant app icons (`AppIcon`, `AppIconDev`) and the global `AccentColor`. |

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

## Branding And Theme

The reference app ships with EUDI visual identity; a production wallet must replace it. App name and
app icon are covered under [Application Identity](#application-identity). The remaining theme and
branding surfaces are documented in **[THEMING.md](THEMING.md)**.

Surfaces to review before release:

| Surface | Where | Notes |
| --- | --- | --- |
| Color palette (light and dark) | `Modules/logic-resources/Sources/Resources/Color.xcassets` | Brand colorsets plus system/semantic overrides; add an `accent` colorset. Set both appearances and verify contrast. |
| Typography and fonts | `Modules/logic-resources/Sources/Resources/` (+ a `WalletFontConfig.plist` you add) | Default is the system font (San Francisco). No font files or `WalletFontConfig.plist` ship by default; add them only if your brand requires a custom face. |
| Shapes | `Modules/logic-resources/Sources/Manager/ShapeManager.swift` | Corner radii. |
| In-app logos | `Modules/logic-resources/Sources/Resources/Images.xcassets` (`logo`, `EUDI-text`, illustrations) | Used on the splash and content headers; keep the imageset names. |
| App icon | `Wallet/Assets.xcassets` — `AppIcon` and `AppIconDev` | One per build variant. |
| Splash / launch screen | in-app `StartupView` (`logo` on `background`) and the OS launch screen (`INFOPLIST_KEY_UILaunchScreen_Generation`) | The generated launch screen is blank by default. |
| Status bar and toolbars | `Modules/logic-ui/Sources/Config/ConfigUiLogic.swift` | Per-screen toolbar background map. |
| RQES signing UI | `Modules/logic-business/Sources/Config/RQESConfig.swift` | The RQES SDK carries its own theme; a wallet rebrand does not restyle it unless you set `RQESConfig.theme`. |

Requirements:

* No EUDI reference branding (name, icon, logos, colors, splash) remains in the production artifact.
* Light and dark colorset appearances are both set and meet WCAG AA contrast for text.
* The signing (RQES) flow either matches your brand or the SDK default is explicitly accepted.
* Run the verification steps and the production checklist in
  [THEMING.md](THEMING.md#production-and-accessibility-checklist).

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

## Dependency Governance

* Use released versions, not snapshots or branch dependencies, unless formally approved.
* Subscribe to security advisories for WalletKit, RQES UI, OpenID4VCI, OpenID4VP, ISO18013
  libraries, Wallet Storage, KeychainAccess, BluetoothKit, Swinject, and the Swift/Xcode toolchain.
* Keep a dependency update SLA.
* Keep `Package.resolved` committed and reviewed.
* Avoid branch dependencies for production unless the commit is pinned and approved.
* Generate and archive an SBOM for every release.
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
  var keyOptions: KeyOptions? { get }
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
| `userAuthenticationRequired` | Whether WalletKit secure storage requires local user authentication. | For LoA High PID and other high-assurance EAA/QEAA credentials, set this to `true` unless an approved remote high-assurance hardware-backed key protection design replaces local key use. Test all issuance, presentation, extension, and background behavior. |
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

This is the reference configuration as shipped. It is not a production recommendation for LoA High
PID or other high-assurance credentials.

Production requirements and decision points:

* `false` relies on app-level PIN/biometric flows and Keychain/App Sandbox protections.
* For LoA High PID and other high-assurance EAA/QEAA credentials, WalletKit-managed credential and
  key material must be protected by strong local authentication and Keychain/Secure Enclave-backed
  protection, or through an approved remote high-assurance hardware-backed storage design.
* `true` can bind WalletKit storage access to platform local authentication, but it must be tested
  with all flows, including extension access, reissuance, revocation checks, and background behavior.
* The current iOS app exposes `userAuthenticationRequired`; it does not expose the Android
  `userAuthenticationTimeout` setting. If batch issuing, deferred issuing, or reissuance causes
  repeated authentication prompts, use only a WalletKit/iOS-supported authentication reuse or session
  design approved by the assurance policy, document the risk decision, and verify the window cannot
  be reused outside the intended flow.
* `userAuthenticationRequired` gates *access* to WalletKit secure storage; the per-credential
  complement that gates *use* of attestation/proof keys at signing time is
  `WalletKitConfig.keyOptions.accessControl` (for example, `.requireUserPresence`). See
  [Attestation Key Options](#attestation-key-options-keyoptions).

Recommended production process:

1. Decide which actions require local authentication:
   * App unlock.
   * PID issuance.
   * Credential presentation.
   * RQES signing.
   * Export or support log creation.
   * Document deletion or wallet reset.
2. Test WalletKit behavior with `userAuthenticationRequired = true`.
3. Test PID issuance, batch/deferred issuance, presentation, and extension access with the selected
   authentication behavior.
4. Decide fallback behavior for devices without biometrics or passcode.
5. Document the UX and support impact.

### Key Storage And Extension Points

The default storage and key-handling behavior is selected by WalletKit when `EudiWallet` is created
with `EudiWalletConfiguration`. In this application, the integration point is:

```text
Modules/logic-core/Sources/Controller/WalletKitController.swift
```

Production teams must decide whether the default WalletKit and Keychain/App Group storage model is
sufficient or whether a WalletKit-supported custom integration, remote signing service, or external
protection SDK is required.

Current app-level configuration points:

| Configuration point | Purpose | When to change |
| --- | --- | --- |
| `ConfigLogic.keyChainConfig.documentStorageServiceName` | Keychain service name passed to WalletKit and the Identity Document Provider extension. | Change only through a planned migration, because it must remain stable across upgrades and extension access. |
| `ConfigLogic.keyChainConfig.keychainAccessGroup` | Runtime Keychain access group used by the main app and extension. | Change when production entitlements, App Groups, or Keychain Sharing groups are finalized. |
| `WalletKitConfig.userAuthenticationRequired` | Local authentication gate for WalletKit secure storage access. | Enable for LoA High PID and other high-assurance credentials unless an approved remote high-assurance hardware-backed design replaces local key use. |
| `WalletKitConfig.keyOptions` | Per-issuance `KeyOptions` (curve, secure area, access protection, access control, key purposes) applied to attestation/proof keys created by `issueDocuments`, `issueDocumentsByOfferUrl`, `reIssueDocument`, `requestDeferredIssuance`, and `resumePendingIssuance`. | Set explicitly for production. For LoA High PID and high-assurance EAA/QEAA, require Secure Enclave (P-256) with appropriate `accessProtection` (e.g. `.whenUnlockedThisDeviceOnly`) and `accessControl` (e.g. `.requireUserPresence`), unless an approved remote high-assurance hardware-backed design replaces local key use. See [Attestation Key Options](#attestation-key-options-keyoptions). |
| `WalletKitAttestationProviderImpl` and `WalletProviderAttestationConfig` | Wallet Provider host and wallet/key attestation calls. | Change when wallet attestation keys must be generated, stored, attested, or unlocked through a custom provider or remote high-assurance key service. |
| `WalletKitConfig.issuersConfig` and `keyAttestationsConfig` | Issuance configuration and Wallet Provider attestation provider wiring. | Change when issuer policy requires different key attestation, DPoP, or proof-of-possession behavior. |
| WalletKit storage and key-management APIs | WalletKit-owned document, credential, and protocol key handling. | If the selected WalletKit version exposes dedicated storage, key manager, Secure Enclave, remote signing, or ephemeral-key configuration, configure it in the production integration and record the exact SDK API. |

Production implementation rules:

* Treat document keys, wallet attestation keys, issuance proof/DPoP keys, and remote presentation
  protocol keys as separate key classes with separate policies.
* Document keys for LoA High PID and high-assurance EAA/QEAA credentials must be hardware-backed or
  protected by an approved remote high-assurance hardware-backed design.
* Wallet attestation keys must be generated, stored, unlocked, and attested according to the Wallet
  Provider policy.
* DPoP or issuance proof keys protect issuance access tokens against replay. Do not disable DPoP in
  production unless the issuer explicitly does not support it and the risk is accepted.
* Remote presentation uses protocol-level ephemeral key material for encrypted OpenID4VP responses.
  Ephemeral key material must be generated per transaction, must not be reused across verifiers, and
  must not be persisted longer than the protocol flow requires. If the selected WalletKit version
  exposes a dedicated configuration option for this ephemeral key storage, configure it in the
  production WalletKit integration and record the exact SDK API in the release evidence.
* Test custom storage or key-management behavior with device lock changes, biometric enrollment
  changes, app upgrade, app reinstall, backup/restore attempts, low-storage conditions, extension
  access, issuer reissuance, and revocation/status refresh.

### Attestation Key Options (`keyOptions`)

`WalletKitConfig.keyOptions` is the iOS-side per-issuance knob for the keys created and used by
WalletKit during credential issuance. The same value is passed to `issueDocuments`,
`issueDocumentsByOfferUrl`, `reIssueDocument`, `requestDeferredIssuance`, and `resumePendingIssuance`
in `WalletKitController`.

Fields:

* `curve` — `CoseEcCurve`. Secure Enclave only supports `.P256`. Other curves (P-384, P-521,
  brainpool, Ed25519) require `secureAreaName` resolving to a software or custom secure area.
* `secureAreaName` — selects a registered `SecureArea`. WalletKit auto-registers
  `SecureEnclaveSecureArea` (when available on the device) and `SoftwareSecureArea`. Prefer the
  type-safe constant (`SecureEnclaveSecureArea.name`, `SoftwareSecureArea.name`, or
  `SecureAreaRegistry.DeviceSecureArea.secureEnclave.rawValue`) over a string literal: an unknown
  name silently falls back to the registry's default secure area instead of erroring.
* `accessProtection` — maps to `kSecAttrAccessible*`. For production, prefer
  `.whenUnlockedThisDeviceOnly` or `.afterFirstUnlockThisDeviceOnly` unless backup/restore of these
  keys is explicitly required and approved.
* `accessControl` — `KeyAccessControl` option set. Enable `.requireUserPresence` to gate signing on
  biometry/passcode for LoA High PID and high-assurance EAA/QEAA credentials.
  `.requireApplicationPassword` adds a second factor for additional data encryption.
* `keyPurposes` — defaults to all purposes (`.signing`, `.keyAgreement`). Narrow when policy
  requires.

The reference value
(`KeyOptions(curve: .P256, secureAreaName: SecureEnclaveSecureArea.name, accessControl: [])`) is
suitable for the reference/demo setup. It does not enable user-presence-bound signing and does not
set an explicit accessibility class. Review all fields against the assurance level of each
credential class before production.

If per-document-type key policy is required (for example, stronger access control for PID than for
low-assurance EAAs), follow the existing per-type pattern used by `documentIssuanceConfig` — extend
`WalletKitConfig` with default and document-specific `KeyOptions`, then resolve in
`WalletKitController` alongside the existing `credentialOptions(for:)` call sites.

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
import OpenID4VP

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

### Relay Attack Risk In Presentation Flows

Production presentation flows must explicitly account for relay attacks. This is especially
important for high-assurance identity verification and for selective-disclosure-only requests such
as age checks.

The wallet's presentation flows implement standard session binding, such as OpenID4VP `nonce`,
`state`, `client_id` binding, and ISO 18013-5 session transcript binding. These controls are
necessary and protect against replay, injection, session mix-up, and similar protocol attacks when
verifiers validate them correctly. They do not, by themselves, prove that the wallet holder is
physically present at the verifier or prevent a live verifier request from being relayed to a
different legitimate wallet holder.

Relay is different from replay:

| Attack | What happens | Why standard binding is not enough |
| --- | --- | --- |
| Replay | An attacker reuses an old presentation response. | Fresh nonces, transaction binding, audience/client binding, and session transcript validation are intended to make old responses invalid. |
| Relay | An attacker forwards a live verifier request to another wallet holder, who creates a fresh, cryptographically valid response that is relayed back to the verifier. | The response is fresh and correctly bound to the verifier request, so cryptographic replay checks can pass even though the person interacting with the verifier is not the wallet holder. |

This is an architectural and ecosystem risk, not necessarily a wallet code bug. The wallet may be
fully conformant with OpenID4VP, ISO 18013-5, and platform-mediated presentment APIs and still
require verifier-side, issuer-side, or deployment-policy controls to mitigate relay risk.

Verifier guidance:

* Document relay risk in integrator and relying-party guidance. Verifiers must understand that
  selective-disclosure-only requests, for example `age_over_18` without portrait or another
  holder-presence check, are vulnerable to live relay.
* For attended in-person verification where the relying party must know that the person in front of
  them is the wallet holder, consider requiring portrait disclosure or another approved biometric
  holder-binding claim. Human comparison of the live person to the disclosed portrait is the primary
  practical relay defense in this scenario.
* Requesting portrait or other biometric data must be lawful, proportionate, purpose-specific, and
  reflected in the verifier privacy notice. Do not request portrait for low-risk age checks unless
  the assurance requirement justifies the additional disclosure.
* For unattended or automated verification, do not treat a cryptographically valid age-only or
  claim-only response as proof of physical presence. Consider additional binding, such as
  server-validated App Attest/DeviceCheck evidence, account/session risk signals, step-up
  authentication, lawful and consented location evidence, or other trust-framework-approved
  controls.
* For ISO 18013-5 proximity use cases where physical presence is expected, evaluate distance
  bounding or other proximity verification mechanisms. QR, BLE, or platform-mediated engagement
  alone should not be documented as a complete relay defense unless the deployment profile includes
  a tested relay-resistant mechanism.
* Treat timing and latency checks as weak signals. They can help identify suspicious relays but do
  not prevent a fast relay and should not be the only control.

Wallet and protocol-profile guidance:

* Keep OpenID4VP replay/session-binding checks enabled and test that verifiers reject wrong or reused
  `nonce`, `state`, `client_id`, and response/session values.
* If the ecosystem profile allows wallet-side timestamps in VP responses or response envelopes, make
  the timestamp integrity-protected and bound to the transaction. Verifiers should reject responses
  outside a short freshness window or responses with suspicious end-to-end latency.
* Do not add unsigned or unauthenticated timestamps and treat them as a security control. Unsigned
  metadata can be altered by an attacker.
* If App Attest, DeviceCheck, location evidence, or another app/device integrity signal is used as a
  compensating control, bind the evidence to a fresh verifier/backend nonce and to the same
  presentation transaction.
* Include Identity Document Provider extension and Digital Credentials API presentment in the same
  relay-risk analysis. Browser or platform mediation can improve flow security and user experience,
  but it does not automatically prove physical presence.
* Make the user consent screen clear about the verifier, the requested claims, and whether the flow
  is remote, proximity/in-person, or extension-mediated. Clear UX does not prevent relay by itself,
  but it reduces social engineering opportunities.

Production decision record:

| Scenario | Required decision |
| --- | --- |
| Age-only remote verification | Decide whether relay risk is acceptable. If not, define additional controls or require a different presentation policy. |
| In-person age or identity verification | Decide whether portrait disclosure and human comparison are mandatory. |
| ISO 18013-5 proximity verification | Decide whether distance bounding, latency checks, human portrait comparison, or another proximity control is required. |
| Identity Document Provider extension or Digital Credentials API presentment | Decide whether platform-mediated web presentment needs additional verifier, browser, account, or transaction-risk controls. |
| Automated high-value verification | Define additional binding, such as App Attest/DeviceCheck, account risk, location evidence, or transaction monitoring. |
| Verifier certification/onboarding | Require verifiers to document how they mitigate relay for each requested claim set and relying-party context. |

Evidence to collect:

* Threat model section distinguishing replay, session fixation, phishing, and live relay.
* Verifier policy for claim-only, age-only, portrait, proximity, automated, and extension-mediated
  requests.
* Test evidence for relayed QR/OpenID4VP requests, Identity Document Provider extension presentment,
  and relayed proximity engagement where feasible.
* Residual-risk sign-off for scenarios where relay cannot be fully mitigated.
* User-facing and verifier-facing guidance explaining the limits of selective disclosure for
  physical-presence assurance.

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
* Registration is only attempted on iOS 26 and later where the Digital Credentials API is available.
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

Current demo/dev code contains issuer URLs such as (two per build variant — a primary at `order: 1`
and a backend at `order: 0`):

```swift
// .DEMO
credentialIssuerURL: "https://issuer.eudiw.dev"
credentialIssuerURL: "https://issuer-backend.eudiw.dev"
// .DEV
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
        parUsage: .required(authorizationCodeDPoPBinding: true),
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
| `parUsage` | Pushed authorization request (PAR) usage policy. Use `.required(authorizationCodeDPoPBinding:)` to require PAR, optionally binding the authorization code to DPoP. | Prefer `.required(authorizationCodeDPoPBinding: true)` where the production profile requires PAR with sender-constrained authorization codes. |
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

The value is injected into `WalletKitAttestationProviderImpl` as `baseUrl`. During issuance,
`WalletKitConfig` passes this provider through `keyAttestationsConfig`, and the app currently calls
the following relative paths through `WalletAttestationRepository`:

```text
wallet-instance-attestation/jwk
key-attestation/jwk-set
```

Current payload shape:

* Wallet instance attestation sends a public key payload as `{"jwk": ...}`.
* Wallet key attestation sends `{"jwkSet": {"keys": [...]}, "nonce": ...}` when a nonce is
  available.

Important: these plain-JWK endpoints are suitable only for testing/reference integration unless your
Wallet Provider adds its own strong validation layer. In the reference/demo setup, they accept JWK
material and do not prove that the submitted keys were generated by Secure Enclave, protected by
Keychain access control, bound to the expected app bundle, or created on an uncompromised iOS
device. Do not rely on these endpoints as the production proof that wallet keys are genuine.

For production, use Apple App Attest/DeviceCheck, a Wallet Provider iOS attestation contract, a
commercial protection signal, or another approved server-verified mechanism to bind wallet
attestation to the expected bundle identifier, Team ID, app version, device/app risk state, and a
fresh backend nonce. If the production Wallet Provider exposes iOS-specific attestation-backed
endpoints, update the iOS client implementation as well as the backend.

Production implementers must not only change `walletProviderAttestationUrl`. If the Wallet Provider
contract changes from plain JWK submission to attestation-backed submission, update
`WalletAttestationApi`, `WalletKitAttestationProviderImpl`, payload generation, response parsing,
tests, and issuer compatibility checks together. The response should still provide the
`walletInstanceAttestation` and `keyAttestation` values expected by WalletKit after backend
validation.

Production requirements:

* Host must be HTTPS.
* Host must be controlled or formally approved by the wallet provider.
* Treat plain-JWK endpoints as non-production unless additional server-side validation makes them
  equivalent to the approved production attestation policy.
* Backend must validate wallet instance, key evidence, nonce freshness, replay protection, app
  version, bundle identifier, Team ID, and app integrity signals.
* App Attest/DeviceCheck or the selected integrity mechanism must be enforced server-side for
  high-risk issuance and signing flows where policy requires it.
* Availability must match issuance availability because issuance can depend on wallet attestation.
* Monitoring and incident response must cover attestation endpoints.

## Document Issuance Rules

Current code configures `documentIssuanceConfig` with:

* Default credential options (`defaultCredentialOptions`): `credentialPolicy: .rotateUse`, `batchSize: 1`.
* PID document-specific options (`documentSpecificCredentialOptions`): `credentialPolicy: .oneTimeUse`.
* Current Demo PID batch size: `10`.
* Current Dev PID batch size: `60`.
* Background reissuance rule (`reIssuanceBackgroundRule`):
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
* `Modules/logic-ui/Sources/Controller/DeepLinkController.swift` (the `DeepLink.Action` enum and `parseType(with:and:)` scheme parsing)
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
| Privacy manifest | Not present — add `PrivacyInfo.xcprivacy` | No privacy manifest ships in the repo today. Add and audit one for required-reason APIs, tracking domains, data collection, and SDK declarations. |

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
* Consider binding PIN verification to a hardware-backed key operation (Secure Enclave) for additional defense in depth.
* Benchmark PBKDF2 iterations on the slowest supported device.
* Consider memory-hard KDF options if supported by your platform/security policy.
* Avoid logging PIN validation results beyond coarse categories.
* Include PIN setup, change, lockout, and recovery in test plans.
* Add telemetry for repeated failed attempts without logging PIN values (the reference implementation does not emit lockout metrics).

Failure counting and lockout are handled separately by `PinThrottleController` — see the next section.

### PIN Throttle And Lockout

The reference implementation includes an escalating client-side lockout enforced by `PinThrottleController` and persisted in the iOS Keychain via `KeyChainController` (using the shared App-Group access group, so the main app and the document-provider extension share state). Policy is configured through `AuthenticationConfig` (see [CONFIGURATION.md#pin-throttle-configuration](CONFIGURATION.md#pin-throttle-configuration)).

Persisted state keys (`KeychainPinThrottleProvider.KeyIdentifier`):

* `pinFailedAttempts` — current consecutive failure counter (`Int`, stored as `String`).
* `pinLockoutLevel` — monotonic counter indexing `AuthenticationConfig.pinLockoutDurations` (`Int`, stored as `String`).
* `pinLockoutStartedAt` — wall-clock timestamp (`Date().timeIntervalSince1970`) when the current lockout began. Used for clock-rollback detection.
* `pinLockoutEndsAt` — wall-clock timestamp when the current lockout ends.

The values are stored as Strings in the Keychain (e.g. `"3"`, `"1762345678.123"`). The Keychain item accessibility class follows `KeyChainController`'s default (`.whenUnlocked`), which means the values are readable only while the device is unlocked and are excluded from iCloud backup under the standard Keychain backup rules.

Default policy (`AuthenticationConfigImpl`):

| Event | Behavior |
| --- | --- |
| 3 consecutive failed attempts | First lockout: 30 seconds. |
| 3 more failures after lockout ends | Second lockout: 90 seconds. |
| 3 more failures after that | Third lockout: 5 minutes. |
| Each subsequent batch of 3 failures | 5 minutes (last list entry reused). |
| Successful PIN or biometric authentication | Counters and lockout level reset. |
| App kill or device reboot | Lockout window persists (wall-clock based). |
| Device clock rolled back | Detected via stored start timestamp; user remains locked for the full duration. |
| App reinstall | State is wiped together with app data. Require re-enrollment unless secure backup/recovery is explicitly implemented. |

Lockout counters are persisted, not just held in UI state. The PIN input is disabled in both the login screen (`BiometryViewModel`) and the change-PIN validation step (`QuickPinViewModel`) while locked. The biometric icon on the login screen stays enabled during PIN lockout and acts as an escape hatch — a successful biometric authentication clears the throttle.

Production gaps to address:

* Decide what happens once the final lockout tier is reached. The reference implementation cycles at the last list entry indefinitely; production policy may instead require device-credential step-up, wallet wipe, or a support recovery flow.
* Decide whether to step up to device credential at high cumulative failures (e.g. after 10 cumulative failures across batches).
* Add server-side risk signals; the current lockout is purely client-side and is wiped by reinstall.
* Add telemetry for lockout events without logging PIN values.
* Combine with App Attest / DeviceCheck / RASP and server-side risk checks where applicable (see [App Attest, DeviceCheck, And App Hardening](#app-attest-devicecheck-and-app-hardening)).
* Clock-rollback mitigation is best-effort; a fully tampered device with reset clock could still bypass parts of the wall-clock window.

### SwiftData Store

Current local storage uses SwiftData and chooses the App Group container when available. The
container identifier is built by `Bundle.getAppGroupIdentifier()` in
`Modules/logic-business/Sources/Extension/Bundle+Extensions.swift`:

```swift
return "group.\(mainAppBundleID)"
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
| PIN lockout policy | Defaults to 3 attempts then escalating lockouts of 30s, 90s, 5m (then 5m repeats). Tune via `AuthenticationConfig.maxFailedPinAttempts` and `pinLockoutDurations`. Decide whether the final tier should escalate further (wipe, support flow, device-credential step-up). See [PIN Throttle And Lockout](#pin-throttle-and-lockout). |
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
* Confirm the shipped PIN lockout / rate limiting (`PinThrottleController`) meets policy; tune `maxFailedPinAttempts` / `pinLockoutDurations` as needed.
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
* Review `WalletKitConfig.keyOptions` (curve, secure area, access protection, access control, key
  purposes) against the assurance level of each credential class.
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

* Review and tune the shipped PIN attempt lockout (`PinThrottleController`); see [PIN Throttle And Lockout](#pin-throttle-and-lockout).
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
* Wallet key attestation.
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
* Relayed OpenID4VP request and response handling.
* Proximity QR/BLE.
* Relayed proximity engagement where feasible.
* Identity Document Provider extension presentment on supported iOS versions.
* Relayed or socially engineered Identity Document Provider extension presentment where feasible.
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
| Security | Debugger, jailbroken test device if available, simulator policy, re-signed app, instrumented app, proxy, relay simulation for remote, proximity, and extension-mediated presentation flows. |

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
* Presentation relay-risk threat model and accepted residual risks.
* Verifier policy for age-only, portrait, proximity, automated, and extension-mediated presentation
  scenarios.
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
eu.europa.ec.euidi
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
* Presentation relay-risk controls and residual risks are documented for verifier scenarios.
* MASVS assessment is complete with accepted residual risks.
* App Attest/hardening strategy is implemented and tested.
* Privacy and legal reviews are complete.
* Operational monitoring and incident response are ready.
* A rollback or emergency update path exists.

## Reference Links

* EUDI iOS WalletKit: https://github.com/eu-digital-identity-wallet/eudi-lib-ios-wallet-kit
* EUDI Architecture Reference Framework: https://github.com/eu-digital-identity-wallet/eudi-doc-architecture-and-reference-framework
* OpenID for Verifiable Presentations 1.0: https://openid.net/specs/openid-4-verifiable-presentations-1_0.html
* ISO/IEC 18013-5: https://www.iso.org/standard/69084.html
* Apple DeviceCheck and App Attest: https://developer.apple.com/documentation/devicecheck
* Apple App Attest server validation: https://developer.apple.com/documentation/devicecheck/validating-apps-that-connect-to-your-server
* Apple Identity Document Provider registration: https://developer.apple.com/documentation/identitydocumentservices/identitydocumentproviderregistrationstore
* Apple Identity Document Provider extension: https://developer.apple.com/documentation/identitydocumentservicesui/identitydocumentprovider
* Apple privacy manifests and required reason APIs: https://developer.apple.com/documentation/bundleresources/describing-use-of-required-reason-api
* Apple URLSession and App Transport Security: https://developer.apple.com/documentation/foundation/urlsession
* Apple preparing apps for distribution: https://developer.apple.com/documentation/xcode/preparing-your-app-for-distribution
* OWASP MASVS: https://mas.owasp.org/MASVS/
* OWASP MASTG: https://mas.owasp.org/MASTG/
