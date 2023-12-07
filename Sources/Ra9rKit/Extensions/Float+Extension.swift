//
//  Int+Extension.swift
//  Ra9rKit
//
//  Created by Rodney Aiglstorfer on 11/23/23.
//

import Foundation

extension Float {
    
    /// Formats the into a `String` with a specified number of decimals
    public func formatPrecision(_ decimals: Int) -> String {
        String(format: "%.\(decimals)f", self)
    }
    
    /// Separates a `Float` into its `wholeNumber` and `decimalNumber` components
    public func uncombine() -> (wholeNumber: Int, decimalNumber: Int) {
        (wholeNumber: Int(self), decimalNumber: Int( ((self - Float(Int(self))) * 10)) )
    }
    
    /// An internal function that will produce a float value that is the combination of a
    /// wholenumber and a decimal number from the picker
    public init(_ wholeNumber: Int, _ decimalNumber: Int) {
        self = Float(wholeNumber) + (Float(decimalNumber) * 0.1)
    }
    
}
