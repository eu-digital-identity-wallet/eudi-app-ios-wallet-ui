# Testing iOS EUDI Holder Demo App using an mDoc Verifier App

## Preparation

Use the link below to download and install the mDoc Verifier app based on Google Identity Credential library (https://github.com/google/identity-credential) that implements ISO/IEC 18013-5:2021:

- [ ] [mDoc Verifier App](https://install.appcenter.ms/orgs/eu-digital-identity-wallet/apps/mdoc-verifier-testing/distribution_groups/mdoc%20verifier%20(testing)%20public)
  This is an external link to AppCenter.

In the EUDI Holder app, follow the steps below:

1. Open the EUDI Holder App
2. Select option to share attributes
3. EUDI Holder App presents QR code to be scanned by the verifier
4. Present QR code to the mDoc Verifier App
5. EUDI Holder App presents the set of requested data after the verifier has scanned the QR code
6. Select the attributes to be shared
7. Select option to send attributes
8. Authenticate to share data

## Data & Security Check Results

![Data security checks](https://static.eudiw.dev/content/eu-digital-identity-wallet/eudi-lib-android-iso18013-holder/eudi_lib_android_iso180813_data_security_checks.png)

1. Check whether issuer data authentication is performed successfully – validation of the Document
   Signer Certificate using the IACA root public key.
2. Check whether issuer data authentication is performed successfully – validation of the MSO using
   the Document Signer Certificate.
3. Check whether mdoc authentication is performed successfully.
4. Check whether MSO Validity Info are valid.
5. Check whether issuer data authentication is performed successfully – validation of the mDL data
   using the Mobile Security Object (MSO).
6. Check whether facial image data is correctly transferred.
7. Check whether data elements are correctly transferred.
