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
    
    func testEncryptionDecryptionOfString() throws {
        let key = SymmetricKey(size: .bits256)
        let value = "Test Data"
        let encryptedData = try value.encrypt(key: key)
        XCTAssertNotNil(encryptedData)
        
        let decryptedValue = try encryptedData?.decrypt(as: String.self, key: key)
        XCTAssertNotNil(decryptedValue)
        
        XCTAssertEqual(value, decryptedValue)
    }
    
    func testEncryptionDecryptionOfCharacter() throws {
        let key = SymmetricKey(size: .bits256)
        let value = Character("T")
        let encryptedData = try value.encrypt(key: key)
        XCTAssertNotNil(encryptedData)
        
        let decryptedValue = try encryptedData?.decrypt(as: Character.self, key: key)
        XCTAssertNotNil(decryptedValue)
        
        XCTAssertEqual(value, decryptedValue)
    }
    
    func testEncryptionDecryptionOfInt() throws {
        let key = SymmetricKey(size: .bits256)
        let value = 25
        let encryptedData = try value.encrypt(key: key)
        XCTAssertNotNil(encryptedData)
        
        let decryptedValue = try encryptedData?.decrypt(as: Int.self, key: key)
        XCTAssertNotNil(decryptedValue)
        
        XCTAssertEqual(value, decryptedValue)
    }
    
    func testEncryptionDecryptionOfUInt() throws {
        let key = SymmetricKey(size: .bits256)
        let value = UInt(25)
        let encryptedData = try value.encrypt(key: key)
        XCTAssertNotNil(encryptedData)
        
        let decryptedValue = try encryptedData?.decrypt(as: UInt.self, key: key)
        XCTAssertNotNil(decryptedValue)
        
        XCTAssertEqual(value, decryptedValue)
    }
    
    func testEncryptionDecryptionOfDouble() throws {
        let key = SymmetricKey(size: .bits256)
        let value = 26.9
        let encryptedData = try value.encrypt(key: key)
        XCTAssertNotNil(encryptedData)
        
        let decryptedValue = try encryptedData?.decrypt(as: Double.self, key: key)
        XCTAssertNotNil(decryptedValue)
        
        XCTAssertEqual(value, decryptedValue)
    }
    
    func testEncryptionDecryptionOfFloat() throws {
        let key = SymmetricKey(size: .bits256)
        let value = Float(26.9)
        let encryptedData = try value.encrypt(key: key)
        XCTAssertNotNil(encryptedData)
        
        let decryptedValue = try encryptedData?.decrypt(as: Float.self, key: key)
        XCTAssertNotNil(decryptedValue)
        
        XCTAssertEqual(value, decryptedValue)
    }
    
    func testEncryptionDecryptionOfBool() throws {
        let key = SymmetricKey(size: .bits256)
        let value = true
        let encryptedData = try value.encrypt(key: key)
        XCTAssertNotNil(encryptedData)
        
        let decryptedValue = try encryptedData?.decrypt(as: Bool.self, key: key)
        XCTAssertNotNil(decryptedValue)
        
        XCTAssertEqual(value, decryptedValue)
    }
}
