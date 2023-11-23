//
//  Decimal+Extention.swift
//  Ra9rKit
//
//  Created by Rodney Aiglstorfer on 11/23/23.
//

import Foundation

extension Decimal {
    public var float: Float {
        return Float(truncating: self as NSNumber)
    }
    
    public func formatPrecision(_ decimals: Int) -> String {
        String(format: "%.\(decimals)f", self.float)
    }
}
