//
//  File.swift
//  
//
//  Created by Rodney Aiglstorfer on 2/9/24.
//

import SwiftUI

@propertyWrapper
public struct UserDefault<Value: Codable>: DynamicProperty {
    public let key: String
    public let defaultValue: Value
    
    public init(key: String, defaultValue: Value) {
        self.key = key
        self.defaultValue = defaultValue
    }
    
    public var wrappedValue: Value {
        get {
            return UserDefaults.standard.object(forKey: key) as? Value ?? defaultValue
        }
        nonmutating set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
    
    public var projectedValue: Binding<Value> {
        Binding(
            get: { wrappedValue },
            set: { wrappedValue = $0 }
        )
    }
}
