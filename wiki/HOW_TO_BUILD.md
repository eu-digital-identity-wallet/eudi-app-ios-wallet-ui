# Building the Reference apps to interact with issuing and verifying services.

## Table of contents

* [Overview](#overview)
* [Setup Apps](#setup-apps)
* [Build configurations](#build-configurations)
* [Build commands](#build-commands)
* [Running against services](#running-against-services)
  * [Running with remote services](#running-with-remote-services)
  * [Running with local services](#running-with-local-services)
  * [How to work with self-signed certificates on iOS](#how-to-work-with-self-signed-certificates-on-ios)
* [Document Provider extension configuration](#document-provider-extension-configuration)
* [Production note](#production-note)

## Overview

This guide aims to assist developers in building the application.

## Setup Apps

### EUDI iOS Wallet reference application

You need [Xcode](https://developer.apple.com/xcode/) and its command-line tools installed. Use Xcode 26.0 or
newer, which ships the iOS 26.0 SDK and Swift 6.2: the Identity Document Provider extension targets
iOS 26.0, and the local packages declare `swift-tools-version: 6.2`. An older Xcode will not build
the project.

The project builds against:

| Component | Requirement |
| --- | --- |
| Swift toolchain | 6.2 |
| Swift language mode | Swift 6 for the main app and the packages; Swift 5 for the extension |
| Main app (`EudiWallet`) deployment target | iOS 17.0 |
| Identity Document Provider extension | iOS 26.0 |

Clone the [iOS repository](https://github.com/eu-digital-identity-wallet/eudi-app-ios-wallet-ui)

Open the project file in Xcode. The application has two schemes: "EUDI Wallet Dev" and "EUDI Wallet Demo".

- EUDI Wallet Dev: This scheme communicates with the services deployed in an environment based on the latest main branch.
- EUDI Wallet Demo: This scheme communicates with the services deployed in the latest stable environment.


Each scheme has two configurations: Debug and Release.

- Debug: Used when running the app from within Xcode.
- Release: Used when running the app after it has been distributed via a distribution platform, currently TestFlight.

This setup results in a total of four configurations. All four configurations are defined in the
`.xcconfig` files in the `Wallet/Config` folder (`WalletDev.xcconfig`, `WalletDevRelease.xcconfig`,
`WalletDemo.xcconfig`, `WalletDemoRelease.xcconfig`).

On first open, **let Swift Package Manager finish resolving dependencies** before building. The
project pulls in ~55 packages, including the C++ `eudi-lib-podofo` library, so the first resolve can
take several minutes. From the command line you can pre-resolve with
`xcodebuild -resolvePackageDependencies -project EudiReferenceWallet.xcodeproj`. If resolution fails,
reset via *File ▸ Packages ▸ Reset Package Caches* and retry.

To run the app on the simulator, select your app scheme and press Run.

> On an Apple-silicon Mac, build for a named simulator and pin `ARCHS=arm64 ONLY_ACTIVE_ARCH=YES`,
> as the simulator command below does, so that only the arm64 slice is built. The pin only avoids
> building an unused x86_64 slice: the two binary dependencies, PoDoFo and `EudiEtsi1196x2`, ship both
> arm64 and x86_64 simulator slices, so either links.

To run the app on a device, follow similar steps to running it on the simulator. Both targets, the
app (`EudiWallet`) and the extension (`EudiReferenceWalletIDProvider`), use manual signing with the
reference team's signing identities and named provisioning profiles. In the Signing & Capabilities
tab of each target, supply your own team, signing certificate and provisioning profile, and keep the
two targets aligned as the
[Document Provider extension configuration](CONFIGURATION.md#document-provider-extension-configuration)
describes.

## Build configurations

Current schemes and configurations:

| Scheme | Run/Test configuration | Archive configuration | Intended use |
| --- | --- | --- | --- |
| `EUDI Wallet Dev` | `Debug Dev` | `Release Dev` | Development environment. |
| `EUDI Wallet Demo` | `Debug Demo` | `Release Demo` | Public demo/stable environment. |

For production, create a dedicated production scheme and production build configurations, for
example `EUDI Wallet Prod`, `Debug Prod`, and `Release Prod`. Do not ship `Release Dev` or
`Release Demo` as a production artifact.

## Build commands

The `generic/platform=iOS` commands below build for a device, so they sign both targets with the
project's manual signing settings. They succeed only once those settings name your own team and
profiles; for a compile-only check, add `CODE_SIGNING_ALLOWED=NO`. On a host where nobody has trusted the
package macro (`SwiftCopyableMacro`) in Xcode, such as a fresh CI runner, also add
`-skipPackagePluginValidation -skipMacroValidation`, as the fastlane lanes do.

Build the Dev scheme:

```bash
xcodebuild \
  -project EudiReferenceWallet.xcodeproj \
  -scheme "EUDI Wallet Dev" \
  -configuration "Debug Dev" \
  -destination "generic/platform=iOS" \
  clean build
```

Build for the simulator (Apple-silicon hosts — note the pinned architecture). Replace the simulator
name with one that `xcrun simctl list devices available` lists:

```bash
xcodebuild \
  -project EudiReferenceWallet.xcodeproj \
  -scheme "EUDI Wallet Dev" \
  -configuration "Debug Dev" \
  -destination "platform=iOS Simulator,name=iPhone 17 Pro" \
  ARCHS=arm64 ONLY_ACTIVE_ARCH=YES \
  clean build
```

Build the Demo release configuration:

```bash
xcodebuild \
  -project EudiReferenceWallet.xcodeproj \
  -scheme "EUDI Wallet Demo" \
  -configuration "Release Demo" \
  -destination "generic/platform=iOS" \
  clean build
```

Recommended production archive shape after adding a production scheme:

```bash
xcodebuild \
  -project EudiReferenceWallet.xcodeproj \
  -scheme "EUDI Wallet Prod" \
  -configuration "Release Prod" \
  -destination "generic/platform=iOS" \
  -archivePath build/EudiWalletProd.xcarchive \
  clean archive
```

> **Command-line / CI builds.** The repo also ships a Ruby/Fastlane toolchain (`Gemfile`,
> `fastlane/Fastfile`) used for CI builds and tests. For those workflows run `bundle install`, then
> run a lane by name, for example `bundle exec fastlane ios tests scheme:"EUDI Wallet Dev"`. The
> lanes read their settings from environment variables such as `APP_SCHEME`; see
> [fastlane/USAGE.md](../fastlane/USAGE.md). For local development the Xcode GUI build above is
> sufficient.

## Running against services

### Running with remote services

The app is configured to the build type (debug/release) and variant (dev/demo) by the four
`.xcconfig` files in `Wallet/Config`; you don't need to change anything unless you want to. Each file
sets `BUILD_TYPE` and `BUILD_VARIANT`:

| File | `BUILD_TYPE` | `BUILD_VARIANT` |
| --- | --- | --- |
| `WalletDev.xcconfig` | `DEBUG` | `DEV` |
| `WalletDevRelease.xcconfig` | `RELEASE` | `DEV` |
| `WalletDemo.xcconfig` | `DEBUG` | `DEMO` |
| `WalletDemoRelease.xcconfig` | `RELEASE` | `DEMO` |

The values defined in the `.xcconfig` files are utilized within instances of `WalletKitConfig` and `RQESConfig` to assign the appropriate configurations. These configurations are selected based on the specified build type and build variant defined in the `.xcconfig` files.

Instances of `ConfigLogic` are responsible for interpreting the raw string values extracted from the `.xcconfig` files and converting them into appropriate data types.

```swift
/**
 * Build type.
 */
var appBuildType: AppBuildType { get }

/**
 * Build variant.
 */
var appBuildVariant: AppBuildVariant { get }
```

Using this parsed information, instances such as `WalletKitConfig` and `RQESConfig` can determine and assign their specific configurations based on the defined build type and variant.

For instance, here's how `WalletKitConfig` resolves its configuration for OpenID4VCI remote services based on the build variant:

```swift
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
            encryptionSupportConfig: .init(credentialResponseEncryptionPolicy: .supported)
          ),
          order: 1
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
            encryptionSupportConfig: .init(credentialResponseEncryptionPolicy: .supported)
          ),
          order: 1
        )
      ]
    }
  }()

  // ...
}
```

In this example, the `issuersConfig` property dynamically assigns configurations, such as `credentialIssuerURL`, `clientId`, `authFlowRedirectionURI`, `parUsage`, `allowPlainJwtProof` (kept `false` so only HAIP-compliant attested proofs are sent), `requireDpop`, `keyAttestationsConfig`, `issuerMetadataPolicy` (derived from `trustConfiguration`), `validateRegistrationCertificate` (the "Check Registration Certificates" switch in Settings, off by default), and `encryptionSupportConfig` (wallet-kit's default `.supported`: encrypted credential requests and responses whenever the issuer advertises encryption), based on the current `appBuildVariant`. This ensures that the appropriate settings are applied for each variant (e.g., `.DEMO` or `.DEV`). The snippet is trimmed to one issuer per variant for brevity; the live `WalletKitConfigImpl` returns **two** issuers per variant — the primary (`order: 1`) plus a backend issuer (`order: 0`): `https://issuer-backend.eudiw.dev` for `.DEMO` and `https://dev.issuer-backend.eudiw.dev` for `.DEV`.

### Running with local services

The first step is to run the backend services locally — the issuer and the web verifier (its UI and endpoint). Follow these repositories for instructions:
* [Issuer](https://github.com/eu-digital-identity-wallet/eudi-srv-web-issuing-eudiw-py)
* [Web Verifier UI](https://github.com/eu-digital-identity-wallet/eudi-web-verifier)
* [Web Verifier Endpoint](https://github.com/eu-digital-identity-wallet/eudi-srv-web-verifier-endpoint-23220-4-kt)

To use them, add the local issuer to `issuersConfig` in `WalletKitConfigImpl`: an offer or scoped
issuance from an issuer not listed there is refused. Sign the issuer's metadata with a certificate that
chains to the access-certificate (WRPAC) trusted list (`wrpacProviders`; the static fallback roots do not
count), since `requireSignedMetadata` is `true`, and give the verifier an access certificate that chains to
the same list, since `readerTrustPolicy` is `.enforce`. See [General configuration](CONFIGURATION.md#general-configuration).

### How to work with self-signed certificates on iOS

To enable the app to interact with a locally running service, a minor code change is required.

> Warning: this change turns off server certificate validation for the host it names. It applies to
> the session that carries the app's own requests and the OpenID4VCI and OpenID4VP traffic that
> wallet-kit sends. It does not cover wallet-kit's fetch of an SD-JWT issuer's keys when the credential
> carries no `x5c` chain (`URLSession.shared`), the issuer's sign-in page, which wallet-kit opens in a
> system sign-in sheet (`ASWebAuthenticationSession`), or the RQES library's calls (`URLSession.shared`);
> for those, install and trust the local certificate on the simulator or device. Use it only for local development and never let it reach a release build; see
> [Network Security](GO_LIVE.md#network-security) and
> [Local Development With Self-Signed Certificates](GO_LIVE.md#local-development-with-self-signed-certificates)
> in the go-live guide.

Before running the app in the simulator, add the following lines of code to the top of the `NetworkSessionProvider.swift` file inside the `logic-api` module (the type you edit is `NetworkSessionProviderImpl`), directly below the import statements. Set `developmentHost` to the host name or IP address of your local services.

```swift
/// Accepts the self-signed certificate of one local development host. Never ship it.
final class SelfSignedDelegate: NSObject, URLSessionDelegate {

  /// The only host whose server certificate is accepted without validation.
  private let developmentHost = "localhost"

  func urlSession(
    _ session: URLSession,
    didReceive challenge: URLAuthenticationChallenge,
    completionHandler: @escaping @Sendable (URLSession.AuthChallengeDisposition, URLCredential?) -> Void
  ) {
    let space = challenge.protectionSpace
    guard space.authenticationMethod == NSURLAuthenticationMethodServerTrust,
          space.host == developmentHost,
          let trust = space.serverTrust else {
      completionHandler(.performDefaultHandling, nil)
      return
    }
    completionHandler(.useCredential, URLCredential(trust: trust))
  }
}

let walletSession: URLSession = {
  let delegate = SelfSignedDelegate()
  let configuration = NetworkSessionProviderImpl.makeConfiguration()
  return URLSession(
    configuration: configuration,
    delegate: delegate,
    delegateQueue: nil
  )
}()
```

Once the above is in place, adjust the initializer:

```swift
init() {
  self.urlSession = walletSession
}
```

The app then accepts the self-signed certificate of `developmentHost`, and every other host and
challenge keeps the system's default handling. Revert both changes before you build anything you
distribute.

## Document Provider extension configuration

If you are enabling or troubleshooting the Identity Document Provider extension, including `SHARED_APP_GROUP_IDENTIFIER`, keychain-access-groups, and extension registration behavior, follow the dedicated configuration guide here:

[Document Provider extension configuration](CONFIGURATION.md#document-provider-extension-configuration)

For all configuration options, please refer to [this document](CONFIGURATION.md)

## Production note

Before creating a production release candidate, follow the [production go-live guide](GO_LIVE.md).
It explains how to add a production scheme/build configuration, configure WalletKit and RQES with
production services, replace demo trust anchors, configure signing and entitlements, harden the app,
align with OWASP MASVS, and collect release evidence.
