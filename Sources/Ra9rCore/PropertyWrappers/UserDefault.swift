//
//  File.swift
//  
//
//  Created by Rodney Aiglstorfer on 2/9/24.
//

import Foundation

@propertyWrapper
public struct UserDefault<Value: Codable> {
    public let key: String
    public let defaultValue: Value
    
    public var wrappedValue: Value {
        get {
            return UserDefaults.standard.object(forKey: key) as? Value ?? defaultValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}
