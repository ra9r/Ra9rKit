//
//  File.swift
//  
//
//  Created by Rodney Aiglstorfer on 3/9/24.
//

import CryptoKit
import Security
import Foundation

public protocol Cryptable {

    public func encrypt(key: )
   
    

    
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
    
    
    
    
}



