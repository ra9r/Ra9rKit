//
//  SymptomGuage.swift
//  SymptomGuageStudy
//
//  Created by Rodney Aiglstorfer on 4/9/24.
//

import SwiftUI

public struct CapsuleGuage: View {
    var height = 15.0
    var rangeMin = 0.0
    var rangeMax = 23.0
    var marks: [CapsuleMark] = []
    
    public init(height: CGFloat = 15.0,
         rangeMin: CGFloat = 0.0,
         rangeMax: CGFloat = 0.1,
         marks: [CapsuleMark]) {
        self.height = height
        self.rangeMax = rangeMax
        self.rangeMin = rangeMin
        self.marks = marks
    }
    
    public var body: some View {
        GeometryReader { geo in
            VStack {
                ZStack(alignment: .leading) {
                    // Background
                    Capsule()
                        .fill(Color.gray.opacity(0.5))
                        .frame(height: height)
                    ForEach(marks) { mark in
                        capsuleMark(geo.size, innerMarks: mark.innerMarks)
                    }
                }
                .frame(width: geo.size.width)
            }
            Spacer()
        }
        .padding()
    }
    
    func translate(_ value: CGFloat) -> CGFloat {
        return (value - rangeMin) / (rangeMax - rangeMin)
    }
    
    @ViewBuilder
    func capsuleMark(_ size: CGSize, innerMarks: [(position: CGFloat, color: Color)]) -> some View {
        let gradientColors = innerMarks.map { $0.color }
        let innerHeight = height/2
        let startX = size.width * translate(innerMarks.first?.position ?? 0)
        let endX = size.width * translate(innerMarks.last?.position ?? 0)
        let innerWidth = endX - startX
        let innerPadding = innerHeight/2
        // Bar
        Capsule()
            .fill(LinearGradient(gradient: Gradient(colors: gradientColors),
                                 startPoint: .leading,
                                 endPoint: .trailing))
            .frame(width: innerWidth, height: height)
            .padding(.leading, startX)
        
        ForEach(innerMarks, id: \.position) { innerMark in
            let innerOffset = size.width * translate(innerMark.position)
            if innerMark.position == innerMarks.first?.position {
                // First Circle
                Capsule()
                    .fill(Color.white)
                    .frame(width: innerHeight, height: innerHeight)
                    .padding(.leading, innerOffset + innerPadding)
            } else if innerMark.position == innerMarks.last?.position {
                // Last Circle
                Capsule()
                    .fill(innerMark.color)
                    .strokeBorder(Color.white, lineWidth: innerHeight/5 )
                    .frame(width: innerHeight, height: innerHeight)
                    .padding(.leading, innerOffset - (innerPadding*3))
            } else {
                // Middle Circles
                Capsule()
                    .fill(Color.white)
                    .frame(width: innerHeight, height: innerHeight)
                    .padding(.leading, innerOffset)
            }
        }
    }
}

public struct CapsuleMark : Identifiable {
    public var id = UUID().uuidString
    public var innerMarks: [(position: CGFloat, color: Color)]
    
    public init(_ innerMarks: [(position: CGFloat, color: Color)]) {
        self.innerMarks = innerMarks
    }
}

#Preview {
    CapsuleGuage(height: 10, rangeMin: 0, rangeMax: 23, marks: [
        CapsuleMark([
            (position: 6, color: .yellow),
            (position: 7, color: .orange),
            (position: 10, color: .red)
        ]),
        CapsuleMark([
            (position: 13, color: .yellow),
            (position: 16, color: .orange)
        ])
    ])
    .frame(maxWidth: 200)
}
