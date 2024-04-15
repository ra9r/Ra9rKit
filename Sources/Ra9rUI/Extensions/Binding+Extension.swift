//
//  Binding+Extension.swift
//  
//
//  Created by Rodney Aiglstorfer on 4/15/24.
//

import SwiftUI

extension Binding where Value == Bool {
    
    public init<T>(value: Binding<T?>) {
        self.init {
            value.wrappedValue != nil
        }
        set: { newValue in
            if !newValue {
                value.wrappedValue = nil
            }
        }
    }
}

public extension Binding where Value: Equatable {
    init(_ source: Binding<Value?>, replacingNilWith nilProxy: Value) {
        self.init(
            get: { source.wrappedValue ?? nilProxy },
            set: { newValue in
                if newValue == nilProxy { source.wrappedValue = nil }
                else { source.wrappedValue = newValue }
            }
        )
    }
}

