//
//  File.swift
//  
//
//  Created by Rodney Aiglstorfer on 1/9/24.
//

import SwiftUI

extension Image {
    
    /// Style the image as a mask for a color.  This is useful for using SVG images into icons
    /// - Parameters:
    ///   - color: Icon solor, defaults to Color.accentColor
    ///   - width: width of the icon, defaults to 20
    ///   - height: height of the icon, defaults to 20
    /// - Returns: A view styled as an icon given the provided color and dimensions
    public func styleAsIcon(_ color: Color? = Color.accentColor, width: CGFloat? = 20, height: CGFloat? = 20) -> some View {
        color
            .mask {
                self
                    .resizable()
                    .scaledToFit()
            }
            .frame(width: width, height: height)
    }
}
