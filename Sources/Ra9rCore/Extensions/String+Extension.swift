//
//  File.swift
//  
//
//  Created by Rodney Aiglstorfer on 11/30/23.
//

import Foundation

extension String {
    /// Converts the string into an optional `Float` if possible.
    public var floatValue: Float? {
        let numberFormatter = NumberFormatter()
        return numberFormatter.number(from: self)?.floatValue
    }
    
    /// Converts a string in "PascalCase" into "Pascal Case"
    public func titlecase() -> String {
        var newString: String = ""
        for (index, character) in self.enumerated() {
            if character.isUppercase && index != 0 {
                newString += " "
            }
            newString += String(character)
        }
        return newString
    }
}
