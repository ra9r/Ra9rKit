//
//  File.swift
//  
//
//  Created by Rodney Aiglstorfer on 3/12/24.
//

import Foundation
import CryptoKit

public protocol Decryptable {
    func decrypt(key: SymmetricKey) throws -> Data
}
