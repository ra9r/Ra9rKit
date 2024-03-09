//
//  File.swift
//  
//
//  Created by Rodney Aiglstorfer on 3/9/24.
//

import CryptoKit
import Security
import Foundation

public struct Cryptable {
    private var key = SymmetricKey(size: .bits256) // A strong 256-bit key
    
    public init(key: SymmetricKey) {
        self.key = key
    }
    
    public func encrypt(_ source: String) throws -> Data? {
        guard let data = source.data(using: .utf8) else {
            return nil
        }
        return try encrypt(data)
    }
    
    public func encrypt(_ character: Character) throws -> Data? {
        return try encrypt(String(character))
    }
    
    public func encrypt(_ number: Int) throws -> Data? {
        let data = Data(withUnsafeBytes(of: number) { Data($0) })
        return try encrypt(data)
    }
    
    public func encrypt(_ number: UInt) throws -> Data? {
        let data = Data(withUnsafeBytes(of: number) { Data($0) })
        return try encrypt(data)
    }
    
    public func encrypt(_ number: Double) throws -> Data? {
        let data = Data(withUnsafeBytes(of: number) { Data($0) })
        return try encrypt(data)
    }
    
    public func encrypt(_ number: Float) throws -> Data? {
        let data = Data(withUnsafeBytes(of: number) { Data($0) })
        return try encrypt(data)
    }
    
    public func encrypt(_ boolValue: Bool) throws -> Data? {
        let data = Data([boolValue ? 1 : 0])
        return try encrypt(data)
    }
    
    public func encrypt(_ data: Data) throws -> Data? {
        let sealedBox = try AES.GCM.seal(data, using: key)
        return sealedBox.combined // Includes ciphertext + authentication tag
    }
    
    public func decrypt(sealedBoxData: Data) throws -> String? {
        let data = try decrypt(sealedBoxData: sealedBoxData) as Data
        return String(data: data, encoding: .utf8)
    }
    
    public func decrypt(sealedBoxData: Data) throws -> Character? {
        let str = try decrypt(sealedBoxData: sealedBoxData) as String?
        return str?.first
    }
    
    public func decrypt(sealedBoxData: Data) throws -> Int? {
        let data = try decrypt(sealedBoxData: sealedBoxData) as Data
        return data.withUnsafeBytes { $0.load(as: Int.self) }
    }
    
    public func decrypt(sealedBoxData: Data) throws -> UInt? {
        let data = try decrypt(sealedBoxData: sealedBoxData) as Data
        return data.withUnsafeBytes { $0.load(as: UInt.self) }
    }
    
    public func decrypt(sealedBoxData: Data) throws -> Float? {
        let data = try decrypt(sealedBoxData: sealedBoxData) as Data
        return data.withUnsafeBytes { $0.load(as: Float.self) }
    }
    
    public func decrypt(sealedBoxData: Data) throws -> Double? {
        let data = try decrypt(sealedBoxData: sealedBoxData) as Data
        return data.withUnsafeBytes { $0.load(as: Double.self) }
    }
    
    public func decrypt(sealedBoxData: Data) throws -> Bool? {
        let data = try decrypt(sealedBoxData: sealedBoxData) as Data
        if let firstByte = data.first {
            return firstByte != 0
        }
        return nil
    }

    public func decrypt(sealedBoxData: Data) throws -> Data {
        let sealedBox = try AES.GCM.SealedBox(combined: sealedBoxData)
        return try AES.GCM.open(sealedBox, using: key)
    }
}

public func StoreKeyInKeychain(tag: String, key: SymmetricKey = SymmetricKey(size: .bits256)) throws {
    
    // Convert the key to Data representation
    let keyData = key.withUnsafeBytes { Data(Array($0)) }
    
    // Create a query for adding the key to the Keychain
    let query: [String: Any] = [
        kSecClass as String: kSecClassKey,
        kSecAttrApplicationTag as String: tag, // Tag to locate the key later
        kSecValueData as String: keyData
    ]
    
    // Add the item to the Keychain
    let status = SecItemAdd(query as CFDictionary, nil)
    guard status == errSecSuccess else {
        print(">> Failed to Save: \(status)")
        throw KeychainError.failedToSave(status)
    }
}

public func RetrieveKeyFromKeychain(tag: String) throws -> SymmetricKey {
    let query: [String: Any] = [
        kSecClass as String: kSecClassKey,
        kSecAttrApplicationTag as String: tag,
        kSecValueData as String: kSecReturnData,
        kSecMatchLimit as String: kSecMatchLimitOne
    ]
    
    var item: CFTypeRef?
    let status = SecItemCopyMatching(query as CFDictionary, &item)
    guard status == errSecSuccess else {
        throw KeychainError.failedToRetrieve(status)
    }
    
    guard let keyData = item as? Data else {
        throw KeychainError.invalidKeyType
    }
    
    return SymmetricKey(data: keyData)
}


