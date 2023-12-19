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
    public var body: some View {
        color
            .ignoresSafeArea()
            .mask {
                Image(image)
                    .resizable()
                    .ignoresSafeArea()
                    .scaledToFill()
            }
    }
}
