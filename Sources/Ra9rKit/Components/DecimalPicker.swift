//
//  DecimalPickerpla.swift
//  Ra9rKit
//
//  Created by Rodney Aiglstorfer on 9/22/22.
//

import SwiftUI

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
        
        let parts = value.wrappedValue.uncombine()
        self.wholeNumber = parts.wholeNumber
        self.decimalNumber = parts.decimalNumber
    }
    
    public var body: some View {
        HStack {
            Picker("Whole Number", selection: $wholeNumber) {
                ForEach(0..<1000) { number in
                    Text("\(number)").tag(number)
                }
            }
            .pickerStyle(WheelPickerStyle())
            
            Text(".")
            
            Picker("Decimal", selection: $decimalNumber) {
                ForEach(0..<10) { number in
                    Text("\(number)").tag(number)
                }
            }
            .pickerStyle(WheelPickerStyle())
        }.onChange(of: wholeNumber) { oldNumber, newNumber in
            let newVal = Float(newNumber, self.decimalNumber)
            value = newVal
        }.onChange(of: decimalNumber) { oldNumber, newNumber in
            let newVal = Float(self.wholeNumber, newNumber)
            value = newVal
        }
    }
}

#Preview {
    struct Preview: View {
        @State var weight: Float = 144.3
        var body: some View {
            Text("\(weight.formatPrecision(1)) kgs").font(.headline)
            DecimalPicker($weight)
                .padding(50)
        }
    }
    
    return Preview()
}
