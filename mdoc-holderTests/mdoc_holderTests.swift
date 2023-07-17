//
//  mdoc_holderTests.swift
//  mdoc-holderTests
//
//  Created by ffeli on 21/05/2023.
//

import XCTest
import SwiftCBOR
@testable import MdocDataModel18013
@testable import MdocSecurity18013
@testable import MdocDataTransfer18013
@testable import mdoc_holder
import CryptoKit

final class mdoc_holderTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
/*
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

	
	func test_cryptoswift_aes_gcm() throws {
		let data:[UInt8] = [0,0,0,0]
		let nonceData:[UInt8] = [0,0,0,0, 0,0,0,0, 0,0,0,1]
		let key = SymmetricKey(size: .bits256)
		let nonce = try AES.GCM.Nonce(data: nonceData)
		let encryptedContent = try AES.GCM.seal(data, using: key, nonce: nonce).combined
		print(encryptedContent!.toHexString())
		
		//let nonceData: Data = nonce.withUnsafeBytes { (p: UnsafeRawBufferPointer) -> Data in  Data(p[0..<p.count]) }
		let symmKeyData = key.withUnsafeBytes { (p: UnsafeRawBufferPointer) -> Data in  Data(p[0..<p.count]) }
		print(symmKeyData.count, " ", symmKeyData.toHexString())
		let gcm = CryptoSwift.GCM(iv: [UInt8](nonceData), mode: .combined)
		let aes = try CryptoSwift.AES(key: [UInt8](symmKeyData), blockMode: gcm, padding: .noPadding)
		let encrypted = try aes.encrypt([UInt8](data))
		print(encrypted.toHexString())
		print(nonceData.toHexString())
		
		guard let sealedBox = try? AES.GCM.SealedBox(combined: nonce + encrypted) else { return }
		guard let decryptedContent = try? AES.GCM.open(sealedBox, using: key) else { return }
		XCTAssertEqual(decryptedContent, Data(data))
	}
 */
	
	func test_encode_device_engagement() throws {
		var de = try XCTUnwrap(DeviceEngagement(data: ScytalesMValidData.deEncoded.bytes))
		let pkData = ScytalesMValidData.privKey963.dropFirst() // drop initial byte 0x04
		de.setD(d: [UInt8](pkData.dropFirst(64)))
		print(ScytalesMValidData.seData.bytes.toHexString())
		let seCbor = try XCTUnwrap(try CBOR.decode(ScytalesMValidData.seData.bytes))
		print(seCbor.description)
		let se = try XCTUnwrap(SessionEstablishment(cbor: seCbor))
		let sessionEncr = try XCTUnwrap(SessionEncryption(se: se, de: de, handOver: BleTransferMode.QRHandover))
		print(sessionEncr.transcript.toCBOR(options: CBOROptions()).description)
	}
}
