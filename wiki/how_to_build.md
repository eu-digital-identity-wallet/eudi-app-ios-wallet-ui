# Building the Reference apps to interact with issuing and verifying services.

## Table of contents

* [Overview](#overview)
* [Dependency versions](#dependency-versions)
* [Setup Apps](#setup-apps)
* [Build configurations](#build-configurations)
* [Build commands](#build-commands)
* [How to work with self-signed certificates on iOS](#how-to-work-with-self-signed-certificates-on-ios)
* [Document Provider extension configuration](configuration.md#document-provider-extension-configuration)
* [Production note](#production-note)

## Overview

This guide aims to assist developers in building the application.

## Dependency versions

Current production-relevant dependency versions are pinned through Swift Package Manager and
`EudiReferenceWallet.xcodeproj/project.xcworkspace/xcshareddata/swiftpm/Package.resolved`.

| Dependency | Current version or source |
| --- | --- |
| Swift tools | `6.2` |
| Minimum package platform | iOS 17 |
| EUDI WalletKit | `0.28.2` |
| EUDI RQES UI | `0.4.0` |
| EUDI OpenID4VCI Swift | `0.35.1` |
| EUDI SIOP OpenID4VP Swift | `0.33.0` |
| EUDI ISO 18013 libraries | `0.14.0` |
| EUDI Wallet Storage | `0.11.3` |

For production, keep dependencies pinned, review transitive updates, run SCA, and archive the
dependency report or SBOM for each release. See the [production go-live guide](go_live.md) for the
full dependency governance checklist.

## Setup Apps

### EUDI iOS Wallet reference application

You need [xcode](https://xcodereleases.com/) and its associated tools installed on your machine. We recommend the latest non-beta version. 

Clone the [iOS repository](https://github.com/eu-digital-identity-wallet/eudi-app-ios-wallet-ui)

Open the project file in Xcode. The application has two schemes: "EUDI Wallet Dev" and "EUDI Wallet Demo".

- EUDI Wallet Dev: This target communicates with the services deployed in an environment based on the latest main branch.
- EUDI Wallet Demo: This target communicates with the services deployed in the latest stable environment.


Each scheme has two configurations: Debug and Release.

- Debug: Used when running the app from within Xcode.
- Release: Used when running the app after it has been distributed via a distribution platform, currently TestFlight.

This setup results in a total of four configurations. All four configurations are defined in the xcconfig files located under the Config folder in the project.

To run the app on the simulator, select your app schema and press Run.

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

### Running with remote services

The app is configured to the type (debug/release) and variant (dev/demo) in the four xcconfig files. These are the contents of the xcconfig file, and you don't need to change anything if you don't want to:

```
BUILD_TYPE = RELEASE
BUILD_VARIANT = DEMO
```

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
var vciConfig: [String: OpenId4VciConfiguration] {
  let openId4VciConfigurations: [OpenId4VciConfiguration] = {
    switch configLogic.appBuildVariant {
    case .DEMO:
      return [
        .init(
          credentialIssuerURL: "https://issuer.eudiw.dev",
          clientId: "wallet-dev",
          keyAttestationsConfig: .init(walletAttestationsProvider: walletKitAttestationProvider),
          authFlowRedirectionURI: URL(string: "eu.europa.ec.euidi://authorization")!,
          requirePAR: true,
          requireDpop: true,
          cacheIssuerMetadata: true
        )
    case .DEV:
      return [
        .init(
          credentialIssuerURL: "https://ec.dev.issuer.eudiw.dev",
          clientId: "wallet-dev",
          keyAttestationsConfig: .init(walletAttestationsProvider: walletKitAttestationProvider),
          authFlowRedirectionURI: URL(string: "eu.europa.ec.euidi://authorization")!,
          requirePAR: true,
          requireDpop: true,
          cacheIssuerMetadata: true
        )
      ]
    }
  }()

  // ...
}
```

In this example, the `vciConfig` property dynamically assigns configurations, such as `issuerUrl`, `clientId`, `redirectUri`, `usePAR`, `useDpopIfSupported`, `keyAttestationsConfig`, and `cacheIssuerMetadata`, based on the current `appBuildVariant`. This ensures that the appropriate settings are applied for each variant (e.g., `.DEMO` or `.DEV`).

### Running with local services

The first step is to run all three services locally on your machine. You can follow these Repositories for further instructions:
* [Issuer](https://github.com/eu-digital-identity-wallet/eudi-srv-web-issuing-eudiw-py)
* [Web Verifier UI](https://github.com/eu-digital-identity-wallet/eudi-web-verifier)
* [Web Verifier Endpoint](https://github.com/eu-digital-identity-wallet/eudi-srv-web-verifier-endpoint-23220-4-kt)

### How to work with self-signed certificates on iOS

To enable the app to interact with a locally running service, a minor code change is required.

Before running the app in the simulator, add the following lines of code to the top of the `NetworkSessionProvider` file inside the `logic-api` module, directly below the import statements.

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

[Document Provider extension configuration](configuration.md#document-provider-extension-configuration)

For all configuration options, please refer to [this document](configuration.md)

## Production note

Before creating a production release candidate, follow the [production go-live guide](go_live.md).
It explains how to add a production scheme/build configuration, configure WalletKit and RQES with
production services, replace demo trust anchors, configure signing and entitlements, harden the app,
align with OWASP MASVS, and collect release evidence.
