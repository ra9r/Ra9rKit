//
//  File 2.swift
//  
//
//  Created by Rodney Aiglstorfer on 3/9/24.
//

import Foundation


enum KeychainError : Error {
    case failedToSave(OSStatus)
    case failedToRetrieve(OSStatus)
    case invalidKeyType
}
