//
//  File.swift
//  
//
//  Created by Rodney Aiglstorfer on 3/12/24.
//

import Foundation
import CryptoKit

extension Character : Encryptable {
    public func encrypt(key: SymmetricKey) throws -> Data? {
        return try String(self).encrypt(key: key)
    }
}
