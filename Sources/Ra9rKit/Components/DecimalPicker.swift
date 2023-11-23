//
//  DecimalPickerpla.swift
//  Ra9rUI
//
//  Created by Rodney Aiglstorfer on 9/22/22.
//

import SwiftUI

private func uncombine(_ value: Float) -> (wholeNumber: Int, decimalNumber: Int) {
    (wholeNumber: Int(value), decimalNumber: Int( ((value - Float(Int(value))) * 10)) )
}

/// An internal function that will produce a float value that is the combination of a
/// wholenumber and a decimal number from the picker
private func combine(_ wholeNumber: Int, _ decimalNumber: Int) -> Float {
    Float(wholeNumber) + (Float(decimalNumber) * 0.1)
}

public struct DecimalPicker: View {
    /// A binding to a variable that will hold the result of the picker
    @Binding var value: Float
    /// The internat state for the whole number portion of the picker
    @State private var wholeNumber: Int
    /// The internat state for the decimal portion of the picker
    @State private var decimalNumber: Int
    /// The range of whole numbers than can be picked from
    var wholeNumbers: [Int]
    /// The range of decimal values that can be picked from
    var decimalValues = [Int](0...9)
    
    public init(_ value: Binding<Float>, lowerLimit: Int = 60, upperLimit: Int = 400) {
        self._value = value
        self.wholeNumbers = [Int](lowerLimit...upperLimit)
        
        let parts = uncombine(value.wrappedValue)
        self.wholeNumber = parts.wholeNumber
        self.decimalNumber = parts.decimalNumber
    }
    
    public var body: some View {
        VStack {
            GeometryReader { geometry in
                HStack(spacing: 5) {
                    Spacer()
                    picker(value: $wholeNumber, range: self.wholeNumbers, geometry: geometry)
                    
                    picker(value: $decimalNumber, range: self.decimalValues, prefix: ".",suffix: "kg", geometry: geometry)
                    Spacer()
                }
            }
        }.onChange(of: wholeNumber) { oldNumber, newNumber in
            let newVal = combine(newNumber, self.decimalNumber)
            value = newVal
        }.onChange(of: decimalNumber) { oldNumber, newNumber in
            let newVal = combine(self.wholeNumber, newNumber)
            value = newVal
        }
    }
    
    @ViewBuilder
    public func picker(value: Binding<Int>, range: [Int], prefix: String = "", suffix: String = "", geometry: GeometryProxy) -> some View{
        Picker(selection: value, label: Text("")) {
            ForEach(0 ..< range.count, id: \.self) { index in
                Text("\(prefix)\(range[index]) \(suffix)").tag(range[index])
                    .scaleEffect(x: 3)
            }
        }
        .pickerStyle(.inline)
        .scaleEffect(x: 0.333)
        .frame(width: geometry.size.width/4, alignment: .center)
    }
}

#Preview {
    Group {
        DecimalPicker(.constant(144.3))
    }
}
