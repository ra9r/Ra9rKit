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
        let roundedSelf = (Double(self) * 16).rounded() / 16.0
        // Get the whole value
        let wholeInches = Int(floor(roundedSelf))
        // Get the remainder (decimal part)
        let remainingPart = self - Double(wholeInches)
        
        // Fraction approximations (same as before)
        let tolerance = 0.0001
        let fractionApproximations = [
            1.0/16.0: "¹⁄₁₆",   // 0.0625
            1.0/8.0: "⅛",       // 0.1250
            3.0/16.0: "³⁄₁₆",   // 0.1875
            1.0/4.0: "¼",       // 0.2500
            5.0/16.0: "⁵⁄₁₆",   // 0.3125
            0.3333: "⅓",        // 0.3333 ... 0.3334
            3.0/8.0: "⅜",       // 0.3750
            7.0/16.0: "⁷⁄₁₆",   // 0.4375
            1.0/2.0: "½",       // 0.5000
            9.0/16.0: "⁹⁄₁₆",   // 0.5625
            5.0/8.0: "⅝",       // 0.2777 ... 0.2778
            0.6666: "⅔",        // 0.6666 ... 0.6667
            11.0/16.0: "¹¹⁄₁₆", // 0.6875
            3.0/4.0: "¾",       // 0.7500
            13.0/16.0: "¹³⁄₁₆", // 0.8125
            7.0/8.0: "⅞",       // 0.8750
            15.0/16.0: "¹⁵⁄₁₆" // 0.9375
        ]
        
        var fraction = ""
        for (fractionalValue, symbol) in fractionApproximations {
            if abs(remainingPart - fractionalValue) <= tolerance {
//            if remainingPart == fractionalValue {
                fraction = symbol
                break
            }
        }
        
        if fraction.isEmpty {
            return "\(self.formatPrecision(1))"
        }
        
        return "\(wholeInches) \(fraction)"
    }
}
