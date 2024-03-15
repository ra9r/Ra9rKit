//
//  Float+Encryptable.swift
//  
//
//  Created by Rodney Aiglstorfer on 3/12/24.
//

import Foundation
import CryptoKit

extension Float : Encryptable {
    public func encrypt(key: SymmetricKey) throws -> Data? {
        let data = Data(withUnsafeBytes(of: self) { Data($0) })
        return try data.encrypt(key: key)
    }
}
