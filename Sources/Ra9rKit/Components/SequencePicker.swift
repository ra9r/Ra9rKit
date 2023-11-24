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
    @Namespace private var namespace
    
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
        self.label = label
        self.value = value
        self.equals = equals
    }
    
    public var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack {
                ForEach(sequence.indices, id: \.self) { ndx in
                    let item = sequence[ndx]
                    ZStack {
                        if isSelected(item) {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.accentColor.gradient)
                                .matchedGeometryEffect(id: "itemBG", in: namespace)
                      
                            
                        }
                        VStack(alignment: .center) {
                            Spacer()
                            Text(label(item))
                                .minimumScaleFactor(0.5)
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
                        withAnimation(.spring){
                            self.selected = item
                        }
                        
                    }
                }
            }
            .scrollTargetLayout()
            
        }
        .scrollTargetBehavior(.viewAligned)
        .frame(height: 80)
        .onAppear() {
            if selected == nil {
                self.selected = current
            }
        }
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

#Preview {
    struct Preview: View {
        @State var selectedDate: Date?
        @State var selectedCycle: Int?
        var dates: [Date] {
            let now = Date.now
            return Array(-6...24).map { days in
                return now.addInterval(days: days)
            }
        }
        var cycles: [Int] {
            return Array(1...12)
        }
        var body: some View {
            Group {
                if let selectedDate {
                    Text(selectedDate.formatted("MMM dd, YYYY"))
                }
                SequencePicker(sequence: dates,
                               selected: $selectedDate,
                               current: Date.now) { date in
                    date.formatted("E")
                } value: { date in
                    let day = Calendar.current.component(.day, from: date)
                    return "\(day)"
                } equals: { dl, dr in
                    return  dl.sameAs(dr)
                }
                if let selectedCycle {
                    Text("Cycle \(selectedCycle)")
                }
                SequencePicker(sequence: cycles,
                               selected: $selectedCycle,
                               current: 5) { cycle in
                    return "Cycle"
                } value: { cycle in
                    return "\(cycle)"
                } equals: { cl, cr in
                    return  cl == cr
                }
            }.padding()
        }
    }
    
    return Preview()
}
