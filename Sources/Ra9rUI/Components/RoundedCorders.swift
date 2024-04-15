//
//  File.swift
//  
//
//  Created by Rodney Aiglstorfer on 4/15/24.
//

import SwiftUI

extension View {
    public func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        modifier( RoundedCornerModifier(radius: radius, corners: corners) )
    }
}

private struct RoundedCorner: Shape {
    
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

private struct RoundedCornerModifier: ViewModifier {
    
    var roundedCorner: RoundedCorner
    
    init(radius: CGFloat, corners: UIRectCorner) {
        self.roundedCorner = RoundedCorner(radius: radius, corners: corners)
    }
    
    func body(content: Content) -> some View {
        content
            .clipShape( roundedCorner )
    }
}
