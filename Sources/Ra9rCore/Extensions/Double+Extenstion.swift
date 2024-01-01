//
//  File.swift
//  
//
//  Created by Rodney Aiglstorfer on 12/31/23.
//

import Foundation

extension Double : Uncombinable {
    
    /// Formats the into a `String` with a specified number of decimals
    public func formatPrecision(_ decimals: Int) -> String {
        String(format: "%.\(decimals)f", self)
    }
    
    /// Separates a `Float` into its `wholeNumber` and `decimalNumber` components
    public func uncombine() -> (wholeNumber: Int, decimalNumber: Int) {
        (wholeNumber: Int(self), decimalNumber: Int( ((self - Double(Int(self))) * 10)) )
    }
    
    /// An internal function that will produce a float value that is the combination of a
    /// wholenumber and a decimal number from the picker
    public init(_ wholeNumber: Int, _ decimalNumber: Int) {
        self = Double(wholeNumber) + (Double(decimalNumber) * 0.1)
    }
    
}
