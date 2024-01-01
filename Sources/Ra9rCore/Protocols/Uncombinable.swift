//
//  File.swift
//  
//
//  Created by Rodney Aiglstorfer on 12/31/23.
//

import Foundation

public protocol Uncombinable {
    func uncombine() -> (wholeNumber: Int, decimalNumber: Int)
    init(_ wholeNumber: Int, _ decimalNumber: Int)
}
