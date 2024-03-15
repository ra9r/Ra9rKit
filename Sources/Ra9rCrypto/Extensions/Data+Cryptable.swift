//
//  File.swift
//  
//
//  Created by Rodney Aiglstorfer on 3/12/24.
//

import Foundation
import CryptoKit

extension Data : Cryptable {
    public func decryptString(key: SymmetricKey) throws -> String? {
        let data = try decrypt(key: key) as Data
        return String(data: data, encoding: .utf8)
    }
    
    public func decryptCharacter(key: SymmetricKey) throws -> Character? {
        let str = try decryptString(key: key)
        return str?.first
    }
    
    public func decryptInt(key: SymmetricKey) throws -> Int? {
        let data = try decrypt(key: key) as Data
        return data.withUnsafeBytes { $0.load(as: Int.self) }
    }
    
    public func decryptUInt(key: SymmetricKey) throws -> UInt? {
        let data = try decrypt(key: key) as Data
        return data.withUnsafeBytes { $0.load(as: UInt.self) }
    }
    
    public func decryptFloat(key: SymmetricKey) throws -> Float? {
        let data = try decrypt(key: key) as Data
        return data.withUnsafeBytes { $0.load(as: Float.self) }
    }
    
    public func decryptDouble(key: SymmetricKey) throws -> Double? {
        let data = try decrypt(key: key) as Data
        return data.withUnsafeBytes { $0.load(as: Double.self) }
    }
    
    public func decryptBool(key: SymmetricKey) throws -> Bool? {
        let data = try decrypt(key: key) as Data
        if let firstByte = data.first {
            return firstByte != 0
        }
        return nil
    }
    
    public func decrypt(key: SymmetricKey) throws -> Data {
        let sealedBox = try AES.GCM.SealedBox(combined: self)
        return try AES.GCM.open(sealedBox, using: key)
    }
    
    public func encrypt(key: SymmetricKey) throws -> Data? {
        let sealedBox = try AES.GCM.seal(self, using: key)
        return sealedBox.combined // Includes ciphertext + authentication tag
    }
}
