//
//  File.swift
//  
//
//  Created by Rodney Aiglstorfer on 3/12/24.
//

import Foundation
import CryptoKit

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


