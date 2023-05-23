# EUID Wallet Prototype v.0.05 for Proximity use case

## About

This repository contains a demo *mdoc holder* iOS application, according to [ISO/IEC 18013-5](https://www.iso.org/standard/69084.html).

At present, device engagement using QR code and data retrieval using Bluetooth low energy (BLE) are available.

## Sample Data

The app contains sample data in the `mdoc-holder/Sample_data/sample_data.json` file.

The `sample_data.json` file contains SampleData CBOR structure encoded in Base64: 

```json
{
  "Data": "<SampleData CBOR structure encoded in Base64>"
}
```

The SampleData shall be CBOR encoded and formatted as follows:

``` 
SamplaData = {
 "version" : tstr, ; Version of the SamplaData structure
 "documents" : [+Document], ;  Documents
 "status" : uint ; Status code
}

Document = {
 "docType" : DocType, ; Document type
 "issuerSigned" : IssuerSigned
}

IssuerSigned = {
 "nameSpaces" : IssuerNameSpaces, ; Data elements
}
    
IssuerNameSpaces = {
 NameSpace => [ + IssuerSignedItemBytes ]
}
    
IssuerSignedItemBytes = #6.24(bstr .cbor IssuerSignedItem)

IssuerSignedItem = {
 "digestID" : uint, ; Digest ID for issuer data authentication
 "random" : bstr, ; Random value for issuer data authentication
 "elementIdentifier" : DataElementIdentifier, ; Data element identifier
 "elementValue" : DataElementValue ; Data element value
}
```
