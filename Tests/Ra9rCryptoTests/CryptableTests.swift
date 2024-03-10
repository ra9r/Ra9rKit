//
//  CryptableTests.swift
//  
//
//  Created by Rodney Aiglstorfer on 3/9/24.
//

import XCTest
import Foundation
import CryptoKit
@testable import Ra9rCrypto

class CryptableTests: XCTestCase {
    
    func testInitialization() {
        let key = SymmetricKey(size: .bits256)
        let cryptable = Cryptable(key: key)
        XCTAssertNotNil(cryptable)
    }
    
    func testEncryptionDecryption() throws {
        let key = SymmetricKey(size: .bits256)
        let cryptable = Cryptable(key: key)
        let data = "Test Data".data(using: .utf8)!
        
        let encryptedData = try cryptable.encrypt(data: data)
        XCTAssertNotNil(encryptedData)
        
        let decryptedData = try cryptable.decrypt(sealedBoxData: encryptedData!)
        XCTAssertEqual(data, decryptedData)
    }
    
//    func testStoreAndRetrieveKeyInKeychain() throws {
//        let tag = "com.example.yourapp.key"
//        let key = SymmetricKey(size: .bits256)
//        
//        // Convert key to Data for comparison later
//        let originalKeyData = key.withUnsafeBytes { Data(Array($0)) }
//        
//        // Store the key in the keychain
//        try StoreKeyInKeychain(tag: tag, key: key)
//        
//        // Retrieve the key from the keychain
//        let retrievedKey = try RetrieveKeyFromKeychain(tag: tag)
//        
//        // Convert retrieved key to Data for comparison
//        let retrievedKeyData = retrievedKey.withUnsafeBytes { Data(Array($0)) }
//        
//        // Compare the original key and the retrieved key
//        XCTAssertEqual(originalKeyData, retrievedKeyData)
//    }
}
