//
//  File.swift
//  
//
//  Created by Rodney Aiglstorfer on 11/23/23.
//

import Foundation

extension Float {
    public func formatPrecision(_ decimals: Int) -> String {
        String(format: "%.\(decimals)f", self)
    }
}
