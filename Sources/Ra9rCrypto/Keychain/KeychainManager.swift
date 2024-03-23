//
//  KeychainHelper.swift
//  
//
//  Created by Rodney Aiglstorfer on 3/21/24.
//

import Foundation
import CryptoKit

public class KeychainManager : ObservableObject {
    
    private var account: String
    
    public init(account: String) {
        self.account = account
    }
    
    // MARK: - Key Support
    
    public func save(tag: String, key: SymmetricKey = SymmetricKey(size: .bits256)) throws {
        
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
            throw KeychainError.statusError(status)
        }
    }
    
    public func read(tag: String) throws -> SymmetricKey {
        let query: [String: Any] = [
            kSecClass as String: kSecClassKey,
            kSecAttrApplicationTag as String: tag,
            kSecValueData as String: kSecReturnData,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        guard status == errSecSuccess else {
            throw KeychainError.statusError(status)
        }
        
        guard let keyData = item as? Data else {
            throw KeychainError.invalidKeyType
        }
        
        return SymmetricKey(data: keyData)
    }
    
    

    
    // MARK: - Codable Support
    public func save<T:Codable>(_ tag: String, value: T) throws {
        if let data = try? JSONEncoder().encode(value) {
            try save(tag, data: data)
        }
    }
    
    public func read<T : Codable>(_ tag: String) throws -> T? {
        guard let data = try read(tag) else {
            return nil
        }
        return try JSONDecoder().decode(T.self, from: data)
    }
    
    // MARK: - Data Support
    public func save(_ tag: String, data: Data) throws {
        let query = [
            kSecClass as String: kSecClassGenericPassword,
//            kSecAttrApplicationTag as String: tag,
            kSecAttrAccount as String: account,
            kSecAttrService as String: tag,
            kSecValueData as String: data
        ] as CFDictionary
        
        let status = SecItemAdd(query as CFDictionary, nil)
        if status == errSecDuplicateItem { // Update existing item
            print("Duplicate!")
            let newQuery = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrAccount as String: account,
                kSecAttrService as String: tag,
            ] as CFDictionary
            
            let attributesToUpdate = [kSecValueData: data] as CFDictionary
            
            SecItemUpdate(newQuery, attributesToUpdate)
        } else if status != errSecSuccess {
            throw KeychainError.statusError(status)
        }
    }
    
    public func read(_ tag: String) throws -> Data? {
        let query = [
            kSecClass: kSecClassGenericPassword,
//            kSecAttrApplicationTag: tag,
            kSecAttrAccount as String: account,
            kSecAttrService as String: tag,
            kSecReturnData: true
        ] as CFDictionary
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query, &item)
        
        if status == errSecSuccess {
            guard let data = item as? Data else { throw KeychainError.typeConversionError }
            return data
        } else if status == errSecItemNotFound {
            return nil // No item found
        } else {
            throw KeychainError.statusError(status)
        }
    }
    
    // MARK: - Delete
    
    public func delete(tag: String) throws {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrApplicationTag: tag
        ] as CFDictionary
        
        let status = SecItemDelete(query)
        if status != errSecSuccess && status != errSecItemNotFound {
            throw KeychainError.statusError(status)
        }
    }
}

