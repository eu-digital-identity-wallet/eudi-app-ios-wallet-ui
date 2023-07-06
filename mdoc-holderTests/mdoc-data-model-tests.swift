//
//  mdoc-data-model-tests.swift
//  mdoc-holderTests
//
//  Created by ffeli on 06/07/2023.
//

import XCTest
import SwiftCBOR
@testable import MdocDataModel18013

final class mdoc_data_model_tests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }


	func test_decode_annex31_device_engagement() throws {
	 let de = try XCTUnwrap(DeviceEngagement(data: AnnexdTestData.d31.bytes))
	 XCTAssertEqual(de.version, "1.0")
	 XCTAssertEqual(de.deviceRetrievalMethods?.first, .ble(isBleServer: false, uuid: "45EFEF742B2C4837A9A3B0E1D05A6917"))
 }
 
 func test_decode_online_options_device_engagement() throws {
	 let de = try XCTUnwrap(DeviceEngagement(data: OtherTestData.deOnline.bytes))
	 XCTAssertEqual(de.version, "1.0")
	 XCTAssertEqual(de.deviceRetrievalMethods?.first, .ble(isBleServer: true, uuid: "0000D29600001000800000805F9B34FB"))
	 XCTAssertEqual(de.serverRetrievalOptions?.webAPI, ServerRetrievalOption(url: "https://api.pp.mobiledl.us/api/Iso18013", token: "eWqbX81BE0LaT1cumhgh"))
 }
 
 func test_encode_device_engagement() throws {
	 let de1 = try XCTUnwrap(DeviceEngagement(data: OtherTestData.deOnline.bytes))
	 // encode in memory structure
	 let de1data = de1.encode(options: .init())
	 XCTAssertNotNil(de1data)
	 let de2 = try XCTUnwrap(DeviceEngagement(data: de1data))
	 XCTAssertEqual(de2.version, "1.0")
 }
 
 func test_decode_driving_privileges() throws {
	 //test decoding according to test data
	 let dps = try XCTUnwrap(DrivingPrivileges(data: AnnexdTestData.d21.bytes))
	 print(dps)
	 XCTAssertEqual(dps[0].vehicleCategoryCode, "A");  XCTAssertEqual(dps[0].issueDate, "2018-08-09");  XCTAssertEqual(dps[0].expiryDate, "2024-10-20")
	 XCTAssertEqual(dps[1].vehicleCategoryCode, "B");  XCTAssertEqual(dps[1].issueDate, "2017-02-23");  XCTAssertEqual(dps[1].expiryDate, "2024-10-20")
	 // test encoding
	 let cborDps = dps.toCBOR(options: CBOROptions())
	 let dps2 = try XCTUnwrap(DrivingPrivileges(cbor: cborDps))
	 XCTAssertEqual(dps2[0].vehicleCategoryCode, "A");  XCTAssertEqual(dps2[0].issueDate, "2018-08-09");  XCTAssertEqual(dps2[0].expiryDate, "2024-10-20")
	 XCTAssertEqual(dps2[1].vehicleCategoryCode, "B");  XCTAssertEqual(dps2[1].issueDate, "2017-02-23");  XCTAssertEqual(dps2[1].expiryDate, "2024-10-20")
 }
 
 func test_decode_issuer_auth() throws {
	 let ia = try XCTUnwrap(IssuerAuth(data: AnnexdTestData.d52.bytes))
	 XCTAssertEqual(ia.mso.digestAlgorithm, "SHA-256")
	 XCTAssertEqual(ia.mso.valueDigests["org.iso.18013.5.1"]?.digestIDs.count, 13)
	 XCTAssertEqual(ia.mso.valueDigests["org.iso.18013.5.1.US"]?.digestIDs.count, 4)
	 XCTAssertEqual(ia.mso.validityInfo.signed, "2020-10-01T13:30:02Z")
 }

 // test based on D.4.1.1 mdoc request section of the ISO/IEC FDIS 18013-5 document
 func test_decode_device_request() throws {
	 let dr = try XCTUnwrap(DeviceRequest(data: AnnexdTestData.d411.bytes))
	 let testItems = ["family_name", "document_number", "driving_privileges", "issue_date", "expiry_date", "portrait"].sorted()
	 XCTAssertEqual(dr.version, "1.0")
	 XCTAssertEqual(dr.docRequests.first?.itemsRequest.nameSpaces["org.iso.18013.5.1"]?.elementIdentifiers.sorted(), testItems)
	 // test encode
	 let cborDr = dr.toCBOR(options: CBOROptions())
	 // test if successfully encoded
	 let dr2 = try XCTUnwrap(DeviceRequest(cbor: cborDr))
	 XCTAssertEqual(dr2.docRequests.first?.itemsRequest.nameSpaces["org.iso.18013.5.1"]?.elementIdentifiers.sorted(), testItems)
	 // test iso make request
	 let isoKeys: [IsoMdlModel.CodingKeys] = [.familyName, .documentNumber, .drivingPrivileges, .issueDate, .expiryDate, .portrait]
	 let dr3 = DeviceRequest(mdl: isoKeys, agesOver: [], intentToRetain: true)
	 XCTAssertEqual(dr3.docRequests.first?.itemsRequest.nameSpaces[IsoMdlModel.namespace]?.elementIdentifiers.sorted(), testItems)
 }
 
 func test_decode_sample_data_response() throws {
	 let dr = try XCTUnwrap(DeviceResponse(data: OtherTestData.sampleCborData.bytes))
	 let pidObj = try XCTUnwrap(EuPidModel(response: dr))
	 XCTAssertEqual(pidObj.family_name, "ANDERSSON")
	 let mdlObj = try XCTUnwrap(IsoMdlModel(response: dr))
	 XCTAssertEqual(mdlObj.familyName, "ANDERSSON")
 }

 // test based on D.4.1.2 mdoc response section of the ISO/IEC FDIS 18013-5 document
 func test_decode_device_response() throws {
	 let dr = try XCTUnwrap(DeviceResponse(data: AnnexdTestData.d412.bytes))
	 XCTAssertEqual(dr.version, "1.0")
	 let docs = try XCTUnwrap(dr.documents)
	 let doc = try XCTUnwrap(docs.first)
	 XCTAssertEqual(doc.docType, "org.iso.18013.5.1.mDL")
	 let isoNS = try XCTUnwrap(doc.issuerSigned.nameSpaces?["org.iso.18013.5.1"])
	 let fnItem = try XCTUnwrap(isoNS.findItem(name: "family_name"))
	 XCTAssertEqual(fnItem.elementValue.asString()!, "Doe")
	 XCTAssertEqual(fnItem.digestID, 0)
	 XCTAssertEqual(fnItem.random.toHexString().localizedUppercase, "8798645B20EA200E19FFABAC92624BEE6AEC63ACEEDECFB1B80077D22BFC20E9")
	 let issuerAuth = doc.issuerSigned.issuerAuth
	 XCTAssertEqual(issuerAuth?.mso.deviceKeyInfo.deviceKey.x.toHexString().uppercased(), "96313D6C63E24E3372742BFDB1A33BA2C897DCD68AB8C753E4FBD48DCA6B7F9A")
	 XCTAssertEqual(issuerAuth?.mso.docType, "org.iso.18013.5.1.mDL")
	 XCTAssertEqual(issuerAuth?.mso.validityInfo.validUntil, "2021-10-01T13:30:02Z")
	 let valueDigests1 = try XCTUnwrap(issuerAuth?.mso.valueDigests["org.iso.18013.5.1"])
	 let valueDigests2 = try XCTUnwrap(issuerAuth?.mso.valueDigests["org.iso.18013.5.1.US"])
	 XCTAssertEqual(valueDigests1.digestIDs.count, 13)
	 XCTAssertEqual(valueDigests1[0]!.toHexString().localizedUppercase, "75167333B47B6C2BFB86ECCC1F438CF57AF055371AC55E1E359E20F254ADCEBF")
	 XCTAssertEqual(valueDigests2.digestIDs.count, 4)
	 XCTAssert(isoNS.count > 0)
	 XCTAssertEqual(doc.deviceSigned?.nsRawBytes.count, 1); XCTAssertEqual(doc.deviceSigned?.nsRawBytes[0], 160) // {} A0 empty dic
	 XCTAssertEqual(doc.deviceSigned?.deviceAuth.coseMacOrSignature.macAlgorithm, Cose.MacAlgorithm.hmac256)
	 XCTAssertEqual(doc.deviceSigned?.deviceAuth.coseMacOrSignature.signature.bytes.toHexString().uppercased(), "E99521A85AD7891B806A07F8B5388A332D92C189A7BF293EE1F543405AE6824D")
	 let model = try XCTUnwrap(IsoMdlModel(response: dr))
	 XCTAssertEqual(model.familyName, "Doe")
 }
 
#if os(iOS)
 func test_generate_BLE_engage_QR_code() throws {
	 let de = DeviceEngagement(isBleServer: true)
	 var strQR = de.qrCode
	 XCTAssertNotNil(de.getQrCodeImage(.m))
 }
#endif

}
