//
//  File.swift
//  
//
//  Created by Rodney Aiglstorfer on 3/8/24.
//

import SwiftUI

public struct ThickProgressBarStyle: ProgressViewStyle {
    var color: Color = Color.accentColor
    var height: Double = 50.0
    var labelFontStyle: Font = .headline
    var currentValueFontStyle: Font = .headline
    var alignment: Alignment = .leading
    public func makeBody(configuration: Configuration) -> some View {
        let progress = configuration.fractionCompleted ?? 0.0
        GeometryReader { geometry in
            VStack(alignment: .leading) {
                
                configuration.label
                    .font(labelFontStyle)
                
                RoundedRectangle(cornerRadius: 10.0)
                    .fill(Color(uiColor: .systemGray5))
                    .frame(height: height)
                    .frame(width: geometry.size.width)
                    .overlay(alignment: alignment) {
                        RoundedRectangle(cornerRadius: 10.0)
                            .fill(color)
                            .frame(width: geometry.size.width * progress)
                            .overlay {
                                if let currentValueLabel = configuration.currentValueLabel {
                                    
                                    currentValueLabel
                                        .font(currentValueFontStyle)
                                        .foregroundColor(.white)
                                }
                            }
                    }
                
            }
        }
        .padding()
    }
}

#Preview {
    VStack {
        Spacer()
        ProgressView(value: 0.5, label: { Text("Progress ...")}, currentValueLabel: { Text("30%")})
            .progressViewStyle(ThickProgressBarStyle(height: 60))
        Spacer()
    }
}
