//
//  Data+Cryptable.swift
//  
//
//  Created by Rodney Aiglstorfer on 3/12/24.
//

import Foundation
import CryptoKit

extension Data : Cryptable {
    public func decrypt(key: SymmetricKey) throws -> Data {
        let sealedBox = try AES.GCM.SealedBox(combined: self)
        return try AES.GCM.open(sealedBox, using: key)
    }
    
    public func encrypt(key: SymmetricKey) throws -> Data? {
        let sealedBox = try AES.GCM.seal(self, using: key)
        return sealedBox.combined // Includes ciphertext + authentication tag
    }
    
    public func decrypt<T>(as source: T.Type, key: SymmetricKey) throws -> T? {
        // first descript the data
        let decryptedData = try self.decrypt(key: key)
        
        // now encode it for the type it was encoded as
        switch source {
            case is String.Type:
                return String(data: decryptedData, encoding: .utf8) as? T
            case is Character.Type:
                return String(data: decryptedData, encoding: .utf8)?.first as? T
            case is Int.Type:
                fallthrough
            case is UInt.Type:
                fallthrough
            case is Double.Type:
                fallthrough
            case is Float.Type:
                return decryptedData.withUnsafeBytes { $0.load(as: T.self) }
            case is Bool.Type:
                if let firstByte = decryptedData.first {
                    return (firstByte != 0) as? T
                }
                fallthrough
            default:
                return nil
        }
    }
}
