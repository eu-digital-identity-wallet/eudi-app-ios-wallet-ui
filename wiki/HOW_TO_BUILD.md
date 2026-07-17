# Building the Reference apps to interact with issuing and verifying services.

## Table of contents

* [Overview](#overview)
* [Setup Apps](#setup-apps)
* [Build configurations](#build-configurations)
* [Build commands](#build-commands)
* [How to work with self-signed certificates on iOS](#how-to-work-with-self-signed-certificates-on-ios)
* [Document Provider extension configuration](#document-provider-extension-configuration)
* [Production note](#production-note)

## Overview

This guide aims to assist developers in building the application.

## Setup Apps

### EUDI iOS Wallet reference application

You need [Xcode](https://xcodereleases.com/) and its command-line tools installed. Use a current
non-beta Xcode that ships the **iOS 26 SDK** or newer — the Identity Document Provider extension
targets iOS 26.2, and an older Xcode will not compile it.

The project builds against:

| Component | Requirement |
| --- | --- |
| Swift | 6.0 |
| Main app (`EudiWallet`) deployment target | iOS 17.0 |
| Identity Document Provider extension | iOS 26.2 |

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

> **Use an Apple-silicon (arm64) simulator.** PoDoFo ships no x86_64 simulator slice, so a
> `generic/platform=iOS Simulator` destination or an Intel/Rosetta build fails at link time. Pin
> `ARCHS=arm64 ONLY_ACTIVE_ARCH=YES` for simulator builds (see the simulator command below).

To run the app on a device, follow similar steps to running it on the simulator. Additionally, you need to supply your own provisioning profile and signing certificate in the Signing & Capabilities tab of your app target.

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

Build the Dev scheme:

```bash
xcodebuild \
  -project EudiReferenceWallet.xcodeproj \
  -scheme "EUDI Wallet Dev" \
  -configuration "Debug Dev" \
  -destination "generic/platform=iOS" \
  clean build
```

Build for the simulator (Apple-silicon hosts — note the pinned architecture):

```bash
xcodebuild \
  -project EudiReferenceWallet.xcodeproj \
  -scheme "EUDI Wallet Dev" \
  -configuration "Debug Dev" \
  -destination "platform=iOS Simulator,name=iPhone 16 Pro" \
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
> the relevant lane (lanes are selected via environment variables such as `APP_SCHEME`). For local
> development the Xcode GUI build above is sufficient.

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
                accessControl: []
              )
            ),
            authFlowRedirectionURI: URL(string: "eu.europa.ec.euidi://authorization")!,
            parUsage: .required(authorizationCodeDPoPBinding: true),
            requireDpop: true,
            issuerMetadataPolicy: trustConfiguration.issuerMetadataPolicy,
            cacheIssuerMetadata: true
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
                accessControl: []
              )
            ),
            authFlowRedirectionURI: URL(string: "eu.europa.ec.euidi://authorization")!,
            parUsage: .required(authorizationCodeDPoPBinding: true),
            requireDpop: true,
            issuerMetadataPolicy: trustConfiguration.issuerMetadataPolicy,
            cacheIssuerMetadata: true
          ),
          order: 1
        )
      ]
    }
  }()

  // ...
}
```

In this example, the `issuersConfig` property dynamically assigns configurations, such as `credentialIssuerURL`, `clientId`, `authFlowRedirectionURI`, `parUsage`, `requireDpop`, `keyAttestationsConfig`, `issuerMetadataPolicy` (derived from `trustConfiguration`), and `cacheIssuerMetadata`, based on the current `appBuildVariant`. This ensures that the appropriate settings are applied for each variant (e.g., `.DEMO` or `.DEV`). The snippet is trimmed to one issuer per variant for brevity; the live `WalletKitConfigImpl` returns **two** issuers per variant — the primary (`order: 1`) plus a backend issuer (`order: 0`): `https://issuer-backend.eudiw.dev` for `.DEMO` and `https://dev.issuer-backend.eudiw.dev` for `.DEV`.

### Running with local services

The first step is to run the backend services locally — the issuer and the web verifier (its UI and endpoint). Follow these repositories for instructions:
* [Issuer](https://github.com/eu-digital-identity-wallet/eudi-srv-web-issuing-eudiw-py)
* [Web Verifier UI](https://github.com/eu-digital-identity-wallet/eudi-web-verifier)
* [Web Verifier Endpoint](https://github.com/eu-digital-identity-wallet/eudi-srv-web-verifier-endpoint-23220-4-kt)

### How to work with self-signed certificates on iOS

To enable the app to interact with a locally running service, a minor code change is required.

Before running the app in the simulator, add the following lines of code to the top of the `NetworkSessionProvider.swift` file inside the `logic-api` module (the type you edit is `NetworkSessionProviderImpl`), directly below the import statements.

```swift
final class SelfSignedDelegate: NSObject, URLSessionDelegate {
  func urlSession(
    _ session: URLSession,
    didReceive challenge: URLAuthenticationChallenge,
    completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void
  ) {
    // Check if the challenge is for a self-signed certificate
    if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust,
       let trust = challenge.protectionSpace.serverTrust {
      // Create a URLCredential with the self-signed certificate
      let credential = URLCredential(trust: trust)
      // Call the completion handler with the credential to accept the self-signed certificate
      completionHandler(.useCredential, credential)
    } else {
      // For other authentication methods, call the completion handler with a nil credential to reject the request
      completionHandler(.cancelAuthenticationChallenge, nil)
    }
  }
}

let walletSession: URLSession = {
  let delegate = SelfSignedDelegate()
  let configuration = URLSessionConfiguration.default
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

This change will allow the app to interact with web services that rely on self-signed certificates.

## Document Provider extension configuration

If you are enabling or troubleshooting the Identity Document Provider extension, including `SHARED_APP_GROUP_IDENTIFIER`, keychain-access-groups, and extension registration behavior, follow the dedicated configuration guide here:

[Document Provider extension configuration](CONFIGURATION.md#document-provider-extension-configuration)

For all configuration options, please refer to [this document](CONFIGURATION.md)

## Production note

Before creating a production release candidate, follow the [production go-live guide](GO_LIVE.md).
It explains how to add a production scheme/build configuration, configure WalletKit and RQES with
production services, replace demo trust anchors, configure signing and entitlements, harden the app,
align with OWASP MASVS, and collect release evidence.
