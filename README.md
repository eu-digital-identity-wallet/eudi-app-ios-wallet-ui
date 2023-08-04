# EUID Wallet Prototype v.0.1 for Proximity use case
[![Tuist badge](https://img.shields.io/badge/Powered%20by-Tuist-blue)](https://tuist.io)

## About

This repository contains a demo *mdoc holder* iOS application, according to [ISO/IEC 18013-5](https://www.iso.org/standard/69084.html).
At the present time, the following features are available:

- Device engagement using QR code.
- Loading of wallet data from CBOR bytes
- Data transfer using Bluetooth Low Energy (BLE)

### Dependencies

The core functionality of the app is implemented in our ISO-18013 Swift Packages: [Data-Model](https://github.com/eu-digital-identity-wallet/eudi-lib-ios-iso18013-data-model.git), [Security](https://github.com/eu-digital-identity-wallet/eudi-lib-ios-iso18013-security.git) and [Data-Transfer](https://github.com/eu-digital-identity-wallet/eudi-lib-ios-iso18013-data-transfer.git)

You can regenerate the Xcode project using [Tuist](https://tuist.io) by running `tuist generate` in the root folder of the project. 

### Sample Data

Currently sample data is used. For more information on how to use sample data for testing mdoc
and eupid, see in [SAMPLE_DATA.md](wiki/SAMPLE_DATA.md).

**Note: PID sample is a technical sample and it does not implement the data model of PID yet.**

### Testing

Use the link below to download and install the mDoc Verifier app based on Google Identity Credential library (https://github.com/google/identity-credential) that implements ISO/IEC 18013-5:2021:

- [ ] [mDoc Verifier App](https://install.appcenter.ms/orgs/eu-digital-identity-wallet/apps/mdoc-verifier-testing/distribution_groups/mdoc%20verifier%20(testing)%20public)
  This is an external link to AppCenter.

### Demo Video

[Demo video](https://github.com/niscy-eudiw/eudi-app-ios-iso18013-holder/assets/4129573/a4d76882-93b7-4d08-b374-80f2777cb45b)

