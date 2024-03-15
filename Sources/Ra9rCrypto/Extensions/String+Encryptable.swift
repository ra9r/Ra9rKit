//
//  String+Encryptable.swift
//  
//
//  Created by Rodney Aiglstorfer on 3/12/24.
//

import Foundation
import CryptoKit

extension String : Encryptable {
    public func encrypt(key: SymmetricKey) throws -> Data? {
        guard let data = self.data(using: .utf8) else {
            return nil
        }
        return try data.encrypt(key: key)
    }
}
