//
//  File.swift
//  
//
//  Created by Rodney Aiglstorfer on 12/19/23.
//

import SwiftUI

extension Color {
    
    struct Semantic {
        let danger = Color(.danger)
        let warning = Color(.warning)
        let info = Color(.info)
        let success = Color(.success)
        let disabled = Color(.disabled)
    }
    
    struct Theme {
        let accent = Color(.accent)
        let secondary = Color(.secondary)
        let tertiary = Color(.tertiary)
        let text = Color(.text)
        let background = Color(.background)
        let semantic = Semantic()
    }
    
    static let theme = Theme()
}
