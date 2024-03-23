//
//  File 2.swift
//  
//
//  Created by Rodney Aiglstorfer on 3/9/24.
//

import Foundation


enum KeychainError : Error, CustomStringConvertible {
    
    case statusError(OSStatus)
    case typeConversionError
    case invalidKeyType
    
    var description: String {
        switch self {
            case .statusError(let status):
                return message(for: status)
            case .typeConversionError:
                return "Unabled to convert to JSON"
            case .invalidKeyType:
                return "Key was not of type Data"
        }
    }
    
    func message(for status: OSStatus) -> String {
        switch status {
            case errSecNotAvailable:
                return "No trust results are available."
            case errSecAuthFailed:
                return "Authorization and/or authentication failed."
            case errSecNoSuchKeychain:
                return "The keychain does not exist."
            case errSecInvalidKeychain:
                return "The keychain is not valid."
            case errSecDuplicateKeychain:
                return "A keychain with the same name already exists."
            case errSecDuplicateCallback:
                return "More than one callback of the same name exists."
            case errSecInvalidCallback:
                return "The callback is not valid."
            case errSecDuplicateItem:
                return "The item already exists."
            case errSecItemNotFound:
                return "The item cannot be found."
            case errSecBufferTooSmall:
                return "The buffer is too small."
            case errSecDataTooLarge:
                return "The data is too large for the particular data type."
            case errSecNoSuchAttr:
                return "The attribute does not exist."
            case errSecInvalidItemRef:
                return "The item reference is invalid."
            case errSecInvalidSearchRef:
                return "The search reference is invalid."
            case errSecNoSuchClass:
                return "The keychain item class does not exist."
            case errSecNoDefaultKeychain:
                return "A default keychain does not exist."
            case errSecInteractionNotAllowed:
                return "Interaction with the Security Server is not allowed."
            case errSecReadOnlyAttr:
                return "The attribute is read-only."
            case errSecWrongSecVersion:
                return "The version is incorrect."
            case errSecKeySizeNotAllowed:
                return "The key size is not allowed."
            case errSecNoStorageModule:
                return "There is no storage module available."
            case errSecNoCertificateModule:
                return "There is no certificate module available."
            case errSecNoPolicyModule:
                return "There is no policy module available."
            case errSecInteractionRequired:
                return "User interaction is required."
            case errSecDataNotAvailable:
                return "The data is not available."
            case errSecDataNotModifiable:
                return "The data is not modifiable."
            case errSecCreateChainFailed:
                return "The attempt to create a certificate chain failed."
            case errSecInvalidPrefsDomain:
                return "The preference domain specified is invalid."
            case errSecInDarkWake:
                return "The user interface cannot be displayed because the system is in a dark wake state."
            default:
                return "Unknown"
        }
    }
}
