//
//  SwiftUIView.swift
//  
//
//  Created by Rodney Aiglstorfer on 3/15/24.
//

import SwiftUI

public struct SpintText: View {
    public var uom: LocalizedStringResource? = nil
    public var valueFont: Font = .largeTitle.bold()
    public var uomFont: Font = .title2
    @Binding var value: CGFloat
    public var body: some View {
        HStack(alignment: .lastTextBaseline, spacing: 5) {
            Text(verbatim: "\(value)")
                .font(.largeTitle.bold())
                .contentTransition(.numericText(value: value))
                .animation(.snappy, value: value)
            
            if let uom {
                Text(uom)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .textScale(.secondary)
                    .foregroundStyle(.gray)
            }
        }
    }
}

#Preview {
    SpintText(value: .constant(10))
}
