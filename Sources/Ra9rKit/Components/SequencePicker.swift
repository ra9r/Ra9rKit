//
//  SwiftUIView.swift
//  Ra9rKit
//
//  Created by Rodney Aiglstorfer on 11/23/23.
//

import SwiftUI

public struct SequencePicker<T : Hashable>: View {
    @Binding var selected: T?
    var sequence: [T]
    var current: T
    var label: (T) -> String
    var value: (T) -> String
    var equals: (T, T) -> Bool
    
    public init(sequence: [T], 
         selected: Binding<T?>,
         current: T,
         label: @escaping (T) -> String,
         value: @escaping (T) -> String,
         equals: @escaping (T, T) -> Bool)
    {
        self.sequence = sequence
        self.current = current
        self._selected = selected
        if selected.wrappedValue == nil {
            self._selected.wrappedValue = current
        }
        self.label = label
        self.value = value
        self.equals = equals
    }
    
    public var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack {
                ForEach(sequence, id: \.self) { item in
                    ZStack {
                        if isSelected(item) {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.red.gradient)
                        }
                        VStack(alignment: .center) {
                            Spacer()
                            Text(label(item))
                                .minimumScaleFactor(0.6)
                            Text(value(item))
                            if isCurrent(item) {
                                Circle()
                                    .fill(isSelected(item) ? Color.white : Color.black)
                                    .frame(width: 5, height: 5)
                            } else {
                                Circle()
                                    .fill(Color.white.opacity(0))
                                    .frame(width: 5, height: 5)
                            }
                            Spacer()
                        }                  }
                    .foregroundColor(isSelected(item) ? Color.white : Color.black)
                    .frame(width: 30, height: 50)
                    .onTapGesture {
                        self.selected = item
                    }
                }
            }
            .scrollTargetLayout()
            
        }
        .scrollTargetBehavior(.viewAligned)
        .frame(height: 80)
    }
}

extension SequencePicker {
    func isCurrent(_ item: T) -> Bool {
        return self.equals(item, self.current)
    }
    
    func isSelected(_ item: T) -> Bool {
        if let selected = self.selected {
            return self.equals(item, selected)
        }
        return false
    }
}
