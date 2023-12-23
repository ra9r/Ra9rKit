//
//  File.swift
//  
//
//  Created by Rodney Aiglstorfer on 12/22/23.
//

import Foundation

public enum AuthError : LocalizedError {
    case credential
    case nonce
    case identityToken
    case identityTokenString
}
