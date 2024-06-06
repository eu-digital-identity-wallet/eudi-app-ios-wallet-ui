# EUDI iOS Wallet reference application

:heavy_exclamation_mark: **Important!** Before you proceed, please read
the [EUDI Wallet Reference Implementation project description](https://github.com/eu-digital-identity-wallet/.github/blob/main/profile/reference-implementation.md)

----

## Table of contents

* [Overview](#overview)
* [Disclaimer](#disclaimer)
* [Important things to know](#important-things-to-know)
* [How to contribute](#how-to-contribute)
* [Demo videos](#demo-videos)
* [How to use the application](#how-to-use-the-application)
* [Application configuration](#application-configuration)
* [License](#license)

## Overview

The EUDI Wallet Reference Implementation is built based on the Architecture Reference Framework and aims to showcase a robust and interoperable platform for digital identification, authentication, and electronic signatures based on common standards across the European Union.
The EUDI Wallet Reference Implementation is based on a modular architecture composed of business-agnostic, reusable components that will evolve in incremental steps and can be re-used across multiple projects.

The EUDI Wallet Reference Implementation is the application that allows users to:

1. To obtain, store, and, present PID and mDL.
2. Verify presentations.
3. Share data on proximity scenarios.
4. Support remote QES and more use cases with the modules included.

The EUDIW project provides through this repository an iOS app. Please refer to the repositories listed in the following sections for more detailed information on how to get started, contribute, and engage with the EUDI Wallet Reference Implementation.
 
# 💡 Specifications Employed

The app consumes the SDK called EUDIW Wallet core [Wallet kit](https://github.com/eu-digital-identity-wallet/eudi-lib-ios-wallet-kit) and a list of available libraries to facilitate remote presentation, proximity, and issuing test/demo functionality following specification of the [ARF](https://github.com/eu-digital-identity-wallet/eudi-doc-architecture-and-reference-framework) including:
 
- OpenID4VP - draft 19 (remote presentation), presentation exchange v2.0,
 
- ISO18013-5 (proximity presentation),
 
- OpenID4VCI draft 13 (issuing)
 
- Issuer functionality, to support development and testing, one can access an OID4VCI test/demo service for issuing at:

  - [EUDI Issuer (Draft 13)](https://issuer.eudiw.dev/)

  - [OpenID4VCI PID and mDL Issuer (python)](https://github.com/eu-digital-identity-wallet/eudi-srv-web-issuing-eudiw-py)
 
  - [OpenID4VCI PID and mDL Issuer (kotlin)](https://github.com/eu-digital-identity-wallet/eudi-srv-pid-issuer)
 
Relying Party functionality:
 
To support development and testing, one can access a test/demo service for remote presentation at:

  - [EUDI Verifier](https://verifier.eudiw.dev) 

  - [Web verifier source](https://github.com/eu-digital-identity-wallet/eudi-web-verifier)

  - [Verifier restful backend service source](https://github.com/eu-digital-identity-wallet/eudi-srv-web-verifier-endpoint-23220-4-kt)
 
To support proximity an Android Proximity Verifier is available as an app that can request PID and mDL with reader authentication available [here](https://install.appcenter.ms/orgs/eu-digital-identity-wallet/apps/mdoc-verifier-testing/distribution_groups/eudi%20verifier%20(testing)%20public)

The issuer, verifier service, and verifier app authentication are based on the EUDIW development [IACA](https://github.com/niscy-eudiw/eudi-app-ios-wallet-ui/tree/main/Wallet/Sample)

## Disclaimer

The released software is an initial development release version: 
-  The initial development release is an early endeavor reflecting the efforts of a short time-boxed period, and by no means can it be considered as the final product.  
-  The initial development release may be changed substantially over time, might introduce new features but also may change or remove existing ones, potentially breaking compatibility with your existing code.
-  The initial development release is limited in functional scope.
-  The initial development release may contain errors or design flaws and other problems that could cause system or other failures and data loss.
-  The initial development release has reduced security, privacy, availability, and reliability standards relative to future releases. This could make the software slower, less reliable, or more vulnerable to attacks than mature software.
-  The initial development release is not yet comprehensively documented. 
-  Users of the software must perform sufficient engineering and additional testing to properly evaluate their application and determine whether any of the open-sourced components is suitable for use in that application.
-  We strongly recommend not to put this version of the software into production use.
-  Only the latest version of the software will be supported

## Important things to know

The main purpose of the reference implementation is to showcase the ecosystem and act as a technical example of how to integrate and use all of the available components.

If you're planning to use this application in production, we recommend reviewing the following steps:
- Configure the application properly by following the guide [here](wiki/configuration.md)
- Ensure the Pin storage configuration matches your security requirements or provide your own by following this guide [Pin Storage Configuration](wiki/configuration.md#pin-storage-configuration)
- Ensure the application meets the OWASP MASVS industry standard. Please refer to the following links for further information on the controls you must implement to ensure maximum compliance:
    - [OWASP MASVS](https://mas.owasp.org/MASVS/)
    - [App Attestation](https://developer.apple.com/documentation/devicecheck/establishing-your-app-s-integrity)

## How to contribute

We welcome contributions to this project. To ensure that the process is smooth for everyone
involved, follow the guidelines found in [CONTRIBUTING.md](CONTRIBUTING.md).

## Demo videos

_(NOTE: These videos are from the Android version)_

Issuance

[Issuance](https://github.com/eu-digital-identity-wallet/eudi-app-ios-wallet-ui/assets/129499766/9e9fb151-38ca-48f7-a0d7-669ce816513b)

Presentation

[Presentation](https://github.com/eu-digital-identity-wallet/eudi-app-ios-wallet-ui/assets/129499766/76953733-4841-4581-9c7e-f53499f408f3)

Proximity

[Proximity](https://github.com/eu-digital-identity-wallet/eudi-app-ios-wallet-ui/assets/129499766/68c975e1-1f99-441e-acef-e4a42572ab4d)

## How to use the application

Minimum device requirements

- Any device that supports iOS 15.0

Prerequisites

To complete the flows described below you need to build and run the application with xcode. Alternatively, you can directly download the Android app onto your device.

App center download method (Android app)

In addition to building the app from the source, you can also use the Android app which you can download *[here](https://install.appcenter.ms/orgs/eu-digital-identity-wallet/apps/eudi-reference-android/distribution_groups/eudi%20wallet%20(demo)%20public)*

Run the app from the source (xcode build)

Clone this repo and make sure you have access to the dependencies below:

[iso18013-data-model](https://github.com/eu-digital-identity-wallet/eudi-lib-ios-iso18013-data-model.git)

[iso18013-data-transfer](https://github.com/eu-digital-identity-wallet/eudi-lib-ios-iso18013-data-transfer.git)

[iso18013-security](https://github.com/eu-digital-identity-wallet/eudi-lib-ios-iso18013-security.git)

[wallet-storage.](https://github.com/eu-digital-identity-wallet/eudi-lib-ios-wallet-storage.git)

[wallet-kit](https://github.com/eu-digital-identity-wallet/eudi-lib-ios-wallet-kit)

[openid4vp-swift](https://github.com/eu-digital-identity-wallet/eudi-lib-ios-siop-openid4vp-swift.git)

[presentation-exchange-swift](https://github.com/eu-digital-identity-wallet/eudi-lib-ios-presentation-exchange-swift.git)

[openid4vci-swift](https://github.com/eu-digital-identity-wallet/eudi-lib-ios-openid4vci-swift)

You will also need to download the Android Verifier app [here](https://install.appcenter.ms/orgs/eu-digital-identity-wallet/apps/mdoc-verifier-testing/distribution_groups/eudi%20verifier%20(testing)%20public)

App launch

1. Launch the application
2. You will be presented with a welcome screen where you will be asked to create a PIN for future logins.

Issuance flow (Scoped)

1. Open the "Add document" screen or if it's the first time you open the app, you will be redirected there after you enter or set up your PIN.
2. Pick "National ID".
3. From the web view that appears select the "FormEU" option and tap submit.
4. Fill in the form. Any data will do.
5. You will be shown a success screen. Tap next.
6. Your "National ID" is displayed. Tap "Continue".
7. You are now on the "Dashboard" screen.

Issuance flow (Credential Offer)

1. Open the "Add document" screen or if it's the first time you open the app, you will be redirected there after you enter or set up your PIN.
2. Tap "SCAN QR".
3. Scan The QR Code from the issuer's website [EUDI Issuer](https://issuer.eudiw.dev/credential_offer_choice)
4. Review the documents contained in the credential offer and tap "Issue".
5. You will be shown a success screen. Tap "Continue".
6. You are now on the "Dashboard" screen.

While on the "Dashboard" screen you can tap "Add doc" and issue a new document, e.g. "Driving License".

If you want to re-issue a document you must delete it first by tapping on the document in the "Dashboard" screen and tapping the delete icon in the "Document details" view.

Presentation (Online authentication/Same device) flow.

1. Go to the browser application on your device and enter "https://verifier.eudiw.dev"
2. Tap the first option (selectable) and pick the fields you want to share (e.g. "Family Name" and "Given Name")
3. Tap "Next" and then "Authorize".
4. When asked to open the wallet app tap "Open".
5. You will be returned to the app to the "Request" screen. Tap "Share".
6. Enter the PIN you added in the initial steps.
7. On success tap "Continue".
8. A browser will open showing that the Verifier has accepted your request.
9. Return to the app. You are back to the "Dashboard" screen and the flow is complete.

Proximity flow

1. The user logs in successfully to the EUDI Wallet app and views the dashboard.
2. The user clicks the 'SHOW QR' button to display the QR code.
3. The Relying Party scans the presented QR code.
4. EUDI Wallet User can view the requested data set from the relying party.

    1. The distinction between mandatory and optional data elements is depicted.
    2. The requestor (i.e. relying party) of the data is depicted.
    3. EUDI Wallet User may select additional optional attributes to be shared.
5. EUDI Wallet User selects the option to share the attributes.
6. EUDI Wallet authenticates to share data (quick PIN).
7. User authorization is accepted - a corresponding message is displayed to the  EUDI Wallet User.

## Application configuration

You can find instructions on how to configure the application [here](wiki/configuration.md)

## Package structure

*logic-resources*: All app resources reside here (images, etc.)

*logic-core*: Wallet core logic.

*logic-analytics*: Access to analytics providers. Capabilities for test monitoring analytics (i.e. crashes) can be added here (no functionality right now)

*logic-business*: App business logic.

*logic-authentication*: PinStorage and System Biometrics Logic.

*logic-ui*: Common UI components.

*feature-common*: Code that is common to all features.

*feature-login*: Login feature.

*feature-dashboard*: The application's main screen.

*feature-startup*: The initial screen of the app.

*feature-presentation*: Online authentication feature.

*feature-issuance*: Document issuance feature.

*feature-proximity*: Proximity scenarios feature.

*logic-assembly*: This module has access to all the above modules and assembles navigation and DI graphs.

```mermaid
graph TD;
  logic-business --> logic-authentication
  logic-core --> logic-authentication
  logic-analytics --> logic-authentication
  logic-resources --> logic-authentication

  feature-common --> logic-assembly
  feature-startup --> logic-assembly
  feature-login --> logic-assembly
  feature-dashboard --> logic-assembly
  feature-presentation --> logic-assembly
  feature-issuance --> logic-assembly
  feature-proximity --> logic-assembly

  logic-business --> logic-core
  logic-resources --> logic-core

  logic-business --> logic-analytics

  feature-common --> feature-issuance

  feature-common --> feature-proximity

  feature-common --> feature-presentation

  feature-common --> feature-dashboard

  feature-common --> feature-login

  logic-core --> feature-common
  logic-business --> feature-common
  logic-analytics --> feature-common
  logic-ui --> feature-common
  logic-api --> feature-common
  logic-authentication --> feature-common

  feature-common --> feature-startup

  logic-core --> logic-api
  logic-business --> logic-api
  logic-analytics --> logic-api

  logic-resources --> logic-business

  logic-business --> logic-ui
  logic-analytics --> logic-ui
  logic-resources --> logic-ui

  logic-core --> logic-ui

```

## License

### License details

Copyright (c) 2023 European Commission

Licensed under the EUPL, Version 1.2 or - as soon they will be approved by the European
Commission - subsequent versions of the EUPL (the "Licence"); You may not use this work
except in compliance with the Licence.

You may obtain a copy of the Licence at:
https://joinup.ec.europa.eu/software/page/eupl

Unless required by applicable law or agreed to in writing, software distributed under 
the Licence is distributed on an "AS IS" basis, WITHOUT WARRANTIES OR CONDITIONS OF 
ANY KIND, either express or implied. See the Licence for the specific language 
governing permissions and limitations under the Licence.
