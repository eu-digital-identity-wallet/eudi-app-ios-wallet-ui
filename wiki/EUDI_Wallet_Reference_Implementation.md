:memo: [EUDI Wallet Reference Implementation](#eudi-wallet-reference-implementation) :computer: [Repositories](#repositories) :wrench:[How to Use](#how-to-use) :heavy_exclamation_mark: [Disclaimer](#disclaimer) :information_source:[About the project](#about-the-project)

# EUDI Wallet Reference Implementation 
## Overview

The EUDI Wallet Reference Implementation is built based on the [Architecture Reference Framework](https://github.com/eu-digital-identity-wallet/architecture-and-reference-framework) and aims at showcasing a robust and interoperable platform for digital identification, authentication and electronic signatures based on common standards across the European Union.

The EUDI Wallet Reference Implementation is based on a modular architecture composed of a set of business agnostic, re-usable components which will be evolved in incremental steps and can be re-used across multiple projects.
Specifically, as part of the EUDI Wallet Reference Implementation, the following set of components are being delivered:

-   Demo EUDI Wallet mobile native applications for proximity and remote flows
-   Verifier mobile native applications and web-services for proximity and remote flows
-   Libraries and other software components needed to the framework

Please refer to our documentation and repositories listed in the following sections for more detailed information on how to get started, contribute, and engage with the EU Wallet Reference Implementation.

## Initial Development Release 0.1.0 - Functional Scope

The current scope of the EUDI Wallet Reference Implementation is split into the initial development releases, ‘0.1.0’, ‘0.2.0’ and the release ‘1.0.0-beta’ considered a minimum viable product.

The functional scope of the ‘0.1.0’ release includes the first iteration of two main use cases of the EUDI Wallet Reference Implementation, which are 'Identification and Authentication to access online services' and 'Proximity Data Sharing - Mobile Driving License'. Further details about the corresponding use cases are listed below:

-   **Remote same-device identification and authorisation**
	-   _Description_: A key use case of the European digital wallet (EUDI Wallet) is to provide secure identification and authentication of users against public and private services of the Relying Parties. This functionality is crucial for public and private Relying Parties that are required to ensure they are communicating with the right person
	-   _Goal_: Enabling user identification and authentication in online services provided by public or private services
	-   _Remarks_:
		-   PID pre-loaded
		-   App-to-app flow for online authentication
	-   _Applicable Platform_: Android


-   **Proximity Data Transfer**
	-   _Description_: A key use case of the European digital wallet (EUDI Wallet) is to enable the user to obtain, store and present a mobile Driving License in order to prove his/her driving rights
	-   _Goal_: Enabling the users to share data on proximity scenarios, focusing on the mobile Driving License (i.e. mDL) scenario
	-   _Remarks_:
		-   mDL pre-loaded
		-   Using QR/BLE proximity protocols
	-   _Applicable Platform_: Android


# Repositories
This section provides an overview over the EUDI Reference Implementation project and aims to provide an overview of the key repositories of the project. The table below acts as navigation aid to find the information you are looking for.

- **For 'Proximity mDL'**


| Name | Description    | Link |
| -------- | ------- |------- |
|eudi-lib-android-iso18013-holder| mdoc Holder application (Implementation of ISO/IEC 18013-5 for Android) | [Repository](https://github.com/eu-digital-identity-wallet/eudi-lib-android-iso18013-holder)|
|eudi-lib-android-iso18013-holder| mdoc Reader app (The repository will include a link to the compiled app) | [Repository](https://github.com/eu-digital-identity-wallet/eudi-lib-android-iso18013-holder)|


- **For 'Same Device Online Authentication'**

| Name | Description    | Link |
| -------- | ------- |------- |
|eudi-app-android-holder-verifier-23220-4-kt| Mobile native applications for demonstrating SIOP-OpenId4VP Kotlin SDK capabilities | [Repository](https://github.com/eu-digital-identity-wallet/eudi-app-android-holder-verifier-23220-4-kt)|
|eudi-srv-web-verifier-endpoint-23220-4-kt| Web application (backend Restful service) that would allow somebody to trigger the presentation use case | [Repository](https://github.com/eu-digital-identity-wallet/eudi-srv-web-verifier-endpoint-23220-4-kt)|
|eudi-lib-jvm-siop-openid4vp-kt| Implementation of SIOPv2 and OpenID4VP protocols (wallet's role) in Kotlin  | [Repository](https://github.com/eu-digital-identity-wallet/eudi-lib-jvm-siop-openid4vp-kt)|
|eudi-lib-jvm-presentation-exchange-kt| Implementation of DIF Presentation Exchange v2 specification in Kotlin | [Repository](https://github.com/eu-digital-identity-wallet/eudi-lib-jvm-presentation-exchange-kt)|



# How to use
Instructions for installing and using the applicable applications/libraries can be found in the corresponding 'ReadMe' files, i.e. for the [Demo App - Proximity Use Case](https://github.com/eu-digital-identity-wallet/eudi-lib-android-iso18013-holder/blob/main/README.md), [Verifier for Proximity](https://github.com/eu-digital-identity-wallet/eudi-lib-android-iso18013-holder/blob/main/wiki/TEST.md), [Demo Apps - Remote Use Case](https://github.com/eu-digital-identity-wallet/eudi-app-android-holder-verifier-23220-4-kt/blob/main/README.md) and [Verifier for Remote](https://github.com/eu-digital-identity-wallet/eudi-srv-web-verifier-endpoint-23220-4-kt/blob/main/README.md).


# Disclaimer
The released software is a initial development release version: 
-  The initial development release is an early endeavor reflecting the efforts of a short timeboxed period, and by no means can be considered as the final product.  
-  The initial development release may be changed substantially over time, might introduce new features but also may change or remove existing ones, potentially breaking compatibility with your existing code.
-  The initial development release is limited in functional scope.
-  The initial development release may contain errors or design flaws and other problems that could cause system or other failures and data loss.
-  The initial development release has reduced security, privacy, availability, and reliability standards relative to future releases. This could make the software slower, less reliable, or more vulnerable to attacks than mature software.
-  The initial development release is not yet comprehensively documented. 
-  Users of the software must perform sufficient engineering and additional testing in order to properly evaluate their application and determine whether any of the open-sourced components is suitable for use in that application.
-  We strongly recommend to not put this version of the software into production use.
-  Only the latest version of the software will be supported

# About the project
Links for additional information:  
-  [Electronic Identification](https://digital-strategy.ec.europa.eu/en/policies/electronic-identification)  
-  [Q&A Digital Identity Regulation Proposal](https://digital-strategy.ec.europa.eu/en/faqs/qa-digital-identity-regulation-proposal)  
-  [European Digital Identity Wallet Toolbox Process](https://digital-strategy.ec.europa.eu/en/policies/eudi-wallet-toolbox)  
-  [European Digital Identity Wallet Pilot implementation (Prototype and Large Scale Pilots)](https://digital-strategy.ec.europa.eu/en/policies/eudi-wallet-implementation)  
