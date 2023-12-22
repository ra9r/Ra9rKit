//
//  SwiftUIView.swift
//  
//
//  Created by Rodney Aiglstorfer on 12/19/23.
//

import SwiftUI

public struct SVGImage: View {
    let image: ImageResource
    let color: Color
    let scale: ScaleOption?
    
    public enum ScaleOption {
        case scaledToFit, scaledToFill
    }
    
    public init(image: ImageResource, color: Color, scale: ScaleOption? = nil) {
        self.image = image
        self.color = color
        self.scale = scale
    }
    
    public var body: some View {
        color
            .ignoresSafeArea()
            .mask {
                if let scale {
                    switch scale {
                        case .scaledToFill:
                            Image(image)
                                .resizable()
                                .ignoresSafeArea()
                                .scaledToFill()
                        case .scaledToFit:
                            Image(image)
                                .resizable()
                                .ignoresSafeArea()
                                .scaledToFit()
                    }
                    
                } else {
                    Image(image)
                        .resizable()
                        .ignoresSafeArea()
                }
            }
    }
}
