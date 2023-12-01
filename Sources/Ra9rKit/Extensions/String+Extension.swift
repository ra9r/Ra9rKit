//
//  File.swift
//  
//
//  Created by Rodney Aiglstorfer on 11/30/23.
//

import Foundation

extension String {
    var floatValue: Float? {
        let numberFormatter = NumberFormatter()
        return numberFormatter.number(from: self)?.floatValue
    }
}
