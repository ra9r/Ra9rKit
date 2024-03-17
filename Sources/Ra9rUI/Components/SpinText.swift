//
//  SwiftUIView.swift
//  
//
//  Created by Rodney Aiglstorfer on 3/15/24.
//

import SwiftUI
import Ra9rCore

public struct SpinningNumber: View {
    @Binding var value: CGFloat
    public var uom: Unit? = UnitLength(forLocale: Locale.current)
    public var valueFont: Font = .largeTitle.bold()
    public var uomFont: Font = .title2
    public var body: some View {
        HStack(alignment: .lastTextBaseline, spacing: 5) {
            var d = Double(value)
            if uom == UnitLength.inches {
                Text(d.formatInches())
                    .font(.largeTitle.bold())
                    .contentTransition(.numericText(value: value))
                    .animation(.snappy, value: value)
            } else {
                Text(verbatim: "\(d)")
                    .font(.largeTitle.bold())
                    .contentTransition(.numericText(value: value))
                    .animation(.snappy, value: value)
            }
            
            if let uom {
                Text(uom.symbol)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .textScale(.secondary)
                    .foregroundStyle(.gray)
            }
        }
    }
}

#Preview {
    SpinningNumber(value: .constant(10.0 + 3/8), uom: UnitLength.inches)
}
