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
* [Trust Store](#trust-store)
* [Registration Certificates: The Second Trust Layer](#registration-certificates-the-second-trust-layer)
* [Issuer Configuration: `issuersConfig`](#issuer-configuration-issuersconfig)
* [Wallet Provider Attestation](#wallet-provider-attestation)
* [Document Issuance Rules](#document-issuance-rules)
* [Document Categories](#document-categories)
* [Revocation And Status Checking](#revocation-and-status-checking)
* [RQES Configuration](#rqes-configuration)
* [Trust Mark Deployment](#trust-mark-deployment)
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
| Registration certificates | `wrprcProviders` points at the production registration trusted list, `validateIssuerRegistrationCertificate` is enabled, every production issuer and verifier presents a registration certificate that validates against it, and every issuer's registered scope covers the documents it offers. Issuance is refused otherwise. |
| RQES | QTSP, TSA, client ID, redirect URI, and signing policy are production values. No QTSP client secret is hardcoded in the app. |
| Secrets | No production secret is hardcoded in Swift, plist files, xcconfig files, or build settings. |
| Network | App Transport Security is enforced; trust-all certificate logic is absent; TLS policy and certificate pinning strategy are agreed. |
| Storage | Wallet data, Keychain items, SwiftData stores, logs, and App Group containers are protected, excluded from inappropriate backup, and migration-safe. |
| Authentication | PIN, biometrics, device credential fallback, key authentication, lockout, recovery, and reset policies are approved. |
| Deep links | All inbound URI schemes, redirect URIs, hosts, and parameters are validated and threat-modeled. |
| Presentation relay risk | Relay attack risk is documented, verifier compensating controls are defined, and residual risk is accepted for each presentation scenario. |
| Logs | Production logs do not include PID, credentials, tokens, request objects, signatures, keys, or user decisions. |
| Screen capture | `ConfigUiLogic.hideContentWhileCaptured` is true, so recording, mirroring, sharing and the app switcher card show a cover, over the ID Provider extension's screens too; screenshots cannot be blocked. See [Screenshots, Screen Recording, And Sensitive UI](#screenshots-screen-recording-and-sensitive-ui). |
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
| `logic-authentication` | PIN storage provider, PIN controller, biometric controller, PIN throttle/lockout, session lock (`SessionController`), factory reset (`WalletResetController`), authentication configuration. |
| `logic-storage` | SwiftData storage for bookmarks, transactions, revoked, suspended and unrecognised documents, status refresh failures, and failed reissuance data. |
| `logic-api` | `URLSession` provider and network request helpers. |
| `logic-analytics` | Optional analytics provider integration. |
| `logic-resources` | Strings, images, theme, localized resources. |
| `logic-ui` | Shared SwiftUI components, navigation, deep-link parsing and handling, interaction tracking for the idle lock, the screen-capture cover (`ScreenCaptureController`). |
| `logic-assembly` | Dependency injection graph, app routing assembly, and the session lock's scene driver (`SessionLockController`). |
| `feature-*` | User-facing flows for startup, dashboard, issuance, presentation, proximity, and common features; `feature-common` holds the QR scanner and the request screens. |
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
| `Wallet/Wallet.plist` | Defines build metadata, URL schemes, encryption export flag, and app-level plist values. |
| `EudiReferenceWallet.xcodeproj/project.pbxproj` | Defines schemes, build configurations, bundle identifiers, signing style, provisioning profiles, app display name, usage descriptions, and extension settings. |
| `EudiWallet.entitlements` | Defines main app Keychain Sharing, App Groups, and Identity Document Provider mobile document types. |
| `EudiReferenceWalletIDProvider/EudiReferenceWalletIDProvider.entitlements` | Defines extension App Groups and Keychain Sharing through `SHARED_APP_GROUP_IDENTIFIER`. |
| `EudiReferenceWalletIDProvider/DocumentProviderExtension.swift` | Extension entry point for Identity Document Provider requests; starts the screen-capture cover for its screens. |
| `EudiReferenceWalletIDProvider/Domain/DI/LogicIDPModule.swift` | Initializes `DcApiHandler` with shared service name and Keychain access group. |
| `Modules/logic-business/Sources/Config/ConfigLogic.swift` | Parses app build type and build variant, exposes app behavior toggles, RQES config, and Keychain config. |
| `Modules/logic-business/Sources/Config/RQESConfig.swift` | Defines QTSP/RSSP, TSA, OAuth client, redirect URI, hash algorithm, and RQES logging behavior. |
| `Modules/logic-core/Sources/Config/WalletKitConfig.swift` | Main WalletKit production configuration: issuers, OpenID4VP, trust anchors, document categories, logging, revocation, and issuance rules. |
| `Modules/logic-core/Sources/Config/WalletProviderAttestationConfig.swift` | Defines the wallet provider attestation host. |
| `Modules/logic-core/Sources/Controller/WalletKitController.swift` | Constructs `EudiWallet`, wires WalletKit config, starts presentation, issuance, revocation, logging, and document registration. |
| `Modules/logic-core/Sources/Worker/RevocationWorkManager.swift` | Status-list results: revoked, suspended, unrecognised, cleared, and refresh failures (`RevocationRecordUpdate`). |
| `Modules/logic-authentication/Sources/Storage/KeychainPinStorageProvider.swift` | Defines PIN hashing, salt, PBKDF2 iteration count, and constant-time comparison. |
| `Modules/logic-authentication/Sources/Controller/SystemBiometryController.swift` | Biometric unlock: the policy evaluated on a fresh `LAContext` and the Keychain probe read with it. |
| `Modules/feature-startup/Sources/Interactor/StartupInteractor.swift` | The start-up gate: login, PIN creation only for a wallet without documents, or an error. |
| `Modules/logic-core/Sources/Storage/StoredDocumentPresence.swift` | Start-up's document check: queries wallet-storage's `pdoc` Keychain items; must change with the storage service. |
| `EudiReferenceWalletIDProvider/UI/Authorization/RequestAuthorizationViewModel.swift` | The extension's PIN or biometric check before a request is shown and again on Accept. |
| `Modules/logic-authentication/Sources/Config/AuthenticationConfig.swift` | PIN lockout policy (max failed attempts, escalating lockout durations), the session lock's timeouts, the weak-PIN list (`commonPins`) and whether a device passcode is required (`requireDeviceSecure`). |
| `Modules/logic-authentication/Sources/Controller/SessionController.swift` | The session lock: unlocked by login or PIN creation, locked again after time in the background or idle. |
| `Modules/logic-assembly/Sources/Controller/SessionLockController.swift` | Drives the lock from the scene: background, return, links, the idle check, and login after a lock. A lock, whatever caused it, also ends a running presentation, so a proximity session does not outlive its screens. |
| `Modules/logic-ui/Sources/Controller/UserInteractionController.swift` | What counts as interaction for the idle lock: touches in the app's windows, text input, VoiceOver focus. |
| `Modules/logic-ui/Sources/Config/ConfigUiLogic.swift` | The UI settings: the protected-flow and login routes, the screens that cover the wallet (`coveringScreenModules`), the holder-picture claims, and the screen-capture cover (`hideContentWhileCaptured`). |
| `Modules/logic-ui/Sources/Controller/ScreenCaptureController.swift` | The screen-capture cover: a window above the wallet's, or the ID Provider extension's, while the scene is recorded, mirrored or shared, or not active (app switcher), when `hideContentWhileCaptured` is true. |
| `Modules/logic-authentication/Sources/Storage/KeychainPinThrottleProvider.swift` | Keychain-persisted PIN failure counter, lockout level, and the lockout on the monotonic clock and boot session. |
| `Modules/logic-business/Sources/Controller/KeyChainController.swift` | Keychain access with its accessibility class, and the biometric probe. The service name and access group come from `Bundle+Extensions.swift` and are worked out once in `ConfigLogicImpl.keyChainConfig`. |
| `Modules/logic-storage/Sources/Config/StorageConfig.swift` | Defines SwiftData store location, App Group container selection, and local storage schema, and excludes the store's folder from backup (`StorageConfigImpl.storeURL`). |
| `Modules/logic-api/Sources/Provider/NetworkSessionProvider.swift` | Defines the shared network session used by app network calls. |
| `Modules/logic-analytics/Sources/Config/AnalyticsConfig.swift` | Defines analytics provider configuration. |
| `.github/workflows/*.yml` | Defines the SAST workflow (`sonar.yml`, SonarCloud). No SCA or secret-scanning workflow is included; `security/gitleaks/gitleaks.toml` holds secret-scanning rules for a pipeline that adds one. |
| `security/gitleaks/gitleaks.toml` | Defines local secret scanning rules. |
| `fastlane/Fastfile` | Defines iOS test, versioning, archive, upload, tag, and release lanes. |
| `Modules/logic-resources/Sources/Resources/Color.xcassets` | Brand color palette (light and dark appearances) and system/semantic color overrides. See [THEMING.md](THEMING.md). |
| `Modules/logic-resources/Sources/Resources/Images.xcassets` | In-app brand logos and illustrations used on the splash and headers. |
| `Wallet/Assets.xcassets` | Per-variant app icons (`AppIcon`, `AppIconDev`) and an `AccentColor` set. The app target names it as the global accent (`ASSETCATALOG_COMPILER_GLOBAL_ACCENT_COLOR_NAME`); it is empty, so the system default applies until it is filled in. |

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
| Apple team | `DEVELOPMENT_TEAM`, App Store Connect | Use the production Apple Developer Program team. |
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
| In-app logos | `Modules/logic-resources/Sources/Resources/Images.xcassets` (`logo`, `logo-eu-digital-indentity-wallet`, illustrations) | Used on the splash and content headers; keep the imageset names. |
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
codesign -d --entitlements :- build/EudiWalletProd.xcarchive/Products/Applications/EudiWallet.app/Extensions/EudiReferenceWalletIDProvider.appex
```

The Identity Document Provider is an ExtensionKit extension, so it is embedded under `Extensions/`,
not `PlugIns/`.

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
| `APP_IPA_PATH` | IPA that the `upload_appstore` lane passes to `pilot`. |
| `APP_EXTENSION_BUNDLE_ID` | Identity Document Provider extension bundle identifier. |
| `APP_EXTENSION_PROVISION_PROFILE` | Extension distribution provisioning profile name. |
| `CONNECT_KEY_ID` | App Store Connect API key ID. |
| `CONNECT_ISSUER_ID` | App Store Connect API issuer ID. |
| `CONNECT_KEY_PATH` | Path to the private key file injected by CI. |
| `CONNECT_APPLE_ID` | Apple account used by Fastlane metadata. |
| `CONNECT_ITC_TEAM_ID` | App Store Connect team ID. |
| `CONNECT_TEAM_NAME` | Developer team name. |
| `CONNECT_TEAM_ID` | Developer team ID. |
| `TESTFLIGHT_GROUPS` | Comma-separated TestFlight groups. Passed to `pilot`, which ignores them because the upload lane does not wait for build processing (see `fastlane/USAGE.md`). |
| `PROD_REMOTE_REPO` | Optional remote used to push production tags. |
| `DEV_REMOTE_REPO` | Optional second remote that receives the same tag. The `upload_tag` lane sets `origin` to each of these URLs in turn and does not restore it. |
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

* Use released versions, not snapshots or branch dependencies, unless formally approved. BluetoothKit is the one
  exception in the reference app (see below): approve its pinned commit formally or replace the library.
* Subscribe to security advisories for WalletKit, RQES UI, OpenID4VCI, OpenID4VP, ISO18013
  libraries, Wallet Storage, KeychainAccess, BluetoothKit, Swinject, and the Swift/Xcode toolchain.
* Keep a dependency update SLA.
* Keep `Package.resolved` committed and reviewed.
* Avoid branch dependencies for production unless the commit is pinned and approved. The reference app has none:
  BluetoothKit has no release Swift Package Manager can use (its last tag, 0.4.0, predates its `Package.swift`), so
  `logic-business` pins it to a commit with `revision:`. Move that revision only after reviewing the new commits.
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
  var validateIssuerRegistrationCertificate: Bool { get }
  var vpConfig: OpenId4VpConfiguration { get }
  var supportedTransactionDataTypes: [SupportedTransactionDataType] { get }
  var trustConfiguration: TrustConfiguration { get }
  var userAuthenticationRequired: Bool { get }
  var keyOptions: KeyOptions? { get }
  var logFileName: String? { get }
  var documentsCategories: DocumentCategories { get }
  var transactionLogger: TransactionLogger { get }
  var revocationIntervalSeconds: TimeInterval { get }
  var workerStopTimeoutSeconds: TimeInterval { get }
  var documentIssuanceConfig: DocumentIssuanceConfig { get }
  var trustMarkSource: TrustMarkSource { get }
}
```

Each property must be reviewed.
For Trust Mark settings, see
[Trust Mark configuration](CONFIGURATION.md#trust-mark-configuration).

## `EudiWalletConfiguration`

`WalletKitController` creates the wallet with:

```swift
EudiWallet(
  eudiWalletConfig: EudiWalletConfiguration(
    serviceName: configLogic.keyChainConfig.documentStorageServiceName,
    accessGroup: configLogic.keyChainConfig.keychainAccessGroup,
    userAuthenticationRequired: walletKitConfig.userAuthenticationRequired,
    deviceAuthMethod: .deviceSignature,
    uiCulture: Locale.current.systemLanguageCode,
    logFileName: walletKitConfig.logFileName
  ),
  trustConfig: walletKitConfig.trustConfiguration,
  openID4VpConfig: walletKitConfig.vpConfig,
  openID4VciConfigurations: walletKitConfig.issuersConfig.mapValues { $0.config },
  // ...
  trustMarkSource: walletKitConfig.trustMarkSource
)
```

Production meaning:

| Setting | Meaning | Production guidance |
| --- | --- | --- |
| `serviceName` | Keychain service name used by WalletKit storage. | Must be stable across app updates and match extension access needs. |
| `accessGroup` | Keychain access group. | Must match signed entitlements and extension sharing requirements. |
| `userAuthenticationRequired` | Whether WalletKit secure storage requires local user authentication. | For LoA High PID and other high-assurance EAA/QEAA credentials, set this to `true` unless an approved remote high-assurance hardware-backed key protection design replaces local key use. Test all issuance, presentation, extension, and background behavior. |
| `trustConfig` | Trust configuration (`TrustConfiguration`) for reader / issuer validation: ETSI LoTE trust sources, verification-context mappings, static fallback anchors, and trust policies. Passed as a separate `EudiWallet` argument, not inside `EudiWalletConfiguration`. | Replace demo LoTE endpoints and fallback anchors with production trust anchors, and review `defaultPolicy` / `statusTrustPolicy` before go-live. |
| `deviceAuthMethod` | Device authentication method used by WalletKit. | Current value is `.deviceSignature`; confirm with WalletKit and assurance policy. |
| `uiCulture` | Locale passed to WalletKit. | Confirm supported locales and fallback behavior. |
| `logFileName` | WalletKit log file name; `nil` outside debug builds (`WalletKitConfigImpl.logFileName(for:)`), so release builds write no file, delete one an earlier build left, and Settings offers no "Retrieve logs". wallet-kit logs authorization codes, access tokens and issued credentials to the file at `.info`. | Keep it off in production unless support policy requires a controlled log export, as on Android. |

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
| `ConfigLogic.keyChainConfig.documentStorageServiceName` | Keychain service name passed to WalletKit, the start-up document check and the Identity Document Provider extension. | Change only through a planned migration, because it must remain stable across upgrades and extension access. |
| `ConfigLogic.keyChainConfig.keychainAccessGroup` | Runtime Keychain access group used by the main app and extension. | Change when production entitlements, App Groups, or Keychain Sharing groups are finalized. |
| `WalletKitConfig.userAuthenticationRequired` | Local authentication gate for WalletKit secure storage access. | Enable for LoA High PID and other high-assurance credentials unless an approved remote high-assurance hardware-backed design replaces local key use. |
| `WalletKitConfig.keyOptions` | Per-issuance `KeyOptions` (curve, secure area, access protection, access control, key purposes) applied to attestation/proof keys created by `issueDocuments`, `issueDocumentsByOfferUrl`, `reIssueDocument`, `requestDeferredIssuance`, and `resumePendingIssuance`. | Set explicitly for production. For LoA High PID and high-assurance EAA/QEAA, require Secure Enclave (P-256) with appropriate `accessProtection` (e.g. `.whenUnlockedThisDeviceOnly`) and `accessControl` (e.g. `.requireUserPresence`), unless an approved remote high-assurance hardware-backed design replaces local key use. See [Attestation Key Options](#attestation-key-options-keyoptions). |
| `WalletKitAttestationProviderImpl` and `WalletProviderAttestationConfig` | Wallet Provider host and wallet/key attestation calls. | Change when wallet attestation keys must be generated, stored, attested, or unlocked through a custom provider or remote high-assurance key service. |
| `WalletKitConfig.issuersConfig` and `keyAttestationsConfig` | Issuance configuration and Wallet Provider attestation provider wiring. | Change when issuer policy requires different key attestation, DPoP, proof type (`allowPlainJwtProof`), credential encryption (`encryptionSupportConfig`), or proof-of-possession behavior. |
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
* A custom `DataStorageService` also needs its own start-up document check; see
  [PIN Storage](#pin-storage).

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
* `accessControl` — a `KeyAccessControl` enum value, not an option set. The named cases
  (`.requireUserPresence`, `.requireBiometryAny`, `.requireBiometryCurrentSet`) are mutually
  exclusive, `.empty` applies no constraint, and `.custom(_:)` passes native keychain flags through
  verbatim, for example `.custom([.biometryCurrentSet, .or, .devicePasscode])`. Enable
  `.requireUserPresence` to gate signing on biometry/passcode for LoA High PID and high-assurance
  EAA/QEAA credentials.
* `keyPurposes` — defaults to all purposes (`.signing`, `.keyAgreement`). Narrow when policy
  requires.

The reference value
(`KeyOptions(curve: .P256, secureAreaName: SecureEnclaveSecureArea.name, accessControl: .empty)`) is
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
    supportedTransactionDataTypes: supportedTransactionDataTypes,
    validateRegistrationCertificate: validateIssuerRegistrationCertificate
  )
}

var supportedTransactionDataTypes: [SupportedTransactionDataType] {
  [.qesApprovalRequest, .qesRequest]
}
```

Production meaning:

| Setting | Meaning | What to put in production |
| --- | --- | --- |
| `.x509SanDns` | Verifier client identity is bound to a DNS name in an X.509 certificate. | Use when verifier certificates and trust anchors are managed and audited. |
| `.x509Hash` | Verifier identity is bound to a certificate hash. | Use when the verifier ecosystem requires hash-based certificate binding. |
| `.preregistered` | Verifiers are explicitly configured in the wallet. | Use for closed pilots or controlled ecosystems. Add the production client ID, legal name and request-signing keys, and the request signing algorithm when it is not RS256. |
| `supportedTransactionDataTypes` | OpenID4VP `transaction_data` types the wallet accepts. The OpenID4VP library rejects any request whose transaction data type is not listed; an empty list rejects every request that carries transaction data. The app accepts the CSC `https://cloudsignatureconsortium.org/2025/qes-approval` (`.qesApprovalRequest`) and `https://cloudsignatureconsortium.org/2025/qes` (`.qesRequest`) types. The same list is used to read the transaction data recorded in presentation logs. | Keep both QES types when supporting signing flows. Add another type only once the wallet can display it, since WalletKit exposes it as raw JSON, which the wallet cannot show, so the app declines the request (`WalletCoreError.transactionDataNotShown`). |
| `validateRegistrationCertificate` | Whether the verifier's WRP registration certificate is validated during OpenID4VP. Set from `validateIssuerRegistrationCertificate`. | See [Registration Certificates: The Second Trust Layer](#registration-certificates-the-second-trust-layer). |

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
            verifierLegalName: "Example Member State Verifier",
            webKeys: productionVerifierWebKeys,
            jarSigningAlg: JWSAlgorithm(.ES256)
          )
        ]
      )
    ],
    supportedTransactionDataTypes: supportedTransactionDataTypes,
    validateRegistrationCertificate: validateIssuerRegistrationCertificate
  )
}
```

`productionVerifierWebKeys` stands for the verifier's public request-signing keys, a `WebKeySet` that
you define.

Rules:

* `webKeys` must hold the verifier's production request-signing public keys.
* `jarSigningAlg` must match the algorithm the verifier signs its requests with. It defaults to RS256.
* `verifierLegalName` must be the official entity name shown to users.
* `clientId` must match verifier registration and protocol profile.
* Do not include development verifier URLs in production.
* If a verifier is not trusted, the user interface must clearly show that status before disclosure.

When a presentation request includes transaction data for signing, each applicable option on the
request screen shows a "Data to be signed" section below its requested data. Its "Signature details" row is
open when the screen appears and lists the trust framework (eIDAS) once, then each transaction, numbered when there
is more than one, as on Android:

* A QES approval shows the transaction type, signature type, requested credential query ids,
  signing credential ID, number of signatures, locations, transaction-data hash algorithms and, for each document,
  its label, location, expected checksum and checksum algorithm, hash representation, hash, hash algorithm, signed
  attributes, circumstantial data, access mode and one-time password.
* A QES request shows the transaction type, requested credential query ids, transaction-data hash algorithms and,
  for each signature request, the document's label, location, expected checksum and checksum algorithm, signature
  type, signature format, conformance level, signed envelope property, reference URI, circumstantial data,
  signature algorithm and its parameters, signed attributes, access mode, one-time password and response URI. A
  document carried in the request itself is shown as included, with its type and size; its content is not
  rendered.
* Every field WalletKit binds into the response is shown. History shows the same fields without one-time
  passwords.
* "Trust framework: eIDAS" is shown once, in both live requests and transaction history. It is a static product
  label: it does not come from the transaction data and does not establish that the issuer, relying party, document
  or signature has been verified.
* The signed attributes carry the line "Chosen by the relying party; not checked by the wallet" in the warning
  colour.
* A request whose transaction data cannot be shown in full is declined with an explanation, never shown in part
  (`PresentationInteractorImpl.canShowTransactionData`): an entry WalletKit cannot read, or an entry bound to a
  document the consent screen does not show. Each option is checked against its own transaction data; an option
  that is not offered, because its documents are blocked, is not checked. WalletKit 0.57.2 binds transaction data
  to SD-JWT and mdoc documents alike.
* When WalletKit itself cannot take a remote request (transaction data it cannot process, no document that satisfies
  the query, a reader certificate whose authentication was required and not established), it sends the error to the
  verifier's response endpoint, and the wallet then shows its error screen, or for the certificate the trust alert
  (WalletKit 0.57.1 and later; the app has no setting for these). A request whose reader certificate is not trusted is
  reported too, because WalletKit's `OpenId4VpConfiguration.errorDispatchPolicy` defaults to `.allClients`;
  `.onlyAuthenticatedClients`, set in `WalletKitConfigImpl.vpConfig`, withholds that report from a verifier that did
  not authenticate.
* Back on the request screen declines a remote request (`RemoteSessionCoordinator.declineResponse`), unless the wallet
  has already tried to send its response: after a failed send, whether WalletKit reported the failure, the verifier
  rejected the response or the network failed, Back closes the request without a second answer, so the history keeps
  the first result. A failure before anything left the device, or a WalletKit authentication prompt cancelled with
  `userAuthenticationRequired` on (it is off), then leaves the verifier to its own timeout. After a failed send, Retry
  on the error screen sends nothing (WalletKit has put the session in its error state); Share on the request screen
  sends the response again, as in the upstream app.

Where a document location is an HTTP(S) link, "Open document" opens it in the browser. These
details are informational: sharing still uses the existing share flow, and WalletKit binds each
transaction to the credential of the chosen option. Hashes and expected checksums are displayed as
supplied; they are not a document-integrity verification result.

The transaction data is also recorded with the presentation. Its transaction details show one
read-only "SIGNING REQUEST / Signature details" section with the same information, without the
transaction type and without document actions. Signing results appear in separate history entries.

Before release, exercise QES approval and QES requests with transaction data: check the details under
each applicable option, the document links where supplied, and the recorded details after
restarting the app. Also check that requests without transaction data show no extra section.

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
* iOS reports the app's authorisation as `notDetermined` until its first registration, even when "Allow on websites"
  is on in Settings, and that first registration authorises it. The wallet therefore registers while the status is
  `authorized` or `notDetermined`, and stops only on `notAuthorized` (the user turned it off) or `notSupported`
  (`DocumentRegistrationManagerImpl.mayRegister(with:)`). Waiting for `authorized` meant a new install never
  registered, and websites reported "no eligible IDs". While `notDetermined` the store is touched only to register a
  document: reading its registrations in that state did not return on the simulator.
* Only CBOR documents are registered (`document.docDataFormat == .cbor`).
* Registrations are reconciled against storage rather than tracked incrementally, so a document deleted in the app is deregistered, and a registration left behind by an earlier build is removed after login by a pass that runs in a task of its own once the dashboard has loaded the documents, so a slow registration store holds up neither the tabs nor the background checks. Passes run one at a time (`SerialCheckRunner`).
* A document with a revocation record (revoked, suspended or unrecognised) is not registered, and the registrations are
  updated whenever a revocation check stores or clears a record; when the records cannot be read nothing is
  registered, as on Android. The extension also declines a request that would include such a document
  (`RequestAuthorizationInteractor.loadRequestData`). See [Revocation And Status Checking](#revocation-and-status-checking).
* Settings has a switch, "Allow document requests from apps and websites (DC API)", which is on by default and shown only on iOS 26
  and later. While it is off, nothing is registered and every registration is withdrawn when the user turns it off
  (`Prefs.Key.offerDocumentsToApps`, on by default in `PrefsControllerImpl`). The extension declines a request that still arrives, after
  the login and before any requested data is shown, and again on Accept, as Android does.

Current request handling:

* The extension is a separate process and does not share the app's unlocked session. It therefore
  asks for the wallet PIN or biometrics first, with the same screen as the app's login, and reads the
  request's documents only after that. No requested value is shown before the user has authenticated.
* Accept asks for the PIN or biometrics again before the response is sent.
* The request is validated once, when it is loaded, so each request writes one history entry. Accept sends only the
  documents and claims the sheet showed (`DocumentProviderSelection`), after reading their revocation records
  again, and then completes that entry. A request declined while it loads, after its validation, or one the user
  rejects with the Reject button, is recorded as not completed, with the reason; once Accept or a decline has
  recorded the outcome, Reject only closes the sheet. A sheet dismissed another way leaves the entry not completed,
  without a reason.
* The requester is shown without the verified badge and behind the warning "The identity of this
  relying party could not be verified"; Accept stays disabled until the user acknowledges it, as on
  Android. Without a website origin the requester gets the generic name, not the one in its
  certificate. `DcApiHandler` validates no reader certificate chain and returns no trust verdict, so the
  extension has nothing to badge. The interactor keeps the authority key identifier of the first
  certificate in the request's reader-authentication chain on `AuthorizationUIModel` (empty when the
  request carries none) for a trust-list lookup the reference app does not perform; only a real verdict
  from such a lookup may set `isRelyingPartyVerified`.

Production validation:

* Install the signed production build on a supported iOS version.
* Issue a supported CBOR document.
* Confirm the document is registered with the system.
* Trigger a web presentment request.
* Confirm the extension appears and can authorize or deny the request.
* Delete the document and confirm its registration is removed; revoke or suspend it and confirm that its registration is withdrawn and that the extension declines a request for it.

## Trust Store

Trust is configured through `WalletKitConfig.trustConfiguration`, which is passed to `EudiWallet` as
the `trustConfig` argument. The primary trust source is an ETSI LoTE (List of Trusted Entities)
source that fetches signed trusted lists at runtime; a static list of bundled DER certificates is
configured as the `fallbackTrustSource`. The fallback certificates are loaded by resource name:

```swift
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

`trustConfiguration` also decides how each check applies:

* `defaultPolicy` governs the certificate that signs each issued document, validated against the
  issuer trusted lists. `.enforce` refuses a document whose signer chain is not trusted: it is not
  stored and the issuance fails. `.warning` stores the document anyway, and WalletKit does not report
  the failure to the app. `docTypePolicies` sets the policy per doc type. The reference app enforces
  for the PID only (`mDocPid` and `sdJwtPid`) and warns for every other attestation, because only the
  PID doc types are classified (`contextTypeMappings`): a doc type with no verification context
  cannot be validated, so enforcing it would refuse every issuance of it.
* An SD-JWT whose header carries no `x5c` chain is not checked against the trusted lists, even under
  `.enforce`. WalletKit takes the signing key from the issuer's published metadata by `kid` instead.
  This holds for the SD-JWT PID as well.
* `requireSignedMetadata: true` requires signed issuer metadata and validates its signing
  certificate against the access-certificate list (`wrpacProviders`). It authenticates the metadata
  document, not the certificate that signs the issued documents, which is the `defaultPolicy` check.
  The app passes it to each issuer as `issuerMetadataPolicy`; see
  [Issuer Configuration: `issuersConfig`](#issuer-configuration-issuersconfig).
* `statusTrustPolicy` governs the signer of each status list, validated against the
  access-certificate list. `.enforce` fails the status check when the signer is not trusted; the app
  then records a refresh failure and the document keeps its last known state. `.warning`, the
  reference value, accepts the list whatever its signer.
* `isRevocationEnabled` on `EtsiTrustSource` decides whether PKIX chain validation checks certificate
  revocation. The reference app passes `false` for every build variant. With `true`, iOS checks revocation by OCSP
  in its own trust evaluation (the ETSI library sets a `SecPolicyCreateRevocation` policy), outside the app's
  network session and App Transport Security, and needs a positive answer. Every certificate below a list entry
  must therefore name an OCSP responder that answers for it; one that gives only CRL distribution points fails
  validation. Unlike on Android, where the wallet refuses cleartext revocation downloads, an `http://` OCSP
  address is not refused. The fallback `StaticListTrustSource` keeps the library default,
  `isRevocationEnabled: true`, so a chain it validates needs the same OCSP answer.

Production guidance:

* Replace the demo LoTE endpoints in `trustConfiguration` with your production trusted-list locations.
* Set `isRevocationEnabled` to `true` in the production `EtsiTrustSource`. `false` suits only the
  development trust lists. Before release, confirm that every certificate below a list entry, in every chain the
  wallet validates, names an OCSP responder that answers for it, and test issuance, presentation and the
  registration checks with revocation on.
* Keep the PID at `.enforce`. Classify every other doc type your trust framework covers and enforce
  it too, or record why it stays at `.warning`.
* Confirm that every SD-JWT PID issuer sends an `x5c` chain, since only then is the signer checked
  against the trusted lists.
* Keep `requireSignedMetadata` at `true`. Set `statusTrustPolicy` to `.enforce` once the status-list
  signers of your issuers validate against the access-certificate list.
* Keep `readerTrustPolicy` at `.enforce`, so an OpenID4VP request whose reader access certificate
  chain is not trusted is refused. `.warning` lets such a signed request proceed with an untrusted
  certificate.
* Configure `wrprcProviders` as well; without it the registration certificates covered in the next
  section have no trust source, and no registration can be validated in either direction.
* Remove demo and staging fallback trust anchors that are not part of the production trust framework.
* Add only production IACA, reader root, verifier, or scheme certificates approved for launch.
* Use clear file names, for example `ms_iaca_2026.der`.
* Document certificate owner, fingerprint, serial number, validity period, source, and rotation plan.
* Add tests or CI checks that production builds include expected anchors and exclude demo anchors.

Certificate governance:

* Store public trust anchors in version control only if policy allows it.
* Do not store private keys in the app repository.
* Define rotation before expiry.
* Define emergency distrust and app update procedures.

## Registration Certificates: The Second Trust Layer

Trust is evaluated on two independent layers, against separate trusted lists, and passing one says
nothing about the other:

| | Access certificate (WRPAC) | Registration certificate (WRPRC) |
|---|---|---|
| Answers | *who is this party* | *what is it registered to do* |
| Establishes | authentication of the issuer or verifier | the registered identity, declared purpose, privacy policy, and the attestation types and claims the party may issue or request |
| Trust source | `wrpacProviders` | `wrprcProviders` |
| Carried in | the request's reader authentication | `registration_cert` in the signed issuer metadata's `issuer_info` (OpenID4VCI), a `verifier_info` element with `format = registration_cert` (OpenID4VP), or the `euWrprc` entry of each `ItemsRequest` `requestInfo` (ISO/IEC 18013-5) |

The two layers are not interchangeable: an authenticated issuer that is not registered for what it
offers is refused, and a registered issuer that fails authentication is refused too.

The app treats the two directions differently, and the asymmetry is intentional:

* **Issuance refuses.** A document is stored only when the issuer's registration is verified and
  covers the credential being issued. A registration that fails validation, or that does not list
  the offered attestation, stops the flow on the "Issuance blocked" alert and reports it the same
  way an authentication failure does, because the distinction does not change what the user can do
  about it. Both flows refuse up front. A credential offer is resolved before anything is issued,
  so the offer screen already knows the issuer's registration. The issuer-list flow asks for the
  issuer's registration before it starts the issuance (`AddDocumentInteractorImpl.issueDocument`),
  and so does a re-issue. A lookup that fails stops the flow: a trust failure as "Issuance blocked",
  any other error as a failure the user can retry; it never reads as "no registration". WalletKit validates the certificate again as part of issuing and reports that outcome only after
  it has written the documents to storage; the app checks it as a fallback and deletes the
  documents itself when it refuses.
* **Presentation warns rather than blocks.** A request whose registration could not be validated
  still reaches the consent screen, shown without the verified badge and behind a warning the user
  must acknowledge before sharing. A request whose registration *is* verified but that reaches
  beyond the registered scope keeps the badge, marks each requested claim outside that scope as
  "Not registered data", and gates sharing behind the same acknowledgement. The acknowledgement is
  not remembered between requests. Access-certificate failures continue to block outright where the
  protocol allows it. A proximity (BLE) reader that did not authenticate (no reader certificate, or
  one that failed validation) is not refused: ISO/IEC 18013-5 makes reader authentication optional,
  and WalletKit checks it only for OpenID4VP. It gets a warning of its own, "The identity of this
  relying party could not be verified", ahead of any registration outcome and whatever
  `validateIssuerRegistrationCertificate` says: no badge, the generic name instead of the one in its
  certificate (a verified registration certificate still names it, as on Android), and Share disabled
  until the user acknowledges it. The Android wallet shows the same warning
  (`ACCESS_CERTIFICATE_NOT_TRUSTED`).

Production requirements:

* Set `wrprcProviders` to the production registration trusted list. It is the only trust source for
  this layer.
* Turn `validateIssuerRegistrationCertificate` on, and confirm every production issuer publishes
  `issuer_info`. An issuer that publishes none never reaches the validation hook, so no
  registration is established and the app refuses; enabling this against such an issuer fails every
  issuance. The value is the user switch "Check Registration Certificates" in Settings, kept in
  UserDefaults and off by default (`WalletKitConfigImpl` reads it from `PrefsController`); a change takes effect after
  the app restarts, as the app and WalletKit's presentations both use the value read at launch. It
  governs presentation too, so leaving it off ships a wallet that neither refuses an unregistered
  issuer nor shows a verifier's registration. Decide whether the switch stays reachable: any user
  can turn the check off. Returning `true` from
  `WalletKitConfigImpl.validateIssuerRegistrationCertificate` and removing the switch is the
  stricter choice.
* Keep `wrprcVciTrustPolicy` at `.enforce`. With the registration check on, the app refuses an
  issuance unless the registration is verified, whatever the policy
  (`WalletKitController.makeIssuerRegistration`, the same rule as the Android wallet's
  `isBlockedForIssuance`): any warning refuses, and so does a registration that was never
  established, such as a certificate that cannot be decoded. `.warning` therefore lets no such
  failure through. Leave `wrprcVpTrustPolicy` at `.warning`:
  presentations are required to reach the consent screen behind an acknowledgement rather than
  terminate.
* Confirm each issuer's registered scope actually covers what it offers, before release. An issuer
  authenticated but not registered for a credential it issues is refused at runtime.
* WalletKit reports a registration certificate's status list that cannot be retrieved only as a
  warning, under either policy. The app refuses an issuance on any such warning, so an unreachable
  status list stops the issuance on the "Issuance blocked" alert; on presentation it is a warning
  the user acknowledges. Confirm the status endpoints of the registration certificates are as
  available as the issuers themselves.
* Test both directions: a party on the registration list succeeds; one that is absent, expired, or
  out of scope is refused on issuance and warned about on presentation.

The verified badge on the consent screen is a combined verdict over **both** layers: it appears only
when the access certificate is trusted *and* the registration raised no problem. A registration that
failed hides the badge even behind a trusted access certificate, and a trusted registration does not
restore it if the access certificate is untrusted. Where no registration was evaluated at all, the
access-certificate verdict decides alone.

The same verdict is carried through to the screens that follow, so a verifier badged on the consent
screen is badged on the success screen and never the reverse. Note the issuance side answers a
narrower question — the issuer's badge reflects its registration alone, since a credential offer
carries no reader authentication to combine it with.

## Issuer Configuration: `issuersConfig`

Credential offers are accepted only from the issuers in `issuersConfig` (`OfferIssuer`, checked before anything is
fetched). An offer that carries itself in the link must name a configured issuer as its `credential_issuer`, written
exactly as its `credentialIssuerURL`; an offer passed by address must be fetched over `https` from a configured
issuer's origin. Any other offer is refused with "This offer comes from an issuer that this wallet is not set up to
use", as on Android, because wallet-kit would otherwise give an unknown issuer the first configured issuer's client
settings. To accept an issuer's offers, add a `VciConfig` entry for it to `issuersConfig` in the build variants that
need it. For an offer passed by address, the issuer the fetched offer names is not compared with that address, and
redirects are followed; the Android wallet has the same limitation (owner, 16 October 2026).

When an issuer issues only some of the documents of an offer, the success screen names the ones not added
(`DocumentSuccessUIConfig.notIssuedDocumentNames`), as on Android; the cause wallet-kit reports is not shown. The
"Add document" flow does the same for its combined PID entry, which asks for every PID format at once: a format the
issuer did not issue is named, found by the configuration identifier each issued document records
(`AddDocumentInteractorImpl.notIssuedConfigIds`).

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
        keyAttestationsConfig: .init(
          walletAttestationsProvider: walletKitAttestationProvider,
          popKeyOptions: KeyOptions(
            secureAreaName: SecureEnclaveSecureArea.name,
            accessControl: .empty
          )
        ),
        authFlowRedirectionURI: URL(string: "eu.example.wallet://authorization")!,
        parUsage: .required(authorizationCodeDPoPBinding: true),
        allowPlainJwtProof: false,
        requireDpop: true,
        issuerMetadataPolicy: trustConfiguration.issuerMetadataPolicy,
        validateRegistrationCertificate: validateIssuerRegistrationCertificate,
        encryptionSupportConfig: .init(credentialResponseEncryptionPolicy: .supported)
      ),
      order: 0
    )
  ]
```

| Field | Meaning | Production value |
| --- | --- | --- |
| `credentialIssuerURL` | Base URL of an OpenID4VCI credential issuer. | Your production issuer base URL. It must expose valid issuer and authorization metadata. |
| `clientId` | Wallet client identifier known to the issuer or authorization server. | Use the registered production wallet client ID. |
| `keyAttestationsConfig` | Wallet/key attestation provider used during issuance. `popKeyOptions` keeps the client-attestation proof-of-possession key in the Secure Enclave; without it WalletKit creates a software key. | Use the production wallet attestation provider, and keep `popKeyOptions`. |
| `authFlowRedirectionURI` | Redirect URI used after authorization. | Must match production URL scheme registration and issuer client registration. |
| `parUsage` | Pushed authorization request (PAR) usage policy. Use `.required(authorizationCodeDPoPBinding:)` to require PAR, optionally binding the authorization code to DPoP. | Prefer `.required(authorizationCodeDPoPBinding: true)` where the production profile requires PAR with sender-constrained authorization codes. |
| `allowPlainJwtProof` | Credential proof policy. `false` (default) is HAIP-compliant: only attested proofs are sent (`attestation`, or `jwt` with a Wallet Provider key attestation). `true` additionally accepts plain `jwt` proofs (ES256/ES384/ES512) without key attestation, so the proof key is no longer attested. | Keep `false`. Set `true` only for a specific issuer that does not support key attestation, after a documented risk decision. |
| `requireDpop` | Whether DPoP is required. | Prefer `true` where the production profile requires sender-constrained tokens. |
| `issuerMetadataPolicy` | Signed-metadata policy. `trustConfiguration.issuerMetadataPolicy` requires signed issuer metadata whose signer validates against the access-certificate list (`wrpacProviders`), since `requireSignedMetadata` is `true`. WalletKit's default, `.ignoreSigned`, accepts unsigned metadata. | Keep `trustConfiguration.issuerMetadataPolicy`. |
| `validateRegistrationCertificate` | Whether the issuer's registration certificate is validated during issuance. WalletKit's default is `false`. | Pass `validateIssuerRegistrationCertificate`; see [Registration Certificates: The Second Trust Layer](#registration-certificates-the-second-trust-layer). |
| `encryptionSupportConfig` | Credential request and response encryption. With `credentialResponseEncryptionPolicy: .supported` (wallet-kit's default) the wallet encrypts whenever the issuer's metadata advertises encryption, and otherwise exchanges plain JSON over TLS; `.required` refuses an issuer that does not support encryption. `ecConfig`, `rsaConfig` and `supportedEncryptionMethods` restrict key types and methods. | Prefer `.required` where the production profile mandates encrypted credential responses and every production issuer supports them. |
| `order` | Display/order preference for scoped issuance. | Use deterministic ordering approved by product owners. |
| `logoOrigins` | Origins, besides the issuer's own, that this issuer's logo may load from (`IssuerLogoOrigins`); default none. | List only the origins your issuer serves its logo from. See [CONFIGURATION.md](CONFIGURATION.md). |

Rules:

* Use HTTPS.
* Do not include demo issuers in production.
* Do not point production wallets to development or staging issuers.
* Confirm issuer metadata contains only production credential configurations.
* Confirm issuer credential signing keys, status endpoints, and trust chains are production keys.
* Confirm issuer and wallet agree on redirect URI, client ID, PAR, DPoP, proof type (`allowPlainJwtProof`), credential encryption (`encryptionSupportConfig`), and attestation policy.

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

The revocation and re-issuance workers start when the dashboard first opens, after login or PIN
creation, never at launch; see [Revocation And Status Checking](#revocation-and-status-checking).

`.rotateUse` with `batchSize: 1`, the default for every document type other than the PID, gives a document one
credential and one device key for its whole validity. Every presentation of it, to every verifier, carries the same
issuer signature and is signed with the same device key, so verifiers who compare notes can link the presentations of
a multi-year mDL or diploma to one holder. The app sets no maximum key age or presentation count of its own:
`ReIssuanceWorkManager` re-issues a `.rotateUse` document only by its remaining validity and a `.oneTimeUse` document
only by its remaining unused credentials, with thresholds from the document's stored credential options, else the
configuration's, else a default, and no floor or ceiling of the wallet's own. Nothing rotates keys after a suspected
compromise. The issuer's `validUntil` is the effective bound on a device key's life.

Production decisions:

| Decision | Guidance |
| --- | --- |
| Credential policy | Align with issuer policy, privacy goals, and verifier ecosystem. Where presentations must not be linkable, prefer `.oneTimeUse` with a batch over `.rotateUse` with `batchSize: 1`, which reuses one device key for the whole validity. |
| Key lifetime | Decide whether the wallet needs a maximum key age or presentation count besides the issuer's `validUntil`; the reference app enforces neither. |
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

The revocation and re-issuance workers start when the dashboard first opens, after login or PIN
creation, and the documents are loaded at the same point. Start-up loads none, and a presentation link
opened before login is kept without starting its session (see
[Deep Links And Redirect URIs](#deep-links-and-redirect-uris)). The first revocation check
runs 30 seconds after the workers start, and later checks follow every `revocationIntervalSeconds`.
Only the factory reset calls `WalletWorkScheduler.stop()`; otherwise the workers run until the process ends. A
failed reset starts them again at once, and after a reset they start with the dashboard, after the next login. The
scheduler (`schedule()`, `stop()`) is the only way to reach them, as the work managers are internal to `logic-core`.
If an integrator calls `stop()` and then `schedule()` after the first revocation check, the next revocation check
waits the full interval; the
re-issuance worker always waits 30 seconds after a start, then `backgroundIntervalSeconds`. The workers
are tasks in the app's process; iOS background execution is not used.

How the check treats what a status list reports (`RevocationWorkManager.checkRevocation()`):

The rules are the Android wallet's (`RevocationRecordUpdate`, Android's `revocationUpdateFor`):

* An Invalid status stores the document as revoked. A revocation is permanent: no later status
  clears or changes it.
* A Suspended status stores the document as suspended, unless it is already revoked. A later Valid
  clears the suspension, and a later Invalid turns it into a revocation.
* A status value the wallet cannot interpret (application-specific or reserved) stores the document
  as unrecognised, unless it is already revoked. A later Valid clears it; a later Invalid or Suspended
  records that status. A record stored before the status was kept counts as unrecognised too, so the
  next check that reads the document's status replaces or clears it.
* Every record blocks the document. A revoked, suspended or unrecognised document is left out of
  remote and proximity presentations; if the records cannot be read, the request fails rather than
  offer a blocked document. The Digital Credentials API registrations leave them out; the extension declines a
  request that would include one, when it loads and again on Accept, and declines when the records cannot be read
  (`WalletKitController.reconcileRegistrations`, `DocumentProviderPolicy.checkRequest`). The documents list,
  the details screen and the issuer card show a suspended document as suspended and the others as
  revoked; the list's "Revoked" filter lists all of them.
* When the records cannot be read, the documents tab shows every document as revoked, as the sharing flows refuse.
* The dashboard notice, "Revoked or suspended documents", lists only the documents a check blocks for
  the first time. A change from one blocked status to another (suspended to revoked) refreshes the
  screens without a new notice.
* **Re-issue** is disabled for a blocked document, and a manual re-issue that reaches
  `DocumentDetailsInteractor.reIssueDocument` for one, for example a document blocked while its details
  are open, is refused before the issuer is contacted ("The issuer has revoked or suspended this
  document, so it cannot be reissued."). A document whose records cannot be read is also stopped before the issuer
  is contacted, with the read error and Try again. The background
  re-issuance worker skips blocked documents: a re-issued copy would get a new identifier and no record,
  which would undo the block. If the records cannot be read, that round re-issues nothing.
  `WalletKitController.reIssueDocument` checks again just before it asks the issuer, for a document
  blocked after the worker chose it. Closing the refusal reloads the details, so the card shows the
  block. If the original is blocked while a re-issue is already under way (the issuer's sign-in), the
  re-issue still completes, as the issuer chose to issue; the revocation check then runs at once
  (`WalletWorkScheduler.scheduleRevocationCheck(afterReIssueOf:)`), so the new copy's own status is read without waiting
  for the interval. The background worker does the same after each renewal, and so does the documents tab when a
  deferred re-issuance delivers its credential. The check runs only if the original had a record, and not while the
  checks are stopped. The Android wallet applies the same rules.
* A renewed document, manual or background, keeps the original's bookmark, as on Android.
* Deleting a document deletes its revocation record, refresh failure, bookmark and failed re-issuance record
  (`WalletKitControllerImpl.deleteRecords(of:)`, as Android's `deleteDocumentRecords`); its history stays. A
  re-issued or deferred original loses its records too, but a re-issued original keeps its revocation record until
  the check after the re-issue has read it.
* A background re-issuance that cannot renew a document leaves a failed re-issuance record
  (`FailedReIssuedDocument`): the document's issuer card opens by itself and says "The wallet could not
  renew this document automatically. Use Reissue document to try again." Each background round replaces
  the records.
* A status that cannot be fetched leaves that document's record as it is, and the check goes on with
  the other documents. The document gets a refresh-failure record (`StatusRefreshFailure`): its issuer
  card opens by itself and says "The document's status could not be refreshed. The state shown is from
  the last successful check." The next check that fetches the status removes the record. A failure
  does not block the document. If the stored records or the failure records cannot be read, the check
  changes nothing.

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
* Confirm `includeRevocationInfo` with the signing policy and QTSP. With `true`, a B-LT or B-LTA signature makes
  the app fetch the CRLs and the OCSP response itself (`rqes-csc-swift`'s `PodofoManager`, through
  `URLSession.shared`), where App Transport Security refuses plain `http`. Every CRL distribution point and OCSP
  address in the signing and timestamp certificates must then be an `https://` URL: a CRL of the signing chain
  that cannot be fetched stops the signature, and an OCSP response that cannot be fetched is left out of it. The reference flow signs
  at rqes-kit's default level, B-B, which fetches neither.
* Disable verbose logs in production.
* Test success, cancellation, network failure, expired authorization, and rejected signing flows.

## Trust Mark Deployment

Set `WalletKitConfig.trustMarkSource` to the Trust Mark configuration for your wallet solution.
The default uses a sample Gist resource and a certification-page URL containing
`WALLET_SOLUTION_ID`. Replace the sample values in your production variant with the correct
resource and certification URLs. See
[Trust Mark configuration](CONFIGURATION.md#trust-mark-configuration) for instructions.

The app does not check certification, recognition, expiry, revocation or wallet instance
attestation, or automatically remove the mark when certification changes. Check that the
displayed image, text and links match your wallet's actual certification status before release.

Test the following:

* On a clean install, the introduction appears after splash, Continue proceeds to PIN setup,
  and later launches skip the completed introduction.
* "About EUDI Wallet" opens from the side menu.
* In both the introduction and About views, "EUDI Wallet Provider Trusted List" opens the
  list of certified wallets and "Certification information page" opens your wallet's
  certification page in the browser. Both links display an external-link icon.
* The Trust Mark image is centered above its localized text and keeps its original proportions.
  Check long text and larger Dynamic Type sizes: the text should use the available width, wrap
  fully and scroll with the screen while Welcome's Continue remains available. Resource and image
  loading errors offer Try again.

For an upgrade release, confirm whether existing users should see the introduction and test
that flow.

The app can report when it cannot open a link. Once the browser opens, page-loading and network
errors are handled by the browser.

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

How the reference app handles a wallet link (`DeepLinkController.handleDeepLinkAction`):

* Before login, and while the wallet is locked, the link is kept for after login and starts nothing. A
  presentation link starts its session only when it is opened after login, just before its request
  screen is shown. The kept link lives in memory, for the current process only: a link received before
  the app was killed does not open at the next launch. When the app returns, the session lock's timeout
  is applied before the link is looked at.
* While the wallet is logged in, a presentation, signing or credential-offer link that arrives away from
  the dashboard ends the flow on screen: the wallet returns to the dashboard, which opens the link. A
  wallet without documents returns to the add-document screen for an offer. A presentation or an offer in
  progress, proximity included, is not replaced in place, and the flow that was ended does not resume.
  The Android wallet behaves the same way, with one exception iOS does not need: an OpenID4VP link that
  arrives while an issuance screen or document details is open is handled there as the issuance's own
  presentation (`DYNAMIC_PRESENTATION`). On iOS, wallet-kit hands that presentation to the issuance
  inside the app, without a link.
* An offer whose transaction code has no length, a length outside 4 to 6 digits, or text input is refused
  with the transaction-code error (`DocumentOfferInteractor.processOfferRequest`).
* Each presentation screen works on the session its route carries (`PresentationInteractorImpl`,
  `ProximityInteractorImpl`); a session started later cannot take its place.
* The verifier's `redirect_uri` after a presentation is never treated as a wallet link: the success screen
  opens it in the browser only if it is an `https` link with a host (`URL.openInBrowser(using:)`,
  `URL.isHttpsWebLink`), and returns to the dashboard either way. A credential-offer, OpenID4VP, RQES or
  any other redirect opens nothing. The Android wallet applies the same rule. A presentation made during
  an issuance is the exception: its redirect is kept to resume the issuance
  (`storeDynamicIssuancePendingUrl`), nothing opens, and the success screen returns to the issuance
  screen.
* A link of no wallet type is dropped, locked or not, as on Android: `DeepLink.Action.parseType`
  returns nil for it, so the wallet neither opens it nor keeps it. The app registers custom schemes only
  and no associated domains, so iOS delivers none today; a deployment that adds associated domains must
  add a route for its own links.
* An `rqes` link counts only when its host and path are a signing service's callback
  (`authFlowRedirectionURI` in `RQESConfig`, `rqes://oauth/callback` in the reference build), as Android matches the
  RQES host; any app can open a custom scheme, so anything else on it is dropped (`DeepLinkControllerImpl.hasDeepLink`).
  A deployment that changes the redirect URI's host or path changes it there only; a new scheme must also be
  registered in the first `CFBundleURLTypes` entry of `Wallet.plist` and must contain `rqes`, since the scheme is
  matched with `retrieveSchemas(with: "rqes")`.

Files to review:

* `Wallet/Wallet.plist`
* `Modules/logic-ui/Sources/Model/DeepLink.swift` (the `DeepLink.Action` enum and its `parseType(with:and:)` scheme parsing) and `Modules/logic-ui/Sources/Controller/DeepLinkController.swift` (what each link does before and after login)
* `Modules/logic-ui/Sources/Extension/URL+Extensions.swift` (`openInBrowser`) and
  `Modules/logic-business/Sources/Extension/URL+Extensions.swift` (`isHttpsWebLink`)
* `Modules/logic-assembly/Sources/Controller/SessionLockController.swift` (the timeout applied before a link is handled)
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

The app uses one ephemeral `URLSession` that keeps no cookies and no response cache, also handed to WalletKit
(`NetworkSessionProviderImpl.makeConfiguration()`):

```text
Modules/logic-api/Sources/Provider/NetworkSessionProvider.swift
```

A cookie one relying party sets is therefore never sent to another through that session. Three paths sit outside it,
and the app cannot change them:

* WalletKit 0.57.2 fetches an SD-JWT issuer's keys, when the credential carries no `x5c` chain, with
  `URLSession.shared`.
* WalletKit's sign-in sheet for issuers (`ASWebAuthenticationSession` in `OpenId4VciService`) is not ephemeral, so
  it shares Safari's cookies: an issuer can recognise the browser across issuances, and the wallet's reset does not
  clear them.
* The RQES library (`rqes-csc-swift` 0.10.0, `HTTPService`) calls the QTSP with `URLSession.shared`, whose cookies
  and response cache the app shares; the reset clears both.

These are residuals for the WalletKit and RQES library teams.

iOS App Transport Security applies to `URLSession` connections by default. Production must keep TLS
validation strict.

Production rules:

* Use HTTPS for issuers, verifiers, wallet provider, QTSP, TSA, changelog, and analytics endpoints, and for the
  CRL and OCSP addresses the RQES library fetches inside the app (see [RQES Configuration](#rqes-configuration)).
  Trusted-list revocation checks run in iOS's own trust evaluation instead (see [Trust Store](#trust-store)).
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
* WalletKit log file (debug builds only).
* Transaction records, bookmarks, revocation records (revoked, suspended, unrecognised), status refresh failures and
  failed re-issuance records.

### Keychain

Current Keychain controller:

```swift
keyChain = Keychain(
  service: service,
  accessGroup: accessGroup
)
.accessibility(Self.accessibility) // .whenUnlockedThisDeviceOnly
```

Biometric validation key:

```swift
.accessibility(
  .whenPasscodeSetThisDeviceOnly,
  authenticationPolicy: [.biometryCurrentSet]
)
```

The item is written once, when the user turns biometric unlock on (`KeyChainController.storeBiometricProbe()`),
or, on an install from before the binding, at its first biometric login (`Prefs.Key.biometricUnlockBound`).
A biometric unlock has the system evaluate `.deviceOwnerAuthenticationWithBiometrics` on a new `LAContext`,
then reads the item with the evaluated context, so the user sees one prompt. The unlock fails when the
evaluation fails or returns `false`, or when the item cannot be read (`SystemBiometryController`,
`KeyChainController`). After a fingerprint or face is added or removed, `.biometryCurrentSet` makes the item
unreadable, so the PIN is needed until the user turns biometric unlock off and on again. The prompt offers no
device-passcode button (`localizedFallbackTitle` is empty): the wallet PIN is the fallback.

`.whenUnlockedThisDeviceOnly` keeps every item `KeyChainController` writes, the PIN salt, hash and
iteration count and the PIN lockout state included, in backups only under a key bound to this device: they can be
restored only to the same device, so the salt and hash never reach another device and the 6-digit PIN cannot be
searched offline elsewhere. Items an earlier build wrote as
`.whenUnlocked` move to the new class at the next start
(`KeyChainControllerImpl.moveItemsFromThePreviousClass`); while the device is locked the move fails, and the next
Keychain read, at the latest the PIN check at login, tries again. wallet-storage writes its own items as `.whenPasscodeSetThisDeviceOnly`.

Production decisions:

* Keep `KeyChainControllerImpl.accessibility` a `ThisDeviceOnly` class, so the PIN record and the
  lockout state can be restored only to the same device.
* Confirm whether Keychain items should survive device restore.
* Confirm behavior when the device passcode is removed. iOS then deletes every Keychain item kept
  `.whenPasscodeSetThisDeviceOnly`: wallet-storage's documents and their keys, and the biometric probe. The PIN record
  (`.whenUnlockedThisDeviceOnly`) stays, so the login screen shows the passcode warning and the user logs in to a
  wallet without documents (the transaction history stays); with `requireDeviceSecure` login is refused until a
  passcode is set. Biometric login fails until a passcode is set again and the user turns biometric unlock off and on
  in Settings. This follows Apple's documented rule for that class; confirm it on a device.
* After a change in biometric enrolment, biometric unlock fails and login needs the PIN until the user turns it off
  and on again (see Biometric enrollment change); confirm this suits policy.
* Confirm app and extension Keychain sharing.

### PIN Storage

Current PIN storage uses:

* Random 32-byte salt from `SecRandomCopyBytes`.
* PBKDF2-HMAC-SHA256.
* 210,000 iterations.
* 32-byte derived key.
* Constant-time comparison.
* Keychain storage for salt, hash, and iteration count.

The start-up gate fails closed:

* A Keychain read that fails is reported (`KeyChainError.readFailed`), never taken for a missing PIN.
  The start-up screen then shows an error with "Try again" instead of PIN creation.
* PIN creation is offered only when the PIN record is absent and the Keychain holds no document.
  Start-up loads no document: it asks the Keychain whether wallet-storage keeps a document item in any
  status, deferred included, reading neither its attributes nor its data (`StoredDocumentPresence`). With
  documents present, or when that check fails, the app shows an error instead. The check reads
  wallet-storage's `KeyChainStorageService` item layout; an integrator who supplies another
  `DataStorageService` must replace it. Otherwise the check finds nothing and start-up offers PIN
  creation over existing documents.
  The reference app offers no recovery from that state other than reinstalling. The Keychain survives
  an uninstall; on the first launch after a reinstall the app deletes every document and its own
  Keychain items (`StartupInteractor.manageStorageForFirstRun()`).
* `setPin` writes the salt, hash and iteration count with their status checked. When a write fails it
  puts back the previous record, or removes the partial one, and reports the error; the PIN screen
  shows it. If putting the previous record back fails as well, all three items are removed; that
  removal reports no error, so a failure there can still leave a mix. The three writes are not one
  transaction. A process killed between them while the first PIN is set leaves a partial record,
  which the gate treats as no PIN. Killed during a PIN change, after the salt and before the hash,
  it leaves the new salt beside the old hash: a complete record that no PIN matches, so the user is
  locked out until biometrics unlock the wallet or it is reinstalled.

Production tasks:

* Confirm PIN length, complexity, and retry UX. PINs that are easy to guess are refused (one digit repeated,
  ascending or descending runs, `AuthenticationConfig.commonPins`), and an empty PIN is never stored; decide whether
  setup and login need a device passcode (`requireDeviceSecure`, off by default, which only warns). Changing the PIN
  of a set-up wallet does not need the passcode, as on Android (`QuickPinInteractor.updatePin`). The setup screen and
  the login screen (the ID Provider extension's too) check the passcode again whenever the app comes back. While a
  passcode is required, PIN entry stays disabled, and at login Face ID or Touch ID is refused as well. See
  CONFIGURATION.
* Consider binding PIN verification to a hardware-backed key operation (Secure Enclave) for additional defense in depth.
* Benchmark PBKDF2 iterations on the slowest supported device.
* Consider memory-hard KDF options if supported by your platform/security policy.
* Avoid logging PIN validation results beyond coarse categories.
* Include PIN setup, change, lockout, and recovery in test plans.
* Add telemetry for repeated failed attempts without logging PIN values (the reference implementation does not emit lockout metrics).

Failure counting and lockout are handled separately by `PinThrottleController` — see the next section.

### PIN Throttle And Lockout

The reference implementation includes an escalating client-side lockout enforced by `PinThrottleController` and persisted in the iOS Keychain via `KeyChainController` (in the Keychain access group the main app and the document-provider extension share, `$(AppIdentifierPrefix)` followed by the main app's bundle identifier, so both see the same state). Policy is configured through `AuthenticationConfig` (see [CONFIGURATION.md#pin-throttle-configuration](CONFIGURATION.md#pin-throttle-configuration)).

Persisted state keys (`KeychainPinThrottleProvider.KeyIdentifier`):

* `pinFailedAttempts` — current consecutive failure counter (`Int`, stored as `String`).
* `pinLockoutLevel` — monotonic counter indexing `AuthenticationConfig.pinLockoutDurations` (`Int`, stored as `String`).
* `pinLockoutStartedAtUptime` — the monotonic clock (`MonotonicClock.now()`, which counts sleep and ignores the date
  and time settings) when the current lockout began.
* `pinLockoutDuration` — the length of the current lockout, in seconds.
* `pinLockoutBootSession` — the boot the lockout began in (`MonotonicClock.bootSessionIdentifier`).
* `pinLockoutStartedAt`, `pinLockoutEndsAt` — wall-clock values of earlier builds, removed at the next successful PIN
  or biometric authentication (`recordSuccess()`).

The values are stored as Strings in the Keychain (e.g. `"3"`, `"812345.123"`). The Keychain item accessibility class follows `KeyChainController`'s default (`.whenUnlockedThisDeviceOnly`): the values are readable only while the device is unlocked, and a backup can restore them only to the same device; see [Keychain](#keychain).

Default policy (`AuthenticationConfigImpl`):

| Event | Behavior |
| --- | --- |
| 3 consecutive failed attempts | First lockout: 30 seconds. |
| 3 more failures after lockout ends | Second lockout: 90 seconds. |
| 3 more failures after that | Third lockout: 5 minutes. |
| Each subsequent batch of 3 failures | 5 minutes (last list entry reused). |
| Successful PIN or biometric authentication | Counters and lockout level reset. |
| App kill | Lockout window persists. |
| Device reboot during a lockout | The lockout begins again in full: the monotonic clock restarts at boot. |
| Device date or time changed | No effect: the lockout runs on the monotonic clock, so moving the date forward does not end it early. |
| Keychain read fails | Counts as a lockout of the longest configured duration, never as extra attempts. |
| Lockout over, then device reboot | No new lockout once the wallet has seen it end (the PIN screen counting down to it, or a PIN entered after it), which clears it and keeps its level; otherwise the reboot begins it again in full. |
| Update from a build with the wall-clock lockout | Ends a lockout in progress: those values are not read; the level is kept. An update between builds that use the monotonic clock keeps the lockout running. |
| App reinstall | The state survives the uninstall, as the Keychain does; the first launch after a reinstall deletes it with the PIN and every document (`StartupInteractor.manageStorageForFirstRun()`). Require re-enrollment unless secure backup/recovery is explicitly implemented. |

Lockout counters are persisted, not just held in UI state. While locked, the PIN input is disabled wherever `BiometryViewModel` asks for the PIN (the login, the confirmations before sharing, the factory reset and the biometric unlock switch, and the ID Provider extension) and in the change-PIN validation step (`QuickPinViewModel`). The biometric icon on the login screen stays enabled during PIN lockout, except at login while a required passcode is missing, and acts as an escape hatch — a successful biometric authentication clears the throttle.

Production gaps to address:

* Decide what happens once the final lockout tier is reached. The reference implementation cycles at the last list entry indefinitely; production policy may instead require device-credential step-up, wallet wipe, or a support recovery flow.
* Decide whether to step up to device credential at high cumulative failures (e.g. after 10 cumulative failures across batches).
* Add server-side risk signals; the current lockout is purely client-side and is wiped by reinstall.
* Add telemetry for lockout events without logging PIN values.
* Combine with App Attest / DeviceCheck / RASP and server-side risk checks where applicable (see [App Attest, DeviceCheck, And App Hardening](#app-attest-devicecheck-and-app-hardening)).

### SwiftData Store

Current local storage uses SwiftData and chooses the App Group container when available. The
container identifier is built by `Bundle.getAppGroupIdentifier()` in
`Modules/logic-business/Sources/Extension/Bundle+Extensions.swift`:

```swift
return "group.\(mainAppBundleID)"
```

The transaction history is a legal record. It has no retention limit and nothing deletes it automatically:
removing a document leaves its entries in place. Entries go only through the per-entry deletion the user
confirms, through the factory reset, and through the cleanup that drops an entry the app can no longer
decode (`WalletKitController.fetchTransactionLogs`), as on Android. The store is read in batches of 100
(`SwiftDataServiceImpl`), and the transactions tab reads it again only when the history changed: every write
or deletion, by the app or the ID Provider extension, stores a fresh token in `Prefs.Key.transactionLogRevision`
(`TransactionLogStorageController.retrieveRevision()`), and `TransactionTabInteractorImpl.fetchTransactions()` reuses
its last read while that value is unchanged. The tab still holds the whole history in memory, because its
filters, search and date range work over all entries.

**Transaction log contents.** WalletKit produces each history entry in the TS10 model (`TransactionEntry`, from
`eudi-lib-ios-iso18013-data-model`), and the app stores it as JSON in the store's `TransactionLog` table. The log
records the relying party, the attestation types and the identifiers of the attributes requested and presented, never
their values; this is the rule the ARF and the Implementing Acts set for it (HLR.64, HLR.65 and IA.34, as the security
review maps them). With WalletKit 0.57.2:

* a presentation entry records the requested and presented claims as attestation type (mdoc `docType` or SD-JWT VC
  `vct`) and claim paths, without values, and the relying party's details WalletKit has for it: name, identifier,
  contacts, intermediary, purpose, privacy policy, registrar and data protection authority;
* the entry also records the transaction data the request carried, decoded and otherwise unchanged
  (`transactionalData`). For a signing request this includes document labels, locations, hashes, any one-time password
  for document access and the whole content of a document carried in the request. History shows the same fields
  without the one-time passwords;
* issuance entries record the attestation types, the number of credentials requested and issued, and the issuer.
  Signing entries, written by the RQES library, record the signing service, the signing certificate's identifier, the
  document's name and size, and its digest (DTBSR).

Beside each presentation entry the app records whether the relying party's registration was verified
(`registrationCheck`); WalletKit does not keep it in the entry.

The store has no explicit file-protection class: nothing in the project sets one, so iOS's default applies
(`completeUntilFirstUserAuthentication`). The file is encrypted at rest and readable from the first unlock after a
restart, by the app and by the ID Provider extension, which shares the App Group container. Rows carry no integrity
tag.

Production tasks:

* Confirm which data is stored in SwiftData.
* Confirm whether the store is in the shared App Group container.
* Apply file protection to every store that holds personal data, the transaction history included: set the class
  explicitly instead of relying on iOS's default, and confirm that the ID Provider extension and the background checks
  can still open the store under it.
* Decide whether one-time passwords and documents carried inline belong in the transaction log at all for your
  deployment.
* The store's folder is excluded from iCloud backup and device-to-device transfer (`isExcludedFromBackup`, set by
  `StorageConfigImpl.storeURL`), as the Android wallet's backup rules exclude its data. A restore is expected to
  bring back no document: wallet-storage keeps documents and their keys as `.whenPasscodeSetThisDeviceOnly`, a class
  iOS leaves out of backups. On the same device the PIN record returns, so the user logs in to an empty wallet
  without history and issues the documents again. Confirm this with an encrypted backup and restore on a device
  before release.
* Define migration behavior before release.
* Test upgrade from previous production builds.
* Test extension access to shared data.

### UserDefaults

Current preferences include:

* `biometryEnabled`
* `biometricUnlockBound`
* `runAtLeastOnce`
* `language`
* `batchCounter`
* `validateIssuerRegistrationCertificate`
* `trustMarkIntroductionCompleted`
* `transactionLogRevision`
* `walletResetGeneration`
* `offerDocumentsToApps`

Production rules:

* Do not store tokens, credential payloads, PID attributes, private keys, or secrets in UserDefaults.
* A link kept for after login lives in memory only. Earlier builds kept it under `cachedDeepLink`;
  `DeepLinkControllerImpl` removes that value at start.
* Clear transient values after use.

### Factory Reset

Settings offer "Reset wallet", as on Android. A confirmation lists what will be deleted, the PIN or biometrics
confirm it, and a screen runs the reset (`WalletResetControllerImpl`, `logic-authentication`). In this order:

1. The background checks stop (`WalletWorkScheduler.stop()`). The reset waits for a check under way for at most
   `WalletKitConfig.workerStopTimeoutSeconds` (30 s) and fails without deleting anything if one is still running
   then, so a re-issuance cannot store a document halfway through. A check cannot start once the stop has
   begun, and the checks cannot be scheduled again while the reset runs.
2. WalletKit deletes every document, issued, deferred and pending, in up to two passes, and logs each deletion
   before it returns; the Digital Credential API registrations are updated with it, also when a deletion
   fails. The reset fails if the keychain still holds a document afterwards.
3. The transaction history, then the bookmarks, revocation records, re-issuance failures and status refresh
   failures; then the SwiftData store is erased and opened empty, so no deleted row stays readable in its
   write-ahead log.
4. The keychain: the app's keychain service, with the PIN salt, hash and lockout state and the biometric key, and
   every generic-password and key item in the wallet's access group: document storage, the documents' keys that
   WalletKit's secure areas keep there (`KeyChainSecureKeyStorage`), those of deferred documents included, and
   WalletKit's DPoP keys, so an issuer cannot link the wallet before and after the reset
   (`KeyChainController.clear()`).
5. Every preference except `language`, `transactionLogRevision` and `walletResetGeneration`, so that onboarding
   runs again; the two counters never go back. "Check Registration Certificates" returns to off, which WalletKit
   applies at the next start.
6. The app's Caches and temporary files, WalletKit's log file and the image cache among them, the cookies and
   the URL cache, as far as they can be removed. `walletResetGeneration` advances, and the ID Provider extension
   clears its own Caches and temporary files, its WalletKit log among them, the next time it starts.
7. The session locks, and the app starts again at start-up (`RouterHost.restartAtStartup()`), which leads to
   onboarding.

Once started, the reset runs to the end even if its screen goes away, and its screen is a protected flow, so the
background lock waits 10 minutes. The app asks iOS to keep it running while the reset runs
(`UIApplication.keepRunningInBackground`), so leaving the app does not suspend it halfway, as far as iOS allows. Links that arrive meanwhile are dropped, and a link kept for after login is
forgotten, so none opens after onboarding. A failed step shows an error with "Try again"; every step can run
again. After a failure the background checks restart at once; after a reset they start with the dashboard, after
the next login.

The reset does not reach: files the app or an integrator writes outside Caches and the temporary directory; the
cookies of WalletKit's sign-in sheet, which are Safari's (see [Network Security](#network-security)); the RQES SDK's
signing session, which `EudiRQESUi` (0.4.7) keeps in memory and the app cannot clear, so a matching `rqes://` callback
can reopen it at its last step until the app restarts, which also holds after a lock (reported to the SDK's owner);
and a request the ID Provider extension answers while the reset runs, since the extension runs in its own process.
Data already shared with relying parties is outside the wallet.

## Logging And Audit

Logging appears in several areas:

* WalletKit log file through `logFileName`, written by debug builds only; it holds authorization codes, access
  tokens and issued credentials.
* Transaction logging through `TransactionLogger`.
* Each presentation's history entry keeps the outcome of the relying party's registration check
  (`RecordedRegistrationCheck`, stored beside the entry). Unless the registration was verified (it was not verified,
  not checked, or no outcome was recorded), history warns that its contacts may not be the party's; when the
  certificate was issued to another party than the one that asked, no deletion request is offered, as on Android.
  The outcome is recorded by WalletKit's transaction identifier (`RegistrationCheckProvider`), as on Android, so it
  reaches only its own presentation's entry. A registration counts as verified only for a requester that
  authenticated: WalletKit binds a registration to the reader certificate even when that certificate failed
  validation, so an unauthenticated requester's registration is recorded as not verified.
* Data-protection requests from history (a data deletion request, a report to the DPA) are recorded only after
  the system has handed them to the mail, phone or browser app (`TransactionDetailsInteractor.recordDataProtectionAction`),
  as on Android, so a failed attempt and its retry leave one record. A request handed off but not recorded offers to
  record it again, never to send it again.
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

The reference app offers a cover as a setting, as the Android wallet's `ConfigUILogic.shouldPreventScreenCapture` sets
`FLAG_SECURE`. With `ConfigUiLogic.hideContentWhileCaptured` set to true, `ScreenCaptureController` follows each
window scene's `sceneCaptureState` and activation, and shows a window of its own above the wallet's windows (sheets, alerts and the
RQES SDK's screens included). The system keyboard's window sits above it, so the keyboard is put away whenever the
cover shows, and again if a field takes focus under it:

* While the screen is recorded, mirrored through AirPlay or QuickTime, or shared, the cover shows the wallet's mark
  (`Theme.shared.image.logo`), the title `screen_capture_cover_title` and the message `screen_capture_cover_message`, so
  that no screen and no PIN typed on the on-screen keypad can be read from the recording. Touches go to the cover until
  the capture ends: unlike `FLAG_SECURE` on Android, the wallet cannot be used on the device itself while the screen is
  recorded, mirrored or shared.
* While the app is inactive or in the background, the cover shows only the wallet's mark, as the start-up screen
  (`StartupView`) does, so that the app switcher card shows none of the wallet's screens, as Android's recent-apps
  preview with `FLAG_SECURE`. The cover also shows whenever the app goes inactive: behind a system prompt such as Face
  ID, Control Center or Notification Center, or on the way to another app. A field that had focus loses it, and the
  user taps it again on return.

The cover window never becomes key, so the session lock's checks still find the wallet's own window, and VoiceOver stays
on the cover while it is shown. A tap on the cover counts as activity for the idle lock; unlike the RQES SDK's or the
sign-in screens, the cover does not pause the idle timeout. The setting is false in the reference configuration, so that
the screens can be recorded in development and testing: set it to true for production. `ConfigUiLogicImpl` applies one
value to every build variant; to keep recording in Dev and Demo builds only, derive it from
`ConfigLogic.appBuildVariant` (`logic-ui` already depends on `logic-business`); the ID Provider extension reads the
setting in its own process, and its `WalletIdProvider.plist` has no `Build Variant` key, so it reads `DEV` there unless
you add the key to it too. A screenshot cannot be blocked: iOS
tells an app about one only after it is taken, and the reference app does not react to it. Hiding content from captures
through a secure text field's layer is undocumented and not used. The ID Provider extension runs in its own process and
starts the same controller (`DocumentProviderExtension`), so the PIN entry and the request it shows over the requesting
app are covered too: while the screen is captured, when the request cannot be answered on the device, and in that app's
card in the app switcher. The system's title and close button around the extension's screens stay visible.

With the setting false, the app switcher card shows the blur that `Application` lays over the wallet's own screens while
the scene is inactive or in the background. Sheets, alerts and the RQES SDK's screens are presented over those screens
and are not blurred, so they show in the card.

Review screens that show:

* PID attributes.
* mDL attributes.
* Presentation request details.
* QR codes.
* Transaction history.
* RQES signing details.
* Error details from backend responses.

Production actions:

* Set `ConfigUiLogic.hideContentWhileCaptured` to true; it also covers the app switcher card.
* If the setting stays false, also hide the sheets, alerts and RQES SDK screens that `Application`'s blur does not cover
  when the app enters the background, and the ID Provider extension's screens, which have no blur.
* Ensure the app switcher snapshot does not expose sensitive data. The setting also covers the ID Provider extension's
  screens, which show over the requesting app.
* Avoid putting secrets or full credential data in notifications.
* Avoid copying sensitive values to the clipboard.
* Add manual tests for screenshots, app switching, screen recording, and AirPlay/mirroring behavior: with
  `hideContentWhileCaptured` true, recording or mirroring shows the cover over every screen, sheet and alert, and the
  wallet returns when it stops; the app switcher shows the wallet's mark and no keyboard; a field that takes focus under
  the cover brings up no keyboard; the ID Provider extension's screens show the cover too, while the screen is captured
  and in the requesting app's card in the app switcher; a screenshot still shows the screen.

## Authentication And Biometrics

The app supports PIN and system biometrics.

Production decisions:

| Area | Guidance |
| --- | --- |
| PIN length | Define minimum length and whether numeric-only is acceptable. |
| PIN lockout policy | Defaults to 3 attempts then escalating lockouts of 30s, 90s, 5m (then 5m repeats). Tune via `AuthenticationConfig.maxFailedPinAttempts` and `pinLockoutDurations`. Decide whether the final tier should escalate further (wipe, support flow, device-credential step-up). See [PIN Throttle And Lockout](#pin-throttle-and-lockout). |
| Session lock | The wallet locks after 60 seconds in the background or 5 minutes without interaction, on every screen; during an issuance, presentation or signing the background limit is 10 minutes, and while another screen (the RQES SDK's, the issuer's sign-in) covers the wallet the idle timeout pauses and 10 minutes covered requires login when the wallet's screen returns. An issuer's sign-in still open after 10 minutes locks the wallet. A lock dismisses what is presented, ends the covered state of the RQES SDK's or the sign-in screens and returns to login; after login the user starts again from the dashboard. A lock also ends a running presentation: a proximity session stops its Bluetooth transfer and advertising (`WalletKitController.stopPresentation()`), and so does a wallet link that returns the user to the dashboard. The proximity QR screen is the exception to the 10-minute limit: leaving the app there once its code is shown stops the session and closes the screen. Tune the timeouts in `AuthenticationConfig` and the screens in `ConfigUiLogic.protectedFlowRouteKeys`; see CONFIGURATION [Session lock configuration](CONFIGURATION.md#session-lock-configuration). The rules are the Android wallet's, except that on iOS the issuer's sign-in pauses the idle timeout: it shows inside the wallet's own scene. |
| Biometric opt-in | Decide whether biometrics are optional or required for specific operations. |
| Biometric unlock switch | Turning biometric unlock on in Settings first asks for the wallet PIN (the PIN-or-biometric screen, as the factory reset does), then for Face ID or Touch ID; turning it off accepts the PIN or a biometric. Someone holding the unlocked phone who has enrolled a new biometric therefore cannot turn it on, as on Android. Keep the PIN step if you change the Settings screen. |
| Device credential fallback | Decide whether passcode fallback is allowed. |
| Biometric enrollment change | Biometric unlock is bound to the enrolment present when the user turns it on: the Keychain probe is written with `.biometryCurrentSet` (`KeyChainController.storeBiometricProbe()`), so after a fingerprint or face is added or removed the probe can no longer be read, and login needs the PIN until the user turns biometric unlock off and on again in Settings. Turning it on asks for the wallet PIN, then for Face ID or Touch ID; turning it off accepts the PIN or a biometric, with no further prompt (`SettingsViewModel.onBiometrySwitch()`, `BiometrySelectionViewModel`). An install from before this binding has biometric unlock on without a probe; its first biometric login binds it (`Prefs.Key.biometricUnlockBound`), as Android binds its key at the first biometric success. Android invalidates its key on enrolment the same way (`setInvalidatedByBiometricEnrollment(true)`). |
| High-risk operation step-up | Require re-authentication before issuance, presentation, RQES signing, reset, or document deletion where policy requires it. |
| Recovery | Define user-facing recovery and reset policy. The reference app fails closed at start-up when the PIN record cannot be read, or when it is missing while documents exist or the Keychain check for them fails; see [PIN Storage](#pin-storage). |

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
* Confirm that release builds write no log file (`WalletKitConfig.logFileName` is `nil` outside debug builds).
* Set `ConfigUiLogic.hideContentWhileCaptured` to true, so that recording, mirroring, sharing and the app switcher show
  a cover.
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
* Confirm that turning biometric unlock on asks for the PIN.
* Decide whether setup and login require a device passcode (`requireDeviceSecure`) and test removing it.
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
* Set `ConfigUiLogic.hideContentWhileCaptured` to true and test recording, mirroring, sharing and the app switcher;
  screenshots cannot be blocked.

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
* Review branch-based SPM dependencies (none in the reference app) and commit-pinned ones (BluetoothKit).

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
* Review the claims that count as a picture of the holder (`ConfigUiLogic.userImageClaimKeys`: `portrait` and
  `picture` by default). A request for one of them shows a biometric-data notice. Share asks for confirmation while
  the picture would be disclosed, and so does Accept in the ID Provider extension, as on Android. Add the claims
  your credentials use.
* A privacy-policy link from a registration certificate opens only when it is `https`: on the request and offer
  screens any other link is not shown, and in history it stays plain text, as on Android, with no exception for
  `http` from Core or Kit.
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
* CRL distribution points and OCSP addresses as `https://` URLs in the signing and timestamp certificates, where
  B-LT or B-LTA signatures carry revocation information (`includeRevocationInfo: true`).
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
* Start-up with the PIN record unreadable (device locked), and with documents but no PIN record or
  the document check failing: an error with "Try again", never PIN creation.
* PIN creation.
* PIN change.
* Incorrect PIN attempts and lockout; a change of the device date during a lockout (no effect) and a restart during
  one (it begins again).
* A request with transaction data: every entry is shown before Share; one that cannot be shown in full is declined.
* A response that fails to send, then Back on the request screen: the verifier gets no second answer, and the history
  keeps the first result.
* Biometric enablement (asks for the PIN first) and disablement (PIN or biometric); Back from the check changes
  nothing.
* Biometric enrollment change.
* A weak PIN refused at setup and on change; setup on a device without a passcode shows the warning.
* Screen recording, AirPlay or QuickTime mirroring with `ConfigUiLogic.hideContentWhileCaptured` true: the cover over
  every screen, sheet and alert, the RQES SDK's included, and no keypad on a PIN screen; the app switcher card shows
  the wallet's mark and no keypad; a saved password or passkey can still be filled into the issuer's sign-in page
  (AutoFill's Face ID check makes the app inactive and brings up the cover);
  the ID Provider extension's screens show the cover too; a screenshot still shows the screen; with it false, no cover,
  the blur in the app switcher, and the extension's screens in the requesting app's card.
* Removing the device passcode after setup: the documents are gone; login shows the warning, or with
  `requireDeviceSecure` refuses the PIN and Face ID or Touch ID until a passcode is set; biometric login needs the
  switch turned off and on again. Test the ID Provider extension before opening the app.
* An offer from an issuer that is not configured refused; a partial issuance naming the documents not added.
* The portrait notice, and Share or Accept asking for confirmation.
* "Allow document requests from apps and websites (DC API)" off: registrations withdrawn, the extension declines.
* A proximity request that several document sets satisfy offers the choice.
* PID issuance from list.
* Credential offer issuance by QR.
* Authorization-code issuance redirect.
* Deferred issuance.
* Reissuance.
* Reissuance of a revoked or suspended document: refused before the issuer is contacted; closing the refusal
  reloads the details.
* Revocation/status checks.
* Same-device OpenID4VP presentation.
* Cross-device presentation.
* Relayed OpenID4VP request and response handling.
* Proximity QR/BLE, including leaving the app or locking the phone once the code is shown: the session stops, a
  reader can no longer connect, and the screen closes. Leaving while the code is still loading: the session stops when
  the code becomes ready. Control Center over the QR screen keeps the session and the screen (with
  `hideContentWhileCaptured` true, behind the cover). Leaving from the request screen keeps the session (10-minute
  limit).
* Proximity: the reader ends the Bluetooth session before the user answers: the request screen goes back and the
  presentation ends. A lock, or a wallet link that returns to the dashboard, ends the session and stops the
  advertising.
* Proximity reader without, or with a failing, reader certificate: the warning, no badge, Share
  disabled until acknowledged.
* Relayed proximity engagement where feasible.
* Identity Document Provider extension presentment on supported iOS versions, with the PIN or
  biometric check before the request is shown and again on Accept; the response carries only the documents and
  claims the screen showed, and the history entry is completed.
* Relayed or socially engineered Identity Document Provider extension presentment where feasible.
* RQES signing.
* RQES cancellation.
* Network unavailable.
* Backend unavailable.
* Expired credential.
* Revoked credential; suspended credential, and its return to Valid; a credential suspended before
  the update (shown as revoked until the next check reads its status, which records it as suspended, or
  clears it if the list reports it valid); a status list that cannot be fetched (the issuer card opens
  with the refresh-failure notice).
* Malformed deep links, and a link of no wallet type (an `https` link, for example): dropped, and it does not
  replace a link kept for after login.
* Session lock: 65 seconds in the background requires login, 10 seconds does not; 5 minutes without
  touching any screen, a sheet included, requires login, while touches keep the session; an issuance
  through the issuer's sign-in completes within 10 minutes without login, and a sign-in that lasts 10
  minutes locks; 6 minutes on the RQES screens do not lock, and closing them after 10 minutes locks the
  wallet, with login in front; work that finishes after a lock (an issuance, a presentation) does not
  reopen the wallet.
* A link that arrives after the lock expired opens only after login; a link received before the app was
  killed does not open at the next launch.
* A second presentation link while a remote request or a proximity presentation is on screen: the
  wallet returns to the dashboard and opens the new request.
* A verifier redirect after a presentation: an `https` redirect opens in the browser; a credential-offer,
  OpenID4VP or RQES redirect opens nothing and starts no flow.
* Malicious credential offer.
* A second credential offer while an offer is on screen: the wallet returns to the dashboard and opens
  the new offer; the first is not issued.
* A credential offer whose transaction code has no length: refused.
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
eudiw-abca
wallet-client
gist.githubusercontent.com
WALLET_SOLUTION_ID
localhost
127.0.0.1
SelfSignedDelegate
serverTrust
completionHandler(.useCredential
rqes://oauth/callback
eu.europa.ec.euidi.dev
eu.europa.ec.euidi
```

`eudiw-abca` and `wallet-client` are the demo issuer and RQES client IDs; the Gist URL and
`WALLET_SOLUTION_ID` are the reference Trust Mark values (see
[Trust Mark Deployment](#trust-mark-deployment)). `eu.europa.ec.euidi` also matches two internal
identifiers that do not change with the bundle identifier: the biometric Keychain item
(`eu.europa.ec.euidi.biometric.access`, `KeyChainController`) and the access-group probe
(`eu.europa.ec.euidi.access.group.probe`, `Bundle+Extensions.swift`). Rename them or exclude them
from this check.

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
