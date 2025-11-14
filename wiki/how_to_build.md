# Building the Reference apps to interact with issuing and verifying services.

## Table of contents

* [Overview](#overview)
* [Setup Apps](#setup-apps)
* [How to work with self signed certificates on iOS](#how-to-work-with-self-signed-certificates-on-ios)

## Overview

This guide aims to assist developers to build the iOS application.

# Setup Apps

## EUDI iOS Wallet reference application

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
          client: .public(id: "wallet-dev"),
          authFlowRedirectionURI: URL(string: "eu.europa.ec.euidi://authorization")!,
          usePAR: true,
          useDpopIfSupported: true,
          cacheIssuerMetadata: true
        )
    case .DEV:
      return [
        .init(
          credentialIssuerURL: "https://ec.dev.issuer.eudiw.dev",
          client: .public(id: "wallet-dev"),
          authFlowRedirectionURI: URL(string: "eu.europa.ec.euidi://authorization")!,
          usePAR: true,
          useDpopIfSupported: true,
          cacheIssuerMetadata: true
        )
      ]
    }
  }()

  // ...
}
```

In this example, the `vciConfig` property dynamically assigns configurations, such as `issuerUrl`, `clientId`, `redirectUri`, `usePAR`, `useDPoP`, and `metadataCache`, based on the current `appBuildVariant`. This ensures that the appropriate settings are applied for each variant (e.g., `.DEMO` or `.DEV`).

### Running with local services

The first step here is to have all three services running locally on your machine. You can follow these Repositories for further instructions:
* [Issuer](https://github.com/eu-digital-identity-wallet/eudi-srv-web-issuing-eudiw-py)
* [Web Verifier UI](https://github.com/eu-digital-identity-wallet/eudi-web-verifier)
* [Web Verifier Endpoint](https://github.com/eu-digital-identity-wallet/eudi-srv-web-verifier-endpoint-23220-4-kt)

### How to work with self-signed certificates on iOS

In addition to the change below, to enable the app to interact with a locally running service, a minor code change is required for successful interaction.

Before running the app in the simulator, add these lines of code to the top of the file WalletKitController just below the import statements.

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
guard let walletKit = try? EudiWallet(serviceName: configLogic.documentStorageServiceName, networking: walletSession) else {
  fatalError("Unable to Initialize WalletKit")
}
```

This change will allow the app to interact with web services that rely on self-signed certificates.

For all configuration options, please refer to [this document](configuration.md)
