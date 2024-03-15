//
//  Bool+Encryptable.swift
//  
//
//  Created by Rodney Aiglstorfer on 3/12/24.
//

import Foundation
import CryptoKit

extension Bool : Encryptable {
    public func encrypt(key: SymmetricKey) throws -> Data? {
        let data = Data([self ? 1 : 0])
        return try data.encrypt(key: key)
    }
}
