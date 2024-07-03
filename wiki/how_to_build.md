# Building the Reference apps to interact with issuing and verifying services.

## Table of contents

* [Overview](#overview)
* [Setup services](#setup-services)
* [Setup Apps](#setup-apps)
* [How to work with self signed certificates on iOS](#how-to-work-with-self-signed-certificates-on-ios)

## Overview

This guide aims to assist developers build the iOS application and make it interact with services that are self hosted. As an example it uses services that run on a local machine.

## Setup services

## Issuer

### Overview

[EUDIW Issuer](https://github.com/eu-digital-identity-wallet/eudi-srv-web-issuing-eudiw-py) is an implementation of a credential issuing service, according to [OpenId4VCI - draft13](https://openid.net/specs/openid-4-verifiable-credential-issuance-1_0.html).

Visit this issuer online at this address:

[EUDIW Issuer](https://github.com/eu-digital-identity-wallet/eudi-srv-web-issuing-eudiw-py)


### Local development environment

## Issuer

You can follow [these instructions](https://github.com/eu-digital-identity-wallet/eudi-srv-web-issuing-eudiw-py/blob/main/install.md) to run this issuer locally. Once it is running, it is accessible at [http://127.0.0.1:5000](http://127.0.0.1:5000)

## Verifier

In order to run the Verifier, clone [EUDI Verifier Endpoint](https://github.com/eu-digital-identity-wallet/eudi-srv-web-verifier-endpoint-23220-4-kt). You need to have Java installed on your machine. For macOS in particular we recommend [SDKMAN!](https://sdkman.io/)

From the Verifier directory run the command:

```
./gradlew bootRun
```

The verifier will then be accesible at [http://localhost:8080]( http://localhost:8080), and comprehensive documentation on its endpoints and configuration can be found [here](https://github.com/eu-digital-identity-wallet/eudi-srv-web-verifier-endpoint-23220-4-kt).


## Verifier web UI

You can clone the Verifier UI [here](https://github.com/eu-digital-identity-wallet/eudi-web-verifier)

You need npm and [Angular CLI](https://github.com/angular/angular-cli) installed on your machine.

In order to access the Verifier UI at [http://localhost:4200](http://localhost:4200) run the following commands:

```
npm install
ng serve
```

# Setup Apps

## EUDI iOS Wallet reference application

You need [xcode](https://xcodereleases.com/) and its associated tools installed on your machine. We recommend the latest non-beta version. 

Clone the [iOS repository](https://github.com/eu-digital-identity-wallet/eudi-app-ios-wallet-ui)

Open the project file in Xcode. The application has two schemas: "EUDI Wallet Dev" and "EUDI Wallet Demo".

- EUDI Wallet Dev: This target communicates with the services deployed in an environment based on the latest main branch.
- EUDI Wallet Demo: This target communicates with the services deployed in the latest stable environment.


Each schema has two configurations: Debug and Release.

- Debug: Used when running the app from within Xcode.
- Release: Used when running the app after it has been distributed via a distribution platform, currently App Center.

This setup results in a total of four configurations. All four configurations are defined in the xcconfig files located under the Config folder in the project.

To run the app on the simulator, select your app schema and press Run.

To run the app on a device, follow similar steps to running it on the simulator. Additionally, you need to supply your own provisioning profile and signing certificate in the Signing & Capabilities tab of your app target.

### Running with remote services

The app is configured to use predefined services in the four xcconfig files. These are the contents of the xcconfig file and you don't need to change anything:

```
BUILD_TYPE = DEBUG
VERIFIER_API_URI = https:/$()/verifier.eudiw.dev
VERIFIER_LEGAL_NAME = EUDI Verifier
VCI_ISSUER_URL = https:/$()/issuer.eudiw.dev
VCI_CLIENT_ID = wallet-dev
VCI_REDIRECT_URI = eudi-openid4ci:/$()/authorize
CORE_USER_AUTH = false
```

### Running with local services

The first step here is to have all three services running locally on your machine as described above under the "Setup services" section, then modify an xcconfig file to points to these services. This requires the changed below:

```
VERIFIER_API_URI = https:/$()/localhost:8080
VCI_ISSUER_URL = http:/$()/127.0.0.1:5000
```

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

