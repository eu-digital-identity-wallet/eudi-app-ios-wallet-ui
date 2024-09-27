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
- Release: Used when running the app after it has been distributed via a distribution platform, currently App Center.

This setup results in a total of four configurations. All four configurations are defined in the xcconfig files located under the Config folder in the project.

To run the app on the simulator, select your app schema and press Run.

To run the app on a device, follow similar steps to running it on the simulator. Additionally, you need to supply your own provisioning profile and signing certificate in the Signing & Capabilities tab of your app target.

### Running with remote services

The app is configured to use predefined services in the four xcconfig files. These are the contents of the xcconfig file and you don't need to change anything:

```
BUILD_TYPE = DEBUG
VCI_ISSUER_URL = https:/$()/issuer.eudiw.dev
VCI_CLIENT_ID = wallet-dev
VCI_REDIRECT_URI = eudi-openid4ci:/$()/authorize
CORE_USER_AUTH = false
```

### Running with local services

The first step here is to have all three services running locally on your machine, 
you can follow these Repositories for further instructions:
* [Issuer](https://github.com/eu-digital-identity-wallet/eudi-srv-web-issuing-eudiw-py)
* [Web Verifier UI](https://github.com/eu-digital-identity-wallet/eudi-web-verifier)
* [Web Verifier Endpoint](https://github.com/eu-digital-identity-wallet/eudi-srv-web-verifier-endpoint-23220-4-kt)

### How to work with self signed certificates on iOS

In addition to the change below, in order for the app to interact with locally running service a small code change is required to do this succesfully.

Before running the app in the simulator add these lines of code to the top of the file WalletKitController just below the import statments. 

```
class SelfSignedDelegate: NSObject, URLSessionDelegate {
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

Once the above is in place add:

```
wallet.urlSession = walletSession
```

in the initializer. This change will allow the app to interact with web services that rely on self signed certificates.

For all configuration options please refer to [this document](configuration.md)

