//
//  File.swift
//  
//
//  Created by Rodney Aiglstorfer on 3/21/24.
//

import SwiftUI

@propertyWrapper
public struct SecureProperty<T: Codable> : DynamicProperty {
    @EnvironmentObject private var keychain: KeychainManager
    @State private var value: T? = nil
    let tag: String
    
    public init(tag: String) {
        self.tag = tag
    }
    
    public var wrappedValue: T? {
        get { value }
        nonmutating set {
            do {
                try keychain.save(tag, value: newValue)
                value = newValue // Update the published value
            } catch {
                print("SecureProperty(\(tag)): \(error)")
            }
        }
    }
    
    public var projectedValue: Binding<T?> {
        Binding<T?>(
            get: { value },
            set: { wrappedValue = $0 }
        )
    }
    
    public func update() {
        let newValue = try? keychain.read(tag) as T?
        DispatchQueue.main.async {
            self.value = newValue
        }
    }
}


