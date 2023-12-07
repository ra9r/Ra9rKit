//
//  Calendar+Extention.swift
//  Ra9rKit
//
//  Created by Rodney Aiglstorfer on 11/23/23.
//

import Foundation

extension Calendar {
    
    /// Computes the number of day between two dates inclusive or exclusive.
    public func daysBetween(_ from: Date, and to: Date, inclusive: Bool = false) -> Int {
        let numberOfDays = dateComponents([.day], from: from, to: to)
        
        return numberOfDays.day! + (inclusive ? 1 : 0)
    }
}
