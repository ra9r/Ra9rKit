//
//  File.swift
//  
//
//  Created by Rodney Aiglstorfer on 12/31/23.
//

import Foundation

extension Double : Uncombinable {
    
    public var wholeNumber: Int {
        return Int(self)
    }
    
    public func decimalNumber(precision: Int = 1) -> Int {
        return Int(((self - Double(Int(self))) * pow(10, Double(precision))))
    }
    
    /// Formats the into a `String` with a specified number of decimals
    public func formatPrecision(_ decimals: Int) -> String {
        String(format: "%.\(decimals)f", self)
    }
    
    /// Separates a `Float` into its `wholeNumber` and `decimalNumber` components
    public func uncombine() -> (wholeNumber: Int, decimalNumber: Int) {
        (wholeNumber: wholeNumber, decimalNumber: decimalNumber(precision: 1))
    }
    
    /// An internal function that will produce a float value that is the combination of a
    /// wholenumber and a decimal number from the picker
    public init(_ wholeNumber: Int, _ decimalNumber: Int) {
        self = Double(wholeNumber) + (Double(decimalNumber) * 0.1)
    }
    
    public mutating func formatInches() -> String {
        // First round to the nearest 1/8th
        let roundedSelf = (Double(self) * 8).rounded() / 8.0
        // Get the whole value
        let wholeInches = Int(floor(roundedSelf))
        // Get the remainder (decimal part)
        let remainingPart = roundedSelf - Double(wholeInches)
        
        // Fraction approximations (same as before)
        let tolerance = 0.01
        let fractionApproximations = [
            1.0/8.0: "⅛",
            1.0/4.0: "¼",
            3.0/8.0: "⅜",
            1.0/2.0: "½",
            5.0/8.0: "⅝",
            3.0/4.0: "¾",
            7.0/8.0: "⅞"
        ]
        
        var fraction = ""
        for (fractionalValue, symbol) in fractionApproximations {
            if abs(remainingPart - fractionalValue) <= tolerance {
                fraction = symbol
                break
            }
        }
        
        if fraction.isEmpty {
            return "\(wholeInches)"
        }
        
        return "\(wholeInches) \(fraction)"
    }
    
}
