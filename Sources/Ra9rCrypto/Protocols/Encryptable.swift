//
//  File.swift
//  
//
//  Created by Rodney Aiglstorfer on 3/12/24.
//

import Foundation
import CryptoKit

public protocol Encryptable {
    func encrypt(key: SymmetricKey) throws -> Data?
}
